require_relative "../spec_helper"


describe "MembershipFinder" do
  let(:finder) { UcbGroups::MembershipFinder.new(:calmessages) }

  context "find options" do
    it "recognizes if groups are invalid" do
      err = UcbGroups::InvalidCampusGroupError
      expect { finder.find(:groups => [:invalid_group]) }.to raise_error(err)
      expect { finder.find(:groups => [:deans, :invalid_group]) }.to raise_error(err)
    end

    it "returns no results if :group and :orgs are both empty" do
      finder.find(:groups => [], :orgs => []).should be_empty
    end
  end

  context "Finding by group" do
    it "finds users in a single group" do
      finder.find(:groups => [:deans]).should_not be_empty
    end

    it "finds users in a multiple groups" do
      finder.find(:groups => [:deans, :instructors]).should_not be_empty
    end
  end

  context "Finding by org" do
    it "finds users beneath a single org" do
      finder.find(:orgs => [:JKASD]).should_not be_empty
    end

    it "finds users beneath any of the provided orgs" do
      jkasd_people = finder.find(:orgs => [:JKASD])
      jkasd_jjcns_people = finder.find(:orgs => [:JKASD, :JJCNS])

      (jkasd_people.length < jkasd_jjcns_people.length).should be_true
    end
  end

  context "Finding by group and org" do
    it "finds users in a single group and org" do
      campus_it_staff = finder.find(:groups => ["it-staff"])
      ist_it_staff = finder.find(:groups => ["it-staff"], :orgs => [:VRIST])

      campus_it_staff.should_not be_empty
      ist_it_staff.should_not be_empty
      (ist_it_staff.length < campus_it_staff.length).should be_true
    end
  end
end
