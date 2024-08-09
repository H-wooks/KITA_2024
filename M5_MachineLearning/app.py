from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import pandas as pd
from surprise import SVD, Dataset, Reader, KNNBaseline
import pymysql

pymysql.install_as_MySQLdb()

app = Flask(__name__)
app.config.from_pyfile('config.py')

db = SQLAlchemy(app)
migrate = Migrate(app, db)

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

# 데이터베이스 연결 테스트
@app.before_first_request
def initialize():
    try:
        connection = db.engine.connect()
        print("Database connected successfully.")
        connection.close()
    except Exception as e:
        print(f"Error connecting to the database: {e}")

def load_data():
    try:
        ratings_df = pd.read_sql('SELECT * FROM ratings', db.engine)
        movies_df = pd.read_sql('SELECT * FROM movies', db.engine)
        print(f"Ratings DataFrame shape: {ratings_df.shape}")
        print(f"Movies DataFrame shape: {movies_df.shape}")

        # 영화 ID 92가 포함된 행 출력
        movie_92_ratings = ratings_df[ratings_df['movieId'] == 92]
        print(f"Ratings for Movie ID 92: {movie_92_ratings}")

        return ratings_df, movies_df
    except Exception as e:
        print(f"Error loading data: {e}")
        raise e

def train_model(ratings_df):
    ratings_df['movieId'] = ratings_df['movieId'].astype(str)  # movieId를 문자열로 변환
    reader = Reader(rating_scale=(0.5, 5.0))
    data = Dataset.load_from_df(ratings_df[['userId', 'movieId', 'rating']], reader)
    trainset = data.build_full_trainset()
    
    print(f"Number of movies in the training set: {trainset.n_items}")
    print(f"Number of users in the training set: {trainset.n_users}")

    movie_ids_in_trainset = [trainset.to_raw_iid(iid) for iid in range(trainset.n_items)]
    #print(f"All Movie IDs in training set: {movie_ids_in_trainset}")  # 모든 영화 ID 출력

    algo = SVD(n_epochs=20, n_factors=50, random_state=0)
    algo.fit(trainset)
    
    return algo, trainset

def get_unseen_movies(ratings_df, movies_df, user_id):
    seen_movies = ratings_df[ratings_df['userId'] == user_id]['movieId'].tolist()
    all_movies = movies_df['movieId'].tolist()
    unseen_movies = [movie for movie in all_movies if movie not in seen_movies]
    return unseen_movies

def recommend_movies(model, user_id, unseen_movies, movies_df, top_n=10):
    predictions = [model.predict(str(user_id), str(movie_id)) for movie_id in unseen_movies]
    top_predictions = sorted(predictions, key=lambda x: x.est, reverse=True)[:top_n]
    top_movie_ids = [int(pred.iid) for pred in top_predictions]
    top_movie_titles = movies_df[movies_df['movieId'].isin(top_movie_ids)]['title'].tolist()
    top_movie_ratings = [pred.est for pred in top_predictions]
    recommendations = list(zip(top_movie_titles, top_movie_ratings))
    return recommendations

def recommend_similar_movies(movie_id, trainset, movies_df, top_n=10):
    print(f"Starting recommend_similar_movies for movie_id: {movie_id}")
    sim_options = {'name': 'cosine', 'user_based': False}
    algo_knn = KNNBaseline(sim_options=sim_options)
    algo_knn.fit(trainset)

    movie_id_str = str(movie_id)
    print(f"Converted movie_id to string: {movie_id_str}")
    try:
        inner_id = algo_knn.trainset.to_inner_iid(movie_id_str)
        print(f"Inner ID for Movie ID {movie_id}: {inner_id}")

        # Check if the inner_id correctly maps back to the original movie_id
        raw_id = algo_knn.trainset.to_raw_iid(inner_id)
        print(f"Raw ID for Inner ID {inner_id}: {raw_id}")

        if raw_id != movie_id_str:
            print(f"Discrepancy found: raw_id {raw_id} does not match movie_id_str {movie_id_str}")

    except ValueError:
        print(f"Movie ID {movie_id} not found in the training set.")
        return None, pd.DataFrame()

    neighbors = algo_knn.get_neighbors(inner_id, k=top_n)
    print(f"Neighbors' inner IDs for Movie ID {movie_id}: {neighbors}")

    neighbors_movie_ids = [algo_knn.trainset.to_raw_iid(inner_id) for inner_id in neighbors]
    neighbors_movie_ids = [int(iid) for iid in neighbors_movie_ids]
    neighbors_movies = movies_df[movies_df['movieId'].isin(neighbors_movie_ids)][['movieId', 'title']]
    print(f"Neighbors' movie IDs: {neighbors_movie_ids}")

    if not neighbors_movies.empty:
        movie_title = movies_df[movies_df['movieId'] == movie_id]['title'].values[0]
    else:
        movie_title = "Movie not found"
        print(f"Movie ID {movie_id} has no similar movies.")
    
    return movie_title, neighbors_movies

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/recommend', methods=['POST'])
def recommend():
    user_id = int(request.form['user_id'])
    print(f"User ID: {user_id}")
    ratings_df, movies_df = load_data()
    model, trainset = train_model(ratings_df)
    unseen_movies = get_unseen_movies(ratings_df, movies_df, user_id)
    recommendations = recommend_movies(model, user_id, unseen_movies, movies_df)
    print(f"Recommendations: {recommendations}")
    return render_template('recommend.html', recommendations=recommendations)

@app.route('/similar', methods=['POST'])
def similar():
    movie_id = int(request.form['movie_id'])
    print(f"Movie ID: {movie_id}")
    ratings_df, movies_df = load_data()
    model, trainset = train_model(ratings_df)
    movie_title, similar_movies = recommend_similar_movies(movie_id, trainset, movies_df)
    
    if movie_title is None:
        return render_template('similar.html', movie_title="Movie not found", similar_movies=pd.DataFrame())
    
    print(f"Similar Movies: {similar_movies}")
    return render_template('similar.html', movie_title=movie_title, similar_movies=similar_movies)

if __name__ == '__main__':
    app.run(debug=True)
