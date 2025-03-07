#
# Cookbook Name:: test
# Recipe:: default
#
# Author:: Joshua Timberman <joshua@getchef.com>
#
# Copyright (c) 2014, Chef Software, Inc. <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This will fall back to loading the data bag item w/o vault.
secret = chef_vault_item('secrets', 'dbpassword')

file '/tmp/chef-vault-secret' do
  content secret['auth']
end

library_secret = test_chef_vault

file '/tmp/chef-vault-secret-from-library' do
  content library_secret['auth']
end

# Verify that we raise an exception if databag fallback is disabled
node.set['chef-vault']['databag_fallback'] = false
begin
  no_fallback_secret = chef_vault_item('secrets', 'dbpassword')
rescue
  no_fallback_secret = {"auth" => "exception raised"}
end
node.set['chef-vault']['databag_fallback'] = true

file '/tmp/chef-vault-secret-no-fallback' do
  content no_fallback_secret["auth"]
end

secret = chef_vault_item_for_environment('secrets', 'bacon')

file '/tmp/chef-vault-environment-secret' do
  content secret['type']
end

library_secret = test_chef_vault_for_environment
file '/tmp/chef-vault-environment-secret-from-library' do
  content library_secret['type']
end
