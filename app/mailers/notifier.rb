class Notifier < ActionMailer::Base
  default :from => "admin@logdives.com"

  def request_confirmation_from_buddy(buddy_object)
    @buddy  = buddy_object
    @confirm_url = buddy_request_gateway_url(buddy_object)
    mail(:to => buddy_object.buddy_diver.email, :subject => 'Logdives.com | Confirmation request')
  end
end
