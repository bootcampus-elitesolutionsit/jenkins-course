# Use an official Python runtime as the base image
FROM python:3.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt /app/requirements.txt

# install Mysql
RUN pip install mysql-connector-python

# Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code to the container
COPY . /app

# Set the environment variable for Flask
ENV FLASK_APP=app.py

# Expose port 5000 for Flask to listen on
EXPOSE 5000

# Run the Flask application
CMD ["flask", "run", "--host=0.0.0.0"]
