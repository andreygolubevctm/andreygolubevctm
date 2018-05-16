;(function ($, undefined) {

  var base = meerkat.modules.addressLookupV2.base;
  var url;
  var smartSearch = {
    init: function(prefix, xpath) {
      url = base.getURL();
      this.prefix = prefix;
      this.xpath = base.formatXpath(xpath);
      this.cacheDom();
      this.bindEvents();
      this.setUpDefault();
      this.setupAutocomplete();
    },
    cacheDom: function() {
      this.searchInput = '.addressSearchV2--' + this.prefix + ' .addressSearchV2__searchContainer input';
      this.$el = $('.addressSearchV2--' + this.prefix);
      this.$postcode = this.$el.find('.addressSearchV2__postcodeSearch');
      this.$postcodeInput = this.$postcode.find('input');
      this.$checkbox = this.$el.find('.addressSearchV2__checkbox input');
      this.$searchContainer = this.$el.find('.addressSearchV2__searchContainer');
      this.$searchField = this.$searchContainer.find('input');
      this.$cantFindField = this.$el.find('.addressSearchV2__cantFindFields');
    },
    bindEvents: function() {
      this.$checkbox.on('change', this.toggleCheckbox.bind(this));
    },
    setupAutocomplete: function() {
      var _this = this;
      this.autocomplete = new meerkat.modules.autocompleteV2.initInput({
            selector: _this.searchInput,
            minChars: 4,
            delay: 250,
            cache: false,
            source: function(term, response) {
                _this.settings.data = JSON.stringify({ addressLine: term, postCodeOrSuburb: _this.$postcodeInput.val() });
                $.ajax(_this.settings).done(function(data) {
                  response(_this.handleData(data));
                });
            },
            renderItem: function (item, search) {
                if (item === base.noAddressFound) { return '<div class="autocomplete-suggestion" data-val="">' + item + '</div>'; }
                return '<div class="autocomplete-suggestion" data-val="' + item + '">' + item + '</div>';
            },
            onSelect: function(event, term, item) {
              _this.handleSelect(term);
            }
        });
    },
    handleSelect: function(text) {

      if (text === '') {
        this.$searchField.val('');
        this.$checkbox.prop('checked', true).change();
      } else {
        var selectedData = this.results.find(function(result) {
          return result.text.indexOf(text) > -1;
        });
        this.fillFields(selectedData);
      }
    },
    displayTextFix: function(text, postcode) {
      var postcodeString = ', ' + postcode;
      var stringFix = text.replace(postcodeString, '');
      return stringFix;
    },
    handleData: function(data) {
      this.results = data;
      var displayData = [];
      for (var i = 0; i < data.length; i++) {
        displayData.push(this.displayTextFix(data[i].text, data[i].postCode));
      }
      displayData.push(base.noAddressFound);
      return displayData;
    },
    setUpDefault: function() {
      if (this.prefix === 'Residential') {
        this.$postcodeInput.val($('#health_situation_postcode').val());
      } else {
        this.$checkbox
          .prop('checked', true)
          .change();
      }
    },
    fillFields: function(data) {
      console.log('DATA [smartSearch]', data);
      console.log('this.xpath', this.xpath);
      var streetSearch = data.houseNoSel + ' ' + data.streetName + ', ' + data.suburbName + ' ' + data.state;
      if ($(this.xpath + '_suburb').find('option[value="'+ data.suburbName +'"]').length === 0) {
        $(this.xpath + '_suburb').append(meerkat.modules.utils.createElement('option', { innerHTML: data.suburbName, value: data.suburbName }));
      }
      $(this.xpath + '_suburbName').val(data.suburbName);
      $(this.xpath + '_suburb').find('option[value="'+ data.suburbName +'"]').prop('selected', true);
      $(this.xpath + '_fullAddress').val(data.text);
      $(this.xpath + '_streetSearch').val(streetSearch);
      $(this.xpath + '_state').val(data.state);
      $(this.xpath + '_nonStdStreet').val(data.streetName);
      $(this.xpath + '_streetName').val(data.streetName);
      $(this.xpath + '_streetNum').val(data.houseNoSel);
      $(this.xpath + '_houseNoSel').val(data.houseNoSel);
      $(this.xpath + '_unitShop').val(data.unitSel);
      $(this.xpath + '_gnafid').val(data.gnafid);
      if (data.unitType.length > 0) {
        var str = data.unitType.toLowerCase();
        var fixStringFormat = str.charAt(0).toUpperCase() + str.slice(1);
        $(this.xpath + '_unitType').find('option:contains("'+ fixStringFormat +'")').prop('selected', true);
      }
    },
    toggleCheckbox: function(event) {
      this.$searchContainer.toggleClass('addressSearchV2__searchContainer--hidden', event.target.checked);
      this.$cantFindField.toggleClass('addressSearchV2__cantFindFields--hidden', !event.target.checked);
    },
    settings: {
      method: 'POST',
      url: url + 'streetsuburb',
      dataType: 'json',
      contentType: 'application/json'
    }
  };

  function getSmartSearch() {
    return $.extend(true, {}, smartSearch);
  }

  meerkat.modules.extend("addressLookupV2", {
    getSmartSearch: getSmartSearch
  });

})(jQuery);
