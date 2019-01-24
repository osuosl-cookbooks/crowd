require 'spec_helper'

describe 'crowd::server' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.normal['crowd']['url'] = 'http://someurl.osl'
          node.normal['crowd']['homedir'] = 'somehomedir'
          node.normal['crowd']['datadir'] = 'somedatadir'
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        expect(chef_run).to head_http_request('HEAD http://someurl.osl').with(
          message: '',
          url: 'http://someurl.osl'
        )
      end

      it do
        expect(chef_run).to create_user('crowd').with(
          comment: 'Atlassian Crowd',
          home: 'somehomedir',
          system: true
        )
      end

      it do
        expect(chef_run).to create_template('somehomedir/crowd-webapp/WEB-INF/classes/crowd-init.properties').with(
          source: 'crowd-init.properties.erb',
          variables: {
            crowd_home: 'somedatadir',
          },
          owner: 'root',
          group: 'root',
          mode: 00644
        )
      end

      it do
        expect(chef_run).to create_directory('somedatadir').with(
          owner: 'crowd',
          mode: 00755
        )
      end

      %w(build.sh start_crowd.sh stop_crowd.sh apache-tomcat/bin/catalina.sh apache-tomcat/bin/setenv.sh apache-tomcat/bin/tool-wrapper.sh apache-tomcat/bin/digest.sh apache-tomcat/bin/shutdown.sh apache-tomcat/bin/version.sh apache-tomcat/bin/setclasspath.sh apache-tomcat/bin/startup.sh).each do |s|
        it do
          expect(chef_run).to create_file("somehomedir/#{s}").with(
            group: 'crowd',
            mode: 00755
          )
        end
      end

      %w(logs temp work).each do |d|
        it do
          expect(chef_run).to create_directory("somehomedir/apache-tomcat/#{d}").with(
            owner: 'crowd'
          )
        end
      end

      it do
        expect(chef_run).to create_file_if_missing('somehomedir/atlassian-crowd-openid-server.log').with(
          owner: 'crowd',
          group: 'crowd',
          mode: 00644
        )
      end

      it do
        expect(chef_run).to create_directory('somehomedir/database').with(
          owner: 'crowd',
          group: 'crowd',
          mode: 00755
        )
      end

      it do
        expect(chef_run).to create_template('/etc/init.d/crowd').with(
          source: 'crowd.init.erb',
          owner: 'root',
          group: 'root',
          mode: 00755,
          variables: {
            crowd_install_dir: 'somehomedir',
            crowd_env: ['CATALINA_PID="$CATALINA_HOME/work/catalina.pid"'],
          }
        )
      end

      it do
        expect(chef_run.template('/etc/init.d/crowd')).to notify('service[crowd]').to(:restart)
      end

      it do
        expect(chef_run).to enable_service('crowd').with(
          supports: { restart: true }
        )
      end

      it do
        expect(chef_run).to start_service('crowd').with(
          supports: { restart: true }
        )
      end
    end
  end
end
