require 'spec_helper'

describe 'crowd_test::local_database' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.normal['crowd']['local_database']['password'] = 'somecrowdpw'
          node.normal['postgresql']['password']['postgres'] = 'somepgpw'
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        expect(chef_run).to include_recipe('osl-postgresql::server')
      end

      it do
        expect(chef_run).to create_postgresql_database('crowd').with(
          owner: 'postgres'
        )
      end

      it do
        expect(chef_run).to create_postgresql_user('crowd').with(
          create_user: 'crowd',
          password: 'somecrowdpw',
          database: 'crowd'
        )
      end
    end
  end
end
