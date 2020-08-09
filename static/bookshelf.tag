<bookshelf>
  <div class="container">
    <div class="book" each={ book in books }>
      <div>
        <img src="/static/assets/covers/{ book.cover }">
      </div>
      <div class="title">{ book.title }</div>
      <div class="author">{ book.author }</div>
      <div class="stars">
        <div class="star" each={ book.rating }></div>
      </div>
      <div class="heart" if={ book.favourite }></div>
    </div>
  </div>

  <script>
    const self = this;
    self.books = [];
    
    self.on('mount', function() {
      getBooks();
    });

    const getBooks = function() {
      const apiUrl = `/api/list`;
      fetch(apiUrl, {method: 'GET', mode: 'cors'}).then(response => {
        response.json().then(data => {
          console.log('getBooks', data);
          self.books = data;
          self.update();
        });
      }).catch(error => {
        console.log('error', error);
      });
    };
  </script>
</bookshelf>
