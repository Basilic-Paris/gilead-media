module ContactHelper
  def create_contacts(object, emails_list)
    @errors = Array.new
    emails_list.each do |email|
      contact = object.contacts.new(email: email)
      unless contact.save
        @errors << "#{contact.email}: #{contact.errors.full_messages.join(', ')}"
      end
    end
  end
end
