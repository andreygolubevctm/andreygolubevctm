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

  function formatXpath(xpath) {
    return '#' + xpath.replace(/\//g, '_');
  }

  var base = {
    getURL: getURL,
    formatXpath: formatXpath,
    buildOptions: buildOptions,
    noAddressFound: "Can't find address? <span class=\"underline\">Click here.</span>"
  };

  meerkat.modules.register("addressLookupV2", {
    base: base
  });

})(jQuery);
