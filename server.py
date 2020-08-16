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
    books = get_books()
    book = get_book_by_read_more_name(books, book_name)

    md_details = get_book_details(book_name)
    html_details = markdown.markdown(md_details)

    return render_template('details.html', details=html_details, book=book)


@app.route('/api/list/')
def list_books():
    books = get_books()
    return jsonify(books)


def get_books():
    filename = os.path.join(app.static_folder, 'assets', 'books.json')
    books_file = open(filename, 'r')
    books = json.load(books_file)
    books_file.close()
    return books


def get_book_details(book_name):
    filename = os.path.join(app.static_folder, 'assets', 'details', '{}.md'.format(book_name))
    details_file = open(filename, 'r')
    md_text = details_file.read()
    details_file.close()

    return md_text


def get_book_by_read_more_name(books, book_name):
    return next(book for book in books if book["readMore"] == book_name)


if __name__ == "__main__":
    app.run()
