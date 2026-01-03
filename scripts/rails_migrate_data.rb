#!/usr/bin/env ruby
#
# Rails Data Migration Script
# Migrates data from old database to new Rails database
#
# Usage:
#   ruby scripts/rails_migrate_data.rb
#
# Requires environment variables:
#   OLD_DB_HOST, OLD_DB_NAME, OLD_DB_USER, OLD_DB_PASSWORD

require_relative "../config/environment"

class DataMigrator
  BATCH_SIZE = 1000

  def initialize
    @old_db_config = {
      adapter: "postgresql",
      host: ENV["OLD_DB_HOST"] || "localhost",
      database: ENV["OLD_DB_NAME"],
      username: ENV["OLD_DB_USER"] || "postgres",
      password: ENV["OLD_DB_PASSWORD"],
      port: ENV["OLD_DB_PORT"] || 5432
    }

    connect_to_old_db
  end

  def migrate_all
    puts "Starting data migration..."

    # Define migration order (respect foreign key dependencies)
    tables = [
      "users",
      "products",
      "orders",
      "order_items"
    ]

    tables.each do |table|
      migrate_table(table)
    end

    update_sequences
    puts "Migration completed!"
  end

  private

  def connect_to_old_db
    @old_connection = ActiveRecord::Base.establish_connection(@old_db_config)
    puts "Connected to old database: #{@old_db_config[:database]}"
  end

  def migrate_table(table_name)
    puts "\nMigrating #{table_name}..."

    # Get all records from old database
    quoted_table = ActiveRecord::Base.connection.quote_table_name(table_name)
    old_records = @old_connection.connection.execute("SELECT * FROM #{quoted_table}")
    total = old_records.count
    puts "  Found #{total} records"

    return if total == 0

    # Get model class
    model_class = table_name.classify.constantize rescue nil
    unless model_class
      puts "  Warning: Model #{table_name.classify} not found, skipping"
      return
    end

    # Migrate in batches
    migrated = 0
    old_records.each_slice(BATCH_SIZE) do |batch|
      ActiveRecord::Base.transaction do
        batch.each do |old_record|
          begin
            attributes = map_attributes(table_name, old_record)
            model_class.create!(attributes)
            migrated += 1
          rescue ActiveRecord::RecordNotUnique
            # Skip duplicates
          rescue => e
            puts "  Error migrating record #{old_record["id"]}: #{e.message}"
          end
        end
      end
      print "  Progress: #{migrated}/#{total}\r"
      $stdout.flush
    end

    puts "\n  Migrated #{migrated} records"
  end

  def map_attributes(table_name, old_record)
    # Map old database columns to new model attributes
    # Customize based on your schema differences

    case table_name
    when "users"
      {
        id: old_record["id"],
        email: old_record["email"],
        # Add other mappings
        created_at: old_record["created_at"],
        updated_at: old_record["updated_at"]
      }
    when "orders"
      {
        id: old_record["id"],
        user_id: old_record["user_id"],
        # Add other mappings
        created_at: old_record["created_at"],
        updated_at: old_record["updated_at"]
      }
    else
      # Default: use all columns
      old_record.to_h.symbolize_keys
    end
  end

  def update_sequences
    puts "\nUpdating sequences..."

    # Reset primary key sequences for PostgreSQL
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        quoted_table = ActiveRecord::Base.connection.quote_table_name(table)
        max_id = ActiveRecord::Base.connection.execute(
          "SELECT MAX(id) FROM #{quoted_table}"
        ).first["max"].to_i

        if max_id > 0
          sequence_name = "#{table}_id_seq"
          quoted_sequence = ActiveRecord::Base.connection.quote(sequence_name)
          ActiveRecord::Base.connection.execute(
            "SELECT setval(#{quoted_sequence}, #{max_id}, true)"
          )
          puts "  Updated #{table}_id_seq to #{max_id}"
        end
      rescue => e
        puts "  Warning: Could not update sequence for #{table}: #{e.message}"
      end
    end
  end
end

# Run migration
if __FILE__ == $0
  unless ENV["OLD_DB_NAME"]
    puts "Error: OLD_DB_NAME environment variable required"
    puts "Usage: OLD_DB_NAME=old_db ruby scripts/rails_migrate_data.rb"
    exit 1
  end

  migrator = DataMigrator.new
  migrator.migrate_all
end
