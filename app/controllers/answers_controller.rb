class AnswersController < ApplicationController
  before_filter :load_response

  def new
    @question = @response.next_question
    return redirect_to(response_path(@response)) if @question.nil?
    @answer = Answer.new(:response => @response, :question => @question)
  end

  def create
    begin
      answer = Answer.new(params[:answer])
      @response.answers << answer
      @response.save!
    rescue Exception => e
      flash[:error] = "Error adding answer: #{e}"
    end

    redirect_to(@response.next_question.nil?? response_path(@response) : new_response_answer_path(@response))
  end

  private

  def load_response
    if params[:response_id].nil?
      flash[:warning] = 'No response specified'
      return redirect_to(new_response_path)
    end

    begin
      @response = Response.find(params[:response_id])
    rescue
      flash[:warning] = 'Unknown response specified'
      return redirect_to(new_response_path)
    end
  end
end