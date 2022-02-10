# README

### How to Run:
- Clone the application by simply running:
  - ```git clone https://github.com/aaltheiab/resturant_reservation.git```
- Install Docker if you don't have it.
- Run docker compose:
  - ```docker-compose up```
- It will do the following:
  - Install the application dependencies
  - Create development Database
  - Load data (seed) into the database
  - You should be good to go
    - You can start using the application (APIs) with postman
  
### Access container:
  - To access docker container do the following:
    - Make sure you installed the app first (```docker-compose up```)
    - Run ```docker-compose exec app bash``` inside the container. 

### Resources Used:
- JWT:
  - https://medium.com/binar-academy/rails-api-jwt-authentication-a04503ea3248
- Docker:
  - https://docs.docker.com/samples/rails/
- Amazing Reusable filtering system:
  - https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/

### Assumptions:
- The application is only one layer that handles 1 Resturant
- Timezone: Riyadh


### Postman Configuration:
- Open your postman 
- Click on ```file``` > ```import```
- Drag ```*.json``` files from ```./postman``` folder into the import dialog
- You should get
  - Collections:
    - Users
    - Reservations
    - Tables
  - Environment:
    - ResturantReservationApp
  

### Diagrams (inside ```/diagrams```):
- Activity Diagram
  - Shows how the reservation activity is being processed 
- Class Diagram
  - Shows an initial class diagram sketch.

### Test cases:
- You can run test cases by simply typing ```rails test``` inside the docker container (```bash```)

