require File.dirname(__FILE__) + '/../spec_helper'

describe "Response" do
  it "belongs to responder" do
    Response.should belong_to(:responder)
  end

  it "has many answers" do
    Response.should have_many(:answers)
  end
end
