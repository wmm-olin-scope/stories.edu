(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
$(function() {
  console.log('Hello from home!');
  require('../share-buttons').setup();
  return require('./seed-carousel').setup();
});


},{"../share-buttons":3,"./seed-carousel":2}],2:[function(require,module,exports){
var closeVideo, openVideo, youtubeIdToUrl;

youtubeIdToUrl = function(id) {
  return "//www.youtube.com/embed/" + id + "?autoplay=1&showinfo=0&modestbranding=1&controls=1&rel=0";
};

openVideo = function(title, youtubeId) {
  var modal;
  modal = $('#story-modal');
  modal.find('#story-modal-title').text(title);
  modal.find('iframe').attr('src', youtubeIdToUrl(youtubeId));
  return modal.modal('show');
};

closeVideo = function() {
  var modal;
  modal = $('#story-modal');
  return modal.find('iframe').attr('src', '');
};

exports.setup = function() {
  $('#story-carousel').find('a').css('cursor', 'pointer').click(function() {
    return openVideo('Some story', $(this).attr('data-youtube-id'));
  });
  $('#story-modal').on('hide.bs.modal', function(e) {
    return closeVideo();
  });
};


},{}],3:[function(require,module,exports){
var setupFacebook, setupTwitter, siteUrl;

siteUrl = 'http://www.thank-a-teacher.org';

setupFacebook = function() {
  $.getScript('//connect.facebook.net/en_UK/all.js', function() {
    return FB.init({
      appId: '1444954685735176'
    });
  });
  return $('#share-facebook').click(function() {
    return FB.ui({
      method: 'feed',
      link: siteUrl,
      caption: 'Thank a teacher!'
    });
  });
};

setupTwitter = function() {
  var encoded, twitterUrl;
  encoded = encodeURIComponent(siteUrl);
  twitterUrl = "https://twitter.com/share?url=" + encoded + "&via=wmmedu";
  return $('#share-twitter').attr('href', twitterUrl).attr('target', '_blank');
};

exports.setup = function() {
  setupFacebook();
  return setupTwitter();
};


},{}]},{},[1])
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvaG9tZS9tbWF5L3N0b3JpZXMuZWR1L25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvaG9tZS9tbWF5L3N0b3JpZXMuZWR1L2NsaWVudC9qcy9ob21lL2luZGV4LmNvZmZlZSIsIi9ob21lL21tYXkvc3Rvcmllcy5lZHUvY2xpZW50L2pzL2hvbWUvc2VlZC1jYXJvdXNlbC5jb2ZmZWUiLCIvaG9tZS9tbWF5L3N0b3JpZXMuZWR1L2NsaWVudC9qcy9zaGFyZS1idXR0b25zLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0NBLENBQUEsQ0FBRSxTQUFBLEdBQUE7QUFDRSxFQUFBLE9BQU8sQ0FBQyxHQUFSLENBQVksa0JBQVosQ0FBQSxDQUFBO0FBQUEsRUFDQSxPQUFBLENBQVEsa0JBQVIsQ0FBMkIsQ0FBQyxLQUE1QixDQUFBLENBREEsQ0FBQTtTQUVBLE9BQUEsQ0FBUSxpQkFBUixDQUEwQixDQUFDLEtBQTNCLENBQUEsRUFIRjtBQUFBLENBQUYsQ0FBQSxDQUFBOzs7O0FDQUEsSUFBQSxxQ0FBQTs7QUFBQSxjQUFBLEdBQWlCLFNBQUMsRUFBRCxHQUFBO1NBQ1osMEJBQUEsR0FBeUIsRUFBekIsR0FBNkIsMkRBRGpCO0FBQUEsQ0FBakIsQ0FBQTs7QUFBQSxTQUdBLEdBQVksU0FBQyxLQUFELEVBQVEsU0FBUixHQUFBO0FBQ1IsTUFBQSxLQUFBO0FBQUEsRUFBQSxLQUFBLEdBQVEsQ0FBQSxDQUFFLGNBQUYsQ0FBUixDQUFBO0FBQUEsRUFDQSxLQUFLLENBQUMsSUFBTixDQUFXLG9CQUFYLENBQWdDLENBQUMsSUFBakMsQ0FBc0MsS0FBdEMsQ0FEQSxDQUFBO0FBQUEsRUFFQSxLQUFLLENBQUMsSUFBTixDQUFXLFFBQVgsQ0FBb0IsQ0FBQyxJQUFyQixDQUEwQixLQUExQixFQUFpQyxjQUFBLENBQWUsU0FBZixDQUFqQyxDQUZBLENBQUE7U0FHQSxLQUFLLENBQUMsS0FBTixDQUFZLE1BQVosRUFKUTtBQUFBLENBSFosQ0FBQTs7QUFBQSxVQVNBLEdBQWEsU0FBQSxHQUFBO0FBQ1QsTUFBQSxLQUFBO0FBQUEsRUFBQSxLQUFBLEdBQVEsQ0FBQSxDQUFFLGNBQUYsQ0FBUixDQUFBO1NBQ0EsS0FBSyxDQUFDLElBQU4sQ0FBVyxRQUFYLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsS0FBMUIsRUFBaUMsRUFBakMsRUFGUztBQUFBLENBVGIsQ0FBQTs7QUFBQSxPQWFPLENBQUMsS0FBUixHQUFnQixTQUFBLEdBQUE7QUFFWixFQUFBLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLElBQXJCLENBQTBCLEdBQTFCLENBQ0ksQ0FBQyxHQURMLENBQ1MsUUFEVCxFQUNtQixTQURuQixDQUVJLENBQUMsS0FGTCxDQUVXLFNBQUEsR0FBQTtXQUFHLFNBQUEsQ0FBVSxZQUFWLEVBQXdCLENBQUEsQ0FBRSxJQUFGLENBQU8sQ0FBQyxJQUFSLENBQWEsaUJBQWIsQ0FBeEIsRUFBSDtFQUFBLENBRlgsQ0FBQSxDQUFBO0FBQUEsRUFJQSxDQUFBLENBQUUsY0FBRixDQUFpQixDQUFDLEVBQWxCLENBQXFCLGVBQXJCLEVBQXNDLFNBQUMsQ0FBRCxHQUFBO1dBQ2xDLFVBQUEsQ0FBQSxFQURrQztFQUFBLENBQXRDLENBSkEsQ0FGWTtBQUFBLENBYmhCLENBQUE7Ozs7QUNBQSxJQUFBLG9DQUFBOztBQUFBLE9BQUEsR0FBVSxnQ0FBVixDQUFBOztBQUFBLGFBRUEsR0FBZ0IsU0FBQSxHQUFBO0FBQ1osRUFBQSxDQUFDLENBQUMsU0FBRixDQUFZLHFDQUFaLEVBQW1ELFNBQUEsR0FBQTtXQUMvQyxFQUFFLENBQUMsSUFBSCxDQUFRO0FBQUEsTUFBQyxLQUFBLEVBQU8sa0JBQVI7S0FBUixFQUQrQztFQUFBLENBQW5ELENBQUEsQ0FBQTtTQUdBLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLEtBQXJCLENBQTJCLFNBQUEsR0FBQTtXQUN2QixFQUFFLENBQUMsRUFBSCxDQUNJO0FBQUEsTUFBQSxNQUFBLEVBQVEsTUFBUjtBQUFBLE1BQ0EsSUFBQSxFQUFNLE9BRE47QUFBQSxNQUVBLE9BQUEsRUFBUyxrQkFGVDtLQURKLEVBRHVCO0VBQUEsQ0FBM0IsRUFKWTtBQUFBLENBRmhCLENBQUE7O0FBQUEsWUFZQSxHQUFlLFNBQUEsR0FBQTtBQUNYLE1BQUEsbUJBQUE7QUFBQSxFQUFBLE9BQUEsR0FBVSxrQkFBQSxDQUFtQixPQUFuQixDQUFWLENBQUE7QUFBQSxFQUNBLFVBQUEsR0FBYyxnQ0FBQSxHQUErQixPQUEvQixHQUF3QyxhQUR0RCxDQUFBO1NBRUEsQ0FBQSxDQUFFLGdCQUFGLENBQ0ksQ0FBQyxJQURMLENBQ1UsTUFEVixFQUNrQixVQURsQixDQUVJLENBQUMsSUFGTCxDQUVVLFFBRlYsRUFFb0IsUUFGcEIsRUFIVztBQUFBLENBWmYsQ0FBQTs7QUFBQSxPQW1CTyxDQUFDLEtBQVIsR0FBZ0IsU0FBQSxHQUFBO0FBQ1osRUFBQSxhQUFBLENBQUEsQ0FBQSxDQUFBO1NBQ0EsWUFBQSxDQUFBLEVBRlk7QUFBQSxDQW5CaEIsQ0FBQSIsInNvdXJjZXNDb250ZW50IjpbIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dGhyb3cgbmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKX12YXIgZj1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwoZi5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxmLGYuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIiwiXG4kIC0+XG4gICAgY29uc29sZS5sb2cgJ0hlbGxvIGZyb20gaG9tZSEnXG4gICAgcmVxdWlyZSgnLi4vc2hhcmUtYnV0dG9ucycpLnNldHVwKClcbiAgICByZXF1aXJlKCcuL3NlZWQtY2Fyb3VzZWwnKS5zZXR1cCgpIiwiXG55b3V0dWJlSWRUb1VybCA9IChpZCkgLT5cbiAgICBcIi8vd3d3LnlvdXR1YmUuY29tL2VtYmVkLyN7aWR9P2F1dG9wbGF5PTEmc2hvd2luZm89MCZtb2Rlc3RicmFuZGluZz0xJmNvbnRyb2xzPTEmcmVsPTBcIlxuXG5vcGVuVmlkZW8gPSAodGl0bGUsIHlvdXR1YmVJZCkgLT5cbiAgICBtb2RhbCA9ICQgJyNzdG9yeS1tb2RhbCdcbiAgICBtb2RhbC5maW5kKCcjc3RvcnktbW9kYWwtdGl0bGUnKS50ZXh0IHRpdGxlXG4gICAgbW9kYWwuZmluZCgnaWZyYW1lJykuYXR0ciAnc3JjJywgeW91dHViZUlkVG9VcmwoeW91dHViZUlkKVxuICAgIG1vZGFsLm1vZGFsICdzaG93J1xuXG5jbG9zZVZpZGVvID0gLT4gXG4gICAgbW9kYWwgPSAkICcjc3RvcnktbW9kYWwnXG4gICAgbW9kYWwuZmluZCgnaWZyYW1lJykuYXR0ciAnc3JjJywgJydcblxuZXhwb3J0cy5zZXR1cCA9IC0+XG5cbiAgICAkKCcjc3RvcnktY2Fyb3VzZWwnKS5maW5kICdhJ1xuICAgICAgICAuY3NzICdjdXJzb3InLCAncG9pbnRlcidcbiAgICAgICAgLmNsaWNrIC0+IG9wZW5WaWRlbyAnU29tZSBzdG9yeScsICQodGhpcykuYXR0cignZGF0YS15b3V0dWJlLWlkJylcblxuICAgICQoJyNzdG9yeS1tb2RhbCcpLm9uICdoaWRlLmJzLm1vZGFsJywgKGUpIC0+XG4gICAgICAgIGNsb3NlVmlkZW8oKVxuXG4gICAgcmV0dXJuXG4iLCJcbnNpdGVVcmwgPSAnaHR0cDovL3d3dy50aGFuay1hLXRlYWNoZXIub3JnJ1xuXG5zZXR1cEZhY2Vib29rID0gLT5cbiAgICAkLmdldFNjcmlwdCAnLy9jb25uZWN0LmZhY2Vib29rLm5ldC9lbl9VSy9hbGwuanMnLCAtPlxuICAgICAgICBGQi5pbml0IHthcHBJZDogJzE0NDQ5NTQ2ODU3MzUxNzYnfVxuXG4gICAgJCgnI3NoYXJlLWZhY2Vib29rJykuY2xpY2sgLT5cbiAgICAgICAgRkIudWlcbiAgICAgICAgICAgIG1ldGhvZDogJ2ZlZWQnLFxuICAgICAgICAgICAgbGluazogc2l0ZVVybCxcbiAgICAgICAgICAgIGNhcHRpb246ICdUaGFuayBhIHRlYWNoZXIhJ1xuXG5zZXR1cFR3aXR0ZXIgPSAtPlxuICAgIGVuY29kZWQgPSBlbmNvZGVVUklDb21wb25lbnQgc2l0ZVVybFxuICAgIHR3aXR0ZXJVcmwgPSBcImh0dHBzOi8vdHdpdHRlci5jb20vc2hhcmU/dXJsPSN7ZW5jb2RlZH0mdmlhPXdtbWVkdVwiXG4gICAgJCgnI3NoYXJlLXR3aXR0ZXInKVxuICAgICAgICAuYXR0ciAnaHJlZicsIHR3aXR0ZXJVcmxcbiAgICAgICAgLmF0dHIgJ3RhcmdldCcsICdfYmxhbmsnXG5cbmV4cG9ydHMuc2V0dXAgPSAtPlxuICAgIHNldHVwRmFjZWJvb2soKVxuICAgIHNldHVwVHdpdHRlcigpXG4gICAgIl19
