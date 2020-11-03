# frozen_string_literal: true

require 'optparse'

module RspecWatcher
  # Parser for RspecWatcher arguments
  class Cli
    DEFAULT_OPTIONS = {
      retry_previous_failures: true,
      run_always_all: false,
      run_all_on_start: false,
      run_all_when_none: true,
      console_waiter: true
    }.freeze

    def self.parse(arguments)
      options = DEFAULT_OPTIONS.dup

      option_parser = OptionParser.new do |praser|
        praser.banner = 'Usage: bin/rspec-watcher [options]'

        praser.separator ''
        praser.separator 'Watcher for RSpec and Zeitwerk based projects.'
        praser.separator 'It waits and runs affected tests in background with Pry console in'
        praser.separator 'foreground. Console allows for easy code debugging on the fly.'
        praser.separator ''
        praser.separator 'Options:'

        praser.on('-a', '--[no-]all', 'Run all test with every change (default: false)') do |toggle|
          options[:run_always_all] = toggle
        end

        praser.on('-n', '--[no-]all-when-none', 'Run all test when no spec file is founded (default: true)') do |toggle|
          options[:run_all_when_none] = toggle
        end

        praser.on('-s', '--[no-]all-on-start', 'Run all test on start (default: false)') do |toggle|
          options[:run_all_on_start] = toggle
        end

        praser.on('-r', '--[no-]retry', 'Retry tests failed on previous run until fixed (default: true)') do |toggle|
          options[:retry_previous_failures] = toggle
        end

        praser.on('-c', '--[no-]console', 'Wait with Pry console (default: true)') do |toggle|
          options[:console_waiter] = toggle
        end

        # No argument, shows at tail. This will print an options summary.
        praser.on('-h', '--help', 'Show this message') do
          puts praser
          exit 0
        end

        praser.separator ''
        praser.separator 'The script is based on rspec-preloader. Check it out under the link:'
        praser.separator ' - https://github.com/victormours/rspec-preloader'

        praser.on_tail ''
      end

      option_parser.parse(arguments)
      options
    end
  end
end
