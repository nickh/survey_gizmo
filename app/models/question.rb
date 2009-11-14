class Question < ActiveRecord::Base
  validates_presence_of :blurb
end