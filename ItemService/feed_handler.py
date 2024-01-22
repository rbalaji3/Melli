from database_handler import DatabaseHandler
from movie_api_handler import TMDBAPIHandler

from typing import List
from operator import itemgetter
from flask import jsonify


class FeedHandler:
    """ 
    Generating a user's feed
    """

    def __init__(self, database_handler: DatabaseHandler, tmdb_api_handler: TMDBAPIHandler):
        self.database_handler = database_handler
        self.tmdb_api_handler = tmdb_api_handler
    
    def objectid_to_int(self, obj_id):
        return int(str(obj_id), 16)
    
    def generate_sorted_feed(self, movie_ratings: List, show_ratings: List):
        
        for movie in movie_ratings:
            del movie["_id"]

        for show in show_ratings:
            del show["_id"]

        all_reviews = movie_ratings + show_ratings
        sorted_list = sorted(all_reviews, key=lambda x: x['timestamp'], reverse=True)
        return sorted_list
    

    def generate_user_feed(self, user_id: str):
        # TODO, add user friends
        user_movie_ratings = self.database_handler._get_all_movie_ratings(user_id=user_id)
        user_show_ratings = self.database_handler._get_all_show_ratings(user_id=user_id)
        
        
        return jsonify({"Feed": self.generate_sorted_feed(movie_ratings=user_movie_ratings, show_ratings=user_show_ratings)[:2]})
