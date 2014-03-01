(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
$(function() {
  console.log('Hello from home!');
  require('../share-buttons').setup();
  return require('./seed-carousel').setup();
});


},{"../share-buttons":3,"./seed-carousel":2}],2:[function(require,module,exports){
var closeVideo, openVideo, youtubeIdToUrl;

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

closeVideo = function() {
  var modal;
  modal = $('#story-modal');
  return modal.find('iframe').attr('src', '');
};

exports.setup = function() {
  $('#story-carousel').find('a').css('cursor', 'pointer').click(function() {
    return openVideo('Some story', $(this).attr('data-youtube-id'));
  });
  return $('.close').click(function() {
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvaG9tZS9tbWF5L3N0b3JpZXMuZWR1L25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvaG9tZS9tbWF5L3N0b3JpZXMuZWR1L2NsaWVudC9qcy9ob21lL2luZGV4LmNvZmZlZSIsIi9ob21lL21tYXkvc3Rvcmllcy5lZHUvY2xpZW50L2pzL2hvbWUvc2VlZC1jYXJvdXNlbC5jb2ZmZWUiLCIvaG9tZS9tbWF5L3N0b3JpZXMuZWR1L2NsaWVudC9qcy9zaGFyZS1idXR0b25zLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0NBLENBQUEsQ0FBRSxTQUFBLEdBQUE7QUFDRSxFQUFBLE9BQU8sQ0FBQyxHQUFSLENBQVksa0JBQVosQ0FBQSxDQUFBO0FBQUEsRUFDQSxPQUFBLENBQVEsa0JBQVIsQ0FBMkIsQ0FBQyxLQUE1QixDQUFBLENBREEsQ0FBQTtTQUVBLE9BQUEsQ0FBUSxpQkFBUixDQUEwQixDQUFDLEtBQTNCLENBQUEsRUFIRjtBQUFBLENBQUYsQ0FBQSxDQUFBOzs7O0FDQUEsSUFBQSxxQ0FBQTs7QUFBQSxjQUFBLEdBQWlCLFNBQUMsRUFBRCxHQUFBO1NBQ1osMEJBQUEsR0FBeUIsRUFBekIsR0FBNkIsMENBRGpCO0FBQUEsQ0FBakIsQ0FBQTs7QUFBQSxTQUdBLEdBQVksU0FBQyxLQUFELEVBQVEsU0FBUixHQUFBO0FBQ1IsTUFBQSxLQUFBO0FBQUEsRUFBQSxLQUFBLEdBQVEsQ0FBQSxDQUFFLGNBQUYsQ0FBUixDQUFBO0FBQUEsRUFDQSxLQUFLLENBQUMsSUFBTixDQUFXLG9CQUFYLENBQWdDLENBQUMsSUFBakMsQ0FBc0MsS0FBdEMsQ0FEQSxDQUFBO0FBQUEsRUFFQSxLQUFLLENBQUMsSUFBTixDQUFXLFFBQVgsQ0FBb0IsQ0FBQyxJQUFyQixDQUEwQixLQUExQixFQUFpQyxjQUFBLENBQWUsU0FBZixDQUFqQyxDQUZBLENBQUE7U0FHQSxLQUFLLENBQUMsS0FBTixDQUFZLE1BQVosRUFKUTtBQUFBLENBSFosQ0FBQTs7QUFBQSxVQVNBLEdBQWEsU0FBQSxHQUFBO0FBQ1QsTUFBQSxLQUFBO0FBQUEsRUFBQSxLQUFBLEdBQVEsQ0FBQSxDQUFFLGNBQUYsQ0FBUixDQUFBO1NBQ0EsS0FBSyxDQUFDLElBQU4sQ0FBVyxRQUFYLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsS0FBMUIsRUFBaUMsRUFBakMsRUFGUztBQUFBLENBVGIsQ0FBQTs7QUFBQSxPQWFPLENBQUMsS0FBUixHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLElBQXJCLENBQTBCLEdBQTFCLENBQ0ksQ0FBQyxHQURMLENBQ1MsUUFEVCxFQUNtQixTQURuQixDQUVJLENBQUMsS0FGTCxDQUVXLFNBQUEsR0FBQTtXQUFHLFNBQUEsQ0FBVSxZQUFWLEVBQXdCLENBQUEsQ0FBRSxJQUFGLENBQU8sQ0FBQyxJQUFSLENBQWEsaUJBQWIsQ0FBeEIsRUFBSDtFQUFBLENBRlgsQ0FBQSxDQUFBO1NBSUEsQ0FBQSxDQUFFLFFBQUYsQ0FBVyxDQUFDLEtBQVosQ0FBa0IsU0FBQSxHQUFBO1dBQ2QsVUFBQSxDQUFBLEVBRGM7RUFBQSxDQUFsQixFQUxZO0FBQUEsQ0FiaEIsQ0FBQTs7OztBQ0FBLElBQUEsb0NBQUE7O0FBQUEsT0FBQSxHQUFVLGdDQUFWLENBQUE7O0FBQUEsYUFFQSxHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLENBQUMsQ0FBQyxTQUFGLENBQVkscUNBQVosRUFBbUQsU0FBQSxHQUFBO1dBQy9DLEVBQUUsQ0FBQyxJQUFILENBQVE7QUFBQSxNQUFDLEtBQUEsRUFBTyxrQkFBUjtLQUFSLEVBRCtDO0VBQUEsQ0FBbkQsQ0FBQSxDQUFBO1NBR0EsQ0FBQSxDQUFFLGlCQUFGLENBQW9CLENBQUMsS0FBckIsQ0FBMkIsU0FBQSxHQUFBO1dBQ3ZCLEVBQUUsQ0FBQyxFQUFILENBQ0k7QUFBQSxNQUFBLE1BQUEsRUFBUSxNQUFSO0FBQUEsTUFDQSxJQUFBLEVBQU0sT0FETjtBQUFBLE1BRUEsT0FBQSxFQUFTLGtCQUZUO0tBREosRUFEdUI7RUFBQSxDQUEzQixFQUpZO0FBQUEsQ0FGaEIsQ0FBQTs7QUFBQSxZQVlBLEdBQWUsU0FBQSxHQUFBO0FBQ1gsTUFBQSxtQkFBQTtBQUFBLEVBQUEsT0FBQSxHQUFVLGtCQUFBLENBQW1CLE9BQW5CLENBQVYsQ0FBQTtBQUFBLEVBQ0EsVUFBQSxHQUFjLGdDQUFBLEdBQStCLE9BQS9CLEdBQXdDLGFBRHRELENBQUE7U0FFQSxDQUFBLENBQUUsZ0JBQUYsQ0FDSSxDQUFDLElBREwsQ0FDVSxNQURWLEVBQ2tCLFVBRGxCLENBRUksQ0FBQyxJQUZMLENBRVUsUUFGVixFQUVvQixRQUZwQixFQUhXO0FBQUEsQ0FaZixDQUFBOztBQUFBLE9BbUJPLENBQUMsS0FBUixHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLGFBQUEsQ0FBQSxDQUFBLENBQUE7U0FDQSxZQUFBLENBQUEsRUFGWTtBQUFBLENBbkJoQixDQUFBIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt0aHJvdyBuZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpfXZhciBmPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChmLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGYsZi5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJcbiQgLT5cbiAgICBjb25zb2xlLmxvZyAnSGVsbG8gZnJvbSBob21lISdcbiAgICByZXF1aXJlKCcuLi9zaGFyZS1idXR0b25zJykuc2V0dXAoKVxuICAgIHJlcXVpcmUoJy4vc2VlZC1jYXJvdXNlbCcpLnNldHVwKCkiLCJcbnlvdXR1YmVJZFRvVXJsID0gKGlkKSAtPlxuICAgIFwiLy93d3cueW91dHViZS5jb20vZW1iZWQvI3tpZH0/c2hvd2luZm89MCZtb2Rlc3RicmFuZGluZz0xJmNvbnRyb2xzPTFcIlxuXG5vcGVuVmlkZW8gPSAodGl0bGUsIHlvdXR1YmVJZCkgLT5cbiAgICBtb2RhbCA9ICQgJyNzdG9yeS1tb2RhbCdcbiAgICBtb2RhbC5maW5kKCcjc3RvcnktbW9kYWwtdGl0bGUnKS50ZXh0IHRpdGxlXG4gICAgbW9kYWwuZmluZCgnaWZyYW1lJykuYXR0ciAnc3JjJywgeW91dHViZUlkVG9VcmwoeW91dHViZUlkKVxuICAgIG1vZGFsLm1vZGFsICdzaG93J1xuXG5jbG9zZVZpZGVvID0gLT4gXG4gICAgbW9kYWwgPSAkICcjc3RvcnktbW9kYWwnXG4gICAgbW9kYWwuZmluZCgnaWZyYW1lJykuYXR0ciAnc3JjJywgJydcblxuZXhwb3J0cy5zZXR1cCA9IC0+XG4gICAgJCgnI3N0b3J5LWNhcm91c2VsJykuZmluZCAnYSdcbiAgICAgICAgLmNzcyAnY3Vyc29yJywgJ3BvaW50ZXInXG4gICAgICAgIC5jbGljayAtPiBvcGVuVmlkZW8gJ1NvbWUgc3RvcnknLCAkKHRoaXMpLmF0dHIoJ2RhdGEteW91dHViZS1pZCcpXG5cbiAgICAkKCcuY2xvc2UnKS5jbGljayAtPlxuICAgICAgICBjbG9zZVZpZGVvKCkiLCJcbnNpdGVVcmwgPSAnaHR0cDovL3d3dy50aGFuay1hLXRlYWNoZXIub3JnJ1xuXG5zZXR1cEZhY2Vib29rID0gLT5cbiAgICAkLmdldFNjcmlwdCAnLy9jb25uZWN0LmZhY2Vib29rLm5ldC9lbl9VSy9hbGwuanMnLCAtPlxuICAgICAgICBGQi5pbml0IHthcHBJZDogJzE0NDQ5NTQ2ODU3MzUxNzYnfVxuXG4gICAgJCgnI3NoYXJlLWZhY2Vib29rJykuY2xpY2sgLT5cbiAgICAgICAgRkIudWlcbiAgICAgICAgICAgIG1ldGhvZDogJ2ZlZWQnLFxuICAgICAgICAgICAgbGluazogc2l0ZVVybCxcbiAgICAgICAgICAgIGNhcHRpb246ICdUaGFuayBhIHRlYWNoZXIhJ1xuXG5zZXR1cFR3aXR0ZXIgPSAtPlxuICAgIGVuY29kZWQgPSBlbmNvZGVVUklDb21wb25lbnQgc2l0ZVVybFxuICAgIHR3aXR0ZXJVcmwgPSBcImh0dHBzOi8vdHdpdHRlci5jb20vc2hhcmU/dXJsPSN7ZW5jb2RlZH0mdmlhPXdtbWVkdVwiXG4gICAgJCgnI3NoYXJlLXR3aXR0ZXInKVxuICAgICAgICAuYXR0ciAnaHJlZicsIHR3aXR0ZXJVcmxcbiAgICAgICAgLmF0dHIgJ3RhcmdldCcsICdfYmxhbmsnXG5cbmV4cG9ydHMuc2V0dXAgPSAtPlxuICAgIHNldHVwRmFjZWJvb2soKVxuICAgIHNldHVwVHdpdHRlcigpXG4gICAgIl19
