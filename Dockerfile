FROM crisis513/flask-app:latest

COPY ./app /app

# Copy the compiled modules from the builder to the actual container
COPY --from=builder /install /usr/local

# Copy my flask code
COPY ./app /app

# Create a non-root user
RUN adduser -D dummyuser
# It needs ownership of the workdir to update the sqlite database
RUN chown dummyuser /app
USER dummyuser

WORKDIR /app

# Setup the database
RUN touch database.db
RUN python ./setup.py

EXPOSE 8080

CMD ["uwsgi", "--ini", "conf.ini"]

