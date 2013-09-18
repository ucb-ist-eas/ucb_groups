module UcbGroups
  class LdapConn
    def self.conn
      net_ldap = ::Net::LDAP.new(auth_info)
      net_ldap.bind || raise(BindFailedException)
      net_ldap
    rescue ::Net::LDAP::LdapError
      raise(LdapBindFailedException)
    end

    def self.authenticate(username, password, host='nds.berkeley.edu')
      @username = username
      @password = password
      @host = host
    end

    def self.authenticate_from_config(config_file)
      conf = YAML.load_file(config_file)
      self.authenticate(conf['username'], conf['password'], conf['host'])
    end

    private

    def self.auth_info
      @auth_info ||= {
          host: @host,
          auth: {
              method: :simple,
              username: @username,
              password: @password,
          },
          port: 636,
          encryption: { method: :simple_tls }
      }
    end
  end
end
