import json
import logging
import os

from flask import Flask, render_template, jsonify, redirect, url_for
from flask_cors import CORS
import markdown
from werkzeug.middleware.proxy_fix import ProxyFix


app = Flask(__name__)
# app.config['DEBUG'] = True if os.environ.get("FLASK_ENV") == "development" else False
# app.config['TEMPLATES_AUTO_RELOAD'] = True
app.wsgi_app = ProxyFix(app.wsgi_app)
CORS(app)

logging.basicConfig(level=logging.DEBUG)


@app.route('/')
def index():
    return redirect(url_for('bookshelf'))


@app.route('/bookshelf')
def bookshelf():
    return render_template('bookshelf.html')


@app.route('/art')
def art():
    return render_template('art.html')


@app.route('/bookshelf/details/<book_name>')
def book_details(book_name):
    books = get_collection('books', 'books.json', 'dateRead')
    book = get_item_by_read_more_name(books, book_name)

    md_details = get_item_details('books', book_name)
    html_details = generate_html(md_details)

    return render_template('book_details.html', details=html_details, book=book)


@app.route('/art/details/<item_name>')
def art_details(item_name):
    art = get_collection('art', 'art.json', 'dateCompleted')
    artwork = get_item_by_read_more_name(art, item_name)

    md_details = get_item_details('art', item_name)
    html_details = generate_html(md_details)

    return render_template('art_details.html', details=html_details, artwork=artwork)


@app.route('/api/list/books')
def list_books():
    books = get_collection('books', 'books.json', 'dateRead')
    return jsonify(books)


@app.route('/api/list/art')
def list_art():
    art = get_collection('art', 'art.json', 'dateCompleted')
    return jsonify(art)


def get_collection(collection_name, filename, sort_key):
    filename = os.path.join(app.static_folder, 'assets', collection_name, filename)
    file = open(filename, 'r')
    items = json.load(file)
    file.close()
    items = sorted(items, key=lambda x: x[sort_key], reverse=True)
    return items


def get_item_details(collection_name, book_name):
    filename = os.path.join(app.static_folder, 'assets', collection_name, 'details', '{}.md'.format(book_name))
    details_file = open(filename, 'r')
    md_text = details_file.read()
    details_file.close()

    return md_text


def generate_html(md):
    # todo sidenotes
    return markdown.markdown(md)


def get_item_by_read_more_name(collection, item_name):
    return next(item for item in collection if item["readMore"] == item_name)
