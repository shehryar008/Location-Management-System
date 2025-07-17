#!/bin/bash

# Database backup script

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="locationcrud_backup_${TIMESTAMP}.bak"

echo "🗄️  Creating database backup..."

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create database backup
docker exec locationcrud-sqlserver /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "123456" -C \
    -Q "BACKUP DATABASE LocationManagerDb TO DISK = '/var/opt/mssql/data/${BACKUP_FILE}'"

# Copy backup file to host
docker cp locationcrud-sqlserver:/var/opt/mssql/data/${BACKUP_FILE} ${BACKUP_DIR}/${BACKUP_FILE}

echo "✅ Backup created: ${BACKUP_DIR}/${BACKUP_FILE}"

# Clean up old backups (keep last 7 days)
find $BACKUP_DIR -name "locationcrud_backup_*.bak" -mtime +7 -delete

echo "🧹 Old backups cleaned up"
