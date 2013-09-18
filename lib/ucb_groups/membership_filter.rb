module UcbGroups
  class MembershipFilter
    attr_accessor :namespace, :groups, :orgs

    def initialize(namespace, groups, orgs)
      @namespace = namespace
      @groups = groups
      @orgs = orgs
    end

    def to_s
      @filter ||= begin
        if groups.empty?
          objectclass_filter & orgs_filter
        elsif orgs.empty?
          objectclass_filter & groups_filter
        else
          objectclass_filter & (groups_filter & orgs_filter)
        end
      end
      @filter.to_rfc2254
    end

    private

    def objectclass_filter
      Net::LDAP::Filter.eq("objectclass", "person")
    end

    def groups_filter
      groups.map    { |group| group_filter(group) }
            .reduce { |accum, filter| accum.send("|", filter) }
    end

    def group_filter(group)
      Net::LDAP::Filter.
          eq("ismemberof",
             "cn=edu:berkeley:app:#{self.namespace}:#{group},ou=campus groups,dc=berkeley,dc=edu")
    end

    def orgs_filter
      @orgs.map    { |org| org_filter(org) }
           .reduce { |accum, filter| accum.send("|", filter) }
    end

    def org_filter(org)
      Net::LDAP::Filter.eq("berkeleyedudeptunithierarchystring", "*#{org}*")
    end
  end
end
