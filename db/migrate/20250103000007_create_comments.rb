class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.boolean :archived, null: false, default: false
      t.timestamps
    end

    add_index :comments, :issue_id
    add_index :comments, :user_id
    add_index :comments, :archived

    # Performance indexes as mentioned in the SQL
    add_index :comments, [ :user_id, :created_at, :id ], name: "ix_comments_user_created"
    add_index :comments, [ :issue_id, :created_at, :id ], name: "ix_comments_issue_created"
    add_index :comments, [ :issue_id, :user_id, :created_at, :id ], name: "ix_comments_issue_user_created"
  end
end
