# The Respondent model provides an interface to a "party" that is answering
# survey questions.  Respondents must have unique email addresses and may
# have an associated name.
class Respondent < ActiveRecord::Base
  has_one :response

  validates_format_of :email_address, :with => /^[^\@]+\@[^\@]+\.[^\@]+$/
  validates_uniqueness_of :email_address

  after_save :ensure_response_exists

  private

  def ensure_response_exists
    self.create_response if self.response.nil?
  end
end