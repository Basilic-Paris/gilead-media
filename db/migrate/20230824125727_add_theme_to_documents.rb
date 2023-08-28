class AddThemeToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :theme, :string
  end
end
