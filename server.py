import json
import os

from flask import Flask, render_template, jsonify
from flask_cors import CORS
from werkzeug.middleware.proxy_fix import ProxyFix


app = Flask(__name__)
app.config['DEBUG'] = True if os.environ.get("FLASK_ENV") == "development" else False
app.wsgi_app = ProxyFix(app.wsgi_app)
CORS(app)


@app.route('/')
def server():
    return render_template('index.html')


@app.route('/api/list/')
def list_books():
    filename = os.path.join(app.static_folder, 'assets', 'books.json')
    f = open(filename, 'r')
    books = json.load(f)
    return jsonify(books)


if __name__ == "__main__":
    app.run()
