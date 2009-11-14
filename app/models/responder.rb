# The Responder model provides an interface to a "party" that is answering
# survey questions.  Responders must have unique email addresses and may
# have an associated name.
class Responder < ActiveRecord::Base
  validates_format_of :email_address, :with => /^[^\@]+\@[^\@]+\.[^\@]+$/
  validates_uniqueness_of :email_address
end