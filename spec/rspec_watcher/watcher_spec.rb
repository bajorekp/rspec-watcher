# frozen_string_literal: true

require 'spec_helper'

describe RspecWatcher::Watcher do
  let(:described_istance) { described_class.new(loader: loader, options: options, start_time: Time.now) }
  let(:loader) { instance_double(Zeitwerk::Loader, reload: nil) }
  let(:options) do
    {
      retry_previous_failures: false,
      run_always_all: false,
      run_all_on_start: false,
      run_all_when_none: false,
      console_waiter: false
    }
  end
  let(:listener) { instance_double(Listen::Listener, start: nil) }

  before do
    allow(described_istance).to receive(:run_tests)
    allow(described_istance).to receive(:sleep)
    allow(Listen).to receive(:to).and_return(listener)
    allow($stdout).to receive(:puts)
  end

  describe '.start' do
    subject(:start_watcher) { described_istance.start }

    it 'starts listener' do
      start_watcher
      expect(listener).to have_received(:start)
      start_watcher
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'executes handler when source code has been modified' do
      start_watcher
      expect(Listen).to have_received(:to).with('./app', './lib', './spec') do |&block|
        expect(block).to be(&described_istance.method(:on_file_change))
        listener
      end
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'goes sleep' do
      start_watcher
      expect(described_istance).to have_received(:sleep)
    end
  end

  describe '#on_file_change' do
    subject(:on_file_change) { described_istance.on_file_change(modified, nil, nil) }

    # rubocop:disable RSpec/AnyInstance
    before do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
    end
    # rubocop:enable RSpec/AnyInstance

    context 'with app files' do
      let(:modified) { ['/project/app/example.rb'] }

      it 'executes its spec' do
        on_file_change
        expect(described_istance).to have_received(:run_tests)
          .with(['/project/spec/example_spec.rb'])
      end
    end

    context 'with lib files' do
      let(:modified) { ['/project/lib/example.rb'] }

      it 'executes its spec' do
        on_file_change
        expect(described_istance).to have_received(:run_tests)
          .with(['/project/spec/example_spec.rb'])
      end
    end

    context 'with spec files' do
      let(:modified) { ['/project/spec/example_spec.rb'] }

      it 'executes its' do
        on_file_change
        expect(described_istance).to have_received(:run_tests)
          .with(['/project/spec/example_spec.rb'])
      end
    end
  end
end
