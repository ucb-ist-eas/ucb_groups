require_relative "../spec_helper"


describe "CampusGroup" do
  let(:entry) do
    {
        :dn => ["cn=edu:berkeley:app:calmessages:calmessages-test,ou=campus groups,dc=berkeley,dc=edu"],
        :description => ["Calmessages Test"],
        :displayName => ["calmessages-test"]
    }
  end

  it "finds all groups within a namespace" do
    groups = UcbGroups::CampusGroup.find(:calmessages)
    groups.should_not be_empty
  end

  it "initializes an entry" do
    group = UcbGroups::CampusGroup.new(entry)

    group.id.should eql("calmessages-test")
    group.name.should eql(entry[:displayName].first)
    group.description.should eql(entry[:description].first)
    group.namespace.should eql("calmessages")
    group.dn.should eql(entry[:dn].first)
  end
end
