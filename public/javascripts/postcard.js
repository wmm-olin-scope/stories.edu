// Generated by CoffeeScript 1.7.1
(function() {
  var setup;

  setup = function() {
    var schoolsearch;
    String.prototype.capitalize = function() {
      var word;
      return ((function() {
        var _i, _len, _ref, _results;
        _ref = this.split(/\s+/);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          word = _ref[_i];
          _results.push(word[0].toUpperCase() + word.slice(1).toLowerCase());
        }
        return _results;
      }).call(this)).join(' ');
    };
    schoolsearch = new Bloodhound({
      datumTokenizer: function(d) {
        return Bloodhound.tokenizers.whitespace(d.num);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/schools/by-name?text=%QUERY',
        filter: function(schools) {
          return $.map(schools, function(school) {
            school.name = school.name.capitalize();
            return school;
          });
        }
      }
    });
    schoolsearch.initialize();
    $('#video_button').click(function() {
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
    $('#teacher_name').keyup(function() {
      $('#mailto_name').text($(this).text());
    });
    $('#send_button').click(function() {
      var anon_request, author_name, author_role, contents, mailto_city_state, mailto_name, mailto_role, mailto_school, mailto_street, message, return_email, return_name, teacher_name, teacher_role;
      teacher_name = $('#teacher_name').text();
      teacher_role = $('#teacher_role').text();
      message = $('#freetext').text();
      author_name = $('#author_name').text();
      author_role = $('#author_role').text();
      anon_request = $('#checkbox_input').is(':checked');
      return_name = $('#return_name').text();
      return_email = $('#return_email').text();
      mailto_name = $('#mailto_name').text();
      mailto_role = $('#mailto_role').text();
      mailto_school = $('#mailto_school').text();
      mailto_street = $('#mailto_street').text();
      mailto_city_state = $('#mailto_city_state').text();
      contents = {
        "teacher_name": teacher_name,
        "teacher_role": teacher_role,
        "message": message,
        "author_name": author_name,
        "author_role": author_role,
        "anon_request": anon_request,
        "return_name": return_name,
        "return_email": return_email,
        "mailto_name": mailto_name,
        "mailto_role": mailto_role,
        "mailto_school": mailto_school,
        "mailto_street": mailto_street,
        "mailto_city_state": mailto_city_state
      };
      console.log(contents);
      return contents;
    });
    $("#mailto_school").typeahead(null, {
      displayKey: "name",
      source: schoolsearch.ttAdapter(),
      minLength: 4
    });
    $("#mailto_school").bind("typeahead:selected", function(event, data, dataset) {
      $('#mailto_street').val(data.mailingAddress.capitalize());
      $('#mailto_city_state').val(data.city.capitalize() + ", " + data.state + " " + data.zip);
    });
  };

  $(function() {
    setup();
  });

}).call(this);
