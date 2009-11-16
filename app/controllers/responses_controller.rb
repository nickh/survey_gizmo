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

    redirect_to(@response.next_question.nil?? response_path(@response) : new_response_answer_path(@response))
  end

  def show
    redirect_to(new_response_path) if @response.nil? || params[:id].to_i != @response.id
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