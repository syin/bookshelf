import json
import logging
import os

from flask import Flask, render_template, jsonify
from flask_cors import CORS
import markdown
from werkzeug.middleware.proxy_fix import ProxyFix


app = Flask(__name__)
app.config['DEBUG'] = True if os.environ.get("FLASK_ENV") == "development" else False
app.wsgi_app = ProxyFix(app.wsgi_app)
CORS(app)

logging.basicConfig(level=logging.DEBUG)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/details/<book_name>')
def details(book_name):
    filename = os.path.join(app.static_folder, 'assets', 'details', '{}.md'.format(book_name))
    f = open(filename, 'r')
    md_text = f.read()
    f.close()
    html = markdown.markdown(md_text)
    return render_template('details.html', details=html)


@app.route('/api/list/')
def list_books():
    filename = os.path.join(app.static_folder, 'assets', 'books.json')
    f = open(filename, 'r')
    books = json.load(f)
    f.close()
    return jsonify(books)


if __name__ == "__main__":
    app.run()
