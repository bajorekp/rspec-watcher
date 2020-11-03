# frozen_string_literal: true

require_relative '../lib/rspec_watcher/cli'
require_relative '../lib/rspec_watcher/watcher'

# Watcher for RSpec and Zeitwerk based projects.
module RspecWatcher
  def self.start(loader:, start_time:, arguments:)
    watcher_options = RspecWatcher::Cli.parse(arguments)
    watcher = RspecWatcher::Watcher.new(
      start_time: start_time,
      options: watcher_options,
      loader: loader
    )
    watcher.start
  end
end
