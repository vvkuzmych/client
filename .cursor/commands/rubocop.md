bin/rubocop --no-server $(git diff --name-only --diff-filter=AMR HEAD | grep '\.rb$' | xargs)
