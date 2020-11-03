# frozen_string_literal: true

require 'spec_helper'

def expect_command(command, opt)
  context "with '#{command}'" do
    let(:options) { [command] }

    it { is_expected.to include(opt) }
  end
end

describe RspecWatcher::Cli do
  subject(:parse) { described_class.parse(options) }

  context 'without any options' do
    let(:options) { [] }

    it { is_expected.to eq(described_class::DEFAULT_OPTIONS) }
  end

  expect_command '-n', { run_all_when_none: true }
  expect_command '--all-when-none', { run_all_when_none: true }
  expect_command '--no-all-when-none', { run_all_when_none: false }

  expect_command '-a', { run_always_all: true }
  expect_command '--all', { run_always_all: true }
  expect_command '--no-all', { run_always_all: false }

  expect_command '-s', { run_all_on_start: true }
  expect_command '--all-on-start', { run_all_on_start: true }
  expect_command '--no-all-on-start', { run_all_on_start: false }

  expect_command '-r', { retry_previous_failures: true }
  expect_command '--retry', { retry_previous_failures: true }
  expect_command '--no-retry', { retry_previous_failures: false }

  expect_command '-c', { console_waiter: true }
  expect_command '--console', { console_waiter: true }
  expect_command '--no-console', { console_waiter: false }

  context 'with "--help"' do
    let(:options) { ['--help'] }

    it 'prints help' do
      allow($stdout).to receive(:puts)
      expect { parse }.to raise_error SystemExit
    end
  end
end
