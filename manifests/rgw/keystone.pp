#
# Copyright (C) 2014 Catalyst IT Limited.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# Author: Ricardo Rocha <ricardo@catalyst.net.nz>
#
# Configures keystone auth/authz for the ceph radosgw.
#
### == Name
# # The RGW id. An alphanumeric string uniquely identifying the RGW.
# ( example: radosgw.gateway )
#
### == Parameters
#
# [*rgw_keystone_admin_domain*]
#   (Required) The name of OpenStack domain with admin
#   privilege when using OpenStack Identity API v3.
#
# [*rgw_keystone_admin_project*]
#   (Optional) The name of OpenStack project with admin
#   privilege when using OpenStack Identity API v3
#
# [*rgw_keystone_admin_user*]
#   (Required) The user name of OpenStack tenant with admin
#   privilege (Service Tenant).
#
# [*rgw_keystone_admin_password*]
#   (Required) The password for OpenStack admin user.
#
# [*rgw_keystone_url*]
#   (Optional) The internal or admin url for keystone.
#   Defaults to 'http://127.0.0.1:5000'
#
# [*rgw_keystone_accepted_roles*]
#   (Optional) Roles to accept from keystone.
#   Comma separated list of roles.
#   Defaults to 'member'
#
# [*rgw_keystone_token_cache_size*]
#   (Optional) How many tokens to keep cached.
#   Defaults to 500
#
# [*rgw_s3_auth_use_keystone*]
#   (Optional) Whether to enable keystone auth for S3.
#   Defaults to true
#
# [*rgw_keystone_implicit_tenants*]
#   (Optional) Set 'true' for a private tenant for each user.
#   Defaults to true
#
## DEPRECATED PARAMS
#
# [*rgw_keystone_version*]
#   (Optional) The api version for keystone.
#   Defaults to undef
#
# [*rgw_keystone_admin_token*]
#   (Optional) The keystone admin token.
#   Defaults to undef
#
# [*use_pki*]
#   (Optional) Whether to use PKI related configuration.
#   Defaults to undef
#
# [*rgw_keystone_revocation_interval*]
#   (Optional) Interval to check for expired tokens.
#   Not useful if not using PKI tokens (if not, set to high value).
#   Defaults to undef
#
# [*nss_db_path*]
#   (Optional) Path to NSS < - > keystone tokens db files.
#   Defaults to undef
#
# [*user*]
#   (Optional) User running the web frontend.
#   Defaults to undef
#
define ceph::rgw::keystone (
  $rgw_keystone_admin_domain,
  $rgw_keystone_admin_project,
  $rgw_keystone_admin_user,
  $rgw_keystone_admin_password,
  $rgw_keystone_url                 = 'http://127.0.0.1:5000',
  $rgw_keystone_accepted_roles      = 'member',
  $rgw_keystone_token_cache_size    = 500,
  $rgw_s3_auth_use_keystone         = true,
  $rgw_keystone_implicit_tenants    = true,
  ## DEPRECATED PARAMS
  $rgw_keystone_version             = undef,
  $rgw_keystone_admin_token         = undef,
  $use_pki                          = undef,
  $rgw_keystone_revocation_interval = undef,
  $nss_db_path                      = undef,
  $user                             = undef,
) {

  unless $name =~ /^radosgw|rgw\..+/ {
    fail("Define name must be started with 'radosgw.' or 'rgw.'")
  }

  if $rgw_keystone_version {
    warning('ceph::rgw::keystone::rgw_keystone_version is deprecated')
  }
  if $rgw_keystone_admin_token {
    warning('ceph::rgw::keystone::rgw_keystone_admin_token is deprecated')
  }
  if $use_pki {
    warning('ceph::rgw::keystone::use_pki is deprecated')
  }
  if $rgw_keystone_revocation_interval {
    warning('ceph::rgw::keystone::rgw_keystone_revocation_interval is deprecated')
  }
  if $nss_db_path {
    warning('ceph::rgw::keystone::nss_db_path is deprecated')
  }
  if $user {
    warning('ceph::rgw::keystone::user is deprecated')
  }

  ceph_config {
    "client.${name}/rgw_keystone_url":              value => $rgw_keystone_url;
    "client.${name}/rgw_keystone_accepted_roles":   value => join(any2array($rgw_keystone_accepted_roles), ',');
    "client.${name}/rgw_keystone_token_cache_size": value => $rgw_keystone_token_cache_size;
    "client.${name}/rgw_s3_auth_use_keystone":      value => $rgw_s3_auth_use_keystone;
    "client.${name}/rgw_keystone_implicit_tenants": value => $rgw_keystone_implicit_tenants;
  }

  ceph_config {
    "client.${name}/rgw_keystone_api_version":    value => 3;
    "client.${name}/rgw_keystone_admin_domain":   value => $rgw_keystone_admin_domain;
    "client.${name}/rgw_keystone_admin_project":  value => $rgw_keystone_admin_project;
    "client.${name}/rgw_keystone_admin_user":     value => $rgw_keystone_admin_user;
    "client.${name}/rgw_keystone_admin_password": value => $rgw_keystone_admin_password;
    "client.${name}/rgw_keystone_admin_token":    ensure => absent;
  }

  ceph_config {
    "client.${name}/nss_db_path":                      ensure => absent;
    "client.${name}/rgw_keystone_revocation_interval": ensure => absent;
  }
}
