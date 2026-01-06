# How to Use GraphiQL

## Setup Steps

1. **Install the GraphiQL gem** (if not already done):
   ```bash
   bundle install
   ```

2. **Restart your Rails server** (required after installing the gem):
   - Stop the server (Ctrl+C in the terminal where it's running)
   - Start it again: `rails server`

3. **Open GraphiQL in your browser**:
   Navigate to: `http://localhost:3100/graphiql`

## Using GraphiQL Interface

GraphiQL is a visual GraphQL IDE that lets you:
- Write and test GraphQL queries
- See query results
- Explore the schema
- View documentation

### Interface Overview

The GraphiQL interface has several sections:

1. **Left Panel - Query Editor**: Write your GraphQL queries here
2. **Right Panel - Response**: See the results of your queries
3. **Bottom Panel - Variables**: Define variables for your queries (optional)
4. **Right Sidebar - Docs**: Click "Docs" to explore your GraphQL schema

### Example Usage

#### 1. Basic Query

Type this in the query editor:

```graphql
query {
  documents {
    id
    title
    status
  }
}
```

Then click the **Play** button (▶️) or press `Ctrl+Enter` (or `Cmd+Enter` on Mac) to execute.

#### 2. Query with Arguments

```graphql
query {
  document(id: "1") {
    id
    title
    content
    status
    createdAt
  }
}
```

#### 3. Query with Variables

In the **Query Variables** panel (bottom), add:
```json
{
  "documentId": "1"
}
```

In the query editor:
```graphql
query GetDocument($documentId: ID!) {
  document(id: $documentId) {
    id
    title
    content
    status
  }
}
```

#### 4. Complex Query with Relations

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
    }
    comments {
      id
      comment
      createdAt
    }
    activities {
      id
      activityType
      description
    }
  }
}
```

#### 5. Query with Filters

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

### Keyboard Shortcuts

- **Ctrl+Enter** (or **Cmd+Enter** on Mac): Execute query
- **Ctrl+Space**: Show autocomplete suggestions
- **Ctrl+Click** on a field: Jump to its definition in the docs

### Exploring the Schema

1. Click **"Docs"** in the right sidebar
2. Browse available queries:
   - `documents` - Get all documents
   - `document` - Get a single document by ID
   - `documentVersions` - Get versions for a document
   - `documentComments` - Get comments for a document
   - `documentActivities` - Get activities for a document

3. Click on any query to see:
   - Required and optional arguments
   - Return types
   - Nested fields you can request

### Tips

1. **Autocomplete**: GraphiQL provides autocomplete as you type. Use `Ctrl+Space` to trigger it.

2. **Query History**: GraphiQL keeps a history of your queries. You can access previous queries from the interface.

3. **Pretty Print**: Use the formatting button to automatically format your query.

4. **Copy Query**: After writing a query, you can copy it to use in your application code.

5. **CSRF Token**: GraphiQL automatically handles CSRF tokens since it's running in the same browser session. No manual token management needed!

## Troubleshooting

### "Route not found" error
- Make sure you ran `bundle install`
- Restart your Rails server after installing the gem
- Check that you're using the correct port (3100)

### CSRF token errors
- GraphiQL should handle CSRF automatically
- If you get CSRF errors, try refreshing the page
- Make sure you're accessing GraphiQL from the same domain as your server

### Empty results
- Check that you have data in your database
- Verify your query syntax is correct
- Look at the "Response" panel for any error messages

## Example Workflow

1. Open `http://localhost:3100/graphiql` in your browser
2. Start typing a query in the left panel
3. Use autocomplete to explore available fields
4. Click "Docs" to understand the schema
5. Execute your query and see results in the right panel
6. Refine your query based on the results
7. Copy the final query to use in your application

