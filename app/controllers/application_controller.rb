# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :fix_session_barf

  # Annoying lesson learned: if you stash something in a session that later can't
  # be marshalled, requests for that session with fail
  def fix_session_barf
    begin
      session[:respondent] = nil
    rescue Exception => e
      reset_session
    end
  end
end
