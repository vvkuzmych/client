class CreateDocumentComments < ActiveRecord::Migration[8.1]
  def change
    create_table :document_comments do |t|
      t.references :document, null: false, foreign_key: true
      t.integer :author_id
      t.text :comment, null: false
      t.timestamps
    end

    add_index :document_comments, :author_id
  end
end

