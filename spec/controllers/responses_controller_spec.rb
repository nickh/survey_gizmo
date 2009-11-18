require File.dirname(__FILE__) + '/../spec_helper'

describe ResponsesController do
  before do
    @test_addr      = 'foo@bar.org'
    @test_name      = 'Foo Bar'
    @test_questions = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
  end

  describe '#index' do
    describe 'when there is a valid response in the session' do
      describe 'and the response is complete' do
        it 'should show a list of responses' do
          complete_response = Response.create(:email_address => @test_addr, :name => @test_name)
          test_answers      = Question.find(:all).collect{|q| Answer.create(:response => complete_response, :question => q)}
          session[:response_id] = complete_response.id
          get :index
          assigns[:responses].should_not be_nil
          response.should render_template(:index)
        end
      end

      describe 'and the response is not complete' do
        it 'should redirect to the next new answer' do
          incomplete_response = Response.create(:email_address => @test_addr, :name => @test_name)
          session[:response_id]  = incomplete_response.id
          get :index
          response.should redirect_to(new_response_answer_path(incomplete_response))
        end
      end
    end

    describe 'when there is an invalid response in the session' do
      it 'should redirect to new' do
        invalid_response = Response.create(:email_address => @test_addr, :name => @test_name)
        Response.delete(invalid_response.id)
        session[:response_id] = invalid_response.id
        get :index
        response.should redirect_to(new_response_path)
      end
    end

    describe 'when there is no response in the session' do
      it 'should redirect to new' do
        session[:response_id] = nil
        get :index
        response.should redirect_to(new_response_path)
      end
    end
  end

  # Be nice to returning visitors, if there's still a Response object in the session,
  # use it to prepopulate the email address and name in the form
  describe '#new' do
    it 'should use the email address and name from the response in the session if it exists' do
      session[:response_id] = Response.create(:email_address => @test_addr, :name => @test_name).id
      get :new
      assigns[:response].should_not be_nil
      assigns[:response].email_address.should == @test_addr
      assigns[:response].name.should          == @test_name
      response.should render_template('new')
    end

    it 'should have no email address or name if no response exists in the session' do
      session.delete(:response_id)
      get :new
      assigns[:response].should_not           be_nil
      assigns[:response].email_address.should be_nil
      assigns[:response].name.should          be_nil
      response.should render_template('new')
    end
  end

  # Handle a POST for a new response session - if a response with the specified
  # email address already exists, restart the existing session; otherwise
  # create a new one.
  describe '#create' do
    describe 'when no email address is specified' do
      it 'should redirect to new' do
        post :create
        response.should redirect_to(new_response_path)
      end
    end

    describe 'when an existing email address is specified' do
      describe 'and the response is complete' do
        it 'should redirect to the existing response show page' do
          complete_response = Response.create(:email_address => @test_addr, :name => @test_name)
          test_answers      = Question.find(:all).collect{|q| Answer.create(:response => complete_response, :question => q)}
          post :create, :response => {:email_address => @test_addr}
          response.should redirect_to(response_path(complete_response))
        end
      end

      describe 'and the response is not complete' do
        it 'should redirect to the next new answer' do
          incomplete_response = Response.create(:email_address => @test_addr, :name => @test_name)
          post :create, :response => {:email_address => @test_addr}
          response.should redirect_to(new_response_answer_path(incomplete_response))
        end
      end
    end

    describe 'when a valid new email_address is specified' do
      it 'should redirect to a new response show page' do
        Response.find_by_email_address(@test_addr).should be_nil
        post :create, :response => {:email_address => @test_addr}
        new_response = Response.find_by_email_address(@test_addr)
        new_response.should_not be_nil
        response.should redirect_to(new_response_answer_path(new_response))
      end
    end

    describe 'when an invalid new email_address is specified' do
      it 'should redirect to new' do
        mock_response = mock(Response.new)
        mock_response.should_receive(:new_record?).and_return true
        Response.stub!(:create).and_return(mock_response)
        post :create, :response => {:email_address => 'something_invalid'}
        response.should redirect_to(new_response_path)
      end
    end
  end

  describe '#show' do
    before do
      @test_response  = Response.create(:email_address => @test_addr, :name => @test_name)
    end

    it 'should redirect to new if there is no response in the session' do
      session[:response_id] = nil
      get :show, :id => @test_response.id
      response.should redirect_to(new_response_path)
    end

    it 'should redirect to new if the response and response do not match' do
      other_response  = Response.create(:email_address => 'other_response@example.com', :name => 'Other Response')
      session[:response_id] = @test_response.id
      get :show, :id => other_response.id
      response.should redirect_to(new_response_path)
    end

    describe 'when the response is complete' do
      it 'should show the response' do
        @test_answers = @test_questions.collect{|q| Answer.create(:question_id => q.id, :response => @test_response)}
        session[:response_id] = @test_response.id
        get :show, :id => @test_response.id
        assigns[:response].should == @test_response
        response.should render_template(:show)
      end
    end

    describe 'when the response is not complete' do
      it 'should redirect to the next new answer' do
        session[:response_id] = @test_response.id
        get :show, :id => @test_response.id
        response.should redirect_to(new_response_answer_path(@test_response))
      end
    end
  end
end
