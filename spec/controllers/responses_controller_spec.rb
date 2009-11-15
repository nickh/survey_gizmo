require File.dirname(__FILE__) + '/../spec_helper'

describe ResponsesController do
  describe "when (re)starting a response session" do
    before do
      @test_addr = 'foo@bar.org'
      @test_name = 'Foo Bar'
    end

    it "requires a valid responder to get started" do
      session[:responder] = nil
      get :index
      response.should redirect_to(new_response_path)
    end

    it "populates the responder email address and name from the session" do
      session[:email_address] = @test_addr
      session[:name]          = @test_name
      get :new
      assigns[:email_address].should == @test_addr
      assigns[:name].should          == @test_name
    end

    it "restarts a response if a valid responder is present" do
      test_responder = Responder.create(:email_address => @test_addr, :name => @test_name)
      test_response  = Response.create(:responder => test_responder)
      session[:responder] = test_responder
      get :index
      response.should redirect_to(response_path(test_response))
    end

    it "creates a new responder" do
      Responder.find_by_email_address(@test_addr).should be_nil
      post :create, :responder => {:email_address => @test_addr, :name => @test_name}
      new_responder = Responder.find_by_email_address(@test_addr)
      new_responder.should_not be_nil
      new_responder.response.should_not be_nil
      assigns[:response].should == new_response
    end

    it "uses an existing responder" do
      existing_responder = Responder.create(:email_address => @test_addr, :name => @test_name)
      post :create, :responder => {:email_address => @test_addr, :name => @test_name}
      assigns[:response].should == existing_responder.response
    end

    it "stores the responder in the session" do
      session[:responder] = nil
      post :create, :responder => {:email_address => @test_addr, :name => @test_name}
      session[:responder].email_address.should == @test_addr
      session[:responder].name.should          == @test_name
    end

    it "redirects to the show page" do
      post :create, :responder => {:email_address => @test_addr, :name => @test_name}
      response.should redirect_to('/show')
    end
  end

  describe "when showing questions" do
    it "shows the next unanswered question" do
      responder = Responder.create(:email_address => @test_addr, :name => @test_name)
      response  = Response.create(:responder => responder)
      test_questions = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
      test_answers   = (1..3).collect{|i| Answer.create(:id => i, :response => response, :question_id => i)}
      get :show, :response => response.id
      assigns[:next_question].should == Question.find(4)
      response.should render_template('show')
    end
  end

  describe "when submitting answers" do
    it "adds new answers"
    it "updates existing answers"
    it "redirects to the show page"
  end

  # Finishing an answer session
  describe "when finishing a session" do
    it "shows the thank you page after all questions have been answered"
  end
end
