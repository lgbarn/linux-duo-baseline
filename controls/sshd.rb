# copyright: 2020, Luther Barnum

title "SSH DUO config"

# you can also use plain tests

# you add controls here
control "ssh-01" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title 'Server: Check sshd_config owner, group and permissions.'
  desc 'The sshd_config should owned by root, only be writable/readable by owner and not be executable.'
  describe file("/etc/ssh/sshd_config") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into os.darwin? ? 'wheel' : 'root' }
    it { should_not be_executable }
    it { should be_readable.by('owner') }
    it { should_not be_readable.by('group') }
    it { should_not be_readable.by('other') }
    it { should be_writable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should_not be_writable.by('other') }
  end
end

#control 'sshd-02' do
#  impact 1.0
#  title 'Server: Specify the listen ssh Port'
#  desc 'Always specify which port the SSH server should listen to. Prevent unexpected settings.'
#  describe sshd_config do
#    its('Port') { should eq('22') }
#  end
#end

control 'sshd-03' do
  impact 1.0
  title 'Server: Specify the IP should be used instead of DNS name'
  desc 'IP should be used instead of DNS name'
  describe sshd_config do
    its('UseDNS') { should eq('no') }
  end
end

control 'sshd-04' do
  impact 1.0
  title 'Server: Force DUO for ssh logins'
  desc 'Force DUO for ssh logins'
  describe sshd_config do
    its('ForceCommand') { should eq('/usr/sbin/login_duo') }
  end
end

control 'sshd-05' do
  impact 1.0
  title 'Server: Disable tunneling'
  desc 'Disable tunneling'
  describe sshd_config do
    its('PermitTunnel') { should eq('no') }
  end
end

control 'sshd-05' do
  impact 1.0
  title 'Server: Disable Forwarding'
  desc 'Disable Forwarding'
  describe sshd_config do
    its('AllowTcpForwarding') { should eq('no') }
  end
end

