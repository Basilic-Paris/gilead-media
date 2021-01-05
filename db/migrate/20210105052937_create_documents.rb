class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :language
      t.text :usage
      t.datetime :validation_at
      t.string :format

      t.timestamps
    end
  end
end
