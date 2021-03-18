class ContactMailer < ApplicationMailer
  def notify_contacts(contact)
    @contact = contact
    @user = @contact.contactable.user
    @custom_mail = @contact.contactable.custom_mail
    mail(to: @contact.email, cc: @user.email, subject: "#{@custom_mail.subject}")
  end
end
