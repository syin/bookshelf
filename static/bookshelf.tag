<bookshelf>
  <div class="container">
    <div class="book" each={ book in books }>
      <div>
        <a if={ book.readMore } href="/details/{ slugify(book.author, book.title) }">
          <img src="/static/assets/covers/{ book.cover }">
        </a>
        <img if={ !book.readMore } src="/static/assets/covers/{ book.cover }">
      </div>
      <div class="title" if={ book.readMore }>
        <a href="/details/{ slugify(book.author, book.title) }">{ book.title }</a> →
      </div>
      <div class="title" if={ !book.readMore }>{ book.title }</div>
      <div class="author">{ book.author }</div>
      <div class="rating">
        <div class="stars">
          <i each={ book.rating } class="icon icon-star">&#xe801;</i>
        </div>
        <div class="heart" if={ book.favourite }>
          <i class="icon icon-heart">&#xe800;</i>
        </div>
      </div>
    </div>
  </div>

  <script>
    const self = this;
    self.books = [];
    
    self.on('mount', function() {
      getBooks();
    });

    slugify(author, title) {
      return `${author}-${title}`.replace(/\s/g , "-").toLowerCase();
    }

    const getBooks = function() {
      const apiUrl = `/api/list`;
      fetch(apiUrl, {method: 'GET', mode: 'cors'}).then(response => {
        response.json().then(data => {
          console.log('getBooks', data);
          self.books = transformStars(data);
          self.update();
        });
      }).catch(error => {
        console.log('error', error);
      });
    };

    const transformStars = function(books) {
      return books.map(function(book) {
        const transformedBook = { ...book };
        transformedBook.rating = Array(book.rating).fill();
        return transformedBook;
      });
    }
  </script>
</bookshelf>
