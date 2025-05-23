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

## Technical Feedback:

### Race conditions:
- Feedback: Didn't handle concurrency related issues. Hint: There is a race condition in chat/message number generation which might cause the generation of duplicate numbers.
- Recommendations: Needs to think about having concurrency in their application and how to handle the issues resulting from that, such as race conditions. We would recommend to get a more hands on experience with concurrent applications and learn about common concurrency patterns.

### Unoptimzied database:

#### No indexes:
- Feedback: Candidate didn't optimize their database schema for all recurring query patterns. Hint: some of the queried columns are not indexed and thus queries will not be efficient.
- Recommendations: Needs to learn more about indexing and how to use it to optimize performance. We would recommend to read "Indexing for High Performance" from "High Performance MySQL". A summary of this chapter can be found here: https://sayedalesawy.hashnode.dev/high-performance-mysql-ch5-indexing-for-high-performance. A summarized series of the book can be found here: https://sayedalesawy.hashnode.dev/series/high-performance-mysql

#### No unique indexes:
- Feedback: Candidate didn't enforce uniqueness constraints in their database schema for all usecases and their application is prone to duplication.
- Recommendations: Go back to the task definition and spot the unique constraints and how to enforce them from the database side.

### Elasticsearch:

#### Unopitmized query/index:
- Feedback: Candidate didn't use the most suitable way for partial matching regarding performance.
- Recommendations: We would recommend to check the elasticsearch ngram tokenizer, here: https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-ngram-tokenizer.html

#### Insecure query:
- Feedback: Candidate didn't satisfy the requirements of the partial matching query. Hint: query might return messages that a user doesn't have access to.
- Recommendations: We would recommend to try tweaking the query to scope search on only messages that a given user can access.

#### Unoptimized updates to chats count and messages count:
- Feedback: Candidate's way of updating chats count and messages count causes too much database load. Hint: Updates are done with every new chat/message.
- Recommendations: We would recommend that the candidates re-reviews the task requirement, specially the part relating to not having to have those counts to be real time and think of how to use that to do more lighter updates of those fields. Hint: cronjobs.

