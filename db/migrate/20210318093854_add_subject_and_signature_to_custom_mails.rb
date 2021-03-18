class AddSubjectAndSignatureToCustomMails < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_mails, :subject, :string
    add_column :custom_mails, :signature, :text
  end
end
