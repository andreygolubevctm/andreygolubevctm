;(function ($, undefined) {

  var base = meerkat.modules.addressLookupV2.base;
  var url;

  var manualPostcodeSearch = {
    results: [],
    init: function(prefix, xpath) {
      url = base.getURL();
      this.prefix = prefix;
      this.xpath = base.formatXpath(xpath);
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2--' + this.prefix);
      this.$postcodeInput = this.$el.find('.addressSearchV2__postcodeSearch input');
      this.$suburbDropdown = this.$el.find('.addressSearchV2__suburbSelect select');
      this.$postcodeLastSearch = this.$el.find('.addressSearchV2__lastPostcodeSearch');
    },
    bindEvents: function() {
      this.$postcodeInput.on('focus keyup', this.search.bind(this));
    },
    renderDropdown: function() {
      this.$suburbDropdown.append(this.htmlElements);
    },
    handleData: function(data) {
      console.log('DATA [manualPostcodeSearch]', data);
      this.results = data;
      this.htmlElements = [];
      this.$suburbDropdown.empty();
      if (data.length > 0) {
        this.$suburbDropdown.prop('disabled', false);
        this.htmlElements = base.buildOptions(data, 'suburb', 'suburb', 'Select suburb');
        $(this.xpath + '_state').val(data[0].state);
      } else {
        this.htmlElements.push('Enter Postcode');
        this.$suburbDropdown.prop('disabled', true);
      }
      this.renderDropdown(this.htmlElements);
    },
    search: function(event) {
      this.query = event.target.value;
      var _this = this;
      if (this.query.length === 4 && this.$postcodeLastSearch.val() !== this.query) {
        this.$postcodeLastSearch.val(this.query);
        this.settings.url = url + 'suburbpostcode/' + this.query;
        $.ajax(this.settings).done(function(data) { _this.handleData(data); });
      }
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json'
    }
  };

  function getManualPostcodeSearch() {
    return $.extend(true, {}, manualPostcodeSearch);
  }

  meerkat.modules.extend("addressLookupV2", {
    getManualPostcodeSearch: getManualPostcodeSearch
  });

})(jQuery);
