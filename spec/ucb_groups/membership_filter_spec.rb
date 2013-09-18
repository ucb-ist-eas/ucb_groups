require_relative "../spec_helper"


describe "MembershipFilter" do
  let(:finder) { UcbGroups::MembershipFilter.new(namespace, groups, orgs) }

  it "creates groups filter" do
    filter = UcbGroups::MembershipFilter.new(:calmessages, [:deans], []).to_s
    filter_str = "(&(objectclass=person)" +
                    "(ismemberof=cn=edu:berkeley:app:calmessages:deans,ou=campus groups,dc=berkeley,dc=edu))"
    filter.should eql(filter_str)

    filter = UcbGroups::MembershipFilter.new(:calmessages, [:deans, :instructors], []).to_s
    filter_str = "(&(objectclass=person)" +
                    "(|(ismemberof=cn=edu:berkeley:app:calmessages:deans,ou=campus groups,dc=berkeley,dc=edu)" +
                      "(ismemberof=cn=edu:berkeley:app:calmessages:instructors,ou=campus groups,dc=berkeley,dc=edu)))"
    filter.should eql(filter_str)
  end

  it "creates orgs filter" do
    filter = UcbGroups::MembershipFilter.new(:calmessages, [], ["JKASD"]).to_s
    filter_str = "(&(objectclass=person)" +
                   "(berkeleyedudeptunithierarchystring=*JKASD*))"
    filter.should eql(filter_str)

    filter = UcbGroups::MembershipFilter.new(:calmessages, [], ["JKASD", "JJCNS"]).to_s
    filter_str = "(&(objectclass=person)" +
                   "(|(berkeleyedudeptunithierarchystring=*JKASD*)" +
                     "(berkeleyedudeptunithierarchystring=*JJCNS*)))"
    filter.should eql(filter_str)
  end

  it "creates groups and orgs filter" do
    filter = UcbGroups::MembershipFilter.new(:calmessages, [:deans], ["JKASD"]).to_s
    filter_str = "(&(objectclass=person)" +
                   "(&(ismemberof=cn=edu:berkeley:app:calmessages:deans,ou=campus groups,dc=berkeley,dc=edu)" +
                     "(berkeleyedudeptunithierarchystring=*JKASD*)))"
    filter.should eql(filter_str)

    filter = UcbGroups::MembershipFilter.new(:calmessages, [:deans, :instructors], ["JKASD"]).to_s
    filter_str = "(&(objectclass=person)" +
                   "(&(|(ismemberof=cn=edu:berkeley:app:calmessages:deans,ou=campus groups,dc=berkeley,dc=edu)" +
                       "(ismemberof=cn=edu:berkeley:app:calmessages:instructors,ou=campus groups,dc=berkeley,dc=edu))" +
                     "(berkeleyedudeptunithierarchystring=*JKASD*)))"
    filter.should eql(filter_str)

    filter = UcbGroups::MembershipFilter.new(:calmessages, [:deans, :instructors], ["JKASD", "JJCNS"]).to_s
    filter_str = "(&(objectclass=person)" +
                   "(&(|(ismemberof=cn=edu:berkeley:app:calmessages:deans,ou=campus groups,dc=berkeley,dc=edu)" +
                       "(ismemberof=cn=edu:berkeley:app:calmessages:instructors,ou=campus groups,dc=berkeley,dc=edu))" +
                     "(|(berkeleyedudeptunithierarchystring=*JKASD*)(berkeleyedudeptunithierarchystring=*JJCNS*))))"
    filter.should eql(filter_str)
  end
end
