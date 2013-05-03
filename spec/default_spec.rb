require 'spec_helper'

describe 'papertrail-cookbook::default' do
  it 'require rsyslog' do
    expect(runner.converge('papertrail-cookbook::default')).to include_recipe 'rsyslog'
  end

  it 'uses the basename of the filename as the suffix for state file name' do
    chef_run = runner('test', {
      papertrail: {
        watch_files: {
          'test/file/name.jpg' => 'test_file'
        }
      }
    }).converge('papertrail-cookbook::default')

    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileName test/file/name.jpg'
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileTag test_file'
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileStateFile state_file_name_test_file'
  end
end
