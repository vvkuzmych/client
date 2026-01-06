class AddFulltextSearchToComments < ActiveRecord::Migration[8.1]
  def up
    # Add a tsvector column for full-text search
    add_column :comments, :search_vector, :tsvector

    # Create GIN index for fast full-text search (very efficient for large datasets)
    add_index :comments, :search_vector, using: :gin, name: "index_comments_on_search_vector"

    # Create a trigger function to automatically update the search_vector
    execute <<-SQL
      CREATE OR REPLACE FUNCTION comments_search_vector_update() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector :=
          setweight(to_tsvector('english', COALESCE(NEW.body, '')), 'A');
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    # Create trigger to automatically update search_vector when body changes
    execute <<-SQL
      CREATE TRIGGER comments_search_vector_trigger
      BEFORE INSERT OR UPDATE OF body ON comments
      FOR EACH ROW
      EXECUTE FUNCTION comments_search_vector_update();
    SQL

    # Update existing records
    execute <<-SQL
      UPDATE comments
      SET search_vector = setweight(to_tsvector('english', COALESCE(body, '')), 'A');
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS comments_search_vector_trigger ON comments;"
    execute "DROP FUNCTION IF EXISTS comments_search_vector_update();"
    remove_index :comments, name: "index_comments_on_search_vector"
    remove_column :comments, :search_vector
  end
end
