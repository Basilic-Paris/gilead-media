class ContactMailerPreview < ActionMailer::Preview
  def notify_contacts
    ContactMailer.notify_contacts(CustomMail.last.mailable.contacts.first)
  end
end
