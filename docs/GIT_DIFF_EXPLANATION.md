# Git Diff --name-only Explanation

## What is `git diff --name-only`?

`git diff --name-only` shows **only the filenames** of files that have changed, without showing the actual changes (diffs).

## Basic Usage

```bash
# Show names of files changed in working directory (unstaged changes)
git diff --name-only

# Show names of files changed compared to HEAD (last commit)
git diff --name-only HEAD

# Show names of files changed between two commits
git diff --name-only HEAD~1 HEAD
```

## Comparison

### Without `--name-only` (regular `git diff`)
```bash
git diff
```
Shows:
- Filenames
- Line-by-line changes (additions/deletions)
- Context lines
- Diff format (+, -, @@, etc.)

### With `--name-only` (only filenames)
```bash
git diff --name-only
```
Shows only:
```
app/models/comment.rb
app/controllers/graphql_controller.rb
config/routes.rb
```

## Common Options

### `--name-only`
Show only filenames of changed files.

### `--name-status`
Show filenames with change status:
```
M    app/models/comment.rb        # Modified
A    app/models/new_model.rb      # Added
D    app/models/old_model.rb      # Deleted
R    app/models/renamed.rb        # Renamed
```

### `--diff-filter=AMR`
Filter by change type:
- `A` - Added files
- `M` - Modified files
- `R` - Renamed files
- `D` - Deleted files (excluded in this case)

### `HEAD`
Compare to the last commit.

## Examples in Our RuboCop Command

### Breaking Down the Command

```bash
git diff --name-only --diff-filter=AMR HEAD
```

1. **`git diff`** - Show differences
2. **`--name-only`** - Show only filenames (not the actual changes)
3. **`--diff-filter=AMR`** - Only show Added, Modified, or Renamed files (exclude Deleted)
4. **`HEAD`** - Compare working directory to the last commit

### Example Output

If you've modified some files:

```bash
$ git diff --name-only --diff-filter=AMR HEAD
app/models/comment.rb
app/controllers/graphql_controller.rb
db/migrate/20250106000001_add_fulltext_search_to_comments.rb
```

### Full Command Breakdown

```bash
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$' | xargs)
```

1. **`git diff --name-only --diff-filter=AMR HEAD`**
   - Gets list of changed Ruby and non-Ruby files
   - Example: `app/models/comment.rb`, `config/routes.rb`, `README.md`

2. **`| grep '\.rb$'`**
   - Filters to only Ruby files (ends with `.rb`)
   - Example: `app/models/comment.rb`, `config/routes.rb`

3. **`| xargs`**
   - Converts the list into arguments
   - Example: `app/models/comment.rb config/routes.rb`

4. **`bin/rubocop --no-server $(...)`**
   - Runs RuboCop on those specific files
   - Equivalent to: `bin/rubocop --no-server app/models/comment.rb config/routes.rb`

## Practical Examples

### See what files changed

```bash
# Files changed (unstaged)
git diff --name-only

# Files changed compared to last commit
git diff --name-only HEAD

# Files changed compared to main branch
git diff --name-only origin/main
```

### See files with status

```bash
git diff --name-status HEAD
# Output:
# M    app/models/comment.rb
# A    app/models/new_file.rb
# D    app/models/deleted.rb
```

### Count changed files

```bash
git diff --name-only HEAD | wc -l
# Returns number of changed files
```

### List changed Ruby files only

```bash
git diff --name-only HEAD | grep '\.rb$'
```

## In the Context of RuboCop

The command:
```bash
git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$' | xargs
```

**Step by step:**
1. Get changed files: `app/models/comment.rb`, `README.md`, `config/routes.rb`, `db/migrate/123.rb`
2. Filter Ruby files: `app/models/comment.rb`, `config/routes.rb`, `db/migrate/123.rb`
3. Pass as arguments to RuboCop

**Result:** RuboCop only checks the Ruby files you've changed, not the entire codebase!

## Useful Variations

```bash
# Only staged files (git add)
git diff --cached --name-only

# Only unstaged files (not git add)
git diff --name-only

# Files changed in last commit
git diff --name-only HEAD~1 HEAD

# Files changed between branches
git diff --name-only branch1 branch2
```

