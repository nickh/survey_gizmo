require File.dirname(__FILE__) + '/../spec_helper'

describe "Answer" do
  it "belongs to a response" do
    Answer.should belong_to(:response)
  end

  it "belongs to a question" do
    Answer.should belong_to(:question)
  end
end
