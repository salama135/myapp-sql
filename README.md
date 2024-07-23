# Instabug Chat API


This project implements a RESTful API for a chat system, as specified in the Instabug Backend Challenge. It uses Ruby on Rails for the main API and (optionally) Golang for handling chat/message creation.


## Features


* **Application Management:** Create, retrieve, and update applications.
* **Chat Management:** Create and retrieve chats within applications.
* **Message Management:** Create and retrieve messages within chats.
* **Message Search:** Search for messages within a chat using Elasticsearch.
* **Background Jobs:** Handles chat/message creation and counter updates asynchronously.
* **Concurrency Handling:** Mitigates race conditions in chat/message number generation.
* **Containerization:** Uses Docker Compose for easy setup and deployment.


## Technology Stack


* **Backend:**
    * Ruby on Rails (API)
* **Database:**
    * MySQL (Primary data store)
    * Elasticsearch (Message search)
    * Redis (Optional, for caching and background job queues)
* **Containerization:** Docker Compose


## Prerequisites


* Docker
* Docker Compose


## Setup


1. **Clone the Repository:**
   ```bash
   git clone <your-repository-url>
   cd instabug-chat-api
2. **Start the Services:**


    ```bash
    docker-compose up
    ```
    This command will:


    Download and build the necessary Docker images (Rails API, MySQL, Elasticsearch, and potentially Redis if used).
    Create and start containers for each service.
    Link the containers together so they can communicate.
    The first time you run this command, it might take a while to download and build the images. Subsequent runs will be much faster.




Base URL
http://localhost:3000
Endpoints


```bash
Applications:


POST /applications (Create an application)
GET /applications/:token (Get an application)
PUT /applications/:token (Update an application)
GET /applications/:token/chats (List chats for an application)
```
```bash
Chats:


POST /applications/:token/chats (Create a chat)
GET /applications/:token/chats/:number (Get a chat)
GET /applications/:token/chats/:number/messages (List messages for a chat)
```
```bash
Messages:


POST /applications/:token/chats/:number/messages (Create a message)
GET /applications/:token/chats/:number/messages/:number (Get a message)
GET /applications/:token/chats/:number/messages/search?query=<search_term> (Search messages)
```
Testing
Run the test suite with RSpec:


```bash
docker-compose run web rspec
```


## Notes
- used for the development & testing environments 
  - wsl2 -> ubuntu 
  - postman
  - docker desktop 

- prior knowledge about .net core apis framework helped with understanding the general architecture of the framework  
- you can test using postman and import the `Instabug Challenge.postman_collection.json` file

## references
- https://gorails.com/setup/windows/10#final-steps
- https://www.udemy.com/course/gcp-associate-cloud-engineer-google-certification/learn/lecture/43762536#overview
- https://plata.news/blog/cant-verify-csrf-token-authenticity/
- https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/install-redis-on-windows/
- https://engineering.chronus.com/handling-race-conditions-in-ruby-on-rails-application-7c393dc631dd
- https://ruby-for-beginners.rubymonstas.org/
- https://maffan.medium.com/processing-background-jobs-using-sidekiq-gem-in-rails-7-part-i-5c71574ac479
- https://stackoverflow.com/questions/63497928/ubuntu-wsl-with-docker-could-not-be-found



