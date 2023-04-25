# Install `nodejs` and `npm`
- RUN `sudo apt install -y nodejs npm`
- RUN `sudo npm install vue-basic-alert`
# Install developers build kit for node library
- RUN `sudo apt install -y build-essential`
# Build app and backend with `npm` and start project
- RUN `cd frontend && npm install`
- RUN `cd backend && npm install`
# Edit Connection to db
`cd backend/config/database.js` and create `db` schema to your `mariadb` or `mysql db`
# Create db schema
`cd frontend/src/resources/db_restaurant.sql`
# Start the frontend server
`cd front && npm run serve`
# Start the frontend server
`cd backend && npm start`
# Admin login
`admin password is: 25082002`

# make sure to open ports `3306` , `8080`, `8081`