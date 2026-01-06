# SQL Injection Check Guide

## Quick Test

### 1. Run Brakeman (Security Scanner)

```bash
bin/brakeman
```

Brakeman will report any potential SQL injection vulnerabilities.

### 2. Test with Malicious Input

In Rails console, test with SQL injection attempts:

```ruby
# Try SQL injection patterns
Comment.search("'; DROP TABLE comments; --")
Comment.search("1' OR '1'='1")
Comment.search_any_word("'; DELETE FROM comments; --", "test")
```

**Expected:** Should return safe results or empty, NOT execute malicious SQL.

### 3. Check SQL Logs

Watch the Rails logs when running searches:

```ruby
# Enable SQL logging
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Run search
Comment.search("test")
```

**Look for:**
- ✅ Parameterized queries: `$1`, `$2` (safe)
- ❌ Direct string interpolation in SQL (dangerous)

## What to Look For

### ✅ Safe (Good)
```ruby
# Parameterized queries
where("body ILIKE ?", "%#{term}%")
where("search_vector @@ plainto_tsquery('english', ?)", query)

# Using sanitize methods
sanitize_sql_array([...])
sanitize_sql_like(term)
```

### ❌ Dangerous (Bad)
```ruby
# String interpolation in SQL
where("body = '#{user_input}'")
where("name LIKE '%#{params[:search]}%'")

# Direct SQL concatenation
execute("SELECT * FROM users WHERE name = '#{name}'")
```

## Quick Verification

```bash
# 1. Run Brakeman
bin/brakeman

# 2. Look for SQL Injection warnings
# Should see: "No warnings found" or no SQL injection warnings

# 3. Test in console
rails console
> Comment.search("test' OR '1'='1")
# Should return safe results, not execute malicious SQL
```

## Current Status

Our search methods are safe because:
- ✅ All user input uses `sanitize_sql_array` or `sanitize_sql_like`
- ✅ Queries combined with Rails' `.or()` method (not string interpolation)
- ✅ No direct string interpolation in WHERE clauses

