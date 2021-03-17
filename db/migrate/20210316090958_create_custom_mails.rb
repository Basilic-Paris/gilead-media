class CreateCustomMails < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_mails do |t|
      t.text :body
      t.references :mailable, polymorphic: true

      t.timestamps
    end
  end
end
