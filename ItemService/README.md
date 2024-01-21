



- [ ] Backend:
- [ ] Note: Item is show or movie
- [ ] Backend Service
    - [x] Table for Reviews:
        - [x] Key value store:
            - [x] Complex Primary key (user_id, item_id)
            - [x] Additional fields:
                - [x] Stars (0-5)
                - [x] Timestamp
                - [x] Additional notes
    - [ ] Table for Following
        - [ ] user_id primary key, friends
    - [ ] API:
        - [x] /post_review
            - [x] Creates new entry into table
        - [x] /get_item
            - [x] Get all reviews for specific item
        - [x] /get_user
            - [x] Get all reviews by a user
        - [x] /get_specific_item
            - [x] Get all reviews by a user for a specific item
        - [x] /search_movie
            - [x] Search for a movie
        - [x] /search_show
        - [ ] ADD IMAGES: https://developer.themoviedb.org/docs/image-basics
        - [ ] /get_feed:
            - [ ] 1: Gets list of other users that current user is following
            - []  2: Collects the most recent items from those users + our users
        - [ ] /follow_user
            - [ ] Allows to follow another user
        - [ ] /unfollow_user
            - [ ] Unfollow user
- [ ] 




External API to use to fetch movie metadata:https://developer.themoviedb.org/docs/getting-started




COMMANDS:
- Print the db: curl -X GET  http://127.0.0.1:5000/print_db
- Search for a movie: curl -X GET -H "Content-Type: application/json" -d '{"search_term": "Oceans 11"}' http://127.0.0.1:5000/search_movie
- Search for a show: curl -X GET -H "Content-Type: application/json" -d '{"search_term": "Ted"}' http://127.0.0.1:5000/search_show
- Post a movie review: curl -X POST -H "Content-Type: application/json" -d '{"media_type": "MOVIE", "user_id": "rishikesh_id", "item_id": "920", "stars": 5, "timestamp": 0, "notes": "goat movie"}' http://127.0.0.1:5000/post_review
- Post a show review: curl -X POST -H "Content-Type: application/json" -d '{"media_type": "SHOW", "user_id": "rishikesh_id", "item_id": "456", "stars": 3, "timestamp": 10, "notes": "eh"}' http://127.0.0.1:5000/post_review
