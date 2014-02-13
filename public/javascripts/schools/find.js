// Generated by CoffeeScript 1.6.3
var disableInput, doByCitySchoolSelection, doByZipSchoolSelection, doCitySelection, doStateSelection, doZipSelection, enableInput, findByCityTransitions, findByZipTransitions, getByCitySchoolHound, getByCitySchoolInput, getByZipSchoolHound, getByZipSchoolInput, getCityHound, getCityInput, getStateSelect, getZipInput, makeHound, populateStateOption, stateList, toTitleCase;

toTitleCase = function(string) {
  var letters, smallWords;
  smallWords = /^(a|an|and|as|at|but|by|en|for|if|in|nor|of|on|or|per|the|to|vs?\.?|via)$/i;
  letters = /[A-Za-z0-9\u00C0-\u00FF]+[^\s-]*/g;
  return string.toLowerCase().replace(letters, function(match, index, title) {
    if (index > 0 && index + match.length !== title.length && match.search(smallWords) > -1 && title.charAt(index - 2) !== ':' && (title.charAt(index + match.length) !== '-' || title.charAt(index - 1) === '-') && title.charAt(index - 1).search(/[^\s-]/) < 0) {
      return match.toLowerCase();
    } else if (match.substr(1).search(/[A-Z]|\../) > -1) {
      return match;
    } else {
      return match.charAt(0).toUpperCase() + match.substr(1);
    }
  });
};

getStateSelect = function() {
  return $('#find-by-city #state-select');
};

getCityInput = function() {
  return $('#find-by-city #city-input');
};

getByCitySchoolInput = function() {
  return $('#find-by-city-school');
};

getZipInput = function() {
  return $('#find-by-zip #zip');
};

getByZipSchoolInput = function() {
  return $('#find-by-zip #find-by-zip-school');
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

findByCityTransitions = {
  state: function() {
    getStateSelect().val('');
    disableInput(getCityInput(), 'Select a state first...');
    disableInput(getByCitySchoolInput(), 'Select a state first...');
    return doStateSelection();
  },
  city: function(state) {
    enableInput(getCityInput(), 'City');
    disableInput(getByCitySchoolInput(), 'Select a city first...');
    return doCitySelection(state);
  },
  school: function(state, city) {
    enableInput(getByCitySchoolInput(), 'School');
    return doByCitySchoolSelection(state, city);
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
      findByCityTransitions.state();
    } else if (state !== oldState) {
      findByCityTransitions.city(state);
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
          display: toTitleCase(city)
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
    return findByCityTransitions.school(state, city);
  });
};

getByCitySchoolHound = function(state, city) {
  return makeHound({
    url: "/schools/by-city/" + state + "/" + (encodeURIComponent(city.name)),
    filter: function(schools) {
      var school, _i, _len;
      for (_i = 0, _len = schools.length; _i < _len; _i++) {
        school = schools[_i];
        school.display = toTitleCase(school.name);
      }
      return schools;
    },
    accessor: function(school) {
      return school.name;
    }
  });
};

doByCitySchoolSelection = function(state, city) {
  var hound, input;
  hound = getByCitySchoolHound(state, city);
  input = getByCitySchoolInput();
  input.typeahead('destroy');
  input.typeahead(null, {
    name: 'schools',
    displayKey: 'display',
    source: hound.ttAdapter()
  });
  input.focus();
  input.off('typeahead:selected');
  return input.on('typeahead:selected', function(obj, school) {
    return console.log(school);
  });
};

findByZipTransitions = {
  zip: function() {
    getZipInput().val('');
    disableInput(getByZipSchoolInput(), 'Input a ZIP code first...');
    return doZipSelection();
  },
  school: function(zip) {
    enableInput(getByZipSchoolInput(), 'School');
    return doByZipSchoolSelection(zip);
  }
};

doZipSelection = function() {
  var input, setError;
  input = getZipInput();
  setError = function(error) {
    return input.parents('.form-group').first().toggleClass('has-error', error);
  };
  input.off('input');
  return input.on('input', function() {
    var zip;
    disableInput(getByZipSchoolInput(), 'Input a ZIP code first...');
    zip = input.val();
    if (/[0-9]{5}/.test(zip)) {
      setError(false);
      return findByZipTransitions.school(zip);
    } else {
      return setError(/[^0-9]/.test(zip));
    }
  });
};

getByZipSchoolHound = function(zip) {
  return makeHound({
    url: "/schools/by-zip/" + zip,
    filter: function(schools) {
      var school, _i, _len;
      for (_i = 0, _len = schools.length; _i < _len; _i++) {
        school = schools[_i];
        school.display = toTitleCase(school.name);
      }
      return schools;
    },
    accessor: function(school) {
      return school.name;
    }
  });
};

doByZipSchoolSelection = function(zip) {
  var hound, input;
  hound = getByZipSchoolHound(zip);
  input = getByZipSchoolInput();
  input.typeahead('destroy');
  input.typeahead(null, {
    name: 'schools',
    displayKey: 'display',
    source: hound.ttAdapter()
  });
  input.focus();
  input.off('typeahead:selected');
  return input.on('typeahead:selected', function(obj, school) {
    return console.log(school);
  });
};

$(function() {
  populateStateOption();
  findByCityTransitions.state();
  return findByZipTransitions.zip();
});
