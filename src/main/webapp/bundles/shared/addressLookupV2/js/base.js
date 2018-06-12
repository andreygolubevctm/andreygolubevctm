;(function ($, undefined) {

  function getURL() {
    switch(meerkat.site.environment) {
      case 'nxi': return 'https://dev.comparethemarket.com.au/api/address/';
      case 'localhost': return 'https://dev.comparethemarket.com.au/api/address/';
      case 'nxq': return 'https://uat.comparethemarket.com.au/api/address/';
      default: return 'https://www.comparethemarket.com.au/api/address/';
    }
  }

  function buildOptions(arrayOptions, valueKey, labelKey, placeholderOption) {
    var options = [];
    if (placeholderOption) {
      options.push(meerkat.modules.utils.createElement('option', { children: placeholderOption, value: '' }));
    }
    for (var i = 0; i < arrayOptions.length; i++) {
      var option = meerkat.modules.utils.createElement('option', { children: arrayOptions[i][labelKey], value: arrayOptions[i][valueKey] });
      options.push(option);
    }
    return options;
  }

  function isValidLocation(location) {
      var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);
      value = $.trim(String(location));
      if (value !== '') {
          if (value.match(search_match)) {
              return true;
          }
      }
      return false;
  }

  function getPostcodeFromLocation(location) {
    if (isValidLocation(location)) {
      // location should be like: "Upper Kedron 4055 QLD"
      var postcode = location.match(/\d+/g)[0];
      return postcode;
    }
    return '';
  }

  function formatXpath(xpath) {
    return '#' + xpath.replace(/\//g, '_');
  }

  var base = {
    getPostcodeFromLocation: getPostcodeFromLocation,
    getURL: getURL,
    formatXpath: formatXpath,
    buildOptions: buildOptions,
    noAddressFound: "Can't find address? <span class=\"underline\">Click here.</span>"
  };

  meerkat.modules.register("addressLookupV2", {
    base: base
  });

})(jQuery);
