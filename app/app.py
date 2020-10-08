import json
import time

from flask import Flask, render_template
import sqlite3 as db

app = Flask(__name__)


@app.route('/')
def index():
    with db.connect('database.db') as conn:
        count = conn.execute('SELECT count(*) FROM counts').fetchone()[0]
    return render_template('index.html', counter=count)


@app.route('/increase')
def increase():
    with db.connect('database.db') as conn:
        count = conn.execute('SELECT count(*) FROM counts').fetchone()[0]
        print(count)
        conn.execute('insert into counts (id) VALUES (?)', (count+1,))
        conn.commit()
    return render_template('index.html', counter=count+1)


if __name__ == '__main__':
    app.run(debug=True)
    while True:
        d = {'name': 'fakenerd', 'time_ms': int(time.time() * 1000)}
        print(json.dumps(d))
        time.sleep(60)
