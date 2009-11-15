# The Response model provides an interface to the set of answers from a
# specific responder.
class Response < ActiveRecord::Base
  belongs_to :respondent
  has_many :answers

  # Return the next unanswered question
  def next_question
  end
end