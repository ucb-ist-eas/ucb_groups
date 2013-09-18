require_relative '../lib/ucb_groups'
require 'yaml'

RSpec.configure do |config|
  ldap_yml = File.expand_path(File.dirname("#{__FILE__}") + "/../ldap.yml")
  UcbGroups::LdapConn.authenticate_from_config(ldap_yml)
end
