#!/usr/bin/env python3
"""
This script marks the initial migration as complete without actually running it.
Use this when you already have some of the database schema but Alembic doesn't know about it.
"""
from flask import Flask
from sqlalchemy import text

from dify_app import create_app
from models import db

app = create_app()

# Mark the initial migration as complete
with app.app_context():
    conn = db.engine.connect()
    
    # Create alembic_version table if it doesn't exist
    conn.execute(text("""
    CREATE TABLE IF NOT EXISTS alembic_version (
        version_num VARCHAR(32) NOT NULL,
        CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
    )
    """))
    conn.commit()
    
    # Mark initial migration as complete
    initial_migration = "64b051264f32"  # The ID of the init migration
    
    # Delete existing version first to avoid conflicts
    conn.execute(text("DELETE FROM alembic_version WHERE version_num = :version"), {"version": initial_migration})
    conn.execute(text("INSERT INTO alembic_version (version_num) VALUES (:version)"), {"version": initial_migration})
    print(f"Marked initial migration {initial_migration} as complete")
    
    conn.commit()
    conn.close()

print("Initial migration has been marked as complete!")
print("Now you can run regular migrations with 'flask db upgrade'")

