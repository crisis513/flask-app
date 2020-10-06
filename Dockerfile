FROM crisis513/flask-app:latest

RUN python ./setup.py

EXPOSE 8080

CMD ["uwsgi", "--ini", "conf.ini"]

