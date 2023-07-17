import os

from flask import Flask


def create_app():
    """ create and configure the app """
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY = "448374fd7a4a1bc60267cd59f9f7be52beb0784db705a34a2a5610eedb7e0e35",
        DATABASE=os.path.join(app.instance_path, 'menu.sqlite'),
    )

    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    from . import db
    db.init_app(app)

    from . import menu
    app.register_blueprint(menu.bp)
    app.add_url_rule('/', endpoint='index')

    return app
    