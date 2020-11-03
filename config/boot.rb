# frozen_string_literal: true

# This is example of boot file.
#
# The file should load all things to required to boot the app up.

require 'bundler'

APP_ENV = ENV['APP_ENV'] || 'development'
Bundler.require(:default, APP_ENV)

loader = Zeitwerk::Loader.new
APP_LOADER = loader
loader.push_dir("#{__dir__}/../app")
loader.enable_reloading if %w[test development].include?(APP_ENV)
loader.setup
loader.eager_load

puts 'Boot completed'
