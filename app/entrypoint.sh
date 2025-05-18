#!/bin/sh
set -e

python -c "from app import wait_for_db, initialize_database; wait_for_db() and initialize_database()"

exec flask run --host=0.0.0.0
