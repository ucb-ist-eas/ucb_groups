require 'rest-client'
require_relative "../spec_helper"
require 'set'

#groups = UcbGroups::CampusGroup.find(:calmessages)
#pp groups.map(&:name).sort


def assert_matching_group(group)
  @finder ||= UcbGroups::MembershipFinder.new(:calmessages)
  grouper_uids = @finder.find(:groups => [group]).map(&:uid).sort
  calmsgs_uids = calmsgs_group_uids(group)

  #if calmsgs_uids.length != grouper_uids.length
    puts "calmsgs: #{calmsgs_uids.length}, grouper: #{grouper_uids.length}"
    puts "Only In Calmsgs: #{calmsgs_uids - grouper_uids}\nOnly in Grouper: #{grouper_uids - calmsgs_uids}"
    grouper_uids.length.should eql(calmsgs_uids.length)
  #end

  calmsgs_uids.should eql(grouper_uids)
end

def calmsgs_group_uids(group)
  uids = RestClient.get("localhost:3000/api/groups/#{group}.json")
  JSON.parse(uids).map(&:to_s).sort
end


describe "Calmsgs Groups Compatibility" do
  it "academic-senate-faculty" do
    # fails but close enough
    assert_matching_group("academic-senate-faculty")
  end

  it "deans" do
    # fails but close enough
    assert_matching_group("deans")
  end

  it "dept-admin" do
    # fails because ldap does not keep emptititlecode around for expired people and caldap does (close enough)
    assert_matching_group("dept-admin")
  end

  it "dept-chairs" do
    # fails but close enough
    assert_matching_group("dept-chairs")
  end

  it "directors" do
    assert_matching_group("directors")
  end

  it "emeriti" do
    assert_matching_group("emeriti")
  end

  it "faculty" do
    # fails because calmsgs is grabbing people that it shouldn't.  In many instances calmsgs
    # is grabbing staff that have no academic affiliation (close enough)
    assert_matching_group("faculty")
  end

  it "it-staff" do
    # fails because calmsgs it grabbing retired or expired it-staff (close enough)
    assert_matching_group("it-staff")
  end

  it "staff" do
    # fails but close enough
    assert_matching_group("staff")
  end

  it "students" do
    # fails but close enough
    assert_matching_group("students")
  end

  it "managers" do
    assert_matching_group("managers") # fails but close enough
  end

  it "supervisors" do
    assert_matching_group("supervisors") # fails but close enough
  end

  it "affiliates" do
    assert_matching_group("affiliates") # fails
  end

  it "ucop" do
    # fails but close enough
    assert_matching_group("ucop")
  end

  it "graduate-students" do
    # no calmsgs group
    # assert_matching_group("graduate-students")
  end

  it "advisors" do
    # no calmsgs group
    # assert_matching_group("advisors")
  end

  it "gsis" do
    # no calmsgs group
    # assert_matching_group("gsis")
  end

  it "gsrs" do
    # no calmsgs group
    # assert_matching_group("gsrs")
  end

  it "instructors" do
    # no calmsgs group
    #assert_matching_group("instructors")
  end

  it "undergrad-students" do
    # no calmsgs group
    # assert_matching_group("undergrad-students")
  end
end


