describe file('/opt/atlassian-crowd-2.5.2') do
  it { should exist }
  it { should be_directory }
end

describe user('crowd') do
  it { should exist }
  its('home') { should eq '/opt/atlassian-crowd-2.5.2' }
end

describe file('/opt/atlassian-crowd-2.5.2/crowd-webapp/WEB-INF/classes/crowd-init.properties') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('content') { should match %r{crowd.home=/var/crowd-home} }
end

describe file('/var/crowd-home') do
  it { should exist }
  it { should be_directory }
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'crowd' }
end

%w(
  build.sh
  start_crowd.sh
  stop_crowd.sh
  apache-tomcat/bin/catalina.sh
  apache-tomcat/bin/setenv.sh
  apache-tomcat/bin/tool-wrapper.sh
  apache-tomcat/bin/digest.sh
  apache-tomcat/bin/shutdown.sh
  apache-tomcat/bin/version.sh
  apache-tomcat/bin/setclasspath.sh
  apache-tomcat/bin/startup.sh
).each do |s|
  describe file("/opt/atlassian-crowd-2.5.2/#{s}") do
    it { should exist }
    its('group') { should eq 'crowd' }
    its('mode') { should cmp '0755' }
  end
end

%w(logs temp work).each do |d|
  describe file("/opt/atlassian-crowd-2.5.2/apache-tomcat/#{d}") do
    it { should exist }
    it { should be_directory }
    its('owner') { should eq 'crowd' }
  end
end

describe file('/opt/atlassian-crowd-2.5.2/atlassian-crowd-openid-server.log') do
  it { should exist }
  its('owner') { should eq 'crowd' }
  its('group') { should eq 'crowd' }
  its('mode') { should cmp '0644' }
end

describe file('/opt/atlassian-crowd-2.5.2/database') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'crowd' }
  its('group') { should eq 'crowd' }
  its('mode') { should cmp '0755' }
end

describe file('/etc/init.d/crowd') do
  it { should exist }
  its('mode') { should cmp '0755' }
  its('content') { should match %r{CATALINA_HOME=/opt/atlassian-crowd-2.5.2} }
  its('content') { should contain 'export CATALINA_PID="$CATALINA_HOME/work/catalina.pid' }
end

describe service('crowd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
