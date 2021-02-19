module ContactHelper
  def notify_contacts
    contacts.each do |contact|
      ContactMailer.notify_contacts(contact).deliver_later
    end
  end
end
