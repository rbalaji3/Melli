
from typing import Optional, Dict, List
import requests



class TMDBAPIHandler:
    """ 
    Handler that communicates with the TMDB API
    """

    def __init__(self, api_key: str, read_access_key: str, url_base: str):
        self.api_key = api_key
        self.read_access_key = read_access_key
        self.url_base = url_base

    def _get(self, endpoint: str, json: Optional[Dict] = None):
        headers = {
            'Authorization': f'Bearer {self.read_access_key}'
        }
        response = requests.get(self.url_base + endpoint, headers=headers)
        if response.status_code == 200:
            return 200, response.json()
        else:
            return response.status_code, response.text

    def _format_items(self, item_list: List[Dict], content_type: str):
        # TODO add images
        # TODO add genres
        if content_type == "show":
            name_key = "name"
        else:
            name_key = "original_title"
        formatted_items = []
        for item in item_list:
            print(item)
            new_item = {
                "adult": item["adult"],
                "id": item["id"],
                "name": item[name_key],
                "overview": item["overview"],
            }
            formatted_items.append(new_item)
        
        return formatted_items



    def search_movie(self, search_term: str):
        formatted_search_term = search_term.replace(" ", "+")
        
        response_code, response = self._get(endpoint=f"/search/movie?query={formatted_search_term}")
        if response_code == 200:
            return self._format_items(response["results"], content_type="movie")
        else:
            return "Could not find movie"
        
    
    def search_show(self, search_term: str):
        formatted_serach_term = search_term.replace(" ", "+")
        response_code, response = self._get(endpoint=f"/search/tv?query={formatted_serach_term}")
        if response_code == 200:
            return self._format_items(response["results"], content_type="show")
        else:
            return "Could not find show"

    def validating_movie_by_id(self, item_id: str):
        """ 
        Validating whether a movie's item_id is valid
        """
        # Returns true, results if 
        response_code, _ = self._get(endpoint=f"/movie/{item_id}")
        if response_code == 200:
            return True
        else:
            return False
    
    def get_movie(self, item_id: str):
        response_code, response = self._get(endpoint=f"/movie/{item_id}")
        if response_code == 200:
            return response
        else:
            return None
    
    def get_show(self, item_id: str):
        response_code, response = self._get(endpoint=f"/tv/{item_id}")
        if response_code == 200:
            return response
        else:
            return None
        
    def validating_show_by_id(self, item_id: str):
        """ 
        Validating whether a movie's item_id is valid
        """
        response_code, _ = self._get(endpoint=f"/tv/{item_id}")
        if response_code == 200:
            return True
        else:
            return False