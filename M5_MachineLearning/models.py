from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Movie(db.Model):
    movieId = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255))
    genres = db.Column(db.String(255))

class Rating(db.Model):
    userId = db.Column(db.Integer, primary_key=True)
    movieId = db.Column(db.Integer, primary_key=True)
    rating = db.Column(db.Float)
    timestamp = db.Column(db.Integer)
    __table_args__ = (
        db.PrimaryKeyConstraint('userId', 'movieId'),
    )
