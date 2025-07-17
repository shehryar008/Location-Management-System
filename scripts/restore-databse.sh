#!/bin/bash

# Database restore script

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup_file>"
    echo "Example: $0 ./backups/locationcrud_backup_20240101_120000.bak"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "🔄 Restoring database from: $BACKUP_FILE"

# Copy backup file to container
docker cp $BACKUP_FILE locationcrud-sqlserver:/var/opt/mssql/data/restore.bak

# Restore database
docker exec locationcrud-sqlserver /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "123456" -C \
    -Q "RESTORE DATABASE LocationManagerDb FROM DISK = '/var/opt/mssql/data/restore.bak' WITH REPLACE"

echo "✅ Database restored successfully!"
