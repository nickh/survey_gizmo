class ResponsesController < ApplicationController
  before_filter :set_response

  # Show responders who have completed a response the list of responses
  def index
    if @response.nil?
      redirect_to new_response_path
    elsif @response.next_question
      redirect_to new_response_answer_path(@response)
    else
      @responses = Response.find(:all)
    end
  end

  # (Re)start a response: find out who would like to respond.
  # Prepopulate with info from the response id from the session if available.
  def new
    default   = Response.find(session[:response_id]) rescue Response.new
    @response = Response.new(:email_address => default.email_address, :name => default.name)
  end

  # Create a response: if a session for the specified email address exists,
  # pick up where they left off; otherwise try to start a new session for
  # the email address and go back to new if the session/email address is not valid.
  def create
    response_params = params[:response] || {}
    if @response = Response.find_by_email_address(response_params[:email_address])
      session[:response_id] = @response.id
    else
      @response = Response.create(response_params)
      return redirect_to(new_response_path) if @response.new_record?
      session[:response_id] = @response.id
    end

    redirect_to(@response.next_question.nil?? response_path(@response) : new_response_answer_path(@response))
  end

  # If the current user has completed their response, show them their own or someone
  # else's; otherwise take them to the next question.
  def show
    if @response.nil?
      redirect_to(new_response_path)
    elsif @response.next_question
      redirect_to(new_response_answer_path(@response))
    elsif params[:id]
      @response = Response.find(params[:id]) rescue nil
      redirect_to(new_response_path) if @response.nil?
    end
  end

  private

  def set_response
    @response = Response.find(session[:response_id]) rescue nil
  end
end