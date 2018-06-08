;(function ($, undefined) {

  var base = meerkat.modules.addressLookupV2.base;
  var url;

  var postcode = {
    init: function(xpath, fallbackXpath) {
      url = base.getURL();
      this.fallbackXpath = fallbackXpath ? base.formatXpath(fallbackXpath) : null;
      this.xpath = base.formatXpath(xpath);
      this.cacheDom();
      this.setupAutocomplete();
      this.prefillFix();
      this.prefill();
    },
    prefillFix: function() {
      var suburbVal = $(this.xpath + '_suburb').val();
      var fallbackSuburb = $(this.fallbackXpath + '_suburbName').val();
      if (!suburbVal && fallbackSuburb) {
        $(this.xpath + '_suburb').val(fallbackSuburb);
      }
    },
    prefill: function() {
      if (!this.$postcodeInput.val()) {
        var suburb = $(this.xpath + '_suburb').val();
        var state = $(this.xpath + '_state').val();
        var postcode = $(this.xpath + '_postcode').val();
        if (postcode && suburb && state) {
          var inputValue = suburb + ' ' + postcode + ' ' + state;
          this.$postcodeInput.val(inputValue);
        } else if(postcode) {
          this.$postcodeInput.val(postcode);
        }
      }
    },
    cacheDom: function() {
      this.searchInput = '.addressSearchV2--postcodeSearch .addressSearchV2__inputField';
      this.$el = $('.addressSearchV2--postcodeSearch');
      this.$postcodeInput = this.$el.find('.addressSearchV2__inputField');
      this.$results = this.$el.find('.addressSearchV2__results');
    },
    setupAutocomplete: function() {
      var _this = this;
      this.autocomplete = new meerkat.modules.autocompleteV2.initInput({
            selector: _this.searchInput,
            minChars: 0,
            delay: 250,
            cache: false,
            source: function(term, response) {
                _this.settings.url = url + 'suburbpostcode/' + term;
                if (term) {
                  $.ajax(_this.settings).done(function(data) {
                    response(_this.handleData(data));
                  });
                }
            },
            renderItem: function (item, search) {
                return '<div class="autocomplete-suggestion" data-val="' + item + '">' + item + '</div>';
            },
            onSelect: function(event, term, item) {
              _this.handleSelect(term);
            }
        });
    },
    handleData: function(data) {
      this.results = data;
      var handleResult = [];
      for (var i = 0; i < data.length; i++) {
        handleResult.push(data[i].suburb + ' ' + data[i].postcode + ' ' + data[i].state);
      }
      return handleResult;
    },
    handleSelect: function(text) {
      var addressObj = this.results.find(function(result) {
        return text.indexOf(result.suburb) === 0;
      });
      this.fillFields(addressObj);
    },
    fillFields: function(data) {
      console.log('DATA [postcodeSearch]', data);
      console.log('this.xpath', this.xpath);
      $(this.xpath + '_suburb').val(data.suburb);
      $(this.xpath + '_state').val(data.state);
      $(this.xpath + '_postcode').val(data.postcode);
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json'
    }
  };


  function getPostCodeSearch() {
    return $.extend(true, {}, postcode);
  }

  meerkat.modules.extend("addressLookupV2", {
    getPostCodeSearch: getPostCodeSearch
  });

})(jQuery);
