(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
$(function() {
  console.log('Hello from home!');
  require('../share-buttons').setup();
  return require('./seed-carousel').setup();
});


},{"../share-buttons":3,"./seed-carousel":2}],2:[function(require,module,exports){
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

exports.setup = function() {
  return $('#story-carousel').find('a').css('cursor', 'pointer').click(function() {
    return openVideo('Some story', '5-MZAXKk7Bw');
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyJDOlxcVXNlcnNcXENoYXNlXFxEcm9wYm94XFxEZXZcXHN0b3JpZXMuZWR1XFxub2RlX21vZHVsZXNcXGJyb3dzZXJpZnlcXG5vZGVfbW9kdWxlc1xcYnJvd3Nlci1wYWNrXFxfcHJlbHVkZS5qcyIsIkM6XFxVc2Vyc1xcQ2hhc2VcXERyb3Bib3hcXERldlxcc3Rvcmllcy5lZHVcXGNsaWVudFxcanNcXGhvbWVcXGluZGV4LmNvZmZlZSIsIkM6XFxVc2Vyc1xcQ2hhc2VcXERyb3Bib3hcXERldlxcc3Rvcmllcy5lZHVcXGNsaWVudFxcanNcXGhvbWVcXHNlZWQtY2Fyb3VzZWwuY29mZmVlIiwiQzpcXFVzZXJzXFxDaGFzZVxcRHJvcGJveFxcRGV2XFxzdG9yaWVzLmVkdVxcY2xpZW50XFxqc1xcc2hhcmUtYnV0dG9ucy5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUNDQSxDQUFBLENBQUUsU0FBQSxHQUFBO0FBQ0UsRUFBQSxPQUFPLENBQUMsR0FBUixDQUFZLGtCQUFaLENBQUEsQ0FBQTtBQUFBLEVBQ0EsT0FBQSxDQUFRLGtCQUFSLENBQTJCLENBQUMsS0FBNUIsQ0FBQSxDQURBLENBQUE7U0FFQSxPQUFBLENBQVEsaUJBQVIsQ0FBMEIsQ0FBQyxLQUEzQixDQUFBLEVBSEY7QUFBQSxDQUFGLENBQUEsQ0FBQTs7OztBQ0FBLElBQUEseUJBQUE7O0FBQUEsY0FBQSxHQUFpQixTQUFDLEVBQUQsR0FBQTtTQUNaLDBCQUFBLEdBQXlCLEVBQXpCLEdBQTZCLDBDQURqQjtBQUFBLENBQWpCLENBQUE7O0FBQUEsU0FHQSxHQUFZLFNBQUMsS0FBRCxFQUFRLFNBQVIsR0FBQTtBQUNSLE1BQUEsS0FBQTtBQUFBLEVBQUEsS0FBQSxHQUFRLENBQUEsQ0FBRSxjQUFGLENBQVIsQ0FBQTtBQUFBLEVBQ0EsS0FBSyxDQUFDLElBQU4sQ0FBVyxvQkFBWCxDQUFnQyxDQUFDLElBQWpDLENBQXNDLEtBQXRDLENBREEsQ0FBQTtBQUFBLEVBRUEsS0FBSyxDQUFDLElBQU4sQ0FBVyxRQUFYLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsS0FBMUIsRUFBaUMsY0FBQSxDQUFlLFNBQWYsQ0FBakMsQ0FGQSxDQUFBO1NBR0EsS0FBSyxDQUFDLEtBQU4sQ0FBWSxNQUFaLEVBSlE7QUFBQSxDQUhaLENBQUE7O0FBQUEsT0FTTyxDQUFDLEtBQVIsR0FBZ0IsU0FBQSxHQUFBO1NBQ1osQ0FBQSxDQUFFLGlCQUFGLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsR0FBMUIsQ0FDSSxDQUFDLEdBREwsQ0FDUyxRQURULEVBQ21CLFNBRG5CLENBRUksQ0FBQyxLQUZMLENBRVcsU0FBQSxHQUFBO1dBQUcsU0FBQSxDQUFVLFlBQVYsRUFBd0IsYUFBeEIsRUFBSDtFQUFBLENBRlgsRUFEWTtBQUFBLENBVGhCLENBQUE7Ozs7QUNBQSxJQUFBLG9DQUFBOztBQUFBLE9BQUEsR0FBVSxnQ0FBVixDQUFBOztBQUFBLGFBRUEsR0FBZ0IsU0FBQSxHQUFBO0FBQ1osRUFBQSxDQUFDLENBQUMsU0FBRixDQUFZLHFDQUFaLEVBQW1ELFNBQUEsR0FBQTtXQUMvQyxFQUFFLENBQUMsSUFBSCxDQUFRO0FBQUEsTUFBQyxLQUFBLEVBQU8sa0JBQVI7S0FBUixFQUQrQztFQUFBLENBQW5ELENBQUEsQ0FBQTtTQUdBLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLEtBQXJCLENBQTJCLFNBQUEsR0FBQTtXQUN2QixFQUFFLENBQUMsRUFBSCxDQUNJO0FBQUEsTUFBQSxNQUFBLEVBQVEsTUFBUjtBQUFBLE1BQ0EsSUFBQSxFQUFNLE9BRE47QUFBQSxNQUVBLE9BQUEsRUFBUyxrQkFGVDtLQURKLEVBRHVCO0VBQUEsQ0FBM0IsRUFKWTtBQUFBLENBRmhCLENBQUE7O0FBQUEsWUFZQSxHQUFlLFNBQUEsR0FBQTtBQUNYLE1BQUEsbUJBQUE7QUFBQSxFQUFBLE9BQUEsR0FBVSxrQkFBQSxDQUFtQixPQUFuQixDQUFWLENBQUE7QUFBQSxFQUNBLFVBQUEsR0FBYyxnQ0FBQSxHQUErQixPQUEvQixHQUF3QyxhQUR0RCxDQUFBO1NBRUEsQ0FBQSxDQUFFLGdCQUFGLENBQ0ksQ0FBQyxJQURMLENBQ1UsTUFEVixFQUNrQixVQURsQixDQUVJLENBQUMsSUFGTCxDQUVVLFFBRlYsRUFFb0IsUUFGcEIsRUFIVztBQUFBLENBWmYsQ0FBQTs7QUFBQSxPQW1CTyxDQUFDLEtBQVIsR0FBZ0IsU0FBQSxHQUFBO0FBQ1osRUFBQSxhQUFBLENBQUEsQ0FBQSxDQUFBO1NBQ0EsWUFBQSxDQUFBLEVBRlk7QUFBQSxDQW5CaEIsQ0FBQSIsInNvdXJjZXNDb250ZW50IjpbIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dGhyb3cgbmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKX12YXIgZj1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwoZi5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxmLGYuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIiwiXHJcbiQgLT5cclxuICAgIGNvbnNvbGUubG9nICdIZWxsbyBmcm9tIGhvbWUhJ1xyXG4gICAgcmVxdWlyZSgnLi4vc2hhcmUtYnV0dG9ucycpLnNldHVwKClcclxuICAgIHJlcXVpcmUoJy4vc2VlZC1jYXJvdXNlbCcpLnNldHVwKCkiLCJcclxueW91dHViZUlkVG9VcmwgPSAoaWQpIC0+XHJcbiAgICBcIi8vd3d3LnlvdXR1YmUuY29tL2VtYmVkLyN7aWR9P3Nob3dpbmZvPTAmbW9kZXN0YnJhbmRpbmc9MSZjb250cm9scz0xXCJcclxuXHJcbm9wZW5WaWRlbyA9ICh0aXRsZSwgeW91dHViZUlkKSAtPlxyXG4gICAgbW9kYWwgPSAkICcjc3RvcnktbW9kYWwnXHJcbiAgICBtb2RhbC5maW5kKCcjc3RvcnktbW9kYWwtdGl0bGUnKS50ZXh0IHRpdGxlXHJcbiAgICBtb2RhbC5maW5kKCdpZnJhbWUnKS5hdHRyICdzcmMnLCB5b3V0dWJlSWRUb1VybCh5b3V0dWJlSWQpXHJcbiAgICBtb2RhbC5tb2RhbCAnc2hvdydcclxuXHJcbmV4cG9ydHMuc2V0dXAgPSAtPlxyXG4gICAgJCgnI3N0b3J5LWNhcm91c2VsJykuZmluZCAnYSdcclxuICAgICAgICAuY3NzICdjdXJzb3InLCAncG9pbnRlcidcclxuICAgICAgICAuY2xpY2sgLT4gb3BlblZpZGVvICdTb21lIHN0b3J5JywgJzUtTVpBWEtrN0J3JyIsIlxyXG5zaXRlVXJsID0gJ2h0dHA6Ly93d3cudGhhbmstYS10ZWFjaGVyLm9yZydcclxuXHJcbnNldHVwRmFjZWJvb2sgPSAtPlxyXG4gICAgJC5nZXRTY3JpcHQgJy8vY29ubmVjdC5mYWNlYm9vay5uZXQvZW5fVUsvYWxsLmpzJywgLT5cclxuICAgICAgICBGQi5pbml0IHthcHBJZDogJzE0NDQ5NTQ2ODU3MzUxNzYnfVxyXG5cclxuICAgICQoJyNzaGFyZS1mYWNlYm9vaycpLmNsaWNrIC0+XHJcbiAgICAgICAgRkIudWlcclxuICAgICAgICAgICAgbWV0aG9kOiAnZmVlZCcsXHJcbiAgICAgICAgICAgIGxpbms6IHNpdGVVcmwsXHJcbiAgICAgICAgICAgIGNhcHRpb246ICdUaGFuayBhIHRlYWNoZXIhJ1xyXG5cclxuc2V0dXBUd2l0dGVyID0gLT5cclxuICAgIGVuY29kZWQgPSBlbmNvZGVVUklDb21wb25lbnQgc2l0ZVVybFxyXG4gICAgdHdpdHRlclVybCA9IFwiaHR0cHM6Ly90d2l0dGVyLmNvbS9zaGFyZT91cmw9I3tlbmNvZGVkfSZ2aWE9d21tZWR1XCJcclxuICAgICQoJyNzaGFyZS10d2l0dGVyJylcclxuICAgICAgICAuYXR0ciAnaHJlZicsIHR3aXR0ZXJVcmxcclxuICAgICAgICAuYXR0ciAndGFyZ2V0JywgJ19ibGFuaydcclxuXHJcbmV4cG9ydHMuc2V0dXAgPSAtPlxyXG4gICAgc2V0dXBGYWNlYm9vaygpXHJcbiAgICBzZXR1cFR3aXR0ZXIoKVxyXG4gICAgIl19
