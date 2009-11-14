require File.dirname(__FILE__) + '/../spec_helper'

describe "Responder" do
  it "should require a valid email address" do
    Responder.new(:email_address => 'no_at_sign').should_not be_valid
    Responder.new(:email_address => 'after@no_dot').should_not be_valid
    Responder.new(:email_address => 'valid@domain.sub').should be_valid
  end
end
