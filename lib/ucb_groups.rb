require 'pp'
require 'ostruct'
require 'net-ldap'
require 'json'

require "ucb_groups/version"
require "ucb_groups/person"
require "ucb_groups/ldap_conn"
require "ucb_groups/campus_group"
require "ucb_groups/membership_filter"
require "ucb_groups/membership_finder"
require "ucb_groups/monkey_patches/net_ldap_filter"


module UcbGroups
  LdapBindFailedException = Class.new(StandardError)

  class InvalidCampusGroupError < StandardError
    def initialize(group)
      super(group)
    end
  end

  class InvalidFinderOptions < StandardError
    def initialize
      super("You must provide at least one group or one org")
    end
  end

  def self.root
    File.expand_path(File.join(__FILE__, '..', '..'))
  end
end


if __FILE__ == $PROGRAM_NAME
  finder = UcbGroups::MembershipFinder.new("calmessages")
  people = finder.find(:groups => ["it-staff"], :orgs => ["JKASD"])
  pp people
end
