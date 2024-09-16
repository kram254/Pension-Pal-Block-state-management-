from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from app.utils import configure_app

db = SQLAlchemy()
migrate = Migrate()

def create_app(config_filename=None):
    app = Flask(__name__)
    configure_app(app)

    CORS(app)

    db.init_app(app)
    migrate.init_app(app, db)

    with app.app_context():
        from app import routes

        db.create_all()

    return app