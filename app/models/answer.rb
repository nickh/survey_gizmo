# The Answer model provides an interface to survey answers.  Each answer
# belongs to a question and a response.
class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :response
end