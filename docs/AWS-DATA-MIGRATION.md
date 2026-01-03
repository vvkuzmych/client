# AWS Data Migration Guide

## Overview
Migrate data from old database tables to new ones in AWS environment.

## Prerequisites

1. **AWS RDS Access**
   - Old database endpoint (RDS instance)
   - New database endpoint (RDS instance)
   - Security groups configured for access

2. **Environment Variables**
   ```bash
   export OLD_DB_HOST=<old-rds-endpoint>
   export OLD_DB_NAME=<old-database-name>
   export OLD_DB_USER=<username>
   export OLD_DB_PASSWORD=<password>
   export OLD_DB_PORT=5432
   ```

## Database Verification (AWS Equivalent of `rails c`)

### Connect to RDS Database via psql

```bash
# Connect to old database
psql -h <old-rds-endpoint>.rds.amazonaws.com \
     -U <username> \
     -d <database-name> \
     -p 5432

# Or using connection string
psql "postgresql://<username>:<password>@<rds-endpoint>:5432/<database-name>"
```

### Check Database and Tables

Once connected via `psql`, use these commands:

```sql
-- List all databases
\l

-- Connect to specific database
\c <database-name>

-- List all tables
\dt

-- List tables with details
\dt+

-- Show table structure
\d <table-name>

-- Count records in a table
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM orders;

-- Check if specific table exists
SELECT EXISTS (
   SELECT FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name = 'users'
);

-- List all tables with row counts
SELECT 
   schemaname,
   tablename,
   pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Alternative: AWS RDS Query Editor

1. Go to AWS Console → RDS → Your Database
2. Click **Query Editor** (if available for your RDS version)
3. Connect and run SQL queries directly in the browser

### Quick Verification Script

```bash
# Check database connection and list tables
psql -h <rds-endpoint> -U <username> -d <database-name> -c "\dt"
```

## Migration Steps

### 1. Connect to AWS Environment
```bash
# SSH into EC2 instance or use AWS Systems Manager Session Manager
ssh -i key.pem ec2-user@<ec2-instance>
```

### 2. Set Environment Variables
```bash
export OLD_DB_HOST=<old-rds-endpoint>.rds.amazonaws.com
export OLD_DB_NAME=<database-name>
export OLD_DB_USER=<username>
export OLD_DB_PASSWORD=<password>
```

### 3. Run Migration
```bash
# Full migration
rails migrate_data:all

# Or migrate specific tables
rails migrate_data:users
rails migrate_data:orders
```

### 4. Verify Migration

**Option A: Using Rails Console (if Rails is available)**
```bash
rails console
> User.count
> Order.count
```

**Option B: Using psql (direct database access)**
```bash
psql -h <new-rds-endpoint> -U <username> -d <database-name>
```
Then run:
```sql
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM orders;
\dt  -- List all tables
```

See [Database Verification](#database-verification-aws-equivalent-of-rails-c) section for more details.

## AWS-Specific Considerations

- **Security Groups**: Ensure EC2 instance can access both RDS instances
- **Network**: Use VPC peering if databases are in different VPCs
- **Performance**: Run during low-traffic hours
- **Backup**: Create RDS snapshots before migration
- **Monitoring**: Use CloudWatch to monitor database performance

## Troubleshooting

- **Connection timeout**: Check security group rules
- **Slow migration**: Increase RDS instance size temporarily
- **Duplicate errors**: Migration handles duplicates automatically

