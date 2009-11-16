# The Answer model provides an interface to survey answers.  Each answer
# belongs to a question and a response.
class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :response

  validates_presence_of :question
  validates_presence_of :response
  validates_uniqueness_of :question_id, :scope => :response_id
end