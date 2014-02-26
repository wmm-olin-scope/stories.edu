(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var setup;

setup = function() {
  var capitalize, disableInput, doCitySelection, doSchoolSelection, doStateSelection, enableInput, findTransitions, g, getCityHound, getCityInput, getSchoolHound, getSchoolInput, getStateSelect, linkTextFields, makeHound, populateStateOption, stateList;
  g = {};
  capitalize = function(s) {
    var word;
    return ((function() {
      var _i, _len, _ref, _results;
      _ref = s.split(/\s+/);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        word = _ref[_i];
        _results.push(word[0].toUpperCase() + word.slice(1).toLowerCase());
      }
      return _results;
    })()).join(' ');
  };
  getStateSelect = function() {
    return $('#state');
  };
  getCityInput = function() {
    return $('#city');
  };
  getSchoolInput = function() {
    return $('#school');
  };
  populateStateOption = function() {
    var select, state, _i, _len;
    select = getStateSelect();
    select.empty();
    select.append("<option value=\"\">State</option>");
    for (_i = 0, _len = stateList.length; _i < _len; _i++) {
      state = stateList[_i];
      select.append("<option value=\"" + state + "\">" + state + "</option>");
    }
  };
  stateList = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'AS', 'GU', 'MP', 'PR', 'VI'];
  enableInput = function(input, placeholder) {
    return input.attr('disabled', false).val('').attr('placeholder', placeholder);
  };
  disableInput = function(input, placeholder) {
    input.typeahead('destroy');
    return input.attr('disabled', true).val('').attr('placeholder', placeholder);
  };
  findTransitions = {
    state: function() {
      getStateSelect().val('');
      disableInput(getCityInput(), 'Select a state first...');
      disableInput(getSchoolInput(), 'Select a state first...');
      return doStateSelection();
    },
    city: function(state) {
      enableInput(getCityInput(), 'City');
      disableInput(getSchoolInput(), 'Select a city first...');
      return doCitySelection(state);
    },
    school: function(state, city) {
      enableInput(getSchoolInput(), 'School');
      return doSchoolSelection(state, city);
    }
  };
  doStateSelection = function() {
    var oldState;
    oldState = null;
    getStateSelect().off('change');
    return getStateSelect().change(function() {
      var state;
      state = getStateSelect().val();
      if (state === '') {
        findTransitions.state();
      } else if (state !== oldState) {
        findTransitions.city(state);
      }
      return oldState = state;
    });
  };
  makeHound = function(options) {
    var accessor, filter, hound, url;
    url = options.url, filter = options.filter, accessor = options.accessor;
    hound = new Bloodhound({
      datumTokenizer: function(d) {
        return Bloodhound.tokenizers.whitespace(accessor(d));
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      prefetch: {
        url: url,
        filter: filter,
        ttl: 0
      }
    });
    hound.initialize();
    return hound;
  };
  getCityHound = function(state) {
    return makeHound({
      url: "/schools/cities/" + state,
      filter: function(cities) {
        var city, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = cities.length; _i < _len; _i++) {
          city = cities[_i];
          _results.push({
            name: city,
            display: capitalize(city)
          });
        }
        return _results;
      },
      accessor: function(city) {
        return city.name;
      }
    });
  };
  doCitySelection = function(state) {
    var hound, input;
    hound = getCityHound(state);
    input = getCityInput();
    input.typeahead('destroy');
    input.typeahead(null, {
      name: 'cities',
      displayKey: 'display',
      source: hound.ttAdapter()
    });
    input.focus();
    input.off('typeahead:selected');
    return input.on('typeahead:selected', function(obj, city) {
      return findTransitions.school(state, city);
    });
  };
  getSchoolHound = function(state, city) {
    return makeHound({
      url: "/schools/by-city/" + state + "/" + (encodeURIComponent(city.name)),
      filter: function(schools) {
        var school, _i, _len;
        for (_i = 0, _len = schools.length; _i < _len; _i++) {
          school = schools[_i];
          school.display = capitalize(school.name);
        }
        return schools;
      },
      accessor: function(school) {
        return school.name;
      }
    });
  };
  doSchoolSelection = function(state, city) {
    var hound, input;
    hound = getSchoolHound(state, city);
    input = getSchoolInput();
    input.typeahead('destroy');
    input.typeahead(null, {
      name: 'schools',
      displayKey: 'display',
      source: hound.ttAdapter()
    });
    input.focus();
    input.off('typeahead:selected');
    return input.on('typeahead:selected', function(obj, school) {
      g.school = school;
      return console.log(g.school);
    });
  };
  $('#video-button-desktop').click(function() {
    console.log('click on vid buttn');
    $('#video-modal').modal();
    if (window.VIDRECORDER == null) {
      window.VIDRECORDER = {};
    }
    window.VIDRECORDER.close = function() {
      return $('#video-modal').modal('hide');
    };
    return console.log('attached handler');
  });
  linkTextFields = function(field1, field2) {
    $(field1).keyup(function() {
      return $(field2).val($(field1).val());
    });
    return $(field2).keyup(function() {
      return $(field1).val($(field2).val());
    });
  };
  linkTextFields('#teacher_name', '#mailto_name');
  linkTextFields('#author_name', '#return_name');
  linkTextFields('#author_role', '#mailto_role');
  $('#mailto_school, #mailto_city_state, #mailto_street').focus(function() {
    $('#school_modal').modal('show');
  });
  $('#modal_submit').click(function() {
    $('#school_modal').modal('hide');
    console.log(g.school);
    if (g.school !== void 0) {
      $('#mailto_school').val(capitalize(g.school.name));
      $('#mailto_street').val(capitalize(g.school.mailingAddress));
      return $('#mailto_city_state').val("" + (capitalize(g.school.city)) + ", " + g.school.state + " " + g.school.zip);
    }
  });
  $('#send_button').click(function() {
    var contents, _ref, _ref1;
    contents = {
      message: $('#freetext').val(),
      recipientFullName: $('#teacher_name').val(),
      recipientRole: $('#teacher_role').val(),
      authorFullName: $('#author_name').val(),
      authorRole: $('#author_role').val(),
      authorEmail: $('#return_email').val(),
      anonymous: $('#checkbox_input').is(':checked'),
      schoolId: (_ref = g.school) != null ? _ref._id : void 0,
      schoolType: (_ref1 = g.school) != null ? _ref1.schoolType : void 0,
      youtubeId: $('#youtube_id').val()
    };
    console.log(contents);
    return $.post('/postcards', contents).done(function(result) {
      return console.log(result);
    }).fail(function(err) {
      return console.log(err);
    });
  });
  populateStateOption();
  return findTransitions.state();
};

