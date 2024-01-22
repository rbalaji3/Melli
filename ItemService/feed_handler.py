from database_handler import DatabaseHandler
from typing import List
from operator import itemgetter
from flask import jsonify


class FeedHandler:
    """ 
    Generating a user's feed
    """

    def __init__(self, database_handler: DatabaseHandler):
        self.database_handler = database_handler
    
    def objectid_to_int(self, obj_id):
        return int(str(obj_id), 16)
    
    def generate_sorted_feed(self, unsorted_feed: List):
        sorted_list = sorted(unsorted_feed, key=lambda x: x['timestamp'], reverse=True)
        for item in sorted_list:
            item["_id"] = self.objectid_to_int(item["_id"])
        return sorted_list
    def generate_user_feed(self, user_id: str):
        # TODO, add user friends
        user_movie_ratings = self.database_handler._get_all_movie_ratings(user_id=user_id)
        user_show_ratings = self.database_handler._get_all_show_ratings(user_id=user_id)
        
        all_reviews = user_movie_ratings + user_show_ratings
        return jsonify({"Feed": self.generate_sorted_feed(all_reviews)})
