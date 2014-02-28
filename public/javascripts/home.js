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
    return openVideo('Some story', $(this).attr('data-youtube-id'));
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsIi9Vc2Vycy9KdWxpYW5hL0RvY3VtZW50cy9yZXBvcy9zdG9yaWVzLmVkdS9jbGllbnQvanMvaG9tZS9pbmRleC5jb2ZmZWUiLCIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvY2xpZW50L2pzL2hvbWUvc2VlZC1jYXJvdXNlbC5jb2ZmZWUiLCIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvY2xpZW50L2pzL3NoYXJlLWJ1dHRvbnMuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQ0EsQ0FBQSxDQUFFLFNBQUEsR0FBQTtBQUNFLEVBQUEsT0FBTyxDQUFDLEdBQVIsQ0FBWSxrQkFBWixDQUFBLENBQUE7QUFBQSxFQUNBLE9BQUEsQ0FBUSxrQkFBUixDQUEyQixDQUFDLEtBQTVCLENBQUEsQ0FEQSxDQUFBO1NBRUEsT0FBQSxDQUFRLGlCQUFSLENBQTBCLENBQUMsS0FBM0IsQ0FBQSxFQUhGO0FBQUEsQ0FBRixDQUFBLENBQUE7Ozs7QUNBQSxJQUFBLHlCQUFBOztBQUFBLGNBQUEsR0FBaUIsU0FBQyxFQUFELEdBQUE7U0FDWiwwQkFBQSxHQUF5QixFQUF6QixHQUE2QiwwQ0FEakI7QUFBQSxDQUFqQixDQUFBOztBQUFBLFNBR0EsR0FBWSxTQUFDLEtBQUQsRUFBUSxTQUFSLEdBQUE7QUFDUixNQUFBLEtBQUE7QUFBQSxFQUFBLEtBQUEsR0FBUSxDQUFBLENBQUUsY0FBRixDQUFSLENBQUE7QUFBQSxFQUNBLEtBQUssQ0FBQyxJQUFOLENBQVcsb0JBQVgsQ0FBZ0MsQ0FBQyxJQUFqQyxDQUFzQyxLQUF0QyxDQURBLENBQUE7QUFBQSxFQUVBLEtBQUssQ0FBQyxJQUFOLENBQVcsUUFBWCxDQUFvQixDQUFDLElBQXJCLENBQTBCLEtBQTFCLEVBQWlDLGNBQUEsQ0FBZSxTQUFmLENBQWpDLENBRkEsQ0FBQTtTQUdBLEtBQUssQ0FBQyxLQUFOLENBQVksTUFBWixFQUpRO0FBQUEsQ0FIWixDQUFBOztBQUFBLE9BU08sQ0FBQyxLQUFSLEdBQWdCLFNBQUEsR0FBQTtTQUNaLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLElBQXJCLENBQTBCLEdBQTFCLENBQ0ksQ0FBQyxHQURMLENBQ1MsUUFEVCxFQUNtQixTQURuQixDQUVJLENBQUMsS0FGTCxDQUVXLFNBQUEsR0FBQTtXQUFHLFNBQUEsQ0FBVSxZQUFWLEVBQXdCLENBQUEsQ0FBRSxJQUFGLENBQU8sQ0FBQyxJQUFSLENBQWEsaUJBQWIsQ0FBeEIsRUFBSDtFQUFBLENBRlgsRUFEWTtBQUFBLENBVGhCLENBQUE7Ozs7QUNBQSxJQUFBLG9DQUFBOztBQUFBLE9BQUEsR0FBVSxnQ0FBVixDQUFBOztBQUFBLGFBRUEsR0FBZ0IsU0FBQSxHQUFBO0FBQ1osRUFBQSxDQUFDLENBQUMsU0FBRixDQUFZLHFDQUFaLEVBQW1ELFNBQUEsR0FBQTtXQUMvQyxFQUFFLENBQUMsSUFBSCxDQUFRO0FBQUEsTUFBQyxLQUFBLEVBQU8sa0JBQVI7S0FBUixFQUQrQztFQUFBLENBQW5ELENBQUEsQ0FBQTtTQUdBLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLEtBQXJCLENBQTJCLFNBQUEsR0FBQTtXQUN2QixFQUFFLENBQUMsRUFBSCxDQUNJO0FBQUEsTUFBQSxNQUFBLEVBQVEsTUFBUjtBQUFBLE1BQ0EsSUFBQSxFQUFNLE9BRE47QUFBQSxNQUVBLE9BQUEsRUFBUyxrQkFGVDtLQURKLEVBRHVCO0VBQUEsQ0FBM0IsRUFKWTtBQUFBLENBRmhCLENBQUE7O0FBQUEsWUFZQSxHQUFlLFNBQUEsR0FBQTtBQUNYLE1BQUEsbUJBQUE7QUFBQSxFQUFBLE9BQUEsR0FBVSxrQkFBQSxDQUFtQixPQUFuQixDQUFWLENBQUE7QUFBQSxFQUNBLFVBQUEsR0FBYyxnQ0FBQSxHQUErQixPQUEvQixHQUF3QyxhQUR0RCxDQUFBO1NBRUEsQ0FBQSxDQUFFLGdCQUFGLENBQ0ksQ0FBQyxJQURMLENBQ1UsTUFEVixFQUNrQixVQURsQixDQUVJLENBQUMsSUFGTCxDQUVVLFFBRlYsRUFFb0IsUUFGcEIsRUFIVztBQUFBLENBWmYsQ0FBQTs7QUFBQSxPQW1CTyxDQUFDLEtBQVIsR0FBZ0IsU0FBQSxHQUFBO0FBQ1osRUFBQSxhQUFBLENBQUEsQ0FBQSxDQUFBO1NBQ0EsWUFBQSxDQUFBLEVBRlk7QUFBQSxDQW5CaEIsQ0FBQSIsInNvdXJjZXNDb250ZW50IjpbIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dGhyb3cgbmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKX12YXIgZj1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwoZi5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxmLGYuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIiwiXG4kIC0+XG4gICAgY29uc29sZS5sb2cgJ0hlbGxvIGZyb20gaG9tZSEnXG4gICAgcmVxdWlyZSgnLi4vc2hhcmUtYnV0dG9ucycpLnNldHVwKClcbiAgICByZXF1aXJlKCcuL3NlZWQtY2Fyb3VzZWwnKS5zZXR1cCgpIiwiXG55b3V0dWJlSWRUb1VybCA9IChpZCkgLT5cbiAgICBcIi8vd3d3LnlvdXR1YmUuY29tL2VtYmVkLyN7aWR9P3Nob3dpbmZvPTAmbW9kZXN0YnJhbmRpbmc9MSZjb250cm9scz0xXCJcblxub3BlblZpZGVvID0gKHRpdGxlLCB5b3V0dWJlSWQpIC0+XG4gICAgbW9kYWwgPSAkICcjc3RvcnktbW9kYWwnXG4gICAgbW9kYWwuZmluZCgnI3N0b3J5LW1vZGFsLXRpdGxlJykudGV4dCB0aXRsZVxuICAgIG1vZGFsLmZpbmQoJ2lmcmFtZScpLmF0dHIgJ3NyYycsIHlvdXR1YmVJZFRvVXJsKHlvdXR1YmVJZClcbiAgICBtb2RhbC5tb2RhbCAnc2hvdydcblxuZXhwb3J0cy5zZXR1cCA9IC0+XG4gICAgJCgnI3N0b3J5LWNhcm91c2VsJykuZmluZCAnYSdcbiAgICAgICAgLmNzcyAnY3Vyc29yJywgJ3BvaW50ZXInXG4gICAgICAgIC5jbGljayAtPiBvcGVuVmlkZW8gJ1NvbWUgc3RvcnknLCAkKHRoaXMpLmF0dHIoJ2RhdGEteW91dHViZS1pZCcpIiwiXG5zaXRlVXJsID0gJ2h0dHA6Ly93d3cudGhhbmstYS10ZWFjaGVyLm9yZydcblxuc2V0dXBGYWNlYm9vayA9IC0+XG4gICAgJC5nZXRTY3JpcHQgJy8vY29ubmVjdC5mYWNlYm9vay5uZXQvZW5fVUsvYWxsLmpzJywgLT5cbiAgICAgICAgRkIuaW5pdCB7YXBwSWQ6ICcxNDQ0OTU0Njg1NzM1MTc2J31cblxuICAgICQoJyNzaGFyZS1mYWNlYm9vaycpLmNsaWNrIC0+XG4gICAgICAgIEZCLnVpXG4gICAgICAgICAgICBtZXRob2Q6ICdmZWVkJyxcbiAgICAgICAgICAgIGxpbms6IHNpdGVVcmwsXG4gICAgICAgICAgICBjYXB0aW9uOiAnVGhhbmsgYSB0ZWFjaGVyISdcblxuc2V0dXBUd2l0dGVyID0gLT5cbiAgICBlbmNvZGVkID0gZW5jb2RlVVJJQ29tcG9uZW50IHNpdGVVcmxcbiAgICB0d2l0dGVyVXJsID0gXCJodHRwczovL3R3aXR0ZXIuY29tL3NoYXJlP3VybD0je2VuY29kZWR9JnZpYT13bW1lZHVcIlxuICAgICQoJyNzaGFyZS10d2l0dGVyJylcbiAgICAgICAgLmF0dHIgJ2hyZWYnLCB0d2l0dGVyVXJsXG4gICAgICAgIC5hdHRyICd0YXJnZXQnLCAnX2JsYW5rJ1xuXG5leHBvcnRzLnNldHVwID0gLT5cbiAgICBzZXR1cEZhY2Vib29rKClcbiAgICBzZXR1cFR3aXR0ZXIoKVxuICAgICJdfQ==
