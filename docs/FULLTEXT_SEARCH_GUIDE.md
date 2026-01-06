# Full-Text Search Guide for Comments

This guide explains how to use the full-text search functionality for comments.

## Overview

We've implemented PostgreSQL's native full-text search with:
- **tsvector** column for indexed search
- **GIN index** for fast queries (optimized for 1M+ records)
- **Automatic updates** via database triggers
- **Multiple search scopes** for different use cases

## Migration

The migration adds:
- `search_vector` column (tsvector type)
- GIN index for performance
- Trigger to auto-update search_vector when body changes

Run the migration:
```bash
rails db:migrate
```

## Usage Examples

### Basic Word Search

```ruby
# Search for a single word
Comment.search("error")
Comment.search("fix")
Comment.search("important")

# Returns results ranked by relevance
# Most relevant comments appear first
```

### Phrase Search

```ruby
# Search for exact phrase
Comment.search_phrase("fix this bug")
Comment.search_phrase("urgent issue")

# Only matches the exact phrase in order
```

### Multiple Words (AND)

```ruby
# All words must be present (AND logic)
Comment.search_all_words("error", "fix")
Comment.search_all_words("urgent", "bug", "production")

# Equivalent to: "error" AND "fix"
```

### Multiple Words (OR)

```ruby
# Any word can be present (OR logic)
Comment.search_any_word("error", "bug", "issue")

# Equivalent to: "error" OR "bug" OR "issue"
```

### Combining with Other Scopes

```ruby
# Search active comments only
Comment.active.search("error")

# Search comments for a specific issue
Comment.where(issue_id: 1).search("fix")

# Search recent comments
Comment.recent.search("urgent").limit(10)

# Search archived comments
Comment.archived.search("old")
```

### Case-Insensitive LIKE Search (Fallback)

For simple pattern matching when full-text search is too strict:

```ruby
# Simple LIKE search (less performant, no ranking)
Comment.search_like("error")
Comment.search_like("fix")
```

## Performance

### Why GIN Index?

- **Very fast** for large datasets (1M+ records)
- **Efficient** for full-text search queries
- **Automatic ranking** by relevance

### Query Performance

```ruby
# Check query performance
Comment.search("error").explain(analyze: true)

# Should show "Index Scan using index_comments_on_search_vector"
```

### Best Practices

1. **Use search scopes** instead of `LIKE` for better performance
2. **Combine with other scopes** to narrow results
3. **Use `search_phrase`** for exact phrase matching
4. **Use `search_all_words`** when you need all terms
5. **Use `search_any_word`** when you want flexibility

## How It Works

### Database Trigger

The trigger automatically updates `search_vector` when:
- A new comment is created
- A comment's body is updated

### Text Processing

PostgreSQL's `to_tsvector('english', body)`:
- Converts text to searchable tokens
- Removes stop words (a, the, is, etc.)
- Stems words (running → run, fixes → fix)
- Normalizes case

### Ranking

Results are ranked by `ts_rank()` which considers:
- Word frequency
- Word position
- Word importance

## Examples in Rails Console

```ruby
# Basic search
results = Comment.search("error")
results.count
results.first.body

# Search with pagination
Comment.search("bug").limit(20).offset(0)

# Search with conditions
Comment.where(archived: false)
      .search("urgent")
      .order(created_at: :desc)
      .limit(10)

# Search specific user's comments
Comment.where(user_id: 1).search("fix")

# Search comments for open issues
Comment.joins(:issue)
       .where(issues: { status: "open" })
       .search("bug")
```

## GraphQL Integration

You can add this to your GraphQL schema:

```ruby
# In app/graphql/types/query_type.rb
field :search_comments, [ Types::CommentType ], null: false do
  argument :query, String, required: true
  argument :limit, Integer, required: false, default_value: 10
end

def search_comments(query:, limit: 10)
  Comment.search(query).limit(limit)
end
```

## Troubleshooting

### Search not finding results

- Check if the word is a stop word (common words like "the", "is" are ignored)
- Use `search_phrase` for exact matching
- Try `search_like` for simple pattern matching

### Performance issues

- Ensure the GIN index exists: `rails db:migrate`
- Check if the index is being used: `Comment.search("test").explain`
- Consider adding additional conditions to narrow results

### Index not updating

- Check if the trigger exists in the database
- Manually update: `Comment.find_each { |c| c.update_column(:body, c.body) }`

## Advanced Usage

### Custom Ranking

```ruby
# You can customize the ranking algorithm
Comment.where("search_vector @@ plainto_tsquery('english', ?)", "error")
       .order("ts_rank_cd(search_vector, plainto_tsquery('english', ?)) DESC", "error")
```

### Multiple Languages

Currently using 'english' text search configuration. To support other languages:
- Create a new migration to change the configuration
- Use different language configurations per comment

### Highlighting Matches

```ruby
# Get highlighted matches (shows which words matched)
Comment.connection.execute(
  "SELECT body, ts_headline('english', body, plainto_tsquery('english', 'error')) 
   FROM comments 
   WHERE search_vector @@ plainto_tsquery('english', 'error') 
   LIMIT 5"
)
```

