# The Response model provides an interface to the set of answers from a
# specific responder.
class Response < ActiveRecord::Base
  has_many :answers

  validates_format_of :email_address, :with => /^[^\@]+\@[^\@]+\.[^\@]+$/
  validates_uniqueness_of :email_address

  # Return the next unanswered question
  def next_question
    all_questions      = Question.find(:all)
    answered_questions = answers.collect{|a| a.question}
    all_questions.detect{|q| !answered_questions.include?(q)}
  end
end