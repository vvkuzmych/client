# lib/tasks/migrate_data.rake
#
# Rake tasks for migrating data from old database
#
# Usage:
#   rails migrate_data:all
#   rails migrate_data:users
#   rails migrate_data:orders

namespace :migrate_data do
  desc "Migrate all data from old database"
  task all: :environment do
    puts "Starting full data migration..."
    
    Rake::Task["migrate_data:users"].invoke
    Rake::Task["migrate_data:products"].invoke
    Rake::Task["migrate_data:orders"].invoke
    Rake::Task["migrate_data:order_items"].invoke
    # Add other tables
    
    Rake::Task["migrate_data:update_sequences"].invoke
    puts "Migration completed!"
  end

  desc "Migrate users"
  task users: :environment do
    migrate_table("users", User)
  end

  desc "Migrate products"
  task products: :environment do
    migrate_table("products", Product)
  end

  desc "Migrate orders"
  task orders: :environment do
    migrate_table("orders", Order)
  end

  desc "Migrate order items"
  task order_items: :environment do
    migrate_table("order_items", OrderItem)
  end

  desc "Update primary key sequences"
  task update_sequences: :environment do
    puts "Updating sequences..."
    
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        max_id = ActiveRecord::Base.connection.execute(
          "SELECT MAX(id) FROM #{table}"
        ).first["max"].to_i
        
        if max_id > 0
          ActiveRecord::Base.connection.execute(
            "SELECT setval('#{table}_id_seq', #{max_id}, true)"
          )
          puts "  Updated #{table}_id_seq to #{max_id}"
        end
      rescue => e
        puts "  Warning: Could not update sequence for #{table}: #{e.message}"
      end
    end
  end

  private

  def connect_to_old_db
    @old_connection ||= begin
      config = {
        adapter: "postgresql",
        host: ENV["OLD_DB_HOST"] || "localhost",
        database: ENV["OLD_DB_NAME"],
        username: ENV["OLD_DB_USER"] || "postgres",
        password: ENV["OLD_DB_PASSWORD"],
        port: ENV["OLD_DB_PORT"] || 5432
      }
      ActiveRecord::Base.establish_connection(config.merge(name: "old_db"))
    end
  end

  def migrate_table(table_name, model_class)
    puts "\nMigrating #{table_name}..."
    
    connect_to_old_db
    
    old_records = @old_connection.connection.execute("SELECT * FROM #{table_name}")
    total = old_records.count
    puts "  Found #{total} records"
    
    return if total == 0
    
    migrated = 0
    old_records.each do |old_record|
      begin
        attributes = map_attributes_for_table(table_name, old_record)
        model_class.create!(attributes)
        migrated += 1
      rescue ActiveRecord::RecordNotUnique
        # Skip duplicates
      rescue => e
        puts "  Error: #{e.message}"
      end
    end
    
    puts "  Migrated #{migrated} records"
    
    # Reconnect to Rails database
    ActiveRecord::Base.establish_connection(Rails.application.config.database_configuration[Rails.env])
  end

  def map_attributes_for_table(table_name, old_record)
    # Customize based on your schema
    old_record.to_h.symbolize_keys
  end
end






