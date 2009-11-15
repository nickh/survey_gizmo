require File.dirname(__FILE__) + '/../spec_helper'

describe ResponsesController do
  before do
    @test_addr = 'foo@bar.org'
    @test_name = 'Foo Bar'
  end

  describe '#index' do
    describe 'when there is a valid respondent in the session' do
      it 'should redirect to show' do
        valid_respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
        session[:respondent] = valid_respondent
        get :index
        response.should redirect_to(response_path(valid_respondent))
      end
    end

    describe 'when there is an invalid respondent in the session' do
      it 'should redirect to new' do
        invalid_respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
        Respondent.delete(invalid_respondent.id)
        session[:respondent] = invalid_respondent
        get :index
        response.should redirect_to(new_response_path)
      end
    end

    describe 'when there is no respondent in the session' do
      it 'should redirect to new' do
        session[:respondent] = nil
        get :index
        response.should redirect_to(new_response_path)
      end
    end
  end

  # Be nice to returning visitors, if there's still a Respondent object in the session,
  # use it to prepopulate the email address and name in the form
  describe '#new' do
    it 'should use the email address and name from the respondent in the session if it exists' do
      session[:respondent] = Respondent.create(:email_address => @test_addr, :name => @test_name)
      get :new
      assigns[:respondent].email_address.should == @test_addr
      assigns[:respondent].name.should          == @test_name
      response.should render_template('new')
    end

    it 'should have no email address or name if no respondent exists in the session' do
      session.delete(:respondent)
      get :new
      assigns[:respondent].email_address.should be_nil
      assigns[:respondent].name.should          be_nil
      response.should render_template('new')
    end
  end

  # Handle a POST for a new response session - if a respondent with the specified
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
      it 'should redirect to the existing response show page' do
        existing_respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
        existing_response  = existing_respondent.response
        existing_response.should_not be_nil
        post :create, :respondent => {:email_address => @test_addr}
        response.should redirect_to(response_path(existing_response))
      end
    end

    describe 'when a valid new email_address is specified' do
      it 'should redirect to a new response show page' do
        Respondent.find_by_email_address(@test_addr).should be_nil
        post :create, :respondent => {:email_address => @test_addr}
        new_respondent = Respondent.find_by_email_address(@test_addr)
        new_respondent.should_not be_nil
        new_response  = new_respondent.response
        response.should redirect_to(response_path(new_response))
      end
    end

    describe 'when an invalid new email_address is specified' do
      it 'should redirect to new' do
        mock_respondent = mock(Respondent.new)
        mock_respondent.should_receive(:new_record?).and_return true
        Respondent.stub!(:create).and_return(mock_respondent)
        post :create, :respondent => {:email_address => 'something_invalid'}
        response.should redirect_to(new_response_path)
      end
    end
  end

  describe '#show' do
    before do
      @test_respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
      @test_response   = @test_respondent.response
      @test_questions  = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
    end

    it 'should redirect to new if there is no respondent in the session' do
      session[:respondent] = nil
      get :show, :id => @test_response.id
      response.should redirect_to(new_response_path)
    end

    it 'should redirect to new if the respondent and response do not match' do
      other_response  = Response.create
      session[:respondent] = @test_respondent
      get :show, :id => other_response.id
      response.should redirect_to(new_response_path)
    end

    it 'should show the response' do
      session[:respondent] = @test_respondent
      get :show, :id => @test_response.id
      response.should render_template('show')
    end

    describe 'when there are unanswered questions' do
      before do
        @test_answers = (1..3).collect{|i| Answer.create(:question_id => i, :response => @test_response)}
        session[:respondent] = @test_respondent
      end

      it 'should have a next question' do
        get :show, :id => @test_response.id
        assigns[:next_question].should_not be_nil
      end
    end

    describe 'when all questions have been answered' do
      before do
        @test_answers = @test_questions.collect{|q| Answer.create(:question_id => q.id, :response => @test_response)}
        session[:respondent] = @test_respondent
      end

      it 'should not have a next question' do
        get :show, :id => @test_response.id
        assigns.should have_key(:next_question)
        assigns[:next_question].should be_nil
      end
    end
  end

  describe '#update' do
    before do
      @test_questions  = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
      @test_respondent = Respondent.create(:email_address => @test_addr, :name => @test_name)
      @test_response   = @test_respondent.response
      @test_blurb      = 'My final answer'
      session[:respondent] = @test_respondent
    end

    it 'should add new answers' do
      @test_response.answers.should be_empty
      post :update, :id => @test_response.id, :answers => [{:question_id => 1, :blurb => @test_blurb}]
      @test_response.answers.should have(1).answer
      answer = @test_response.answers.first
      answer.question_id.should == 1
      answer.blurb.should == @test_blurb
    end

    it 'should update existing answers' do
      new_blurb   = @test_blurb + ' is forthcoming'
      test_answer = @test_response.answers.create(:question_id => 1, :blurb => @test_blurb)
      @test_response.answers.should have(1).answer
      post :update, :id => @test_response.id, :answers => [{:question_id => 1, :blurb => new_blurb}]
      @test_response.answers.should have(1).answer
      test_answer.reload
      test_answer.question_id.should == 1
      test_answer.blurb.should == new_blurb
    end

    it 'should redirect to show' do
      post :update, :id => @test_response.id, :answers => [{:question_id => 1, :blurb => @test_blurb}]
      response.should redirect_to(response_path(@test_response))
    end
  end
end
