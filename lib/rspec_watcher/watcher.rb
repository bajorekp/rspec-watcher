# frozen_string_literal: true

require 'pathname'

module RspecWatcher
  # Listen for file modification in app, lib and spec directories.
  #
  # Listener watches for changes and:
  #  1. Executes code reloader (loader.reload)
  #  2. Forks process (whole App should be initialized in the moment)
  #  3. Loads RSpec config (spec_helper.rb - required setup)
  #  4. Loads and executes each spec file
  class Watcher
    def initialize(loader:, start_time:, options:)
      @loader = loader
      @start_time = start_time
      @options = options

      @failed_specs = []
    end

    def start
      print_bootup_info
      raise Error, 'Loader must be set' unless loader

      listener = setup_listener
      run_tests(['.']) if options[:run_all_on_start]
      listener.start
      run_waiter
    end

    def on_file_change(modified, _added, _removed)
      specs_to_run = get_specs_to_run(modified)
      print_listen_summary(modified, specs_to_run)
      loader.reload
      run_tests(specs_to_run)
    end

    private

    attr_reader :loader, :options, :start_time, :failed_specs

    def setup_listener
      Listen.to('./app', './lib', './spec', &method(:on_file_change))
    end

    def get_specs_to_run(modified)
      return ['.'] if options[:run_always_all]

      specs_to_run = map_to_spec(modified)
      specs_to_run += failed_specs if options[:retry_previous_failures] && failed_specs.is_a?(Array)
      specs_to_run = ['.'] if options[:run_all_when_none] && specs_to_run.empty?
      specs_to_run
    end

    # Lists affected specs
    #
    # If the file in app folder will be modified it will add spec
    # with correlated path, i.e. modification of 'app/services/foo.rb'
    # will run 'spec/services/foo_spec.rb'.
    def map_to_spec(changed)
      paths = changed.map do |path|
        if path.match? '/spec/'
          path
        elsif path.match? '/app/'
          path.gsub('/app/', '/spec/').gsub('.rb', '_spec.rb')
        elsif path.match? '/lib/'
          path.gsub('/lib/', '/spec/').gsub('.rb', '_spec.rb')
        end
      end
      paths.compact.uniq.filter { |path| Pathname.new(path).exist? }
    end

    def print_bootup_info
      saved_time = (Time.now - start_time).round(2)
      puts "App loaded. You'll save #{saved_time} seconds with each spec run."
    end

    def print_listen_summary(modified, specs_to_run)
      puts
      puts "Modified: #{modified}"
      puts "Last failed: #{failed_specs}"
      puts "Specs to run: #{specs_to_run}"
    end

    def run_waiter
      if options[:console_waiter]
        puts 'Watcher listens for changes. Pry console is active.'
        puts 'Press Enter to bring the console to the foreground.'
        Pry.start
      else
        puts 'Watcher is listening. Waits for changes.'
        sleep
      end
    end

    def run_tests(spec_paths)
      RSpec.configuration.start_time = Time.now
      @failed_specs = fork_with_return do
        RSpec::Core::Runner.run(spec_paths, $stderr, $stdout)
        RSpec.configuration.reporter.failed_examples.map(&:file_path)
      end
    end

    def fork_with_return
      read_end, write_end = IO.pipe
      pid = fork do
        result_in_fork = yield
        Marshal.dump(result_in_fork, write_end)
      end
      Process.wait(pid)
      write_end.close
      result = Marshal.load(read_end.read)
      read_end.close
      result
    end
  end
end
