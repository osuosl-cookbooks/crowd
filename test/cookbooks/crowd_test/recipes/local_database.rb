#
# Cookbook Name:: crowd
# Recipe:: local_database
#
# Copyright 2012, SecondMarket Labs, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'osl-postgresql::server'

# randomly generate postgres password
node.default_unless['crowd']['local_database']['password'] = random_password

postgresql_database_user 'create crowd' do
  username 'crowd'
  connection postgresql_connection_info
  password node['crowd']['local_database']['password']
  action :create
end

postgresql_database 'crowd' do
  owner 'crowd'
end

postgresql_database_user 'grant crowd' do
  username 'crowd'
  connection postgresql_connection_info
  database_name 'crowd'
  privileges [:all]
  action :grant
end
