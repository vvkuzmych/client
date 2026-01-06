# Annotate Gem Guide

The `annotaterb` gem automatically adds schema information (columns, indexes, etc.) as comments at the top of your model files.

**Note:** We're using `annotaterb` instead of the deprecated `annotate` gem because it's actively maintained and supports Ruby 3.4+ and Rails 8+.

## Installation

The gem is already added to your Gemfile. Just run:

```bash
bundle install
```

## Usage

### Annotate Models

After running migrations, update all model annotations:

```bash
# Using annotaterb (recommended)
bundle exec annotaterb models

# Or shorthand
bundle exec annotaterb
```

This will add comments to all your model files showing:
- Table columns with types
- Indexes
- Foreign keys
- Constraints

### Example Output

After running `rails annotate:models`, your `app/models/comment.rb` will look like:

```ruby
# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  issue_id   :bigint           not null
#  user_id    :bigint           not null
#  body       :text             not null
#  archived   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_archived  (archived)
#  index_comments_on_issue_id  (issue_id)
#  index_comments_on_user_id   (user_id)
#  ix_comments_issue_created   (issue_id,created_at,id)
#  ix_comments_issue_user_created (issue_id,user_id,created_at,id)
#  ix_comments_user_created    (user_id,created_at,id)
#
# Foreign Keys
#
#  fk_rails_...  (issue_id => issues.id)
#  fk_rails_...  (user_id => users.id)
#

class Comment < ApplicationRecord
  # ... your model code
end
```

### Annotate Routes

To annotate your routes file:

```bash
rake annotate_routes
# or
bundle exec annotate --routes
```

This adds a comment at the top of `config/routes.rb` showing all your routes.

### Annotate Everything

To annotate models, routes, and more:

```bash
rails annotate
```

### Auto-Annotate on Migrations

To automatically run annotations after migrations, add this to a Rake task or use a hook.

You can also run it manually after migrations:

```bash
rails db:migrate && rails annotate:models
```

### Configuration

Create a config file for custom settings:

```bash
rails g annotate:install
```

This creates `lib/tasks/auto_annotate_models.rake` where you can configure:
- Which files to annotate
- Where to place annotations (top/bottom)
- What information to include
- Exclude certain files

### Useful Commands

```bash
# Annotate all models
bundle exec annotaterb models

# Annotate only specific models
bundle exec annotaterb models app/models/comment.rb

# Remove all annotations
bundle exec annotaterb models --delete

# Annotate routes
bundle exec annotaterb routes

# Annotate factories (if using FactoryBot)
bundle exec annotaterb factories

# Annotate fixtures
bundle exec annotaterb fixtures

# Annotate everything
bundle exec annotaterb

# Show help
bundle exec annotaterb --help
```

### Best Practices

1. **Run after migrations**: Always run `rails annotate:models` after running migrations
2. **Keep it updated**: Re-run annotations when schema changes
3. **Version control**: Commit the annotations - they're helpful documentation
4. **CI/CD**: Some teams exclude annotations from code review, but they're generally useful to keep

### Example Workflow

```bash
# 1. Install the gem (if not already installed)
bundle install

# 2. Create a migration
rails generate migration AddEmailToUsers email:string

# 3. Run migration
rails db:migrate

# 4. Update annotations
bundle exec annotaterb models

# 5. Check the updated User model to see the new email column documented
```

### Tips

- Annotations are automatically updated when you run `rails annotate:models`
- The annotations show the current state of your database schema
- If you delete columns in a migration, re-run annotations to update
- You can configure annotations to be at the top or bottom of files
- Annotations are just comments, so they don't affect functionality

