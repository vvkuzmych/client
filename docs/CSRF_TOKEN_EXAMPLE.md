# CSRF Token Example

## Get CSRF Token

Once your Rails server is running (`rails server`), you can get a CSRF token using:

```bash
# Basic request - saves cookie and returns token
curl -X GET http://localhost:3000/graphql/csrf_token \
  -c cookies.txt

# Pretty-printed JSON response
curl -X GET http://localhost:3000/graphql/csrf_token \
  -c cookies.txt \
  -s | jq .

# Without jq, just the raw response
curl -X GET http://localhost:3000/graphql/csrf_token \
  -c cookies.txt
```

Expected response:
```json
{
  "csrf_token": "your-csrf-token-string-here"
}
```

## Using the CSRF Token

### Option 1: Use the token in X-CSRF-Token header

```bash
# Step 1: Get token and save to variable
TOKEN=$(curl -s http://localhost:3000/graphql/csrf_token -c cookies.txt | jq -r '.csrf_token')

# Step 2: Use token in GraphQL request
curl -X POST http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $TOKEN" \
  -b cookies.txt \
  -d '{"query": "{ documents { id title status } }"}'
```

### Option 2: Use cookies (automatic for same-origin)

```bash
# First request - get cookie
curl -X GET http://localhost:3000/graphql/csrf_token \
  -c cookies.txt \
  -b cookies.txt

# Second request - cookie is automatically used
curl -X POST http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -b cookies.txt \
  -c cookies.txt \
  -d '{"query": "{ documents { id title status } }"}'
```

## Complete Example Script

```bash
#!/bin/bash

BASE_URL="http://localhost:3000"
COOKIE_FILE="cookies.txt"

# Get CSRF token
echo "Getting CSRF token..."
TOKEN_RESPONSE=$(curl -s -X GET "$BASE_URL/graphql/csrf_token" -c "$COOKIE_FILE")
echo "Response: $TOKEN_RESPONSE"

# Extract token (requires jq)
if command -v jq &> /dev/null; then
  TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.csrf_token')
  echo "CSRF Token: $TOKEN"
  
  # Make GraphQL request with token
  echo ""
  echo "Making GraphQL request..."
  curl -X POST "$BASE_URL/graphql" \
    -H "Content-Type: application/json" \
    -H "X-CSRF-Token: $TOKEN" \
    -b "$COOKIE_FILE" \
    -d '{"query": "{ documents { id title status } }"}'
else
  echo "jq not installed. Using cookie-based authentication..."
  curl -X POST "$BASE_URL/graphql" \
    -H "Content-Type: application/json" \
    -b "$COOKIE_FILE" \
    -d '{"query": "{ documents { id title status } }"}'
fi
```

## Testing Without Server Running

If you want to test the endpoint, first start your Rails server:

```bash
# Terminal 1: Start server
rails server

# Terminal 2: Make requests
curl -X GET http://localhost:3000/graphql/csrf_token -c cookies.txt
```

Get CSRF Token:
curl -X GET http://localhost:3100/graphql/csrf_token -c cookies.txt

Make GraphQL Query (with token extraction):
TOKEN=$(curl -s http://localhost:3100/graphql/csrf_token -c cookies.txt | ruby -r json -e "puts JSON.parse(STDIN.read)['csrf_token']")
curl -X POST http://localhost:3100/graphql \
-H "Content-Type: application/json" \
-H "X-CSRF-Token: $TOKEN" \
-b cookies.txt \
-d '{"query": "{ documents { id title status } }"}'
TOKEN=$(curl -s http://localhost:3100/graphql/csrf_token -c cookies.txt | ruby -r json -e "puts JSON.parse(STDIN.read)['csrf_token']")curl -X POST http://localhost:3100/graphql \  -H "Content-Type: application/json" \  -H "X-CSRF-Token: $TOKEN" \  -b cookies.txt \  -d '{"query": "{ documents { id title status } }"}'
