#!/bin/sh

set -e

python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py migrate

gunicorn --bind :9000 --workers 4 app.wsgi 
# It will bind to all addesses in docker and it will be on port 9000
# Can access it on port 9000
# 4 worker processes running in our container.
# we're specifying the whiskey config in app dot whiskey.

# All that points to app.
# Well everything runs from the app directory.
# So it's actually app.Wsgi which is created by Django.
# And this is just the entry point for creating a whiskey server from our Django app.
