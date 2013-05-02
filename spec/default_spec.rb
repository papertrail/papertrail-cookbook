require 'spec_helper'

describe 'papertrail-cookbook::default' do
  it 'uses the basename of the filename as the suffix for state file name' do
    chef_run = runner('test', {
      papertrail: {
        watch_files: {
          'test/file/name.jpg' => 'test-file'
        }
      }
    }).converge('papertrail-cookbook::default')

    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileName test/file/name.jpg'
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileStateFile state_file_name'
  end
end
