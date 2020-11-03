# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative '../config/boot'
require_relative '../lib/rspec_watcher'
require_relative '../lib/rspec_watcher/cli'
require_relative '../lib/rspec_watcher/watcher'
