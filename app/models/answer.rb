# The Responder model provides an interface to survey answers.  Each answer
# belongs to a question and a responder.
class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :responder
end