require File.dirname(__FILE__) + '/../spec_helper'

describe AnswersController do
  before do
    @test_addr      = 'foo@bar.org'
    @test_name      = 'Foo Bar'
    @test_response  = Response.create(:email_address => @test_addr, :name => @test_name)
    @test_questions = (1..5).collect{|i| Question.create(:id => i, :blurb => "Question #{i}")}
  end

  describe '#new' do
    describe 'when there are unanswered questions' do
      it 'shows the next unanswered question' do
        @test_answers = (1..3).collect{|i| Answer.create(:question_id => i, :response => @test_response)}
        get :new, :response_id => @test_response
        assigns.should have_key(:question)
        assigns[:question].should == Question.find(4)
        response.should render_template(:new)
      end
    end

    describe 'when all questions have been answered' do
      it 'redirects to the response show page' do
        @test_answers = @test_questions.collect{|q| Answer.create(:question_id => q.id, :response => @test_response)}
        get :new, :response_id => @test_response
        response.should redirect_to(response_path(@test_response))
      end
    end
  end

  describe '#create' do
    it 'adds new answers' do
      test_question = Question.find(:first)
      test_blurb    = 'My final answer'
      @test_response.answers.should be_empty
      post :create, :response_id => @test_response, :answer => {:question_id => test_question.id, :blurb => test_blurb}
      flash[:error].should be_nil
      @test_response.reload
      @test_response.answers.should have(1).answer
      answer = @test_response.answers.first
      answer.question_id.should == test_question.id
      answer.blurb.should       == test_blurb
    end

    it 'does not add answers to already answered questions' do
      test_question = Question.find(:first)
      test_blurb    = 'My final answer'
      @test_response.answers.create(:question => test_question, :blurb => 'Existing answer')
      post :create, :response_id => @test_response, :answer => {:question_id => test_question.id, :blurb => test_blurb}
      flash[:error].should_not be_nil
    end
      
    describe 'when there are unanswered questions' do
      it 'shows the next unanswered question' do
        @test_answers = (1..3).collect{|i| Answer.create(:question_id => i, :response => @test_response)}
        post :create, :response_id => @test_response, :answer => {:question_id => 4, :blurb => 'Next answer'}
        response.should redirect_to(new_response_answer_path(@test_response))
      end
    end

    describe 'when all questions have been answered' do
      it 'redirects to the response show page' do
        @test_answers = (1..4).collect{|i| Answer.create(:question_id => i, :response => @test_response)}
        post :create, :response_id => @test_response, :answer => {:question_id => 5, :blurb => 'Next answer'}
        response.should redirect_to(response_path(@test_response))
      end
    end
  end
end