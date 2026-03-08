#!/usr/bin/env zsh
# This script restores a database from an SQL file.
# Usage: ./dbrestore.sh [container-name] [table-name] [input-file] [mysql-user:optional] [mysql-user-password:optional] [mysql-root-password:optional]
# Get container name, table name, and input file from arguments

zparseopts -D -E -- \
  {h,-help}=help

CONTAINER_NAME="$1"
TABLE_NAME="$2"
INPUT_FILE="$3"
MYSQL_USER="${4:-sail}" 
MYSQL_USER_PASSWORD="${5:-password}"
MYSQL_ROOT_PASSWORD="${6:-password}"

# If --help is passed as any argument, show usage information
if (( $#help )); then
  echo "Usage: $0 [container-name] [table-name] [input-file] [mysql-user:optional] [mysql-user-password:optional] [mysql-root-password:optional]"
  echo ""
  echo "Arguments:"
  echo "  container-name          Name of the Docker container running MySQL"
  echo "  table-name              Name of the database to restore"
  echo "  input-file              Path to the SQL file to restore from"
  echo "  mysql-user              (Optional) MySQL username to grant permissions to (default: sail)"
  echo "  mysql-user-password     (Optional) MySQL user password (default: password)"
  echo "  mysql-root-password     (Optional) MySQL root password (default: password)"
  echo ""
  echo "Example:"
  echo "  $0 my-mysql-container my_database backup.sql"
  echo "  $0 my-mysql-container my_database backup.sql root mypassword"
  exit 0
fi

# Check if container name, table name, and input file are provided
if [ -z "$CONTAINER_NAME" ] || [ -z "$TABLE_NAME" ] || [ -z "$INPUT_FILE" ];
then
  echo "Usage: $0 [container-name] [table-name] [input-file] [mysql-user:optional] [mysql-user-password:optional] [mysql-root-password:optional]"
  exit 1
fi

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ];
then
  echo "Input file $INPUT_FILE does not exist."
  exit 1
fi

# Check if the container is running
if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$";
then
  echo "Container $CONTAINER_NAME is not running."
  exit 1
fi

# Check if the database exists in the container
if ! docker exec "$CONTAINER_NAME" mysql -uroot -p"$MYSQL_ROOT_PASSWORD" $TABLE_NAME;
then
  # If not, create the database and add permissions
  docker exec "$CONTAINER_NAME" mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE $TABLE_NAME; GRANT ALL PRIVILEGES ON $TABLE_NAME.* TO '$MYSQL_USER'@'%'; FLUSH PRIVILEGES;"
  echo "Database $TABLE_NAME created and permissions granted."
else
  # Truncate the data
  docker exec "$CONTAINER_NAME" mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "TRUNCATE TABLE $TABLE_NAME;"
  echo "Database $TABLE_NAME truncated."
fi

# Insert the data from the SQL file into the database
docker exec -i "$CONTAINER_NAME" mysql -u"$MYSQL_USER" -p"$MYSQL_USER_PASSWORD" "$TABLE_NAME" < "$INPUT_FILE"
echo "Database $TABLE_NAME restored from $INPUT_FILE."