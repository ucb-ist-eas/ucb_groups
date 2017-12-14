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
      finder.find(:groups => [:deans, 'calmessages-test']).should_not be_empty
    end
  end

  context "Finding by org" do
    it "finds users beneath a single org" do
      finder.find(:orgs => [:JKASD]).should_not be_empty
    end

    it "finds users beneath any of the provided orgs" do
      jkasd_people = finder.find(:orgs => [:JKASD])
      jkasd_jjcns_people = finder.find(:orgs => [:JKASD, :JJCNS])

      (jkasd_people.length < jkasd_jjcns_people.length).should == true
    end
  end

  context "Finding by group and org" do
    it "finds users in a single group and org" do
      # Note, the memebers in these two groups may change over time, but it shouldn't
      # happen very often.  Test will need to be updated when groups members are changed

      testers = finder.find(:groups => ['calmessages-test'])
      names = testers.map(&:first_name)
      names.should =~ ["Veronica", "Elise", "Jeff"]

      jlstp_testers = finder.find(:groups => ['calmessages-test'], :orgs => [:JKASD])
      jlstp_names = jlstp_testers.map(&:first_name)
      jlstp_names.should =~ ["Elise"]
    end
  end
end
