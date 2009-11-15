require File.dirname(__FILE__) + '/../spec_helper'

describe "Response" do
  it "belongs to respondent" do
    Response.should belong_to(:respondent)
  end

  it "has many answers" do
    Response.should have_many(:answers)
  end
end
