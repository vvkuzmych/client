class AddEmailToUsers < ActiveRecord::Migration[8.1]
  def up
    # Add column as nullable first
    add_column :users, :email, :string, null: true

    # Populate email for existing users based on handle
    execute <<-SQL
      UPDATE users
      SET email = handle || '@example.com'
      WHERE email IS NULL;
    SQL

    # Now make it NOT NULL
    change_column_null :users, :email, false

    # Add unique index
    add_index :users, :email, unique: true
  end

  def down
    remove_index :users, :email
    remove_column :users, :email
  end
end
