# The Response model provides an interface to the set of answers from a
# specific responder.
class Response < ActiveRecord::Base
  belongs_to :respondent
  has_many :answers

  # Return the next unanswered question
  def next_question
    all_questions      = Question.find(:all)
    answered_questions = answers.collect{|a| a.question}
    all_questions.detect{|q| !answered_questions.include?(q)}
  end
end