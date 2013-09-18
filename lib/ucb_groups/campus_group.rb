module UcbGroups
  class CampusGroup
    attr_accessor :dn, :description, :namespace, :name

    def initialize(ldap_entry)
      @dn = ldap_entry[:dn].first.to_s
      @description = ldap_entry[:description].first.to_s
      @namespace, @name = parse_dn
    end

    def self.find(namespace)
      args = {
          :base => "ou=campus groups,dc=berkeley,dc=edu",
          :filter => build_filter(namespace),
          :attributes => %w(dn description name),
      }
      LdapConn.conn.search(args).map { |entry| CampusGroup.new(entry) }
    end

    private

    # example dn: "cn=edu:berkeley:app:calmessages:faculty,ou=campus groups,dc=berkeley,dc=edu"
    def parse_dn
      dn.split(/:|,/)[3..4].map(&:to_s)
    end

    def self.build_filter(namespace)
      "(&(objectclass=*)(cn=edu:berkeley:app:#{namespace}*))"
    end
  end
end
