require File.dirname(__FILE__) + '/../spec_helper'

describe "Response" do
  before do
    @test_addr = 'foo@bar.org'
    @test_name = 'Foo Bar'
  end

  it "should require a valid email address" do
    Response.new(:email_address => 'no_at_sign').should_not be_valid
    Response.new(:email_address => 'after@no_dot').should_not be_valid
    Response.new(:email_address => 'valid@domain.sub').should be_valid
  end

  it "should ensure email addresses are unique" do
    Response.create(:email_address => @test_addr)
    Response.new(:email_address => @test_addr, :name => @test_name).should_not be_valid
  end

  it "has many answers" do
    Response.should have_many(:answers)
  end

  it "returns the next unanswered question" do
    test_response  = Response.create(:email_address => @test_addr, :name => @test_name)
    test_questions = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
    test_answers   = (1..3).collect{|i| Answer.create(:question_id => i, :response => test_response)}
    test_response.next_question.should == Question.find(4)
  end
end
