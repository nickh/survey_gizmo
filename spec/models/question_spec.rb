require File.dirname(__FILE__) + '/../spec_helper'

describe "Question" do
  it "should be invalid with a nil blurb" do
    Question.new(:blurb => nil).should_not be_valid
  end

  it "should be invalid with an empty blurb" do
    Question.new(:blurb => '').should_not be_valid
  end
end
