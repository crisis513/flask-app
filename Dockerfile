FROM crisis513/flask-app:latest

#RUN apk add --no-cache linux-headers build-base

#COPY requirements.txt /requirements.txt

#RUN pip install -r /requirements.txt

COPY ./app /app
WORKDIR /app
#RUN pip install flask

#RUN touch database.db
#RUN python ./setup.py

EXPOSE 8080
CMD ["uwsgi", "--ini", "conf.ini"]
