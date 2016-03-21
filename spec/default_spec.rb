require 'spec_helper'

describe 'papertrail::default' do
  let(:runner)   { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  before do
    node.set['papertrail']['watch_files'] = {'test/file/name.jpg' => 'test_file'}
  end

  it 'require rsyslog' do
    expect(chef_run).to include_recipe 'rsyslog'
  end

  it 'uses the basename of the filename as the suffix for state file name' do
    config_filename = '/etc/rsyslog.d/60-watch-files.conf'
    expect(chef_run).to render_file(config_filename)
      .with_content('$InputFileName test/file/name.jpg')
    expect(chef_run).to render_file(config_filename)
      .with_content('$InputFileTag test_file')
    expect(chef_run).to render_file(config_filename)
      .with_content('$InputFileStateFile state_file_name_test_file')
  end

  it 'uses attributes to generate configuration' do
    config_filename = '/etc/rsyslog.d/65-papertrail.conf'
    expect(chef_run).to render_file(config_filename)
      .with_content('$ActionResumeRetryCount -1')
    expect(chef_run).to render_file(config_filename)
      .with_content('$ActionQueueMaxDiskSpace 100M')
    expect(chef_run).to render_file(config_filename)
      .with_content('$ActionQueueSize 100000')
    expect(chef_run).to render_file(config_filename)
      .with_content('$ActionQueueFileName papertrailqueue')
  end
end
