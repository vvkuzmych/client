# How to Use EXPLAIN in Rails

## The Problem

You cannot call `.explain` on the result of `.count` because `.count` returns an Integer, not an ActiveRecord::Relation.

```ruby
# ❌ This doesn't work
Comment.count.explain
# => NoMethodError: undefined method 'explain' for an instance of Integer
```

## The Solution

Call `.explain` on the ActiveRecord::Relation **before** executing the query (before calling `.count`, `.all`, `.first`, etc.).

### 1. Explain a SELECT Query

```ruby
# ✅ Explain what SELECT will do
Comment.all.explain

# ✅ Explain with conditions
Comment.where(archived: false).explain
Comment.where(issue_id: 1).explain
Comment.where("created_at > ?", 1.month.ago).explain
```

### 2. Explain COUNT Query

For COUNT, you need to call `.explain` on the relation before calling `.count`:

```ruby
# ✅ Method 1: Explain the relation first
Comment.all.explain  # Shows the SELECT query plan
Comment.where(archived: false).explain  # Shows filtered SELECT

# ✅ Method 2: Get the SQL and explain it directly
ActiveRecord::Base.connection.explain(
  Comment.count.to_sql
)
# This won't work because count doesn't return a relation with to_sql

# ✅ Method 3: Use where(nil) to get a relation for COUNT
ActiveRecord::Base.connection.explain(
  Comment.all.select("COUNT(*)").to_sql
)
```

Actually, the best way for COUNT:

```ruby
# ✅ Best way: Explain the COUNT query
Comment.all.explain  # This shows the query plan

# Or get the actual COUNT query SQL:
sql = "SELECT COUNT(*) FROM comments"
ActiveRecord::Base.connection.explain(sql)
```

### 3. Explain Complex Queries

```ruby
# ✅ Joins
Comment.joins(:issue).joins(:user).explain

# ✅ With includes (eager loading)
Comment.includes(:issue).explain

# ✅ Grouped queries
Comment.group(:issue_id).count
# For explain, use:
Comment.group(:issue_id).explain

# ✅ Ordered queries
Comment.order(created_at: :desc).explain
Comment.where(issue_id: 1).order(created_at: :desc).limit(10).explain
```

## Practical Examples

### Example 1: Check if index is being used

```ruby
# Check if the issue_id index is used
Comment.where(issue_id: 1).explain
# Look for "Index Scan using index_comments_on_issue_id"
```

### Example 2: Compare query plans

```ruby
# Without index usage (might do a sequential scan)
Comment.where(user_id: 1).explain

# With index usage
Comment.where(issue_id: 1, user_id: 1).explain
```

### Example 3: Explain with specific database analyzer

```ruby
# PostgreSQL - show more details
ActiveRecord::Base.connection.explain(
  Comment.where(issue_id: 1).to_sql,
  analyze: true  # Actually runs the query and shows timing
)

# Or use the relation directly:
Comment.where(issue_id: 1).explain(analyze: true)
```

### Example 4: Explain COUNT with conditions

```ruby
# ✅ This works - explain the relation
Comment.where(archived: false).explain

# ❌ This doesn't work
Comment.where(archived: false).count.explain
```

## PostgreSQL-Specific EXPLAIN Options

```ruby
# Basic explain
Comment.all.explain

# With ANALYZE (actually runs the query)
Comment.all.explain(analyze: true)

# With VERBOSE
Comment.all.explain(verbose: true)

# With BUFFERS (shows buffer usage)
Comment.all.explain(analyze: true, buffers: true)

# With COSTS (default, shows cost estimates)
Comment.all.explain(costs: true)

# Combined
Comment.where(issue_id: 1).explain(
  analyze: true,
  verbose: true,
  buffers: true
)
```

## Understanding the Output

### Good Signs:
- `Index Scan` or `Index Only Scan` - using an index ✅
- `Bitmap Index Scan` - efficient for multiple conditions ✅
- Low "Execution Time" when using `analyze: true` ✅

### Warning Signs:
- `Seq Scan` (Sequential Scan) - scans entire table ⚠️
- High "cost" values
- High "Execution Time" when using `analyze: true` ⚠️

### Example Output

```ruby
Comment.where(issue_id: 1).explain

# Output:
# EXPLAIN for: SELECT "comments".* FROM "comments" WHERE "comments"."issue_id" = $1
#                                QUERY PLAN
# -------------------------------------------------------------------------
# Index Scan using index_comments_on_issue_id on comments
#   Index Cond: (issue_id = 1)
# (2 rows)
```

## Tips

1. **Always call `.explain` before executing** - Once you call `.count`, `.all`, `.first`, etc., you get a result, not a relation
2. **Use `analyze: true` for real performance data** - It actually runs the query and shows timing
3. **Check for index usage** - Look for "Index Scan" in the output
4. **Compare query plans** - Run explain with and without conditions to see the difference

## Quick Reference

```ruby
# ✅ DO THIS:
Comment.all.explain
Comment.where(issue_id: 1).explain
Comment.joins(:issue).explain

# ❌ DON'T DO THIS:
Comment.count.explain           # count returns Integer
Comment.all.to_a.explain        # to_a returns Array
Comment.first.explain           # first returns Comment object
```

