<bookshelf>
  <div class="year-list">
    <span
      each={ year in years }
      class={"year": true, "selected": year === selectedYear }
      onclick={ selectYear }>
      { year }
    </span>
  </div>
  <div class="container book">
    <div class="grid-item" each={ book in books }>
      <div>
        <a if={ book.readMore } href="/bookshelf/details/{ book.readMore }">
          <img src="/static/assets/books/covers/{ book.cover }">
        </a>
        <img if={ !book.readMore } src="/static/assets/books/covers/{ book.cover }">
      </div>
      <div>
        <div class="title" title="Read more" if={ book.readMore }>
          <a href="/bookshelf/details/{ book.readMore }">{ book.title }</a> →
        </div>
        <div class="title" if={ !book.readMore }>{ book.title }</div>
        <div class="author">{ book.author }</div>
      </div>
      <div class="rating">
        <div class="stars" title="Rating">
          <i each={ book.rating } class="icon icon-star"></i>
        </div>
        <div class="meta-icons">
          <div class="heart" title="Favourite" if={ book.favourite }>
            <i class="icon icon-heart"></i>
          </div>
          <div class="audio" title="Audiobook" if={ book.audiobook }>
            <i class="icon icon-headphones"></i>
          </div>
          <div class="reread" title="Reread" if={ book.reread }>
            <i class="icon icon-cw"></i>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    const self = this;
    self.books = [];
    self.years = ["2021", "2020"];
    self.selectedYear = "2021";
    
    self.on('mount', function() {
      getBooks();
    });

    slugify(author, title) {
      return `${author}-${title}`.replace(/\s/g , "-").toLowerCase();
    }

    selectYear(e) {
      self.selectedYear = e.item.year;
      getBooks();
    }

    const getBooks = function() {
      const apiUrl = `/api/list/books/${self.selectedYear}`;
      fetch(apiUrl, {method: 'GET', mode: 'cors'}).then(response => {
        response.json().then(data => {
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
