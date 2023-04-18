# Use an official Node.js runtime as a parent image
FROM node:14-alpine As builder

# Add metadata to the image with your name
LABEL maintainer="Louis Benagha <support@tsr.com>"

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React application
RUN npm run build

# Serve the built application using a web server
FROM nginx:1.21.1-alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
