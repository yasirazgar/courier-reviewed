# README

# CourierReviewed -  https://courier-reviewed.herokuapp.com

The basic idea of the application is to allow the deliveryperson/courier to add a post/review of the place/restaurants he visits for picking up the item, example in the context of a restaurant it can be a post about hygiene, behavior of the restaurant staffs and etc. 
Post/reviews can be showed in the restaurant listing page along with the user reviews in the main application, i will be useful as the user only sees the food, which arrives in the packed box, he/she has no idea about conditions in which the food is prepared or about staffs in the restaurant.


Only the rails api is implemented here, which can be consumed by other applications.

Tried to keep the application simple by avoiding additional gems/libraries and queuing/caching mechanisms. 

Refer Docs for various api endpoints and its respective response structure with sample json responses.
https://github.com/yasirazgar/courier-reviewed/blob/master/docs/end_points.txt

**Tech Stack**
  
  *  Language/Framework - Rails (6.0.0) - Ruby (2.6.4)
  
  *  Database - Postgresql
  
     Database setup rails db:create db:migrate db:seed 
     
  *  Api architecture style - RESTful api
  
  *  Unit testing framework - Minitest
  
     rails test - runs all unit test


# Steps for checking the endpoints

**To access all the end points**

Login and get the jwt and set it to the header with key 'Authorization' in the format "Bearer #{jwt}"

Eg: Bearer asdfasdf89798709asdff


**Pagination keys **

limit => page_limit
page => page
Links for first, next, prev and last pages are available in response headers.

**Also Created a simple end point for creating a user**

    POST   /v1/admin/users.json
    require_params = { "user":{ "username": "Yash3", "email": "yash3@carriage.com", "password": "passworD@1" } }
    response = { "message": "User created successfully." }

**Available users**

     Admin          - email => yasir@carriage.com;  password => 'PassworD@55'
     Courier/Member - email => jhonny@carriage.com; password => 'PassworD@55'
     Refer seed.rb file for more.


Currently the api-only app is deployed to heroku - https://courier-reviewed.herokuapp.com
