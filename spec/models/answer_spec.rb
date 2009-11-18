require File.dirname(__FILE__) + '/../spec_helper'

describe "Answer" do
  it "belongs to a response" do
    Answer.should belong_to(:response)
  end

  it "belongs to a question" do
    Answer.should belong_to(:question)
  end

  it "requires a response" do
    answer = Answer.new(:question => Question.new)
    answer.should_not be_valid
    answer.should have_errors_on(:response)
  end

  it "requires a question" do
    answer = Answer.new(:response => Response.new)
    answer.should_not be_valid
    answer.should have_errors_on(:question)
  end

  it "allows only one answer to a given question for each response" do
    response1   = Response.create(:email_address => 'foo@bar.org', :name => 'Foo Bar')
    response2   = Response.create(:email_address => 'bar@foo.org', :name => 'Bar Foo')
    question    = Question.create(:blurb => 'Is this a question?')
    answer1     = Answer.create(:response => response1, :question => question)
    answer2     = Answer.new(:response => response1, :question => question)
    answer3     = Answer.new(:response => response2, :question => question)
    answer1.should     be_valid
    answer2.should_not be_valid
    answer3.should     be_valid
  end
end
