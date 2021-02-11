class AddContactableToContacts < ActiveRecord::Migration[6.0]
  def change
    add_reference :contacts, :contactable, polymorphic: true
  end
end
