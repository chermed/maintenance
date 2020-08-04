from flask import Blueprint

example_blueprint = Blueprint("main", __name__)


@example_blueprint.route("/")
def home():
    return "Hello world"
