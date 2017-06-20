module UcbGroups
  class Person
    include Comparable

    ATTRIBUTE_MAPPINGS = {
        :uid => :uid,
        :first_name => :givenname,
        :last_name => :sn,
        :public_email => :mail,
        :official_email => :ucbemail,
        :orgs => :berkeleyedudeptunithierarchystring
    }.freeze

    attr_accessor *ATTRIBUTE_MAPPINGS.keys

    def initialize(ldap_entry)
      ATTRIBUTE_MAPPINGS.each do |attr, val|
        self.send("#{attr}=", ldap_entry[val].first.to_s) if ldap_entry[val]
      end
    end

    def full_name
      [first_name, last_name].join(" ")
    end

    def self.ldap_attributes
      @ldap_attributes ||= ATTRIBUTE_MAPPINGS.values.map(&:to_s)
    end

    def eql?(other_person)
      self.hash == other_person.hash
    end

    def hash
      self.uid.to_i
    end

    def <=>(other_person)
      self.hash <=> other_person.hash
    end
  end
end
