class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :email
      t.references :shared_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
