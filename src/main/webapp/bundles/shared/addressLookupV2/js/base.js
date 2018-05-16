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
      options.push(createElement('option', { innerHTML: placeholderOption, value: '' }));
    }
    for (var i = 0; i < arrayOptions.length; i++) {
      var option = createElement('option', { innerHTML: arrayOptions[i][labelKey], value: arrayOptions[i][valueKey] });
      options.push(option);
    }
    return options;
  }

  function formatXpath(xpath) {
    return '#' + xpath.replace(/\//g, '_');
  }

  var base = {
    getURL: getURL,
    formatXpath: formatXpath,
    buildOptions: buildOptions,
    noAddressFound: "Can't find address? <span class=\"underline\">Click here.</span>",
    doneTypingTime: 250
  };

  meerkat.modules.extend("addressLookupV2", {
    base: base
  });

})(jQuery);
