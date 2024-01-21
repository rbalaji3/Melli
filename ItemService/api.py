

from flask import Flask, request, jsonify
from module import Module
from request_definitions import SearchRequest, PostReviewRequest, MEDIA_TYPE, UserReviewsRequest, ItemReviewsRequest, ItemGetRequest
from pydantic import ValidationError

from functools import wraps
app = Flask(__name__)
module = Module()



def request_validator(data_model):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            try:
                # Parse and validate JSON data using Pydantic model
                incoming_request = data_model.model_validate_json(request.data)
                
                # Pass the parsed data to the original function
                return func(incoming_request, *args, **kwargs)
            except ValidationError as e:
                # Handle validation errors
                return jsonify({"error": str(e)}), 400
        return wrapper
    return decorator



@app.route("/search_movie", methods=['POST'])
@request_validator(SearchRequest)
def search_movie(request):
    response = module.tmdb_api_handler().search_movie(search_term=request.search_term)
    return jsonify({"Results":response})


@app.route("/search_show", methods=['POST'])
@request_validator(SearchRequest)
def search_show(request):
    response = module.tmdb_api_handler().search_show(search_term=request.search_term)

    return jsonify({"Results":response})

@app.route("/post_review", methods=['POST'])
@request_validator(PostReviewRequest)
def post_review(request):
    """ 
    Allowing a user to post a review
    """
    if request.media_type == MEDIA_TYPE.MOVIE: 
        if module.tmdb_api_handler().validating_movie_by_id(item_id=request.item_id):
            sucess = module.database_handler().insert_movie_rating(review=request)
            return jsonify({"Success": str(sucess != None)})
        else:
            return jsonify({"Success": "Could not validate movie", "item_id": request.item_id})
    elif request.media_type == MEDIA_TYPE.SHOW:
        if module.tmdb_api_handler().validating_show_by_id(item_id=request.item_id):
            sucess = module.database_handler().insert_show_rating(review=request)
            return jsonify({"Success": str(sucess != None)})
        else:
            return jsonify({"Success": "Could not validate show", "item_id": request.item_id})
    


@app.route("/get_user_reviews", methods=['GET'])
@request_validator(UserReviewsRequest)
def get_user_reviews(request):
    movie_ratings = module.database_handler().get_all_movie_ratings(user_id=request.user_id)
    show_ratings = module.database_handler().get_all_show_ratings(user_id=request.user_id)
    
    return jsonify(
        {
            "user_id": request.user_id,
            "movie_ratings": movie_ratings,
            "show_ratings": show_ratings,
        }
    )




@app.route("/get_show_reviews", methods=['GET'])
@request_validator(ItemReviewsRequest)
def get_show_reviews(request):
    """ 
    Get all reviews for a specific show
    """
    ratings = module.database_handler().get_all_show_ratings(item_id=request.item_id)
    return jsonify(
        {
            "item_id": request.item_id,
            "show_reviews": ratings,
        }
    )

@app.route("/get_movie_reviews", methods=['GET'])
@request_validator(ItemReviewsRequest)
def get_movie_reviews(request):
    """ 
    Get all reviews for a specific show
    """
    ratings = module.database_handler().get_all_movie_ratings(item_id=request.item_id)
    return jsonify(
        {
            "item_id": request.item_id,
            "movie_reviews": ratings,
        }
    )

@app.route("/get_item", methods=['GET'])
@request_validator(ItemGetRequest)
def get_item(request):
    if module.tmdb_api_handler().validating_movie_by_id(item_id=request.item_id):
        return module.tmdb_api_handler().get_movie(item_id=request.item_id)
    elif module.tmdb_api_handler().validating_show_by_id(item_id=request.item_id):
        return module.tmdb_api_handler().get_show(item_id=request.item_id)
    else:
        return jsonify({"Result": "Could not find item"})
    

@app.route("/print_db", methods=['GET'])
def print_db():
    """ 
    Get all reviews for a specific movie
    """
    module.database_handler().print_movie_db()
    module.database_handler().print_show_db()
    
    return jsonify({"printed": "db"})


if __name__ == '__main__':
    app.run(debug=True)