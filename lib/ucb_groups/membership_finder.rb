module UcbGroups
  class MembershipFinder
    attr_accessor :namespace, :groups, :orgs

    def initialize(namespace)
      @namespace = namespace
    end

    def find(*options)
      @groups, @orgs = parse_options(options)

      return [] if @groups.empty? && @orgs.empty?

      ensure_valid_options

      args = {
          base: "ou=people,dc=berkeley,dc=edu",
          filter: membership_filter,
          attributes: Person.ldap_attributes
      }

      LdapConn.conn.search(args).map { |entry| Person.new(entry) }
    end

    private

    def parse_options(options)
      options = options.first || {}
      groups = options.fetch(:groups, []).map(&:to_s)
      orgs = options.fetch(:orgs, []).map(&:to_s)

      [groups, orgs]
    end

    def ensure_valid_options
      groups.each do |group|
        unless namespace_groups.include?(group.to_s)
          raise(InvalidCampusGroupError.new(group))
        end
      end
    end

    def membership_filter
      MembershipFilter.new(namespace, groups, orgs).to_s
    end

    def namespace_groups
      @namespace_groups ||= CampusGroup.find(namespace).map(&:id)
    end
  end
end

