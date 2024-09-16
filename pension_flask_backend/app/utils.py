def configure_app(app):
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///pensions.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = 'your_secret_key_here'