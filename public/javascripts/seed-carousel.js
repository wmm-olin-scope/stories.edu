// Generated by CoffeeScript 1.6.3
(function() {
  var openVideo, youtubeIdToUrl;

  youtubeIdToUrl = function(id) {
    return "//www.youtube.com/embed/" + id + "?showinfo=0&modestbranding=1&controls=1";
  };

  openVideo = function(title, youtubeId) {
    var modal;
    modal = $('#story-modal');
    modal.find('#story-modal-title').text(title);
    modal.find('iframe').attr('src', youtubeIdToUrl(youtubeId));
    return modal.modal('show');
  };

  $(function() {
    return $('#story-carousel').find('a').css('cursor', 'pointer').click(function() {
      return openVideo('Some story', 'wX78iKhInsc');
    });
  });

}).call(this);

/*
//@ sourceMappingURL=seed-carousel.map
*/
