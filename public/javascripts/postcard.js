// Generated by CoffeeScript 1.6.3
var setup;

setup = function() {
  var disableInput, doCitySelection, doSchoolSelection, doStateSelection, enableInput, findTransitions, g, getCityHound, getCityInput, getSchoolHound, getSchoolInput, getStateSelect, makeHound, populateStateOption, stateList;
  g = {};
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
            display: city.capitalize()
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
          school.display = school.name.capitalize();
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
  $('#teacher_name').keyup(function() {
    $('#mailto_name').val($(this).val());
  });
  $('#author_name').keyup(function() {
    $('#return_name').val($(this).val());
  });
  $('#author_role').keyup(function() {
    $('#mailto_role').val($(this).val());
  });
  $('#mailto_school, #mailto_city_state, #mailto_street').focus(function() {
    $('#school_modal').modal('show');
  });
  $('#modal_submit').click(function() {
    $('#school_modal').modal('hide');
    console.log(g.school);
    if (g.school !== void 0) {
      $('#mailto_school').val(g.school.name.capitalize());
      $('#mailto_street').val(g.school.mailingAddress.capitalize());
      return $('#mailto_city_state').val(g.school.city.capitalize() + ", " + g.school.state + " " + g.school.zip);
    }
  });
  $('#send_button').click(function() {
    var anon_request, author_name, author_role, contents, mailto_city_state, mailto_name, mailto_role, mailto_school, mailto_street, message, return_email, return_name, teacher_name, teacher_role;
    teacher_name = $('#teacher_name').val();
    teacher_role = $('#teacher_role').val();
    message = $('#freetext').val();
    author_name = $('#author_name').val();
    author_role = $('#author_role').val();
    anon_request = $('#checkbox_input').is(':checked');
    return_name = $('#return_name').val();
    return_email = $('#return_email').val();
    mailto_name = $('#mailto_name').val();
    mailto_role = $('#mailto_role').val();
    mailto_school = $('#mailto_school').val();
    mailto_street = $('#mailto_street').val();
    mailto_city_state = $('#mailto_city_state').val();
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
    $.post('/postcards', contents, function(err, data) {
      console.log("Post request sent");
      if (err) {
        console.log(err);
      } else {
        console.log(data);
      }
    });
  });
  populateStateOption();
  findTransitions.state();
};

$(function() {
  setup();
});
