# copyright: 2020, Luther Barnum

title "DUO Repoconfig"

# you can also use plain tests

# you add controls here
control "duo-01" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Server: Check duosecurity.repo owner, group and permissions.'
  desc 'The duosecurity.repo should owned by root, only be writable/readable by owner and not be executable.'
  describe file("/etc/yum.repos.d/duosecurity.repo") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should_not be_executable }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end

control "duo-02" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Check install of DUO GPG Key'
  desc 'The DUO GPG key should be installed before package can be installed'
  describe command("rpm -qa --qf '%{VERSION}-%{RELEASE} %{SUMMARY}\n' gpg-pubkey*") do
    its('exit_status')  { should eq 0 }
    its('stdout')  { should match (/Duo/) }
  end
end

control "duo-03" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Check install of DUO Package'
  desc 'The DUO Package be installed'
  describe package("inspec") do
    it  { should be_installed }
  end
end
  
control "duo-04" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Check DUO Config file'
  desc 'The DUO config file should be present and configured'
  describe file("/etc/duo/login_duo.conf") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'sshd' }
    it { should_not be_executable }
    it { should be_readable.by('owner') }
    it { should_not be_readable.by('group') }
    it { should_not be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end

control "duo-05" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Check DUO Config file parameters'
  desc 'The DUO config file should be configured'
  describe ini("/etc/duo/login_duo.conf") do
    its('duo.ikey') { should_not eq('') }
    its('duo.skey') { should_not eq('') }
    its('duo.host') { should_not eq('') }
    its('duo.pushinfo') { should eq('yes') }
  end
end

control "duo-06" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Check DUO script'
  desc 'The DUO script should be present'
  describe file("/usr/sbin/login_duo_multi") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_executable }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end