$(function() {
  require('../share-buttons').setup();
  require('./video-upload').setup();
  return setup();
});


},{"../share-buttons":3,"./video-upload":2}],2:[function(require,module,exports){
var auth, config, constants, does_meet_requirements, utils, webcam,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

config = {
  OAUTH2_CLIENT_ID: '40051200930.apps.googleusercontent.com',
  DEVELOPER_KEY: '40051200930.apps.googleusercontent.com',
  VIDEO_CATEGORY: 'Education'
};

constants = {
  CATEGORIES_CACHE_EXPIRATION_MINUTES: 3 * 24 * 60,
  CATEGORIES_CACHE_KEY: 'categories',
  DISPLAY_NAME_CACHE_KEY: 'display_name',
  UPLOADS_LIST_ID_CACHE_KEY: 'uploads_list_id',
  PROFILE_PICTURE_CACHE_KEY: 'profile_picture',
  GENERIC_PROFILE_PICTURE_URL: '//s.ytimg.com/yt/img/no_videos_140-vfl1fDI7-.png',
  OAUTH2_TOKEN_TYPE: 'Bearer',
  OAUTH2_SCOPE: 'https://gdata.youtube.com',
  GDATA_SERVER: 'https://gdata.youtube.com',
  CLIENT_LIB_LOAD_CALLBACK: 'onClientLibReady',
  CLIENT_LIB_URL: 'https://apis.google.com/js/client.js?onload=',
  YOUTUBE_API_SERVICE_NAME: 'youtube',
  YOUTUBE_API_VERSION: 'v3',
  PAGE_SIZE: 50,
  MAX_ITEMS_TO_RETRIEVE: 200,
  FEED_CACHE_MINUTES: 5,
  STATE_CACHE_MINUTES: 15,
  MAX_KEYWORD_LENGTH: 30,
  KEYWORD_UPDATE_XML_TEMPLATE: '<?xml version="1.0"?> <entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007" xmlns:gd="http://schemas.google.com/g/2005" gd:fields="media:group/media:keywords"> <media:group> <media:keywords>{0}</media:keywords> </media:group> </entry>',
  WIDGET_EMBED_CODE: '<iframe width="420" height="500" src="{0}#playlist={1}"></iframe>',
  PLAYLIST_EMBED_CODE: '<iframe width="640" height="360" src="//www.youtube.com/embed/?listType=playlist&list={0}&showinfo=1" frameborder="0" allowfullscreen></iframe>',
  SUBMISSION_RSS_FEED: 'https://gdata.youtube.com/feeds/api/videos?v=2&alt=rss&orderby=published&category=%7Bhttp%3A%2F%2Fgdata.youtube.com%2Fschemas%2F2007%2Fkeywords.cat%7D{0}',
  DEFAULT_KEYWORD: 'ytdl',
  WEBCAM_VIDEO_TITLE: 'Webcam Submission',
  WEBCAM_VIDEO_DESCRIPTION: 'Uploaded via a webcam.',
  REJECTED_VIDEOS_PLAYLIST: 'Rejected YTDL Submissions',
  NO_THUMBNAIL_URL: '//i.ytimg.com/vi/hqdefault.jpg',
  VIDEO_CONTAINER_TEMPLATE: '<li><div class="video-container {additionalClass}"><input type="button" class="submit-video-button" value="Submit Video"><div><span class="video-title">{title}</span><span class="video-duration">({duration})</span></div><div class="video-uploaded">Uploaded on {uploadedDate}</div><div class="thumbnail-container" data-video-id="{videoId}"><img src="{thumbnailUrl}" class="thumbnail-image"><img src="images/play.png" class="play-overlay"></div></div></li>',
  VIDEO_LI_TEMPLATE: '<li><div class="video-container {0}"><input type="button" class="submit-video-button" data-video-id="{1}" data-existing-keywords="{2}" value="Submit Video"><div><span class="video-title">{3}</span><span class="video-duration">({5})</span></div><div class="video-uploaded">Uploaded on {4}</div><div class="thumbnail-container" data-video-id="{1}"><img src="{6}" class="thumbnail-image"><img src="./images/play.png" class="play-overlay"></div></div></li>',
  ADMIN_VIDEO_LI_TEMPLATE: '<li><div class="video-container">{buttonsHtml}<div><span class="video-title">{title}</span><span class="video-duration">({duration})</span></div><div class="video-uploaded">Uploaded on {uploadedDate} by {uploader}</div><div class="thumbnail-container" data-video-id="{videoId}"><img src="{thumbnailUrl}" class="thumbnail-image"><img src="./images/play.png" class="play-overlay"></div></div></li>',
  PLAYLIST_LI_TEMPLATE: '<li data-playlist-name="{playlistName}" data-state="embed-codes" data-playlist-id="{playlistId}">{playlistName}</li>'
};

webcam = {
  init: function() {
    if ((typeof YT === "undefined" || YT === null) || (YT.UploadWidget == null)) {
      window.onYouTubeIframeAPIReady = function() {
        return webcam.loadUploadWidget();
      };
      return $.getScript('//www.youtube.com/iframe_api');
    } else {
      return webcam.loadUploadWidget();
    }
  },
  loadUploadWidget: function() {
    return new YT.UploadWidget('webcam-widget', {
      webcamOnly: true,
      events: {
        onApiReady: function(event) {
          event.target.setVideoTitle(config.VIDEO_TITLE || constants.WEBCAM_VIDEO_TITLE);
          return event.target.setVideoDescription(config.VIDEO_DESCRIPTION || constants.WEBCAM_VIDEO_DESCRIPTION);
        },
        onUploadSuccess: function(event) {
          console.log("Webcam submission success!");
          console.log(event);
          $('#youtube_id').val(event.data.videoId);
          return window.VIDRECORDER.close();
        },
        onStateChange: function(event) {
          if (event.data.state === YT.UploadWidgetState.ERROR) {
            return console.error("Webcam submission error!");
          }
        }
      }
    });
  }
};

utils = {
  itemsInResponse: function(response) {
    return __indexOf.call(response, 'items') >= 0 && response.items.length > 0;
  }
};

auth = {
  initAuth: function() {
    window[constants.CLIENT_LIB_LOAD_CALLBACK] = function() {
      return gapi.auth.init(function() {
        if (lscache.get(constants.DISPLAY_NAME_CACHE_KEY)) {
          window.setTimeout(function() {
            return gapi.auth.authorize({
              client_id: config.OAUTH2_CLIENT_ID,
              scope: [constants.OAUTH2_SCOPE],
              immediate: true
            }, auth.onAuthResult);
          }, 1);
          return console.log('auth script launched');
        } else {
          return console.log('requesting YT login');
        }
      });
    };
    return $.getScript(constants.CLIENT_LIB_URL + constants.CLIENT_LIB_LOAD_CALLBACK);
  },
  onAuthResult: function(authResult) {
    if (authResult) {
      console.log('Got auth result', authResult);
      return gapi.client.load(constants.YOUTUBE_API_SERVICE_NAME, constants.YOUTUBE_API_VERSION, auth.onYouTubeClientLoad);
    } else {
      console.log('Auth failed');
      return lscache.flush();
    }
  },
  onYouTubeClientLoad: function() {
    var request;
    console.log('Youtube client loaded!');
    if (lscache.get(constants.DISPLAY_NAME_CACHE_KEY)) {

    } else {
      request = gapi.client[constants.YOUTUBE_API_SERVICE_NAME].channels.list({
        mine: true,
        part: 'snippet,contentDetails,status'
      });
      return request.execute(function(response) {
        if (utils.itemsInResponse(response)) {
          if (response.items[0].status.isLinked) {
            lscache.set(constants.UPLOADS_LIST_ID_CACHE_KEY, response.items[0].contentDetails.relatedPlaylists.uploads);
            lscache.set(constants.DISPLAY_NAME_CACHE_KEY, response.items[0].snippet.title);
            return lscache.set(constants.PROFILE_PICTURE_CACHE_KEY, response.items[0].snippet.thumbnails["default"].url);
          } else {
            return console.error('Your account cannot upload videos. Please visit <a target="_blank" href="https://www.youtube.com/signin?next=/create_channel">https://www.youtube.com/signin?next=/create_channel</a> to add a YouTube channel to your account, and try again.');
          }
        } else {
          console.log(response);
          return console.error("Unable to retrieve channel info.");
        }
      });
    }
  }
};

does_meet_requirements = function() {
  if (!$.support.cors) {
    console.error("Browser not supported!");
    return false;
  } else {
    return true;
  }
};

exports.setup = function() {
  if (!config.OAUTH2_CLIENT_ID || !config.DEVELOPER_KEY) {
    return console.log("NOT CONFIGURED!");
  } else {
    console.log("Configured!");
    if (does_meet_requirements) {
      auth.initAuth();
      return webcam.init();
    }
  }
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyJDOlxcVXNlcnNcXENoYXNlXFxEcm9wYm94XFxEZXZcXHN0b3JpZXMuZWR1XFxub2RlX21vZHVsZXNcXGJyb3dzZXJpZnlcXG5vZGVfbW9kdWxlc1xcYnJvd3Nlci1wYWNrXFxfcHJlbHVkZS5qcyIsIkM6XFxVc2Vyc1xcQ2hhc2VcXERyb3Bib3hcXERldlxcc3Rvcmllcy5lZHVcXGNsaWVudFxcanNcXHBvc3RjYXJkXFxtYWtlLmNvZmZlZSIsIkM6XFxVc2Vyc1xcQ2hhc2VcXERyb3Bib3hcXERldlxcc3Rvcmllcy5lZHVcXGNsaWVudFxcanNcXHBvc3RjYXJkXFx2aWRlby11cGxvYWQuY29mZmVlIiwiQzpcXFVzZXJzXFxDaGFzZVxcRHJvcGJveFxcRGV2XFxzdG9yaWVzLmVkdVxcY2xpZW50XFxqc1xcc2hhcmUtYnV0dG9ucy5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUNDQSxJQUFBLEtBQUE7O0FBQUEsS0FBQSxHQUFRLFNBQUEsR0FBQTtBQUNKLE1BQUEsc1BBQUE7QUFBQSxFQUFBLENBQUEsR0FBSSxFQUFKLENBQUE7QUFBQSxFQUVBLFVBQUEsR0FBYSxTQUFDLENBQUQsR0FBQTtBQUNULFFBQUEsSUFBQTtXQUFBOztBQUFDO0FBQUE7V0FBQSwyQ0FBQTt3QkFBQTtBQUFBLHNCQUFBLElBQUssQ0FBQSxDQUFBLENBQUUsQ0FBQyxXQUFSLENBQUEsQ0FBQSxHQUF3QixJQUFLLFNBQUssQ0FBQyxXQUFYLENBQUEsRUFBeEIsQ0FBQTtBQUFBOztRQUFELENBQTRFLENBQUMsSUFBN0UsQ0FBa0YsR0FBbEYsRUFEUztFQUFBLENBRmIsQ0FBQTtBQUFBLEVBS0EsY0FBQSxHQUFpQixTQUFBLEdBQUE7V0FBRyxDQUFBLENBQUUsUUFBRixFQUFIO0VBQUEsQ0FMakIsQ0FBQTtBQUFBLEVBTUEsWUFBQSxHQUFlLFNBQUEsR0FBQTtXQUFHLENBQUEsQ0FBRSxPQUFGLEVBQUg7RUFBQSxDQU5mLENB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QUNaLEVBQUEsYUFBQSxDQUFBLENBQUEsQ0FBQTtTQUNBLFlBQUEsQ0FBQSxFQUZZO0FBQUEsQ0FuQmhCLENBQUEiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3Rocm93IG5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIil9dmFyIGY9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGYuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sZixmLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIlxyXG5zZXR1cCA9IC0+XHJcbiAgICBnID0ge31cclxuXHJcbiAgICBjYXBpdGFsaXplID0gKHMpIC0+XHJcbiAgICAgICAgKHdvcmRbMF0udG9VcHBlckNhc2UoKSArIHdvcmRbMS4uLl0udG9Mb3dlckNhc2UoKSBmb3Igd29yZCBpbiBzLnNwbGl0IC9cXHMrLykuam9pbiAnICdcclxuXHJcbiAgICBnZXRTdGF0ZVNlbGVjdCA9IC0+ICQgJyNzdGF0ZSdcclxuICAgIGdldENpdHlJbnB1dCA9IC0+ICQgJyNjaXR5J1xyXG4gICAgZ2V0U2Nob29sSW5wdXQgPSAtPiAkICcjc2Nob29sJ1xyXG5cclxuICAgIHBvcHVsYXRlU3RhdGVPcHRpb24gPSAtPlxyXG4gICAgICAgIHNlbGVjdCA9IGdldFN0YXRlU2VsZWN0KClcclxuICAgICAgICBzZWxlY3QuZW1wdHkoKVxyXG4gICAgICAgIHNlbGVjdC5hcHBlbmQgXCI8b3B0aW9uIHZhbHVlPVxcXCJcXFwiPlN0YXRlPC9vcHRpb24+XCJcclxuICAgICAgICBmb3Igc3RhdGUgaW4gc3RhdGVMaXN0XHJcbiAgICAgICAgICAgIHNlbGVjdC5hcHBlbmQgXCI8b3B0aW9uIHZhbHVlPVxcXCIje3N0YXRlfVxcXCI+I3tzdGF0ZX08L29wdGlvbj5cIlxyXG4gICAgICAgIHJldHVyblxyXG5cclxuICAgICBzdGF0ZUxpc3QgPSBbXHJcbiAgICAgICAgJ0FMJywnQUsnLCdBWicsJ0FSJywnQ0EnLCdDTycsJ0NUJywnREUnLCdEQycsJ0ZMJywnR0EnLCdISScsJ0lEJywnSUwnLFxyXG4gICAgICAgICdJTicsJ0lBJywnS1MnLCdLWScsJ0xBJywnTUUnLCdNRCcsJ01BJywnTUknLCdNTicsJ01TJywnTU8nLCdNVCcsJ05FJyxcclxuICAgICAgICAnTlYnLCdOSCcsJ05KJywnTk0nLCdOWScsJ05DJywnTkQnLCdPSCcsJ09LJywnT1InLCdQQScsJ1JJJywnU0MnLCdTRCcsXHJcbiAgICAgICAgJ1ROJywnVFgnLCdVVCcsJ1ZUJywnVkEnLCdXQScsJ1dWJywnV0knLCdXWScsJ0FTJywnR1UnLCdNUCcsJ1BSJywnVkknXVxyXG5cclxuICAgIGVuYWJsZUlucHV0ID0gKGlucHV0LCBwbGFjZWhvbGRlcikgLT4gXHJcbiAgICAgICAgaW5wdXQuYXR0cignZGlzYWJsZWQnLCBubykudmFsKCcnKS5hdHRyKCdwbGFjZWhvbGRlcicsIHBsYWNlaG9sZGVyKVxyXG4gICAgZGlzYWJsZUlucHV0ID0gKGlucHV0LCBwbGFjZWhvbGRlcikgLT5cclxuICAgICAgICBpbnB1dC50eXBlYWhlYWQgJ2Rlc3Ryb3knXHJcbiAgICAgICAgaW5wdXQuYXR0cignZGlzYWJsZWQnLCB5ZXMpLnZhbCgnJykuYXR0cigncGxhY2Vob2xkZXInLCBwbGFjZWhvbGRlcilcclxuXHJcbiAgICBmaW5kVHJhbnNpdGlvbnMgPVxyXG4gICAgICAgIHN0YXRlOiAtPlxyXG4gICAgICAgICAgICBnZXRTdGF0ZVNlbGVjdCgpLnZhbCAnJ1xyXG4gICAgICAgICAgICBkaXNhYmxlSW5wdXQgZ2V0Q2l0eUlucHV0KCksICdTZWxlY3QgYSBzdGF0ZSBmaXJzdC4uLidcclxuICAgICAgICAgICAgZGlzYWJsZUlucHV0IGdldFNjaG9vbElucHV0KCksICdTZWxlY3QgYSBzdGF0ZSBmaXJzdC4uLidcclxuICAgICAgICAgICAgZG9TdGF0ZVNlbGVjdGlvbigpXHJcbiAgICAgICAgY2l0eTogKHN0YXRlKSAtPlxyXG4gICAgICAgICAgICBlbmFibGVJbnB1dCBnZXRDaXR5SW5wdXQoKSwgJ0NpdHknXHJcbiAgICAgICAgICAgIGRpc2FibGVJbnB1dCBnZXRTY2hvb2xJbnB1dCgpLCAnU2VsZWN0IGEgY2l0eSBmaXJzdC4uLidcclxuICAgICAgICAgICAgZG9DaXR5U2VsZWN0aW9uIHN0YXRlXHJcbiAgICAgICAgc2Nob29sOiAoc3RhdGUsIGNpdHkpIC0+XHJcbiAgICAgICAgICAgIGVuYWJsZUlucHV0IGdldFNjaG9vbElucHV0KCksICdTY2hvb2wnXHJcbiAgICAgICAgICAgIGRvU2Nob29sU2VsZWN0aW9uIHN0YXRlLCBjaXR5XHJcblxyXG4gICAgZG9TdGF0ZVNlbGVjdGlvbiA9IC0+XHJcbiAgICAgICAgb2xkU3RhdGUgPSBudWxsXHJcbiAgICAgICAgZ2V0U3RhdGVTZWxlY3QoKS5vZmYgJ2NoYW5nZSdcclxuICAgICAgICBnZXRTdGF0ZVNlbGVjdCgpLmNoYW5nZSAtPlxyXG4gICAgICAgICAgICBzdGF0ZSA9IGdldFN0YXRlU2VsZWN0KCkudmFsKClcclxuICAgICAgICAgICAgaWYgc3RhdGUgaXMgJydcclxuICAgICAgICAgICAgICAgIGZpbmRUcmFuc2l0aW9ucy5zdGF0ZSgpXHJcbiAgICAgICAgICAgIGVsc2UgaWYgc3RhdGUgaXNudCBvbGRTdGF0ZVxyXG4gICAgICAgICAgICAgICAgZmluZFRyYW5zaXRpb25zLmNpdHkgc3RhdGVcclxuICAgICAgICAgICAgb2xkU3RhdGUgPSBzdGF0ZVxyXG5cclxuICAgIG1ha2VIb3VuZCA9IChvcHRpb25zKSAtPlxyXG4gICAgICAgIHt1cmwsIGZpbHRlciwgYWNjZXNzb3J9ID0gb3B0aW9uc1xyXG4gICAgICAgIGhvdW5kID0gbmV3IEJsb29kaG91bmRcclxuICAgICAgICAgICAgZGF0dW1Ub2tlbml6ZXI6IChkKSAtPiBcclxuICAgICAgICAgICAgICAgIEJsb29kaG91bmQudG9rZW5pemVycy53aGl0ZXNwYWNlIGFjY2Vzc29yIGRcclxuICAgICAgICAgICAgcXVlcnlUb2tlbml6ZXI6IEJsb29kaG91bmQudG9rZW5pemVycy53aGl0ZXNwYWNlXHJcbiAgICAgICAgICAgIHByZWZldGNoOlxyXG4gICAgICAgICAgICAgICAgdXJsOiB1cmxcclxuICAgICAgICAgICAgICAgIGZpbHRlcjogZmlsdGVyXHJcbiAgICAgICAgICAgICAgICB0dGw6IDAgIyBUT0RPOiB3aGVuIGluIHByb2R1Y3Rpb24gc2V0IHRvIGxvbmdlclxyXG4gICAgICAgIGhvdW5kLmluaXRpYWxpemUoKVxyXG4gICAgICAgIGhvdW5kXHJcblxyXG4gICAgZ2V0Q2l0eUhvdW5kID0gKHN0YXRlKSAtPiBtYWtlSG91bmRcclxuICAgICAgICB1cmw6IFwiL3NjaG9vbHMvY2l0aWVzLyN7c3RhdGV9XCJcclxuICAgICAgICBmaWx0ZXI6IChjaXRpZXMpIC0+IFxyXG4gICAgICAgICAgICB7bmFtZTogY2l0eSwgZGlzcGxheTogY2FwaXRhbGl6ZSBjaXR5fSBmb3IgY2l0eSBpbiBjaXRpZXNcclxuICAgICAgICBhY2Nlc3NvcjogKGNpdHkpIC0+IGNpdHkubmFtZVxyXG5cclxuICAgIGRvQ2l0eVNlbGVjdGlvbiA9IChzdGF0ZSkgLT5cclxuICAgICAgICBob3VuZCA9IGdldENpdHlIb3VuZCBzdGF0ZVxyXG4gICAgICAgIGlucHV0ID0gZ2V0Q2l0eUlucHV0KClcclxuXHJcbiAgICAgICAgaW5wdXQudHlwZWFoZWFkICdkZXN0cm95J1xyXG4gICAgICAgIGlucHV0LnR5cGVhaGVhZCBudWxsLFxyXG4gICAgICAgICAgICBuYW1lOiAnY2l0aWVzJ1xyXG4gICAgICAgICAgICBkaXNwbGF5S2V5OiAnZGlzcGxheSdcclxuICAgICAgICAgICAgc291cmNlOiBob3VuZC50dEFkYXB0ZXIoKVxyXG4gICAgICAgIGlucHV0LmZvY3VzKClcclxuXHJcbiAgICAgICAgaW5wdXQub2ZmICd0eXBlYWhlYWQ6c2VsZWN0ZWQnXHJcbiAgICAgICAgaW5wdXQub24gJ3R5cGVhaGVhZDpzZWxlY3RlZCcsIChvYmosIGNpdHkpIC0+IFxyXG4gICAgICAgICAgICBmaW5kVHJhbnNpdGlvbnMuc2Nob29sIHN0YXRlLCBjaXR5XHJcblxyXG4gICAgZ2V0U2Nob29sSG91bmQgPSAoc3RhdGUsIGNpdHkpIC0+IG1ha2VIb3VuZFxyXG4gICAgICAgIHVybDogXCIvc2Nob29scy9ieS1jaXR5LyN7c3RhdGV9LyN7ZW5jb2RlVVJJQ29tcG9uZW50IGNpdHkubmFtZX1cIlxyXG4gICAgICAgIGZpbHRlcjogKHNjaG9vbHMpIC0+XHJcbiAgICAgICAgICAgIGZvciBzY2hvb2wgaW4gc2Nob29sc1xyXG4gICAgICAgICAgICAgICAgc2Nob29sLmRpc3BsYXkgPSBjYXBpdGFsaXplIHNjaG9vbC5uYW1lXHJcbiAgICAgICAgICAgIHNjaG9vbHNcclxuICAgICAgICBhY2Nlc3NvcjogKHNjaG9vbCkgLT4gc2Nob29sLm5hbWVcclxuXHJcbiAgICBkb1NjaG9vbFNlbGVjdGlvbiA9IChzdGF0ZSwgY2l0eSkgLT5cclxuICAgICAgICBob3VuZCA9IGdldFNjaG9vbEhvdW5kIHN0YXRlLCBjaXR5XHJcbiAgICAgICAgaW5wdXQgPSBnZXRTY2hvb2xJbnB1dCgpXHJcblxyXG4gICAgICAgIGlucHV0LnR5cGVhaGVhZCAnZGVzdHJveSdcclxuICAgICAgICBpbnB1dC50eXBlYWhlYWQgbnVsbCxcclxuICAgICAgICAgICAgbmFtZTogJ3NjaG9vbHMnXHJcbiAgICAgICAgICAgIGRpc3BsYXlLZXk6ICdkaXNwbGF5J1xyXG4gICAgICAgICAgICBzb3VyY2U6IGhvdW5kLnR0QWRhcHRlcigpXHJcbiAgICAgICAgaW5wdXQuZm9jdXMoKVxyXG5cclxuICAgICAgICBpbnB1dC5vZmYgJ3R5cGVhaGVhZDpzZWxlY3RlZCdcclxuICAgICAgICBpbnB1dC5vbiAndHlwZWFoZWFkOnNlbGVjdGVkJywgKG9iaiwgc2Nob29sKSAtPiBcclxuICAgICAgICAgICAgZy5zY2hvb2wgPSBzY2hvb2xcclxuICAgICAgICAgICAgY29uc29sZS5sb2cgZy5zY2hvb2xcclxuXHJcbiAgICAkKCcjdmlkZW8tYnV0dG9uLWRlc2t0b3AnKS5jbGljayAtPlxyXG4gICAgICAgIGNvbnNvbGUubG9nKCdjbGljayBvbiB2aWQgYnV0dG4nKVxyXG4gICAgICAgICQoJyN2aWRlby1tb2RhbCcpLm1vZGFsKClcclxuICAgICAgICBpZiBub3Qgd2luZG93LlZJRFJFQ09SREVSP1xyXG4gICAgICAgICAgICB3aW5kb3cuVklEUkVDT1JERVIgPSB7fVxyXG4gICAgICAgIHdpbmRvdy5WSURSRUNPUkRFUi5jbG9zZSA9ICgpIC0+ICQoJyN2aWRlby1tb2RhbCcpLm1vZGFsKCdoaWRlJylcclxuICAgICAgICBjb25zb2xlLmxvZygnYXR0YWNoZWQgaGFuZGxlcicpXHJcblxyXG4gICAgbGlua1RleHRGaWVsZHMgPSAoZmllbGQxLCBmaWVsZDIpIC0+XHJcbiAgICAgICAgJChmaWVsZDEpLmtleXVwIC0+ICQoZmllbGQyKS52YWwgJChmaWVsZDEpLnZhbCgpXHJcbiAgICAgICAgJChmaWVsZDIpLmtleXVwIC0+ICQoZmllbGQxKS52YWwgJChmaWVsZDIpLnZhbCgpXHJcblxyXG4gICAgbGlua1RleHRGaWVsZHMgJyN0ZWFjaGVyX25hbWUnLCAnI21haWx0b19uYW1lJ1xyXG4gICAgbGlua1RleHRGaWVsZHMgJyNhdXRob3JfbmFtZScsICcjcmV0dXJuX25hbWUnXHJcbiAgICBsaW5rVGV4dEZpZWxkcyAnI2F1dGhvcl9yb2xlJywgJyNtYWlsdG9fcm9sZSdcclxuXHJcbiAgICAkKCcjbWFpbHRvX3NjaG9vbCwgI21haWx0b19jaXR5X3N0YXRlLCAjbWFpbHRvX3N0cmVldCcpLmZvY3VzIC0+XHJcbiAgICAgICAgJCgnI3NjaG9vbF9tb2RhbCcpLm1vZGFsKCdzaG93JylcclxuICAgICAgICByZXR1cm5cclxuXHJcbiAgICAkKCcjbW9kYWxfc3VibWl0JykuY2xpY2sgLT5cclxuICAgICAgICAkKCcjc2Nob29sX21vZGFsJykubW9kYWwoJ2hpZGUnKVxyXG4gICAgICAgIGNvbnNvbGUubG9nIGcuc2Nob29sXHJcbiAgICAgICAgaWYgZy5zY2hvb2wgIT0gdW5kZWZpbmVkXHJcbiAgICAgICAgICAgICQoJyNtYWlsdG9fc2Nob29sJykudmFsIGNhcGl0YWxpemUgZy5zY2hvb2wubmFtZVxyXG4gICAgICAgICAgICAkKCcjbWFpbHRvX3N0cmVldCcpLnZhbCBjYXBpdGFsaXplIGcuc2Nob29sLm1haWxpbmdBZGRyZXNzXHJcbiAgICAgICAgICAgICQoJyNtYWlsdG9fY2l0eV9zdGF0ZScpLnZhbCBcIiN7Y2FwaXRhbGl6ZSBnLnNjaG9vbC5jaXR5fSwgI3tnLnNjaG9vbC5zdGF0ZX0gI3tnLnNjaG9vbC56aXB9XCJcclxuXHJcbiAgICAkKCcjc2VuZF9idXR0b24nKS5jbGljayAtPlxyXG4gICAgICAgIGNvbnRlbnRzID1cclxuICAgICAgICAgICAgbWVzc2FnZTogJCgnI2ZyZWV0ZXh0JykudmFsKClcclxuICAgICAgICAgICAgcmVjaXBpZW50RnVsbE5hbWU6ICQoJyN0ZWFjaGVyX25hbWUnKS52YWwoKVxyXG4gICAgICAgICAgICByZWNpcGllbnRSb2xlOiAkKCcjdGVhY2hlcl9yb2xlJykudmFsKClcclxuICAgICAgICAgICAgYXV0aG9yRnVsbE5hbWU6ICQoJyNhdXRob3JfbmFtZScpLnZhbCgpXHJcbiAgICAgICAgICAgIGF1dGhvclJvbGU6ICQoJyNhdXRob3Jfcm9sZScpLnZhbCgpXHJcbiAgICAgICAgICAgIGF1dGhvckVtYWlsOiAkKCcjcmV0dXJuX2VtYWlsJykudmFsKClcclxuICAgICAgICAgICAgYW5vbnltb3VzOiAkKCcjY2hlY2tib3hfaW5wdXQnKS5pcyAnOmNoZWNrZWQnXHJcbiAgICAgICAgICAgIHNjaG9vbElkOiBnLnNjaG9vbD8uX2lkXHJcbiAgICAgICAgICAgIHNjaG9vbFR5cGU6IGcuc2Nob29sPy5zY2hvb2xUeXBlXHJcbiAgICAgICAgICAgIHlvdXR1YmVJZDogJCgnI3lvdXR1YmVfaWQnKS52YWwoKVxyXG4gICAgICAgIGNvbnNvbGUubG9nKGNvbnRlbnRzKVxyXG4gICAgICAgICQucG9zdCAnL3Bvc3RjYXJkcycsIGNvbnRlbnRzXHJcbiAgICAgICAgICAgIC5kb25lIChyZXN1bHQpIC0+IGNvbnNvbGUubG9nIHJlc3VsdFxyXG4gICAgICAgICAgICAuZmFpbCAoZXJyKSAtPiBjb25zb2xlLmxvZyBlcnJcclxuXHJcbiAgICBwb3B1bGF0ZVN0YXRlT3B0aW9uKClcclxuICAgIGZpbmRUcmFuc2l0aW9ucy5zdGF0ZSgpXHJcblxyXG4kIC0+XHJcbiAgICByZXF1aXJlKCcuLi9zaGFyZS1idXR0b25zJykuc2V0dXAoKVxyXG4gICAgcmVxdWlyZSgnLi92aWRlby11cGxvYWQnKS5zZXR1cCgpXHJcbiAgICBzZXR1cCgpIiwiY29uZmlnID1cclxuICAgICMgUkVRVUlSRURcclxuICAgICMgU2VlIGh0dHBzOi8vZGV2ZWxvcGVycy5nb29nbGUuY29tL2FwaS1jbGllbnQtbGlicmFyeS9qYXZhc2NyaXB0L2ZlYXR1cmVzL2F1dGhlbnRpY2F0aW9uXHJcbiAgICAjIGZvciBpbnN0cnVjdGlvbnMgb24gcmVnaXN0ZXJpbmcgZm9yIE9BdXRoIDIuXHJcbiAgICAjIEFmdGVyIGdlbmVyYXRpbmcgeW91ciBPQXV0aCAyIGNsaWVudCBpZCwgeW91IE1VU1QgdGhlbiB2aXNpdCB0aGUgXCJTZXJ2aWNlc1wiIHRhYiBvZlxyXG4gICAgIyBodHRwczovL2NvZGUuZ29vZ2xlLmNvbS9hcGlzL2NvbnNvbGUvIGZpbmQgdGhlIGVudHJ5IGZvciBcIllvdVR1YmUgRGF0YSBBUEkgdjNcIlxyXG4gICAgIyBhbmQgZmxpcCBpdCB0byBcIk9OXCIuXHJcbiAgICBPQVVUSDJfQ0xJRU5UX0lEOiAnNDAwNTEyMDA5MzAuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20nXHJcblxyXG4gICAgIyBSRVFVSVJFRFxyXG4gICAgIyBSZWdpc3RlciBhdCBodHRwczovL2NvZGUuZ29vZ2xlLmNvbS9hcGlzL3lvdXR1YmUvZGFzaGJvYXJkL2d3dC9pbmRleC5odG1sIHRvIGdldCB5b3VyIG93biBrZXkuXHJcbiAgICBERVZFTE9QRVJfS0VZOiAnNDAwNTEyMDA5MzAuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20nXHJcblxyXG4gICAgIyBJZiB5b3UnZCBsaWtlIHRvIGVuYWJsZSBHb29nbGUgQW5hbHl0aWNzIHN0YXRpc3RpY3MgdG8geW91ciBZb3VUdWJlIERpcmVjdCBMaXRlIGluc3RhbmNlLFxyXG4gICAgIyByZWdpc3RlciBmb3IgYSBHb29nbGUgQW5hbHl0aWNzIGFjY291bnQgYW5kIGVudGVyIHlvdXIgaWQgY29kZSBiZWxvdy5cclxuICAgICMsR09PR0xFX0FOQUxZVElDU19JRDogJ1VBLSMjIyMjIyMjLSMnXHJcblxyXG4gICAgIyBTZXR0aW5nIGFueSBvciBhbGwgb2YgdGhlc2UgdGhyZWUgZmllbGRzIGFyZSBvcHRpb25hbC5cclxuICAgICMgSWYgc2V0IHRoZW4gdGhlIHZhbHVlKHMpIHdpbGwgYmUgdXNlZCBmb3IgbmV3IHZpZGVvIHVwbG9hZHMsIGFuZCB5b3VyIHVzZXJzIHdvbid0IGJlIHByb21wdGVkIGZvciB0aGUgY29ycmVzcG9uZGluZyBmaWVsZHMgb24gdGhlIHZpZGVvIHVwbG9hZCBmb3JtLlxyXG4gICAgI1ZJREVPX1RJVExFOiAnVmlkZW8gU3VibWlzc2lvbidcclxuICAgICNWSURFT19ERVNDUklQVElPTjogJ1RoaXMgaXMgYSB2aWRlbyBzdWJtaXNzaW9uLidcclxuICAgICMgTWFrZSBzdXJlIHRoYXQgdGhpcyBjb3JyZXNwb25kcyB0byBhbiBhc3NpZ25hYmxlIGNhdGVnb3J5IVxyXG4gICAgIyBTZWUgaHR0cHM6Ly9kZXZlbG9wZXJzLmdvb2dsZS5jb20veW91dHViZS8yLjAvcmVmZXJlbmNlI1lvdVR1YmVfQ2F0ZWdvcnlfTGlzdFxyXG4gICAgVklERU9fQ0FURUdPUlk6ICdFZHVjYXRpb24nXHJcblxyXG5jb25zdGFudHMgPVxyXG4gICAgQ0FURUdPUklFU19DQUNIRV9FWFBJUkFUSU9OX01JTlVURVM6IDMgKiAyNCAqIDYwLFxyXG4gICAgQ0FURUdPUklFU19DQUNIRV9LRVk6ICdjYXRlZ29yaWVzJ1xyXG4gICAgRElTUExBWV9OQU1FX0NBQ0hFX0tFWTogJ2Rpc3BsYXlfbmFtZSdcclxuICAgIFVQTE9BRFNfTElTVF9JRF9DQUNIRV9LRVk6ICd1cGxvYWRzX2xpc3RfaWQnXHJcbiAgICBQUk9GSUxFX1BJQ1RVUkVfQ0FDSEVfS0VZOiAncHJvZmlsZV9waWN0dXJlJ1xyXG4gICAgR0VORVJJQ19QUk9GSUxFX1BJQ1RVUkVfVVJMOiAnLy9zLnl0aW1nLmNvbS95dC9pbWcvbm9fdmlkZW9zXzE0MC12ZmwxZkRJNy0ucG5nJ1xyXG4gICAgT0FVVEgyX1RPS0VOX1RZUEU6ICdCZWFyZXInXHJcbiAgICBPQVVUSDJfU0NPUEU6ICdodHRwczovL2dkYXRhLnlvdXR1YmUuY29tJ1xyXG4gICAgR0RBVEFfU0VSVkVSOiAnaHR0cHM6Ly9nZGF0YS55b3V0dWJlLmNvbSdcclxuICAgIENMSUVOVF9MSUJfTE9BRF9DQUxMQkFDSzogJ29uQ2xpZW50TGliUmVhZHknXHJcbiAgICBDTElFTlRfTElCX1VSTDogJ2h0dHBzOi8vYXBpcy5nb29nbGUuY29tL2pzL2NsaWVudC5qcz9vbmxvYWQ9J1xyXG4gICAgWU9VVFVCRV9BUElfU0VSVklDRV9OQU1FOiAneW91dHViZSdcclxuICAgIFlPVVRVQkVfQVBJX1ZFUlNJT046ICd2MydcclxuICAgIFBBR0VfU0laRTogNTBcclxuICAgIE1BWF9JVEVNU19UT19SRVRSSUVWRTogMjAwXHJcbiAgICBGRUVEX0NBQ0hFX01JTlVURVM6IDVcclxuICAgIFNUQVRFX0NBQ0hFX01JTlVURVM6IDE1XHJcbiAgICBNQVhfS0VZV09SRF9MRU5HVEg6IDMwXHJcbiAgICBLRVlXT1JEX1VQREFURV9YTUxfVEVNUExBVEU6ICc8P3htbCB2ZXJzaW9uPVwiMS4wXCI/PiA8ZW50cnkgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8yMDA1L0F0b21cIiB4bWxuczptZWRpYT1cImh0dHA6Ly9zZWFyY2gueWFob28uY29tL21yc3MvXCIgeG1sbnM6eXQ9XCJodHRwOi8vZ2RhdGEueW91dHViZS5jb20vc2NoZW1hcy8yMDA3XCIgeG1sbnM6Z2Q9XCJodHRwOi8vc2NoZW1hcy5nb29nbGUuY29tL2cvMjAwNVwiIGdkOmZpZWxkcz1cIm1lZGlhOmdyb3VwL21lZGlhOmtleXdvcmRzXCI+IDxtZWRpYTpncm91cD4gPG1lZGlhOmtleXdvcmRzPnswfTwvbWVkaWE6a2V5d29yZHM+IDwvbWVkaWE6Z3JvdXA+IDwvZW50cnk+J1xyXG4gICAgV0lER0VUX0VNQkVEX0NPREU6ICc8aWZyYW1lIHdpZHRoPVwiNDIwXCIgaGVpZ2h0PVwiNTAwXCIgc3JjPVwiezB9I3BsYXlsaXN0PXsxfVwiPjwvaWZyYW1lPidcclxuICAgIFBMQVlMSVNUX0VNQkVEX0NPREU6ICc8aWZyYW1lIHdpZHRoPVwiNjQwXCIgaGVpZ2h0PVwiMzYwXCIgc3JjPVwiLy93d3cueW91dHViZS5jb20vZW1iZWQvP2xpc3RUeXBlPXBsYXlsaXN0Jmxpc3Q9ezB9JnNob3dpbmZvPTFcIiBmcmFtZWJvcmRlcj1cIjBcIiBhbGxvd2Z1bGxzY3JlZW4+PC9pZnJhbWU+J1xyXG4gICAgU1VCTUlTU0lPTl9SU1NfRkVFRDogJ2h0dHBzOi8vZ2RhdGEueW91dHViZS5jb20vZmVlZHMvYXBpL3ZpZGVvcz92PTImYWx0PXJzcyZvcmRlcmJ5PXB1Ymxpc2hlZCZjYXRlZ29yeT0lN0JodHRwJTNBJTJGJTJGZ2RhdGEueW91dHViZS5jb20lMkZzY2hlbWFzJTJGMjAwNyUyRmtleXdvcmRzLmNhdCU3RHswfSdcclxuICAgIERFRkFVTFRfS0VZV09SRDogJ3l0ZGwnXHJcbiAgICBXRUJDQU1fVklERU9fVElUTEU6ICdXZWJjYW0gU3VibWlzc2lvbidcclxuICAgIFdFQkNBTV9WSURFT19ERVNDUklQVElPTjogJ1VwbG9hZGVkIHZpYSBhIHdlYmNhbS4nXHJcbiAgICBSRUpFQ1RFRF9WSURFT1NfUExBWUxJU1Q6ICdSZWplY3RlZCBZVERMIFN1Ym1pc3Npb25zJ1xyXG4gICAgTk9fVEhVTUJOQUlMX1VSTDogJy8vaS55dGltZy5jb20vdmkvaHFkZWZhdWx0LmpwZydcclxuICAgIFZJREVPX0NPTlRBSU5FUl9URU1QTEFURTogJzxsaT48ZGl2IGNsYXNzPVwidmlkZW8tY29udGFpbmVyIHthZGRpdGlvbmFsQ2xhc3N9XCI+PGlucHV0IHR5cGU9XCJidXR0b25cIiBjbGFzcz1cInN1Ym1pdC12aWRlby1idXR0b25cIiB2YWx1ZT1cIlN1Ym1pdCBWaWRlb1wiPjxkaXY+PHNwYW4gY2xhc3M9XCJ2aWRlby10aXRsZVwiPnt0aXRsZX08L3NwYW4+PHNwYW4gY2xhc3M9XCJ2aWRlby1kdXJhdGlvblwiPih7ZHVyYXRpb259KTwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPVwidmlkZW8tdXBsb2FkZWRcIj5VcGxvYWRlZCBvbiB7dXBsb2FkZWREYXRlfTwvZGl2PjxkaXYgY2xhc3M9XCJ0aHVtYm5haWwtY29udGFpbmVyXCIgZGF0YS12aWRlby1pZD1cInt2aWRlb0lkfVwiPjxpbWcgc3JjPVwie3RodW1ibmFpbFVybH1cIiBjbGFzcz1cInRodW1ibmFpbC1pbWFnZVwiPjxpbWcgc3JjPVwiaW1hZ2VzL3BsYXkucG5nXCIgY2xhc3M9XCJwbGF5LW92ZXJsYXlcIj48L2Rpdj48L2Rpdj48L2xpPidcclxuICAgIFZJREVPX0xJX1RFTVBMQVRFOiAnPGxpPjxkaXYgY2xhc3M9XCJ2aWRlby1jb250YWluZXIgezB9XCI+PGlucHV0IHR5cGU9XCJidXR0b25cIiBjbGFzcz1cInN1Ym1pdC12aWRlby1idXR0b25cIiBkYXRhLXZpZGVvLWlkPVwiezF9XCIgZGF0YS1leGlzdGluZy1rZXl3b3Jkcz1cInsyfVwiIHZhbHVlPVwiU3VibWl0IFZpZGVvXCI+PGRpdj48c3BhbiBjbGFzcz1cInZpZGVvLXRpdGxlXCI+ezN9PC9zcGFuPjxzcGFuIGNsYXNzPVwidmlkZW8tZHVyYXRpb25cIj4oezV9KTwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPVwidmlkZW8tdXBsb2FkZWRcIj5VcGxvYWRlZCBvbiB7NH08L2Rpdj48ZGl2IGNsYXNzPVwidGh1bWJuYWlsLWNvbnRhaW5lclwiIGRhdGEtdmlkZW8taWQ9XCJ7MX1cIj48aW1nIHNyYz1cIns2fVwiIGNsYXNzPVwidGh1bWJuYWlsLWltYWdlXCI+PGltZyBzcmM9XCIuL2ltYWdlcy9wbGF5LnBuZ1wiIGNsYXNzPVwicGxheS1vdmVybGF5XCI+PC9kaXY+PC9kaXY+PC9saT4nXHJcbiAgICBBRE1JTl9WSURFT19MSV9URU1QTEFURTogJzxsaT48ZGl2IGNsYXNzPVwidmlkZW8tY29udGFpbmVyXCI+e2J1dHRvbnNIdG1sfTxkaXY+PHNwYW4gY2xhc3M9XCJ2aWRlby10aXRsZVwiPnt0aXRsZX08L3NwYW4+PHNwYW4gY2xhc3M9XCJ2aWRlby1kdXJhdGlvblwiPih7ZHVyYXRpb259KTwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPVwidmlkZW8tdXBsb2FkZWRcIj5VcGxvYWRlZCBvbiB7dXBsb2FkZWREYXRlfSBieSB7dXBsb2FkZXJ9PC9kaXY+PGRpdiBjbGFzcz1cInRodW1ibmFpbC1jb250YWluZXJcIiBkYXRhLXZpZGVvLWlkPVwie3ZpZGVvSWR9XCI+PGltZyBzcmM9XCJ7dGh1bWJuYWlsVXJsfVwiIGNsYXNzPVwidGh1bWJuYWlsLWltYWdlXCI+PGltZyBzcmM9XCIuL2ltYWdlcy9wbGF5LnBuZ1wiIGNsYXNzPVwicGxheS1vdmVybGF5XCI+PC9kaXY+PC9kaXY+PC9saT4nXHJcbiAgICBQTEFZTElTVF9MSV9URU1QTEFURTogJzxsaSBkYXRhLXBsYXlsaXN0LW5hbWU9XCJ7cGxheWxpc3ROYW1lfVwiIGRhdGEtc3RhdGU9XCJlbWJlZC1jb2Rlc1wiIGRhdGEtcGxheWxpc3QtaWQ9XCJ7cGxheWxpc3RJZH1cIj57cGxheWxpc3ROYW1lfTwvbGk+J1xyXG5cclxud2ViY2FtID1cclxuICAgIGluaXQ6ICgpIC0+XHJcbiAgICAgICAgaWYgbm90IFlUPyBvciBub3QgWVQuVXBsb2FkV2lkZ2V0P1xyXG4gICAgICAgICAgICB3aW5kb3cub25Zb3VUdWJlSWZyYW1lQVBJUmVhZHkgPSAoKSAtPlxyXG4gICAgICAgICAgICAgICAgd2ViY2FtLmxvYWRVcGxvYWRXaWRnZXQoKVxyXG4gICAgICAgICAgICAkLmdldFNjcmlwdCgnLy93d3cueW91dHViZS5jb20vaWZyYW1lX2FwaScpXHJcbiAgICAgICAgZWxzZVxyXG4gICAgICAgICAgICB3ZWJjYW0ubG9hZFVwbG9hZFdpZGdldCgpXHJcblxyXG4gICAgbG9hZFVwbG9hZFdpZGdldDogKCkgLT5cclxuICAgICAgICBuZXcgWVQuVXBsb2FkV2lkZ2V0KCd3ZWJjYW0td2lkZ2V0JyxcclxuICAgICAgICAgICAgd2ViY2FtT25seTogdHJ1ZVxyXG4gICAgICAgICAgICBldmVudHM6XHJcbiAgICAgICAgICAgICAgICBvbkFwaVJlYWR5OiAoZXZlbnQpIC0+XHJcbiAgICAgICAgICAgICAgICAgICAgZXZlbnQudGFyZ2V0LnNldFZpZGVvVGl0bGUoY29uZmlnLlZJREVPX1RJVExFIG9yIGNvbnN0YW50cy5XRUJDQU1fVklERU9fVElUTEUpXHJcbiAgICAgICAgICAgICAgICAgICAgZXZlbnQudGFyZ2V0LnNldFZpZGVvRGVzY3JpcHRpb24oY29uZmlnLlZJREVPX0RFU0NSSVBUSU9OIG9yIGNvbnN0YW50cy5XRUJDQU1fVklERU9fREVTQ1JJUFRJT04pXHJcbiAgICAgICAgICAgICAgICAgICAgIyBldmVudC50YXJnZXQuc2V0VmlkZW9LZXl3b3JkcyhbdXRpbHMuZ2VuZXJhdGVLZXl3b3JkRnJvbVBsYXlsaXN0SWQoZ2xvYmFscy5oYXNoUGFyYW1zLnBsYXlsaXN0KV0pXHJcblxyXG4gICAgICAgICAgICAgICAgb25VcGxvYWRTdWNjZXNzOiAoZXZlbnQpIC0+XHJcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJXZWJjYW0gc3VibWlzc2lvbiBzdWNjZXNzIVwiKVxyXG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGV2ZW50KVxyXG4gICAgICAgICAgICAgICAgICAgICQoJyN5b3V0dWJlX2lkJykudmFsKGV2ZW50LmRhdGEudmlkZW9JZClcclxuICAgICAgICAgICAgICAgICAgICB3aW5kb3cuVklEUkVDT1JERVIuY2xvc2UoKVxyXG5cclxuICAgICAgICAgICAgICAgICAgICAjIHV0aWxzLmFkZFZpZGVvVG9QbGF5bGlzdChcIlBlbmRpbmdcIiwgZXZlbnQuZGF0YS52aWRlb0lkKVxyXG5cclxuICAgICAgICAgICAgICAgIG9uU3RhdGVDaGFuZ2U6IChldmVudCkgLT5cclxuICAgICAgICAgICAgICAgICAgICBpZiBldmVudC5kYXRhLnN0YXRlID09IFlULlVwbG9hZFdpZGdldFN0YXRlLkVSUk9SXHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUuZXJyb3IoXCJXZWJjYW0gc3VibWlzc2lvbiBlcnJvciFcIilcclxuICAgICAgICApXHJcblxyXG51dGlscyA9XHJcbiAgICBpdGVtc0luUmVzcG9uc2U6IChyZXNwb25zZSkgLT5cclxuICAgICAgICByZXR1cm4gKCdpdGVtcycgaW4gcmVzcG9uc2UgYW5kIHJlc3BvbnNlLml0ZW1zLmxlbmd0aCA+IDApXHJcblxyXG4gICAgIyBhZGRWaWRlb1RvUGxheWxpc3Q6IChwbGF5bGlzdElkLCB2aWRlb0lkKSAtPlxyXG4gICAgIyAgICAgY29uc29sZS5sb2coXCJUcnlpbmcgdG8gYWRkIHZpZGVvIHRvIHBsYXlsaXN0IVwiKVxyXG4gICAgIyAgICAgY29uc29sZS5sb2codmlkZW9JZClcclxuICAgICMgICAgIGNvbnNvbGUubG9nKHBsYXlsaXN0SWQpXHJcblxyXG4gICAgIyAgICAgbHNjYWNoZS5yZW1vdmUoY29uc3RhbnRzLkdEQVRBX1NFUlZFUiArICcvZmVlZHMvYXBpL3VzZXJzL2RlZmF1bHQvcGxheWxpc3RzJylcclxuICAgICMgICAgIGxzY2FjaGUucmVtb3ZlKHBsYXlsaXN0SWQpXHJcblxyXG4gICAgIyAgICAgcmVxdWVzdCA9IGdhcGkuY2xpZW50LnlvdXR1YmUucGxheWxpc3RJdGVtcy5pbnNlcnQoXHJcbiAgICAjICAgICAgICAgICAgIHBhcnQ6ICdzbmlwcGV0J1xyXG4gICAgIyAgICAgICAgICAgICByZXNvdXJjZTpcclxuICAgICMgICAgICAgICAgICAgICAgIHNuaXBwZXQ6XHJcbiAgICAjICAgICAgICAgICAgICAgICAgICAgcGxheWxpc3RJZDogcGxheWxpc3RJZFxyXG4gICAgIyAgICAgICAgICAgICAgICAgICAgIHJlc291cmNlSWQ6XHJcbiAgICAjICAgICAgICAgICAgICAgICAgICAgICAgIGtpbmQ6ICd5b3V0dWJlI3ZpZGVvJ1xyXG4gICAgIyAgICAgICAgICAgICAgICAgICAgICAgICB2aWRlb0lkOiB2aWRlb0lkXHJcbiAgICAjICAgICAgICAgICAgICAgICAgICAgcG9zaXRpb246IDBcclxuICAgICMgICAgIClcclxuXHJcbiAgICAjICAgICByZXF1ZXN0LmV4ZWN1dGUoKHJlc3BvbnNlKSAtPlxyXG4gICAgIyAgICAgICAgIGlmICdlcnJvcicgaW4gcmVzcG9uc2VcclxuICAgICMgICAgICAgICAgICAgY29uc29sZS5sb2cocmVzcG9uc2UuZXJyb3IpXHJcbiAgICAjICAgICAgICAgICAgIGNvbnNvbGUuZXJyb3IoJ0NvdWxkIG5vdCBhZGQgdmlkZW8gcGxheWxpc3QuICcpXHJcbiAgICAjICAgICAgICAgZWxzZVxyXG4gICAgIyAgICAgICAgICAgICBjb25zb2xlLmxvZygnU3VjY2VzcyBhZGRpbmcgdmlkZW8gdG8gcGxheWxpc3QhJylcclxuICAgICMgICAgIClcclxuXHJcbmF1dGggPVxyXG4gICAgaW5pdEF1dGg6ICgpIC0+XHJcbiAgICAgICAgd2luZG93W2NvbnN0YW50cy5DTElFTlRfTElCX0xPQURfQ0FMTEJBQ0tdID0gKCkgLT5cclxuICAgICAgICAgICAgZ2FwaS5hdXRoLmluaXQoKCkgLT5cclxuICAgICAgICAgICAgICAgIGlmIGxzY2FjaGUuZ2V0KGNvbnN0YW50cy5ESVNQTEFZX05BTUVfQ0FDSEVfS0VZKSAjIEZJWE1FXHJcbiAgICAgICAgICAgICAgICAgICAgd2luZG93LnNldFRpbWVvdXQoKCkgLT5cclxuICAgICAgICAgICAgICAgICAgICAgICAgZ2FwaS5hdXRoLmF1dGhvcml6ZShcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsaWVudF9pZDogY29uZmlnLk9BVVRIMl9DTElFTlRfSURcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNjb3BlOiBbY29uc3RhbnRzLk9BVVRIMl9TQ09QRV1cclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGltbWVkaWF0ZTogdHJ1ZVxyXG4gICAgICAgICAgICAgICAgICAgICAgICAsIGF1dGgub25BdXRoUmVzdWx0KVxyXG4gICAgICAgICAgICAgICAgICAgICwgMSlcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZygnYXV0aCBzY3JpcHQgbGF1bmNoZWQnKVxyXG4gICAgICAgICAgICAgICAgZWxzZVxyXG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKCdyZXF1ZXN0aW5nIFlUIGxvZ2luJylcclxuICAgICAgICAgICAgICAgICAgICAjIGdhcGkuYXV0aC5hdXRob3JpemUoe1xyXG4gICAgICAgICAgICAgICAgICAgICMgICAgIGNsaWVudF9pZDogY29uZmlnLk9BVVRIMl9DTElFTlRfSURcclxuICAgICAgICAgICAgICAgICAgICAjICAgICBzY29wZTogW2NvbnN0YW50cy5PQVVUSDJfU0NPUEVdXHJcbiAgICAgICAgICAgICAgICAgICAgIyAgICAgaW1tZWRpYXRlOiBmYWxzZX1cclxuICAgICAgICAgICAgICAgICAgICAjICAgICAsIGF1dGgub25BdXRoUmVzdWx0XHJcbiAgICAgICAgICAgICAgICAgICAgIyApXHJcbiAgICAgICAgICAgIClcclxuICAgICAgICAkLmdldFNjcmlwdChjb25zdGFudHMuQ0xJRU5UX0xJQl9VUkwgKyBjb25zdGFudHMuQ0xJRU5UX0xJQl9MT0FEX0NBTExCQUNLKVxyXG5cclxuICAgIG9uQXV0aFJlc3VsdDogKGF1dGhSZXN1bHQpIC0+XHJcbiAgICAgICAgaWYgYXV0aFJlc3VsdFxyXG4gICAgICAgICAgICBjb25zb2xlLmxvZygnR290IGF1dGggcmVzdWx0JywgYXV0aFJlc3VsdClcclxuICAgICAgICAgICAgZ2FwaS5jbGllbnQubG9hZChjb25zdGFudHMuWU9VVFVCRV9BUElfU0VSVklDRV9OQU1FLCBjb25zdGFudHMuWU9VVFVCRV9BUElfVkVSU0lPTiwgYXV0aC5vbllvdVR1YmVDbGllbnRMb2FkKVxyXG4gICAgICAgIGVsc2VcclxuICAgICAgICAgICAgY29uc29sZS5sb2coJ0F1dGggZmFpbGVkJylcclxuICAgICAgICAgICAgbHNjYWNoZS5mbHVzaCgpICMgRklYTUVcclxuICAgICAgICAgICAgIyB1dGlscy5yZWRpcmVjdCgnbG9naW4nKVxyXG5cclxuICAgIG9uWW91VHViZUNsaWVudExvYWQ6ICgpIC0+XHJcbiAgICAgICAgIyAgIHZhciBuZXh0U3RhdGUgPSBnbG9iYWxzLmhhc2hQYXJhbXMuc3RhdGUgfHwgJyc7XHJcbiAgICAgICAgIyAgIGlmIChuZXh0U3RhdGUgPT0gJ2xvZ2luJykge1xyXG4gICAgICAgICMgICAgIG5leHRTdGF0ZSA9ICcnO1xyXG4gICAgICAgICMgICB9XHJcbiAgICAgICAgY29uc29sZS5sb2coJ1lvdXR1YmUgY2xpZW50IGxvYWRlZCEnKVxyXG4gICAgICAgIGlmIGxzY2FjaGUuZ2V0KGNvbnN0YW50cy5ESVNQTEFZX05BTUVfQ0FDSEVfS0VZKSAjIEZJWE1FXHJcbiAgICAgICAgICAgICMgdXRpbHMucmVkaXJlY3QobmV4dFN0YXRlKTtcclxuICAgICAgICBlbHNlXHJcbiAgICAgICAgICAgIHJlcXVlc3QgPSBnYXBpLmNsaWVudFtjb25zdGFudHMuWU9VVFVCRV9BUElfU0VSVklDRV9OQU1FXS5jaGFubmVscy5saXN0KFxyXG4gICAgICAgICAgICAgICAgbWluZTogdHJ1ZVxyXG4gICAgICAgICAgICAgICAgcGFydDogJ3NuaXBwZXQsY29udGVudERldGFpbHMsc3RhdHVzJ1xyXG4gICAgICAgICAgICApXHJcbiAgICAgICAgICAgIHJlcXVlc3QuZXhlY3V0ZSggKHJlc3BvbnNlKSAtPlxyXG4gICAgICAgICAgICAgICAgaWYgdXRpbHMuaXRlbXNJblJlc3BvbnNlKHJlc3BvbnNlKSAjIEZJWE1FXHJcbiAgICAgICAgICAgICAgICAgICAgaWYgcmVzcG9uc2UuaXRlbXNbMF0uc3RhdHVzLmlzTGlua2VkXHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGxzY2FjaGUuc2V0KGNvbnN0YW50cy5VUExPQURTX0xJU1RfSURfQ0FDSEVfS0VZLCByZXNwb25zZS5pdGVtc1swXS5jb250ZW50RGV0YWlscy5yZWxhdGVkUGxheWxpc3RzLnVwbG9hZHMpXHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGxzY2FjaGUuc2V0KGNvbnN0YW50cy5ESVNQTEFZX05BTUVfQ0FDSEVfS0VZLCByZXNwb25zZS5pdGVtc1swXS5zbmlwcGV0LnRpdGxlKVxyXG4gICAgICAgICAgICAgICAgICAgICAgICBsc2NhY2hlLnNldChjb25zdGFudHMuUFJPRklMRV9QSUNUVVJFX0NBQ0hFX0tFWSwgcmVzcG9uc2UuaXRlbXNbMF0uc25pcHBldC50aHVtYm5haWxzLmRlZmF1bHQudXJsKVxyXG4gICAgICAgICAgICAgICAgICAgICAgICAjIHV0aWxzLnJlZGlyZWN0KG5leHRTdGF0ZSlcclxuICAgICAgICAgICAgICAgICAgICBlbHNlXHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUuZXJyb3IoJ1lvdXIgYWNjb3VudCBjYW5ub3QgdXBsb2FkIHZpZGVvcy4gUGxlYXNlIHZpc2l0IDxhIHRhcmdldD1cIl9ibGFua1wiIGhyZWY9XCJodHRwczovL3d3dy55b3V0dWJlLmNvbS9zaWduaW4/bmV4dD0vY3JlYXRlX2NoYW5uZWxcIj5odHRwczovL3d3dy55b3V0dWJlLmNvbS9zaWduaW4/bmV4dD0vY3JlYXRlX2NoYW5uZWw8L2E+IHRvIGFkZCBhIFlvdVR1YmUgY2hhbm5lbCB0byB5b3VyIGFjY291bnQsIGFuZCB0cnkgYWdhaW4uJylcclxuICAgICAgICAgICAgICAgIGVsc2VcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhyZXNwb25zZSlcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmVycm9yKFwiVW5hYmxlIHRvIHJldHJpZXZlIGNoYW5uZWwgaW5mby5cIilcclxuICAgICAgICAgICAgKVxyXG5cclxuZG9lc19tZWV0X3JlcXVpcmVtZW50cyA9IC0+XHJcbiAgICBpZiBub3QgJC5zdXBwb3J0LmNvcnNcclxuICAgICAgICBjb25zb2xlLmVycm9yKFwiQnJvd3NlciBub3Qgc3VwcG9ydGVkIVwiKVxyXG4gICAgICAgIHJldHVybiBmYWxzZVxyXG4gICAgZWxzZVxyXG4gICAgICAgIHJldHVybiB0cnVlXHJcblxyXG5cclxuZXhwb3J0cy5zZXR1cCA9IC0+XHJcbiAgICBpZiBub3QgY29uZmlnLk9BVVRIMl9DTElFTlRfSUQgb3Igbm90IGNvbmZpZy5ERVZFTE9QRVJfS0VZXHJcbiAgICAgICAgY29uc29sZS5sb2coXCJOT1QgQ09ORklHVVJFRCFcIilcclxuICAgIGVsc2VcclxuICAgICAgICBjb25zb2xlLmxvZyhcIkNvbmZpZ3VyZWQhXCIpXHJcbiAgICAgICAgaWYgZG9lc19tZWV0X3JlcXVpcmVtZW50c1xyXG4gICAgICAgICAgICBhdXRoLmluaXRBdXRoKClcclxuICAgICAgICAgICAgd2ViY2FtLmluaXQoKVxyXG4iLCJcclxuc2l0ZVVybCA9ICdodHRwOi8vd3d3LnRoYW5rLWEtdGVhY2hlci5vcmcnXHJcblxyXG5zZXR1cEZhY2Vib29rID0gLT5cclxuICAgICQuZ2V0U2NyaXB0ICcvL2Nvbm5lY3QuZmFjZWJvb2submV0L2VuX1VLL2FsbC5qcycsIC0+XHJcbiAgICAgICAgRkIuaW5pdCB7YXBwSWQ6ICcxNDQ0OTU0Njg1NzM1MTc2J31cclxuXHJcbiAgICAkKCcjc2hhcmUtZmFjZWJvb2snKS5jbGljayAtPlxyXG4gICAgICAgIEZCLnVpXHJcbiAgICAgICAgICAgIG1ldGhvZDogJ2ZlZWQnLFxyXG4gICAgICAgICAgICBsaW5rOiBzaXRlVXJsLFxyXG4gICAgICAgICAgICBjYXB0aW9uOiAnVGhhbmsgYSB0ZWFjaGVyISdcclxuXHJcbnNldHVwVHdpdHRlciA9IC0+XHJcbiAgICBlbmNvZGVkID0gZW5jb2RlVVJJQ29tcG9uZW50IHNpdGVVcmxcclxuICAgIHR3aXR0ZXJVcmwgPSBcImh0dHBzOi8vdHdpdHRlci5jb20vc2hhcmU/dXJsPSN7ZW5jb2RlZH0mdmlhPXdtbWVkdVwiXHJcbiAgICAkKCcjc2hhcmUtdHdpdHRlcicpXHJcbiAgICAgICAgLmF0dHIgJ2hyZWYnLCB0d2l0dGVyVXJsXHJcbiAgICAgICAgLmF0dHIgJ3RhcmdldCcsICdfYmxhbmsnXHJcblxyXG5leHBvcnRzLnNldHVwID0gLT5cclxuICAgIHNldHVwRmFjZWJvb2soKVxyXG4gICAgc2V0dXBUd2l0dGVyKClcclxuICAgICJdfQ==
