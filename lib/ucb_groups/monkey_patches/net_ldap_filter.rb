# Pull request with this patch has been submitted via github.  As soon
# as this patch is merged into ruby-net-ldap master branch we can remove
# this monkey patch

Net::LDAP::Filter::FilterParser.class_eval do
  def parse_filter_branch(scanner)
    scanner.scan(/\s*/)
    if token = scanner.scan(/[-\w:.]*[\w]/)
      scanner.scan(/\s*/)
      if op = scanner.scan(/<=|>=|!=|:=|=/)
        scanner.scan(/\s*/)
        #if value = scanner.scan(/(?:[-\w*.+@=,#\$%&!'\s]|\\[a-fA-F\d]{2})+/)

        # Our patch allows ':' as a valid character.
        if value = scanner.scan(/(?:[-\w*.+@=,:#\$%&!'\s]|\\[a-fA-F\d]{2})+/)
          # 20100313 AZ: Assumes that "(uid=george*)" is the same as
          # "(uid=george* )". The standard doesn't specify, but I can find
          # no examples that suggest otherwise.
          value.strip!

          case op
            when "="
              Net::LDAP::Filter.eq(token, value)
            when "!="
              Net::LDAP::Filter.ne(token, value)
            when "<="
              Net::LDAP::Filter.le(token, value)
            when ">="
              Net::LDAP::Filter.ge(token, value)
            when ":="
              Net::LDAP::Filter.ex(token, value)
          end
        end
      end
    end
  end
end

