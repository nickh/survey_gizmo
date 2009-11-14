# The Question model provides an interface to individual survey questions.
# Each question must have a blurb (the text of the question.)
class Question < ActiveRecord::Base
  validates_presence_of :blurb
end