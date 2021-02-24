class ContactMailer < ApplicationMailer
  def notify_contacts(contact)
    @contact = contact
    @user = @contact.contactable.user
    mail(to: @contact.email, subject: "#{@user.full_name} souhaite partager des documents avec vous")
  end
end
