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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyJDOlxcVXNlcnNcXENoYXNlXFxEcm9wYm94XFxEZXZcXHN0b3JpZXMuZWR1XFxub2RlX21vZHVsZXNcXGJyb3dzZXJpZnlcXG5vZGVfbW9kdWxlc1xcYnJvd3Nlci1wYWNrXFxfcHJlbHVkZS5qcyIsIkM6XFxVc2Vyc1xcQ2hhc2VcXERyb3Bib3hcXERldlxcc3Rvcmllcy5lZHVcXGNsaWVudFxcanNcXGhvbWVcXGluZGV4LmNvZmZlZSIsIkM6XFxVc2Vyc1xcQ2hhc2VcXERyb3Bib3hcXERldlxcc3Rvcmllcy5lZHVcXGNsaWVudFxcanNcXGhvbWVcXHNlZWQtY2Fyb3VzZWwuY29mZmVlIiwiQzpcXFVzZXJzXFxDaGFzZVxcRHJvcGJveFxcRGV2XFxzdG9yaWVzLmVkdVxcY2xpZW50XFxqc1xcc2hhcmUtYnV0dG9ucy5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUNDQSxDQUFBLENBQUUsU0FBQSxHQUFBO0FBQ0UsRUFBQSxPQUFPLENBQUMsR0FBUixDQUFZLGtCQUFaLENBQUEsQ0FBQTtBQUFBLEVBQ0EsT0FBQSxDQUFRLGtCQUFSLENBQTJCLENBQUMsS0FBNUIsQ0FBQSxDQURBLENBQUE7U0FFQSxPQUFBLENBQVEsaUJBQVIsQ0FBMEIsQ0FBQyxLQUEzQixDQUFBLEVBSEY7QUFBQSxDQUFGLENBQUEsQ0FBQTs7OztBQ0FBLElBQUEseUJBQUE7O0FBQUEsY0FBQSxHQUFpQixTQUFDLEVBQUQsR0FBQTtTQUNaLDBCQUFBLEdBQXlCLEVBQXpCLEdBQTZCLDBDQURqQjtBQUFBLENBQWpCLENBQUE7O0FBQUEsU0FHQSxHQUFZLFNBQUMsS0FBRCxFQUFRLFNBQVIsR0FBQTtBQUNSLE1BQUEsS0FBQTtBQUFBLEVBQUEsS0FBQSxHQUFRLENBQUEsQ0FBRSxjQUFGLENBQVIsQ0FBQTtBQUFBLEVBQ0EsS0FBSyxDQUFDLElBQU4sQ0FBVyxvQkFBWCxDQUFnQyxDQUFDLElBQWpDLENBQXNDLEtBQXRDLENBREEsQ0FBQTtBQUFBLEVBRUEsS0FBSyxDQUFDLElBQU4sQ0FBVyxRQUFYLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsS0FBMUIsRUFBaUMsY0FBQSxDQUFlLFNBQWYsQ0FBakMsQ0FGQSxDQUFBO1NBR0EsS0FBSyxDQUFDLEtBQU4sQ0FBWSxNQUFaLEVBSlE7QUFBQSxDQUhaLENBQUE7O0FBQUEsT0FTTyxDQUFDLEtBQVIsR0FBZ0IsU0FBQSxHQUFBO1NBQ1osQ0FBQSxDQUFFLGlCQUFGLENBQW9CLENBQUMsSUFBckIsQ0FBMEIsR0FBMUIsQ0FDSSxDQUFDLEdBREwsQ0FDUyxRQURULEVBQ21CLFNBRG5CLENBRUksQ0FBQyxLQUZMLENBRVcsU0FBQSxHQUFBO1dBQUcsU0FBQSxDQUFVLFlBQVYsRUFBd0IsQ0FBQSxDQUFFLElBQUYsQ0FBTyxDQUFDLElBQVIsQ0FBYSxpQkFBYixDQUF4QixFQUFIO0VBQUEsQ0FGWCxFQURZO0FBQUEsQ0FUaEIsQ0FBQTs7OztBQ0FBLElBQUEsb0NBQUE7O0FBQUEsT0FBQSxHQUFVLGdDQUFWLENBQUE7O0FBQUEsYUFFQSxHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLENBQUMsQ0FBQyxTQUFGLENBQVkscUNBQVosRUFBbUQsU0FBQSxHQUFBO1dBQy9DLEVBQUUsQ0FBQyxJQUFILENBQVE7QUFBQSxNQUFDLEtBQUEsRUFBTyxrQkFBUjtLQUFSLEVBRCtDO0VBQUEsQ0FBbkQsQ0FBQSxDQUFBO1NBR0EsQ0FBQSxDQUFFLGlCQUFGLENBQW9CLENBQUMsS0FBckIsQ0FBMkIsU0FBQSxHQUFBO1dBQ3ZCLEVBQUUsQ0FBQyxFQUFILENBQ0k7QUFBQSxNQUFBLE1BQUEsRUFBUSxNQUFSO0FBQUEsTUFDQSxJQUFBLEVBQU0sT0FETjtBQUFBLE1BRUEsT0FBQSxFQUFTLGtCQUZUO0tBREosRUFEdUI7RUFBQSxDQUEzQixFQUpZO0FBQUEsQ0FGaEIsQ0FBQTs7QUFBQSxZQVlBLEdBQWUsU0FBQSxHQUFBO0FBQ1gsTUFBQSxtQkFBQTtBQUFBLEVBQUEsT0FBQSxHQUFVLGtCQUFBLENBQW1CLE9BQW5CLENBQVYsQ0FBQTtBQUFBLEVBQ0EsVUFBQSxHQUFjLGdDQUFBLEdBQStCLE9BQS9CLEdBQXdDLGFBRHRELENBQUE7U0FFQSxDQUFBLENBQUUsZ0JBQUYsQ0FDSSxDQUFDLElBREwsQ0FDVSxNQURWLEVBQ2tCLFVBRGxCLENBRUksQ0FBQyxJQUZMLENBRVUsUUFGVixFQUVvQixRQUZwQixFQUhXO0FBQUEsQ0FaZixDQUFBOztBQUFBLE9BbUJPLENBQUMsS0FBUixHQUFnQixTQUFBLEdBQUE7QUFDWixFQUFBLGFBQUEsQ0FBQSxDQUFBLENBQUE7U0FDQSxZQUFBLENBQUEsRUFGWTtBQUFBLENBbkJoQixDQUFBIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt0aHJvdyBuZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpfXZhciBmPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChmLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGYsZi5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJcclxuJCAtPlxyXG4gICAgY29uc29sZS5sb2cgJ0hlbGxvIGZyb20gaG9tZSEnXHJcbiAgICByZXF1aXJlKCcuLi9zaGFyZS1idXR0b25zJykuc2V0dXAoKVxyXG4gICAgcmVxdWlyZSgnLi9zZWVkLWNhcm91c2VsJykuc2V0dXAoKSIsIlxyXG55b3V0dWJlSWRUb1VybCA9IChpZCkgLT5cclxuICAgIFwiLy93d3cueW91dHViZS5jb20vZW1iZWQvI3tpZH0/c2hvd2luZm89MCZtb2Rlc3RicmFuZGluZz0xJmNvbnRyb2xzPTFcIlxyXG5cclxub3BlblZpZGVvID0gKHRpdGxlLCB5b3V0dWJlSWQpIC0+XHJcbiAgICBtb2RhbCA9ICQgJyNzdG9yeS1tb2RhbCdcclxuICAgIG1vZGFsLmZpbmQoJyNzdG9yeS1tb2RhbC10aXRsZScpLnRleHQgdGl0bGVcclxuICAgIG1vZGFsLmZpbmQoJ2lmcmFtZScpLmF0dHIgJ3NyYycsIHlvdXR1YmVJZFRvVXJsKHlvdXR1YmVJZClcclxuICAgIG1vZGFsLm1vZGFsICdzaG93J1xyXG5cclxuZXhwb3J0cy5zZXR1cCA9IC0+XHJcbiAgICAkKCcjc3RvcnktY2Fyb3VzZWwnKS5maW5kICdhJ1xyXG4gICAgICAgIC5jc3MgJ2N1cnNvcicsICdwb2ludGVyJ1xyXG4gICAgICAgIC5jbGljayAtPiBvcGVuVmlkZW8gJ1NvbWUgc3RvcnknLCAkKHRoaXMpLmF0dHIoJ2RhdGEteW91dHViZS1pZCcpIiwiXHJcbnNpdGVVcmwgPSAnaHR0cDovL3d3dy50aGFuay1hLXRlYWNoZXIub3JnJ1xyXG5cclxuc2V0dXBGYWNlYm9vayA9IC0+XHJcbiAgICAkLmdldFNjcmlwdCAnLy9jb25uZWN0LmZhY2Vib29rLm5ldC9lbl9VSy9hbGwuanMnLCAtPlxyXG4gICAgICAgIEZCLmluaXQge2FwcElkOiAnMTQ0NDk1NDY4NTczNTE3Nid9XHJcblxyXG4gICAgJCgnI3NoYXJlLWZhY2Vib29rJykuY2xpY2sgLT5cclxuICAgICAgICBGQi51aVxyXG4gICAgICAgICAgICBtZXRob2Q6ICdmZWVkJyxcclxuICAgICAgICAgICAgbGluazogc2l0ZVVybCxcclxuICAgICAgICAgICAgY2FwdGlvbjogJ1RoYW5rIGEgdGVhY2hlciEnXHJcblxyXG5zZXR1cFR3aXR0ZXIgPSAtPlxyXG4gICAgZW5jb2RlZCA9IGVuY29kZVVSSUNvbXBvbmVudCBzaXRlVXJsXHJcbiAgICB0d2l0dGVyVXJsID0gXCJodHRwczovL3R3aXR0ZXIuY29tL3NoYXJlP3VybD0je2VuY29kZWR9JnZpYT13bW1lZHVcIlxyXG4gICAgJCgnI3NoYXJlLXR3aXR0ZXInKVxyXG4gICAgICAgIC5hdHRyICdocmVmJywgdHdpdHRlclVybFxyXG4gICAgICAgIC5hdHRyICd0YXJnZXQnLCAnX2JsYW5rJ1xyXG5cclxuZXhwb3J0cy5zZXR1cCA9IC0+XHJcbiAgICBzZXR1cEZhY2Vib29rKClcclxuICAgIHNldHVwVHdpdHRlcigpXHJcbiAgICAiXX0=
