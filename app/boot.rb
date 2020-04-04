# frozen_string_literal: true

# This is example of boot file.
#
# The file should load all things to required to boot the app up.

require 'bundler'
require 'listen'

APP_ENV = ENV['APP_ENV'] || 'development'

Bundler.require(:default, APP_ENV)

puts "Boot completed"