FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=demo
ENV MYSQL_DATABASE=db_restaurant
ENV MYSQL_USER=dbuser
ENV MYSQL_PASSWORD=demo

COPY db_restaurant.sql /docker-entrypoint-initdb.d/
CMD ["mysqld"]