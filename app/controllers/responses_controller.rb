class ResponsesController < ApplicationController
  before_filter :set_response

  def index
    redirect_to @response.nil?? new_response_path : response_path(@response)
  end

  def new
    email_address = session[:respondent].email_address rescue nil
    name          = session[:respondent].name          rescue nil
    @respondent   = Respondent.new(:email_address => email_address, :name => name)
  end

  def create
    respondent_params = params[:respondent] || {}
    email_address    = respondent_params[:email_address]
    if email_address.blank?
      return redirect_to(new_response_path)
    elsif existing_respondent = Respondent.find_by_email_address(email_address)
      session[:respondent] = existing_respondent
      @response = existing_respondent.response
    else
      new_respondent = Respondent.create(respondent_params)
      session[:respondent] = new_respondent
      return redirect_to(new_response_path) if new_respondent.new_record?
      @response = new_respondent.response
    end

    redirect_to(response_path(@response))
  end

  def show
    return redirect_to(new_response_path) if @response.nil? || params[:id].to_i != @response.id
    @next_question = @response.next_question
  end

  def update
    return redirect_to(new_response_path) if @response.nil? || params[:id].to_i != @response.id

    new_answers = params[:answers] || []
    new_answers.each do |answer_params|
      answer = Answer.find_or_create_by_question_id_and_response_id(answer_params[:question_id], @response.id)
      answer.update_attribute(:blurb, answer_params[:blurb])
    end

    redirect_to(response_path(@response))
  end

  private

  def set_response
    if session[:respondent]
      begin
        session[:respondent].reload
        @response = session[:respondent].response
      rescue
        nil
      end
    end
  end
end