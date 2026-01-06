# Running RuboCop on Changed Files Only

## Quick Command

To run RuboCop only on changed Ruby files:

```bash
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$' | xargs)
```

## Alternative Commands

### Only Staged Files (git add)

```bash
bin/rubocop --no-server $(git diff --cached --name-only --diff-filter=AMR | grep '\.rb$' | xargs)
```

### Changed Files vs Main Branch

```bash
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR origin/main | grep '\.rb$' | xargs)
```

### Changed Files in Working Directory (includes unstaged)

```bash
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR | grep '\.rb$' | xargs)
```

### Using Git Diff

```bash
# Only files changed in last commit
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR HEAD~1 HEAD | grep '\.rb$' | xargs)
```

## Explanation

- `git diff --name-only` - Get only filenames that changed
- `--diff-filter=AMR` - Only Added (A), Modified (M), or Renamed (R) files
- `grep '\.rb$'` - Filter only Ruby files
- `xargs` - Pass files as arguments to rubocop
- `--no-server` - Skip RuboCop server (avoids permission issues)

## Handling Edge Cases

### When No Files Changed

If no files changed, the command will run on all files. To handle this:

```bash
changed_files=$(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$')
if [ -n "$changed_files" ]; then
  bin/rubocop --no-server $changed_files
else
  echo "No Ruby files changed"
fi
```

### Safe Version (with fallback)

```bash
changed=$(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$')
if [ -z "$changed" ]; then
  echo "No changed Ruby files. Running on all files..."
  bin/rubocop --no-server
else
  bin/rubocop --no-server $changed
fi
```

## Git Pre-commit Hook (Optional)

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
changed_files=$(git diff --cached --name-only --diff-filter=AMR | grep '\.rb$')
if [ -n "$changed_files" ]; then
  bin/rubocop --no-server $changed_files
  exit $?
fi
exit 0
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Recommended Command for Development

The `.cursor/commands/rubocop.md` file is updated with:

```bash
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$' | xargs)
```

This runs RuboCop on:
- Files changed compared to HEAD
- Only Ruby files (.rb)
- Only added, modified, or renamed files

## Usage

```bash
# In terminal
/rubocop

# Or manually
bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$' | xargs)
```

