require "#{__dir__}/../app/boot.rb"
require "#{__dir__}/../app/foo.rb"

describe Foo do
  context '.foo' do
    it { expect(Foo.foo).to eq :bar }
  end
end