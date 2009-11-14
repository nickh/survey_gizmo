require File.dirname(__FILE__) + '/../spec_helper'

describe "Answer" do
  it "belongs to a responder" do
    Answer.new.should belong_to(:responder)
  end

  it "belongs to a question" do
    Answer.new.should belong_to(:question)
  end
end
