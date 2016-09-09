require 'spec_helper'

describe Plugin::Sdk::Ruby do
  it 'has a version number' do
    expect(Plugin::Sdk::Ruby::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
