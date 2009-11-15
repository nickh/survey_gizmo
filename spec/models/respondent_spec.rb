require File.dirname(__FILE__) + '/../spec_helper'

describe "Respondent" do
  before do
    @test_addr = 'foo@bar.org'
    @test_name = 'Foo Bar'
  end

  it "has one response" do
    Respondent.should have_one(:response)
  end

  it "should require a valid email address" do
    Respondent.new(:email_address => 'no_at_sign').should_not be_valid
    Respondent.new(:email_address => 'after@no_dot').should_not be_valid
    Respondent.new(:email_address => 'valid@domain.sub').should be_valid
  end

  it "should ensure email addresses are unique" do
    Respondent.create(:email_address => @test_addr)
    Respondent.new(:email_address => @test_addr, :name => @test_name).should_not be_valid
  end

  it "creates an associated response when saving new respondents if none exists" do
    respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
    respondent.response.should_not be_nil
  end

  it "creates an associated response when saving existing responders if none exists" do
    respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
    Response.delete_all(:respondent_id => respondent.id)
    respondent = Respondent.find_by_email_address(@test_addr)
    respondent.response.should be_nil
    respondent.save
    respondent.response.should_not be_nil
  end
end
