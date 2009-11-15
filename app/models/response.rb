# The Response model provides an interface to the set of answers from a
# specific responder.
class Response < ActiveRecord::Base
  belongs_to :responder
  has_many :answers
end