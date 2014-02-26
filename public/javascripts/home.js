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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvbm9kZV9tb2R1bGVzL2Jyb3dzZXJpZnkvbm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyIsIi9Vc2Vycy9KdWxpYW5hL0RvY3VtZW50cy9yZXBvcy9zdG9yaWVzLmVkdS9jbGllbnQvanMvaG9tZS9pbmRleC5jb2ZmZWUiLCIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvY2xpZW50L2pzL2hvbWUvc2VlZC1jYXJvdXNlbC5jb2ZmZWUiLCIvVXNlcnMvSnVsaWFuYS9Eb2N1bWVudHMvcmVwb3Mvc3Rvcmllcy5lZHUvY2xpZW50L2pzL3NoYXJlLWJ1dHRvbnMuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQ0EsQ0FBQSxDQUFFLFNBQUEsR0FBQTtBQUNFLEVBQUEsT0FBTyxDQUFDLEdBQVIsQ0FBWSxrQkFBWixDQUFBLENBQUE7QUFBQSxFQUNBLE9BQUEsQ0FBUSxrQkFBUixDQUEyQixDQUFDLEtBQTVCLENBQUEsQ0FEQSxDQUFBO1NBRUEsT0FBQSxDQUFRLGlCQUFSLENBQTBCLENBQUMsS0FBM0IsQ0FBQSxFQUhGO0FBQUEsQ0FBRixDQUFBLENBQUE7Ozs7QUNBQSxJQUFBLHlCQUFBOztBQUFBLGNBQUEsR0FBaUIsU0FBQyxFQUFELEdBQUE7U0FDWiwwQkFBQSxHQUF5QixFQUF6QixHQUE2QiwwQ0FEakI7QUFBQSxDQUFqQixDQUFBOztBQUFBLFNBR0EsR0FBWSxTQUFDLEtBQUQsRUFBUSxTQUFSLEdBQUE7QUFDUixNQUFBLEtBQUE7QUFBQSxFQUFBLEtBQUEsR0FBUSxDQUFBLENBQUUsY0FBRixDQUFSLENBQUE7QUFBQSxFQUNBLEtBQUssQ0FBQyxJQUFOLENBQVcsb0JBQVgsQ0FBZ0MsQ0FBQyxJQUFqQyxDQUFzQyxLQUF0QyxDQURBLENBQUE7QUFBQSxFQUVBLEtBQUssQ0FBQyxJQUFOLENBQVcsUUFBWCxDQUFvQixDQUFDLElBQXJCLENBQTBCLEtBQTFCLEVBQWlDLGNBQUEsQ0FBZSxTQUFmLENBQWpDLENBRkEsQ0FBQTtTQUdBLEtBQUssQ0FBQyxLQUFOLENBQVksTUFBWixFQUpRO0FBQUEsQ0FIWixDQUFBOztBQUFBLE9BU08sQ0FBQyxLQUFSLEdBQWdCLFNBQUEsR0FBQTtTQUNaLENBQUEsQ0FBRSxpQkFBRixDQUFvQixDQUFDLElBQXJCLENBQTBCLEdBQTFCLENBQ0ksQ0FBQyxHQURMLENBQ1MsUUFEVCxFQUNtQixTQURuQixDQUVJLENBQUMsS0FGTCxDQUVXLFNBQUEsR0FBQTtXQUFHLFNBQUEsQ0FBVSxZQUFWLEVBQXdCLGFBQXhCLEVBQUg7RUFBQSxDQUZYLEVBRFk7QUFBQSxDQVRoQixDQUFBOzs7O0FDQUEsSUFBQSxvQ0FBQTs7QUFBQSxPQUFBLEdBQVUsZ0NBQVYsQ0FBQTs7QUFBQSxhQUVBLEdBQWdCLFNBQUEsR0FBQTtBQUNaLEVBQUEsQ0FBQyxDQUFDLFNBQUYsQ0FBWSxxQ0FBWixFQUFtRCxTQUFBLEdBQUE7V0FDL0MsRUFBRSxDQUFDLElBQUgsQ0FBUTtBQUFBLE1BQUMsS0FBQSxFQUFPLGtCQUFSO0tBQVIsRUFEK0M7RUFBQSxDQUFuRCxDQUFBLENBQUE7U0FHQSxDQUFBLENBQUUsaUJBQUYsQ0FBb0IsQ0FBQyxLQUFyQixDQUEyQixTQUFBLEdBQUE7V0FDdkIsRUFBRSxDQUFDLEVBQUgsQ0FDSTtBQUFBLE1BQUEsTUFBQSxFQUFRLE1BQVI7QUFBQSxNQUNBLElBQUEsRUFBTSxPQUROO0FBQUEsTUFFQSxPQUFBLEVBQVMsa0JBRlQ7S0FESixFQUR1QjtFQUFBLENBQTNCLEVBSlk7QUFBQSxDQUZoQixDQUFBOztBQUFBLFlBWUEsR0FBZSxTQUFBLEdBQUE7QUFDWCxNQUFBLG1CQUFBO0FBQUEsRUFBQSxPQUFBLEdBQVUsa0JBQUEsQ0FBbUIsT0FBbkIsQ0FBVixDQUFBO0FBQUEsRUFDQSxVQUFBLEdBQWMsZ0NBQUEsR0FBK0IsT0FBL0IsR0FBd0MsYUFEdEQsQ0FBQTtTQUVBLENBQUEsQ0FBRSxnQkFBRixDQUNJLENBQUMsSUFETCxDQUNVLE1BRFYsRUFDa0IsVUFEbEIsQ0FFSSxDQUFDLElBRkwsQ0FFVSxRQUZWLEVBRW9CLFFBRnBCLEVBSFc7QUFBQSxDQVpmLENBQUE7O0FBQUEsT0FtQk8sQ0FBQyxLQUFSLEdBQWdCLFNBQUEsR0FBQTtBQUNaLEVBQUEsYUFBQSxDQUFBLENBQUEsQ0FBQTtTQUNBLFlBQUEsQ0FBQSxFQUZZO0FBQUEsQ0FuQmhCLENBQUEiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3Rocm93IG5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIil9dmFyIGY9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGYuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sZixmLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIlxuJCAtPlxuICAgIGNvbnNvbGUubG9nICdIZWxsbyBmcm9tIGhvbWUhJ1xuICAgIHJlcXVpcmUoJy4uL3NoYXJlLWJ1dHRvbnMnKS5zZXR1cCgpXG4gICAgcmVxdWlyZSgnLi9zZWVkLWNhcm91c2VsJykuc2V0dXAoKSIsIlxueW91dHViZUlkVG9VcmwgPSAoaWQpIC0+XG4gICAgXCIvL3d3dy55b3V0dWJlLmNvbS9lbWJlZC8je2lkfT9zaG93aW5mbz0wJm1vZGVzdGJyYW5kaW5nPTEmY29udHJvbHM9MVwiXG5cbm9wZW5WaWRlbyA9ICh0aXRsZSwgeW91dHViZUlkKSAtPlxuICAgIG1vZGFsID0gJCAnI3N0b3J5LW1vZGFsJ1xuICAgIG1vZGFsLmZpbmQoJyNzdG9yeS1tb2RhbC10aXRsZScpLnRleHQgdGl0bGVcbiAgICBtb2RhbC5maW5kKCdpZnJhbWUnKS5hdHRyICdzcmMnLCB5b3V0dWJlSWRUb1VybCh5b3V0dWJlSWQpXG4gICAgbW9kYWwubW9kYWwgJ3Nob3cnXG5cbmV4cG9ydHMuc2V0dXAgPSAtPlxuICAgICQoJyNzdG9yeS1jYXJvdXNlbCcpLmZpbmQgJ2EnXG4gICAgICAgIC5jc3MgJ2N1cnNvcicsICdwb2ludGVyJ1xuICAgICAgICAuY2xpY2sgLT4gb3BlblZpZGVvICdTb21lIHN0b3J5JywgJzUtTVpBWEtrN0J3JyIsIlxuc2l0ZVVybCA9ICdodHRwOi8vd3d3LnRoYW5rLWEtdGVhY2hlci5vcmcnXG5cbnNldHVwRmFjZWJvb2sgPSAtPlxuICAgICQuZ2V0U2NyaXB0ICcvL2Nvbm5lY3QuZmFjZWJvb2submV0L2VuX1VLL2FsbC5qcycsIC0+XG4gICAgICAgIEZCLmluaXQge2FwcElkOiAnMTQ0NDk1NDY4NTczNTE3Nid9XG5cbiAgICAkKCcjc2hhcmUtZmFjZWJvb2snKS5jbGljayAtPlxuICAgICAgICBGQi51aVxuICAgICAgICAgICAgbWV0aG9kOiAnZmVlZCcsXG4gICAgICAgICAgICBsaW5rOiBzaXRlVXJsLFxuICAgICAgICAgICAgY2FwdGlvbjogJ1RoYW5rIGEgdGVhY2hlciEnXG5cbnNldHVwVHdpdHRlciA9IC0+XG4gICAgZW5jb2RlZCA9IGVuY29kZVVSSUNvbXBvbmVudCBzaXRlVXJsXG4gICAgdHdpdHRlclVybCA9IFwiaHR0cHM6Ly90d2l0dGVyLmNvbS9zaGFyZT91cmw9I3tlbmNvZGVkfSZ2aWE9d21tZWR1XCJcbiAgICAkKCcjc2hhcmUtdHdpdHRlcicpXG4gICAgICAgIC5hdHRyICdocmVmJywgdHdpdHRlclVybFxuICAgICAgICAuYXR0ciAndGFyZ2V0JywgJ19ibGFuaydcblxuZXhwb3J0cy5zZXR1cCA9IC0+XG4gICAgc2V0dXBGYWNlYm9vaygpXG4gICAgc2V0dXBUd2l0dGVyKClcbiAgICAiXX0=
