class MainController < ApplicationController
  def index
    @no_emails_sent_today = Email.where('created_at > ?', Date.today.beginning_of_day).count
    @from = "contact@openaustraliafoundation.org.au"
    @to = "Matthew Landauer <matthew@openaustralia.org>, mlandauer@yahoo.com"
    @cc = "matthew@planningalerts.org.au"
    @subject = "This is a test email from Cuttlefish"
    @text = <<-EOF
Hello folks. Hopefully this should have worked and you should
be reading this. So, all is good.

Love,
The Awesome Cuttlefish
    EOF
  end

  # Send a test email
  def test_email
    mail = Mail.new
    mail.from = params[:from]
    mail.to = params[:to]
    mail.cc = params[:cc]
    mail.subject = params[:subject]
    mail.body = params[:text]
    mail.delivery_method :smtp, ActionMailer::Base.smtp_settings
    mail.deliver

    flash[:notice] = "Test email sent"
    redirect_to :root
  end
end
