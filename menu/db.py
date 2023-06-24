# There's really no point to change this from the flask tutorial, so i'm just copy pasting it from there.
# https://flask.palletsprojects.com/en/2.3.x/tutorial/database/
import sqlite3

import click
from flask import current_app, g


def get_db():
    """ returns the database, and add it if not already added """
    if 'db' not in g:
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )
        g.db.row_factory = sqlite3.Row

    return g.db


def close_db(e=None):
    """ closes the database by removing the connection """
    db = g.pop('db', None)

    if db is not None:
        db.close()

def init_db():
    """ runs schema.sql to initialize the database  """
    db = get_db()

    with current_app.open_resource('schema.sql') as f:
        db.executescript(f.read().decode('utf8'))


@click.command('init-db')
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')

def init_app(app):
    """ makes sure the database is closed after every request, and adds the initializize database cmd  """
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)