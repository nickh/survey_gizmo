require File.dirname(__FILE__) + '/../spec_helper'

describe "AnswerSession" do
  before do
    @new_responder      = Responder.create(:email_address => 'new@example.org',      :name => 'New')
    @partial_responder  = Responder.create(:email_address => 'partial@example.org',  :name => 'Partial')
    @finished_responder = Responder.create(:email_address => 'finished@example.org', :name => 'Finished')
    @test_questions     = (1..5).collect {|i| Question.create(:id => i, :blurb => "What is the answer to question ##{i}?")}
    @partial_answers    = (1..3).collect {|i| Answer.create(:responder => @test_responder,     :question => Question.find(i), :blurb => "Working on it")}
    @finished_answers   = (1..5).collect {|i| Answer.create(:responder => @finished_responder, :question => Question.find(i), :blurb => "Working on it")}
  end

  describe "when initializing" do
    it "succeeds with a valid responder" do
      session = AnswerSession.new(:responder => @test_responder)
      session.should respond_to(:responder)
      session.responder.should == @test_responder
    end

    it "fails with an invalid responder" do
      lambda{AnswerSession.new(:responder => "not a responder object")}.should raise_error
    end

    it "fails with a missing responder" do
      lambda{AnswerSession.new}.should raise_error
    end
  end

  describe "when returning answers" do
    it "only includes answers from the responder" do
      test_responder = @partial_responder
      session = AnswerSession.new(:responder => test_responder)
      session.should respond_to(:answers)
      session.answers.sort_by{|a| a.question_id}.should == @partial_answers.sort_by{|a| a.question_id}
    end
  end

  describe "when returning the next unanswered question" do
    it "handles sessions with no questions answered" do
      session = AnswerSession.new(:responder => @new_responder)
      session.next_question.should == @test_questions.first
    end

    it "handles sessions with some questions answered" do
      unanswered_questions = @test_questions.reject{|q| @partial_answers.detect{|a| a.question_id == q.id}}
      unanswered_questions.should_not be_empty
      session = AnswerSession.new(:responder => @partial_responder)
      session.next_question.should == unanswered_questions.first
    end

    it "handles sessions with all questions answered" do
      session = AnswerSession.new(:responder => @finished_responder)
      session.next_question.should be_nil
    end
  end
end
