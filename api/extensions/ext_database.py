from dify_app import DifyApp
from models import db
from sqlalchemy import text


def init_app(app: DifyApp):
    db.init_app(app)
    with app.app_context():
        # Enable the uuid-ossp extension for PostgreSQL
        db.session.execute(text('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'))
        db.session.commit()
        db.create_all()
