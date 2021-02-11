class RemoveSharedListFromContacts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :contacts, :shared_list, null: false, foreign_key: true
  end
end
