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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsIi9Vc2Vycy9KdWxpYW5hL0RvY3VtZW50cy9yZXBvcy9zdG9yaWVzLmVkdS9jbGllbnQvanMvaG9tZS9pbmRleC5jb2ZmZWUiLCIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvY2xpZW50L2pzL2hvbWUvc2VlZC1jYXJvdXNlbC5jb2ZmZWUiLCIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvY2xpZW50L2pzL3NoYXJlLWJ1dHRvbnMuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQ0EsQ0FBQSxDQUFFLFNBQUEsR0FBQTtBQUNFLEVBQUEsT0FBTyxDQUFDLEdBQVIsQ0FBWSxrQkFBWixDQUFBLENBQUE7QUFBQSxFQUNBLE9BQUEsQ0FBUSxrQkFBUixDQUEyQixDQUFDLEtBQTVCLENBQUEsQ0FEQSxDQUFBO1NBRUEsT0FBQSxDQUFRLGlCQUFSLENBQTBCLENBQUMsS0FBM0IsQ0FBQSxFQUhGO0FBQUEsQ0FBRixDQUFBLENBQUE7Ozs7QUNBQSxJQUFBLHFDQUFBOztBQUFBLGNBQUEsR0FBaUIsU0FBQyxFQUFELEdBQUE7U0FDWiwwQkFBQSxHQUF5QixFQUF6QixHQUE2QiwyREFEakI7QUFBQSxDQUFqQixDQUFBOztBQUFBLFNBR0EsR0FBWSxTQUFDLEtBQUQsRUFBUSxTQUFSLEdBQUE7QUFDUixNQUFBLEtBQUE7QUFBQSxFQUFBLEtBQUEsR0FBUSxDQUFBLENBQUUsY0FBRixDQUFSLENBQUE7QUFBQSxFQUNBLEtBQUssQ0FBQyxJQUFOLENBQVcsb0JBQVgsQ0FBZ0MsQ0FBQyxJQUFqQyxDQUFzQyxLQUF0QyxDQURBLENBQUE7QUFBQSxFQUVBLEtBQUssQ0FBQyxJQUFOLENBQVcsUUFBWCxDQUFvQixDQUFDLElBQXJCLENBQTBCLEtBQTFCLEVBQWlDLGNBQUEsQ0FBZSxTQUFmLENBQWpDLENBRkEsQ0FBQTtTQUdBLEtBQUssQ0FBQyxLQUFOLENBQVksTUFBWixFQUpRO0FBQUEsQ0FIWixDQUFBOztBQUFBLFVBU0EsR0FBYSxTQUFBLEdBQUE7QUFDVCxNQUFBLEtBQUE7QUFBQSxFQUFBLEtBQUEsR0FBUSxDQUFBLENBQUUsY0FBRixDQUFSLENBQUE7U0FDQSxLQUFLLENBQUMsSUFBTixDQUFXLFFBQVgsQ0FBb0IsQ0FBQyxJQUFyQixDQUEwQixLQUExQixFQUFpQyxFQUFqQyxFQUZTO0FBQUEsQ0FUYixDQUFBOztBQUFBLE9BYU8sQ0FBQyxLQUFSLEdBQWdCLFNBQUEsR0FBQTtBQUVaLEVBQUEsQ0FBQSxDQUFFLGlCQUFGLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsR0FBMUIsQ0FDSSxDQUFDLEdBREwsQ0FDUyxRQURULEVBQ21CLFNBRG5CLENBRUksQ0FBQyxLQUZMLENBRVcsU0FBQSxHQUFBO1dBQUcsU0FBQSxDQUFVLFlBQVYsRUFBd0IsQ0FBQSxDQUFFLElBQUYsQ0FBTyxDQUFDLElBQVIsQ0FBYSxpQkFBYixDQUF4QixFQUFIO0VBQUEsQ0FGWCxDQUFBLENBQUE7QUFBQSxFQUlBLENBQUEsQ0FBRSxjQUFGLENBQWlCLENBQUMsRUFBbEIsQ0FBcUIsZUFBckIsRUFBc0MsU0FBQyxDQUFELEdBQUE7V0FDbEMsVUFBQSxDQUFBLEVBRGtDO0VBQUEsQ0FBdEMsQ0FKQSxDQUZZO0FBQUEsQ0FiaEIsQ0FBQTs7OztBQ0FBLElBQUEsb0NBQUE7O0FBQUEsT0FBQSxHQUFVLGdDQUFWLENBQUE7O0FBQUEsYUFFQSxHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLENBQUMsQ0FBQyxTQUFGLENBQVkscUNBQVosRUFBbUQsU0FBQSxHQUFBO1dBQy9DLEVBQUUsQ0FBQyxJQUFILENBQVE7QUFBQSxNQUFDLEtBQUEsRUFBTyxrQkFBUjtLQUFSLEVBRCtDO0VBQUEsQ0FBbkQsQ0FBQSxDQUFBO1NBR0EsQ0FBQSxDQUFFLGlCQUFGLENBQW9CLENBQUMsS0FBckIsQ0FBMkIsU0FBQSxHQUFBO1dBQ3ZCLEVBQUUsQ0FBQyxFQUFILENBQ0k7QUFBQSxNQUFBLE1BQUEsRUFBUSxNQUFSO0FBQUEsTUFDQSxJQUFBLEVBQU0sT0FETjtBQUFBLE1BRUEsT0FBQSxFQUFTLGtCQUZUO0tBREosRUFEdUI7RUFBQSxDQUEzQixFQUpZO0FBQUEsQ0FGaEIsQ0FBQTs7QUFBQSxZQVlBLEdBQWUsU0FBQSxHQUFBO0FBQ1gsTUFBQSxtQkFBQTtBQUFBLEVBQUEsT0FBQSxHQUFVLGtCQUFBLENBQW1CLE9BQW5CLENBQVYsQ0FBQTtBQUFBLEVBQ0EsVUFBQSxHQUFjLGdDQUFBLEdBQStCLE9BQS9CLEdBQXdDLGFBRHRELENBQUE7U0FFQSxDQUFBLENBQUUsZ0JBQUYsQ0FDSSxDQUFDLElBREwsQ0FDVSxNQURWLEVBQ2tCLFVBRGxCLENBRUksQ0FBQyxJQUZMLENBRVUsUUFGVixFQUVvQixRQUZwQixFQUhXO0FBQUEsQ0FaZixDQUFBOztBQUFBLE9BbUJPLENBQUMsS0FBUixHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLGFBQUEsQ0FBQSxDQUFBLENBQUE7U0FDQSxZQUFBLENBQUEsRUFGWTtBQUFBLENBbkJoQixDQUFBIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt0aHJvdyBuZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpfXZhciBmPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChmLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGYsZi5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJcbiQgLT5cbiAgICBjb25zb2xlLmxvZyAnSGVsbG8gZnJvbSBob21lISdcbiAgICByZXF1aXJlKCcuLi9zaGFyZS1idXR0b25zJykuc2V0dXAoKVxuICAgIHJlcXVpcmUoJy4vc2VlZC1jYXJvdXNlbCcpLnNldHVwKCkiLCJcbnlvdXR1YmVJZFRvVXJsID0gKGlkKSAtPlxuICAgIFwiLy93d3cueW91dHViZS5jb20vZW1iZWQvI3tpZH0/YXV0b3BsYXk9MSZzaG93aW5mbz0wJm1vZGVzdGJyYW5kaW5nPTEmY29udHJvbHM9MSZyZWw9MFwiXG5cbm9wZW5WaWRlbyA9ICh0aXRsZSwgeW91dHViZUlkKSAtPlxuICAgIG1vZGFsID0gJCAnI3N0b3J5LW1vZGFsJ1xuICAgIG1vZGFsLmZpbmQoJyNzdG9yeS1tb2RhbC10aXRsZScpLnRleHQgdGl0bGVcbiAgICBtb2RhbC5maW5kKCdpZnJhbWUnKS5hdHRyICdzcmMnLCB5b3V0dWJlSWRUb1VybCh5b3V0dWJlSWQpXG4gICAgbW9kYWwubW9kYWwgJ3Nob3cnXG5cbmNsb3NlVmlkZW8gPSAtPiBcbiAgICBtb2RhbCA9ICQgJyNzdG9yeS1tb2RhbCdcbiAgICBtb2RhbC5maW5kKCdpZnJhbWUnKS5hdHRyICdzcmMnLCAnJ1xuXG5leHBvcnRzLnNldHVwID0gLT5cblxuICAgICQoJyNzdG9yeS1jYXJvdXNlbCcpLmZpbmQgJ2EnXG4gICAgICAgIC5jc3MgJ2N1cnNvcicsICdwb2ludGVyJ1xuICAgICAgICAuY2xpY2sgLT4gb3BlblZpZGVvICdTb21lIHN0b3J5JywgJCh0aGlzKS5hdHRyKCdkYXRhLXlvdXR1YmUtaWQnKVxuXG4gICAgJCgnI3N0b3J5LW1vZGFsJykub24gJ2hpZGUuYnMubW9kYWwnLCAoZSkgLT5cbiAgICAgICAgY2xvc2VWaWRlbygpXG5cbiAgICByZXR1cm5cbiIsIlxuc2l0ZVVybCA9ICdodHRwOi8vd3d3LnRoYW5rLWEtdGVhY2hlci5vcmcnXG5cbnNldHVwRmFjZWJvb2sgPSAtPlxuICAgICQuZ2V0U2NyaXB0ICcvL2Nvbm5lY3QuZmFjZWJvb2submV0L2VuX1VLL2FsbC5qcycsIC0+XG4gICAgICAgIEZCLmluaXQge2FwcElkOiAnMTQ0NDk1NDY4NTczNTE3Nid9XG5cbiAgICAkKCcjc2hhcmUtZmFjZWJvb2snKS5jbGljayAtPlxuICAgICAgICBGQi51aVxuICAgICAgICAgICAgbWV0aG9kOiAnZmVlZCcsXG4gICAgICAgICAgICBsaW5rOiBzaXRlVXJsLFxuICAgICAgICAgICAgY2FwdGlvbjogJ1RoYW5rIGEgdGVhY2hlciEnXG5cbnNldHVwVHdpdHRlciA9IC0+XG4gICAgZW5jb2RlZCA9IGVuY29kZVVSSUNvbXBvbmVudCBzaXRlVXJsXG4gICAgdHdpdHRlclVybCA9IFwiaHR0cHM6Ly90d2l0dGVyLmNvbS9zaGFyZT91cmw9I3tlbmNvZGVkfSZ2aWE9d21tZWR1XCJcbiAgICAkKCcjc2hhcmUtdHdpdHRlcicpXG4gICAgICAgIC5hdHRyICdocmVmJywgdHdpdHRlclVybFxuICAgICAgICAuYXR0ciAndGFyZ2V0JywgJ19ibGFuaydcblxuZXhwb3J0cy5zZXR1cCA9IC0+XG4gICAgc2V0dXBGYWNlYm9vaygpXG4gICAgc2V0dXBUd2l0dGVyKClcbiAgICAiXX0=
