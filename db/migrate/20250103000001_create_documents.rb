class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.text :content
      t.string :status, default: "draft"
      t.integer :author_id
      t.timestamps
    end

    add_index :documents, :status
    add_index :documents, :author_id
  end
end
