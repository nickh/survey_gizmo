class Responder < ActiveRecord::Base
  validates_format_of :email_address, :with => /^[^\@]+\@[^\@]+\.[^\@]+$/
end