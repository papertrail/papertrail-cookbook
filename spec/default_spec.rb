require 'spec_helper'

describe 'papertrail-cookbook::default' do
  it 'require rsyslog' do
    expect(runner.converge('papertrail-cookbook::default')).to include_recipe 'rsyslog'
  end
end
