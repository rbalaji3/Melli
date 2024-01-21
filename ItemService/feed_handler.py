from database_handler import DatabaseHandler



class FeedHandler:
    """ 
    Generating a user's feed
    """

    def __init__(self, database_handler: DatabaseHandler):
        self.database_handler = database_handler
    

    def generate_user_feed(self, user_id: str):
        # TODO, add user friends

        movie_ratings = self.database_handler().get_all_movie_ratings(user_id=user_id)
        show_ratings = self.database_handler().get_all_show_ratings(user_id=user_id)
        return None