FROM crisis513/flask-app:latest

COPY ./app /app

USER dummyuser

WORKDIR /app

# Setup the database
RUN touch database.db
RUN python ./setup.py

EXPOSE 8080

CMD ["uwsgi", "--ini", "conf.ini"]

