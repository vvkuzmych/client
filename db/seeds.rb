# Seed script for PostgreSQL
# Creates: 100 users, 10,000 issues, 1,000,000 comments (1% archived)

puts "Starting seed process..."
start_time = Time.current

# Clear existing data
puts "Clearing existing data..."
Comment.delete_all
Issue.delete_all
User.delete_all

# Reset sequences
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('issues')
ActiveRecord::Base.connection.reset_pk_sequence!('comments')

# Optional: Speed-ups for seeding (session-local)
ActiveRecord::Base.connection.execute("SET synchronous_commit = off") if Rails.env.development?
ActiveRecord::Base.connection.execute("SET work_mem = '256MB'") if Rails.env.development?

# 1) Create 100 random users
puts "Creating 100 users..."
users_data = []
100.times do |i|
  handle = "user_#{i + 1}_#{SecureRandom.hex(3)}"
  created_at = Time.current - rand(365).days
  users_data << { handle: handle, created_at: created_at, updated_at: created_at }
end
User.insert_all(users_data)
users = User.all.to_a
puts "✓ Created #{User.count} users"

# 2) Create 10,000 random issues
puts "Creating 10,000 issues..."
issues_data = []
10000.times do |i|
  user = users.sample
  status = rand < 0.65 ? 'open' : 'closed'
  priority = rand(1..5)
  title = "Issue ##{i + 1} - #{SecureRandom.hex(5)}"
  created_at = Time.current - rand(365).days
  updated_at = created_at + rand(30).days
  issues_data << {
    user_id: user.id,
    status: status,
    priority: priority,
    title: title,
    created_at: created_at,
    updated_at: updated_at
  }

  # Insert in batches of 1000 for better performance
  if issues_data.size >= 1000
    Issue.insert_all(issues_data)
    issues_data = []
  end
end
Issue.insert_all(issues_data) if issues_data.any?
issues = Issue.all.to_a
puts "✓ Created #{Issue.count} issues"

# 3) Create 1,000,000 random comments (1% archived)
puts "Creating 1,000,000 comments (this may take a few minutes)..."
comments_data = []
batch_size = 5000
total_batches = (1_000_000 / batch_size.to_f).ceil

1_000_000.times do |i|
  issue = issues.sample
  user = users.sample
  body = "Comment #{i + 1}: #{SecureRandom.hex(16)}"
  archived = rand < 0.01
  created_at = Time.current - rand(365).days

  comments_data << {
    issue_id: issue.id,
    user_id: user.id,
    body: body,
    archived: archived,
    created_at: created_at,
    updated_at: created_at
  }

  # Insert in batches for better performance
  if comments_data.size >= batch_size
    Comment.insert_all(comments_data)
    comments_data = []

    # Progress indicator
    current_batch = (i / batch_size) + 1
    if current_batch % 10 == 0
      puts "  Progress: #{current_batch}/#{total_batches} batches (#{i + 1}/1,000,000 comments)"
    end
  end
end

# Insert remaining comments
Comment.insert_all(comments_data) if comments_data.any?

# Reset session settings
ActiveRecord::Base.connection.execute("RESET synchronous_commit") if Rails.env.development?
ActiveRecord::Base.connection.execute("RESET work_mem") if Rails.env.development?

elapsed_time = Time.current - start_time
puts ""
puts "✓ Seed completed successfully!"
puts "  - Users: #{User.count}"
puts "  - Issues: #{Issue.count}"
puts "  - Comments: #{Comment.count}"
puts "  - Archived comments: #{Comment.where(archived: true).count}"
puts "  - Time taken: #{elapsed_time.round(2)} seconds"
