import os

from flask import Flask


def create_app():

    # instantiate the app
    app = Flask(__name__)

    # set config
    app_settings = os.getenv(
        "APP_SETTINGS", "server.config.DevelopmentConfig"
    )
    app.config.from_object(app_settings)

    # register blueprints
    from server.example.views import example_blueprint

    app.register_blueprint(example_blueprint)

    # shell context for flask cli
    @app.shell_context_processor
    def ctx():
        return {"app": app}

    return app
