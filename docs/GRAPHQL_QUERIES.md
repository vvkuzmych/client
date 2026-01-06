# GraphQL Queries for Document Flow

## Setup

1. Install the GraphQL gem:
   ```bash
   bundle install
   ```

2. Run migrations:
   ```bash
   rails db:migrate
   ```

3. Start the server:
   ```bash
   rails server
   ```

## GraphQL Endpoint

POST `/graphql`

**Note:** CSRF protection is enabled by default. All requests must include a valid CSRF token.

## CSRF Token

The GraphQL endpoint requires CSRF token authentication for security. You can get a CSRF token and use it in your requests:

### Get CSRF Token

```bash
# Get CSRF token
curl -X GET http://localhost:3100/graphql/csrf_token -c cookies.txt
```

This returns:
```json
{
  "csrf_token": "your-csrf-token-here"
}
```

The token is also automatically included in cookies for same-origin requests.

## Example Queries

### Get All Documents

```graphql
query {
  documents {
    id
    title
    content
    status
    authorId
    createdAt
    updatedAt
  }
}
```

### Get Documents with Status Filter

```graphql
query {
  documents(status: "draft", limit: 5) {
    id
    title
    status
    createdAt
  }
}
```

### Get a Single Document

```graphql
query {
  document(id: "1") {
    id
    title
    content
    status
    authorId
    createdAt
    updatedAt
  }
}
```

### Get Document with Versions

```graphql
query {
  document(id: "1") {
    id
    title
    status
    versions {
      id
      versionNumber
      title
      content
      createdAt
    }
    currentVersion {
      id
      versionNumber
      title
      content
    }
  }
}
```

### Get Document with Comments

```graphql
query {
  document(id: "1") {
    id
    title
    comments {
      id
      comment
      authorId
      createdAt
    }
  }
}
```

### Get Document with Activities

```graphql
query {
  document(id: "1") {
    id
    title
    activities {
      id
      activityType
      description
      performedById
      createdAt
    }
  }
}
```

### Get Document Versions

```graphql
query {
  documentVersions(documentId: "1") {
    id
    versionNumber
    title
    content
    createdAt
  }
}
```

### Get Document Comments

```graphql
query {
  documentComments(documentId: "1") {
    id
    comment
    authorId
    createdAt
  }
}
```

### Get Document Activities (Filtered by Type)

```graphql
query {
  documentActivities(documentId: "1", activityType: "approved") {
    id
    activityType
    description
    performedById
    createdAt
  }
}
```

### Complete Document Query with All Relations

```graphql
query {
  document(id: "1") {
    id
    title
    content
    status
    authorId
    createdAt
    updatedAt
    versions {
      id
      versionNumber
      title
      content
      createdAt
    }
    comments {
      id
      comment
      authorId
      createdAt
    }
    activities {
      id
      activityType
      description
      performedById
      createdAt
    }
    currentVersion {
      id
      versionNumber
      title
      content
    }
  }
}
```

## Testing with cURL

### Get CSRF Token

```bash
curl -X GET http://localhost:3100/graphql/csrf_token -c cookies.txt
```

### Make GraphQL Query (with token extraction)

```bash
# Extract CSRF token using Ruby and make GraphQL request
TOKEN=$(curl -s http://localhost:3100/graphql/csrf_token -c cookies.txt | ruby -r json -e "puts JSON.parse(STDIN.read)['csrf_token']")
curl -X POST http://localhost:3100/graphql \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $TOKEN" \
  -b cookies.txt \
  -d '{"query": "{ documents { id title status } }"}'
```

### Alternative: Using cookies only

If you prefer to use cookie-based authentication (simpler but less explicit):

```bash
# First request - get CSRF token and save cookie
curl -X GET http://localhost:3100/graphql/csrf_token -c cookies.txt

# Second request - use cookies automatically
curl -X POST http://localhost:3100/graphql \
  -H "Content-Type: application/json" \
  -b cookies.txt \
  -d '{"query": "{ documents { id title status } }"}'
```

### For Same-Origin Browser Requests

When making requests from JavaScript in the same origin (same domain), Rails automatically handles CSRF tokens via cookies. Just include:

```javascript
// In your JavaScript code
fetch('/graphql', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
  },
  credentials: 'same-origin',
  body: JSON.stringify({
    query: '{ documents { id title status } }'
  })
});
```

## Testing with GraphiQL (Optional)

To use GraphiQL for interactive testing, you can add the graphiql-rails gem to your Gemfile (development only):

```ruby
# In Gemfile, under :development group
gem 'graphiql-rails'
```

Then add to routes:

```ruby
# In config/routes.rb (development only)
if Rails.env.development?
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
end
```

Then visit `http://localhost:3100/graphiql` in your browser.

### Quick Start with GraphiQL

1. **Install and restart**:
   ```bash
   bundle install
   # Restart your Rails server
   ```

2. **Open in browser**: Navigate to `http://localhost:3100/graphiql`

3. **Try your first query**: Type this in the query editor and click the Play button:
   ```graphql
   query {
     documents {
       id
       title
       status
     }
   }
   ```

4. **Explore the schema**: Click "Docs" in the right sidebar to see all available queries and fields.

**Key Features:**
- Autocomplete: Press `Ctrl+Space` for suggestions
- Execute: Press `Ctrl+Enter` (or `Cmd+Enter` on Mac)
- Schema Explorer: Click "Docs" to browse available queries
- CSRF tokens are handled automatically - no setup needed!

**Note:** Default Rails server runs on port 3000, but your server is configured to run on port 3100. Adjust the port number accordingly.

For more detailed instructions, see [GRAPHQL_USAGE.md](./GRAPHQL_USAGE.md).

