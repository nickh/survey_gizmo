# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def responder(response)
    h(response.name + ' <' + response.email_address + '>')
  end
end
