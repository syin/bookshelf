<art-gallery>
  <h3>2020</h3>
  <div class="container artwork">
    <div class="grid-item" each={ artwork in artworks }>
      <div>
        <a if={ artwork.readMore } href="/art/details/{ artwork.readMore }">
          <img src="/static/assets/art/covers/{ artwork.cover }">
        </a>
        <img if={ !artwork.readMore } src="/static/assets/art/covers/{ artwork.cover }">
      </div>
    </div>
  </div>

  <script>
    const self = this;
    self.artworks = [];
    
    self.on('mount', function() {
      getArtworks();
    });

    const getArtworks = function() {
      const apiUrl = `/api/list/art`;
      fetch(apiUrl, {method: 'GET', mode: 'cors'}).then(response => {
        response.json().then(data => {
          console.log('getArtworks', data);
          self.artworks = data;
          self.update();
        });
      }).catch(error => {
        console.log('error', error);
      });
    };
  </script>
</art-gallery>
