


# class DatabaseHandler:

# brew services start mongodb-community
# brew services stop mongodb-community
# brew services list
#  brew services info mongodb-community
from request_definitions import PostReviewRequest
from typing import Dict
from bson import json_util
import json



USER_ID_KEY = "user_id"
ITEM_ID_KEY = "item_id"

class DatabaseHandler:
    
    def __init__(self, database_name: str, mongo_client):
        self.db = mongo_client[database_name]
        # Initialize the movie collection
        self.movie_collection = self.db['movies']
        self.movie_collection.create_index(USER_ID_KEY, unique=False)
        self.movie_collection.create_index(ITEM_ID_KEY, unique=False)
        
        # Initialize the show collection
        self.show_collection = self.db['shows']
        self.show_collection.create_index(USER_ID_KEY, unique=False)
        self.show_collection.create_index(ITEM_ID_KEY, unique=False)

    def insert_movie_rating(self, review: PostReviewRequest):
        """
        Inserting item into table
        """
        try:
            item = {
                ITEM_ID_KEY: review.item_id,
                USER_ID_KEY: review.user_id,
                "stars": review.stars, 
                "timestamp": review.timestamp,
                "notes": review.notes,
            }
            result = self.movie_collection.insert_one(item)
            return result
        except:
            return None

    def delete_movie_rating(self, filter_query: Dict):
        """ 
        Deleting by filter query dictionary
        """
        result = self.movie_collection.delete_many(filter_query)
        return result
    
    def _get_all_movie_ratings(self, user_id: str = None, item_id: str = None):
        filter_query = {}
        if user_id: 
            filter_query[USER_ID_KEY] = user_id
        if item_id: 
            filter_query[ITEM_ID_KEY] = item_id
        matching_items = list(self.movie_collection.find(filter_query))
        return matching_items
    
    def get_all_movie_ratings(self, user_id: str = None, item_id: str = None):
        """
        Retrieving items from the movie collection
        """
        return json.dumps(self.get_all_movie_ratings(user_id=user_id, item_id=item_id), default=json_util.default)
        

    def insert_show_rating(self, review: PostReviewRequest):
        try:
            item = {
                ITEM_ID_KEY: review.item_id,
                USER_ID_KEY: review.user_id,
                "stars": review.stars, 
                "timestamp": review.timestamp,
                "notes": review.notes,
            }
            result = self.show_collection.insert_one(item)
            return result
        except:
            return None
    
    def delete_show_rating(self, filter_query: Dict):
        """ 
        Deleting by filter query dictionary
        """
        result = self.show_collection.delete_many(filter_query)
        return result
    
    def _get_all_show_ratings(self, user_id: str = None, item_id: str = None):
        filter_query = {}
        if user_id: 
            filter_query[USER_ID_KEY] = user_id
        if item_id: 
            filter_query[ITEM_ID_KEY] = item_id
        matching_items = list(self.show_collection.find(filter_query))
        return matching_items

    def get_all_show_ratings(self, user_id: str = None, item_id: str = None):
        """
        Retrieving items from the movie collection
        """
        return json.dumps(self._get_all_show_ratings(user_id=user_id, item_id=item_id), default=json_util.default)


    def print_movie_db(self):
        all_documents = self.movie_collection.find()
        for document in all_documents:
            print(document)

    def print_show_db(self):
        all_documents = self.show_collection.find()
        for document in all_documents:
            print(document)
    
