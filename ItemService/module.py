import os
import yaml
import pymongo
from typing import Optional, Dict
from movie_api_handler import TMDBAPIHandler
from database_handler import DatabaseHandler
from feed_handler import FeedHandler


def load_config() -> Optional[Dict]:
    config_path = os.getcwd() + "/config.yaml"
    try:
        with open(config_path, 'r') as file:
            config = yaml.safe_load(file)
            return config["config"]
    except:
        raise Exception("Could not load config file")

class Module:
    """ 
    Module to instantiate classes
    """
    def __init__(self):

        self.config = load_config()
        self._tmdb_api_handler = None
        self._mongodb_client = None
        self._database_handler = None
        self._feed_handler = None

    def tmdb_api_handler(self) -> TMDBAPIHandler:
        if self._tmdb_api_handler:
            return self._tmdb_api_handler
        else:
            return TMDBAPIHandler(api_key=self.config["TMDB_API_KEY"], read_access_key=self.config["TMDB_READ_ACCESS_TOKEN"], url_base=self.config["TMDB_URL_BASE"])
    
    def mongodb_client(self):
        if self._mongodb_client:
            return self._mongodb_client
        else:
            # TODO: Containize
            return pymongo.MongoClient('localhost', 27017)
    
    def database_name(self):
        return self.config["database_name"]

    def database_handler(self) -> DatabaseHandler:
        if self._database_handler:
            return self._database_handler
        else:
            return DatabaseHandler(database_name=self.database_name(), tmdb_api_handler=self.tmdb_api_handler(), mongo_client=self.mongodb_client())
    
    def feed_handler(self) -> FeedHandler:
        if self._feed_handler:
            return self._feed_handler
        else:
            return FeedHandler(database_handler=self.database_handler(), tmdb_api_handler=self.tmdb_api_handler())