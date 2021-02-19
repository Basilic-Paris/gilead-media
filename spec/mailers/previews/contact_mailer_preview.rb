class ContactMailerPreview < ActionMailer::Preview
  def notify_contacts
    ContactMailer.notify_contacts(Contact.last)
  end
end
