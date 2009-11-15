require File.dirname(__FILE__) + '/../spec_helper'

describe "Response" do
  it "belongs to respondent" do
    Response.should belong_to(:respondent)
  end

  it "has many answers" do
    Response.should have_many(:answers)
  end

  it "returns the next unanswered question" do
    test_response  = Response.create
    test_questions = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
    test_answers   = (1..3).collect{|i| Answer.create(:question_id => i, :response => test_response)}
    test_response.next_question.should == Question.find(4)
  end
end
