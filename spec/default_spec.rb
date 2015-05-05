require 'spec_helper'

describe 'papertrail-cookbook::default' do
  it 'require rsyslog' do
    expect(runner.converge('papertrail-cookbook::default')).to include_recipe 'rsyslog'
  end

  describe 'plain filename' do
    it 'uses the basename of the filename as the suffix for state file name' do
      chef_run = runner('test', {
        papertrail: {
          watch_files: {
            'spec/testlogs/spec.log' => 'test_file'
          }
        }
      }).converge('papertrail-cookbook::default')

      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileName spec/testlogs/spec.log'
      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileTag test_file'
      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileStateFile state_file_spec_test_file'
    end
  end

  describe 'wildcard filenames' do
    around do |example|
      File.open("spec/testlogs/a.log", "w")
      File.open("spec/testlogs/b.log", "w")

      example.run

      File.delete("spec/testlogs/a.log")
      File.delete("spec/testlogs/b.log")
    end

    it 'uses globbing to expand the filelist' do
      chef_run = runner('test', {
        papertrail: {
          watch_files: {
            'spec/testlogs/*.log' => 'test_file'
          }
        }
      }).converge('papertrail-cookbook::default')

      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileName spec/testlogs/a.log'
      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileTag test_file'
      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileStateFile state_file_a_test_file'

      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileName spec/testlogs/b.log'
      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileTag test_file'
      expect(chef_run).to create_file_with_content '/etc/rsyslog.d/60-watch-files.conf', '$InputFileStateFile state_file_b_test_file'
    end
  end

  it 'uses attributes to generate configuration' do
    chef_run = runner.converge('papertrail-cookbook::default')
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/65-papertrail.conf', '$ActionResumeRetryCount -1'
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/65-papertrail.conf', '$ActionQueueMaxDiskSpace 100M'
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/65-papertrail.conf', '$ActionQueueSize 100000'
    expect(chef_run).to create_file_with_content '/etc/rsyslog.d/65-papertrail.conf', '$ActionQueueFileName papertrailqueue'
  end
end
