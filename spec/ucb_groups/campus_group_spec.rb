require_relative "../spec_helper"


describe "CampusGroup" do
  let(:entry) do
    {
        :dn => ["cn=edu:berkeley:app:calmessages:faculty,ou=campus groups,dc=berkeley,dc=edu"],
        :description => ["UCB Instructors"],
        :displayName => ["Instructors"]
    }
  end

  it "Finds Campus Groups" do
    groups = UcbGroups::CampusGroup.find(:calmessages)
    groups.should_not be_empty
  end

  it "initializes an entry" do
    group = UcbGroups::CampusGroup.new(entry)

    group.id.should eql("faculty")
    group.name.should eql("Instructors")
    group.description.should eql(entry[:description].first)
    group.namespace.should eql("calmessages")
    group.dn.should eql(entry[:dn].first)
  end
end
