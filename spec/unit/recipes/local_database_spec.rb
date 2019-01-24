require 'spec_helper'

describe 'crowd::local_database' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.normal['crowd']['local_database']['password'] = 'somecrowdpw'
          node.normal['postgresql']['password']['postgres'] = 'somepgpw'
        end.converge(described_recipe)
      end

      before do
        stub_command('ls /var/lib/pgsql/8.4/data/recovery.conf').and_return(true)
        stub_command('ls /var/lib/pgsql/9.2/data/recovery.conf').and_return(true)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        expect(chef_run).to create_postgresql_database_user('create crowd').with(
          username: 'crowd',
          connection: {
            host: 'localhost',
            username: 'postgres',
            password: 'somepgpw',
          },
          password: 'somecrowdpw'
        )
      end

      it do
        expect(chef_run).to create_postgresql_database('crowd').with(
          connection: {
            host: 'localhost',
            username: 'postgres',
            password: 'somepgpw',
          },
          owner: 'postgres'
        )
      end

      it do
        expect(chef_run).to grant_postgresql_database_user('grant crowd').with(
          username: 'crowd',
          connection: {
            host: 'localhost',
            username: 'postgres',
            password: 'somepgpw',
          },
          database_name: 'crowd',
          privileges: [:all]
        )
      end
    end
  end
end
