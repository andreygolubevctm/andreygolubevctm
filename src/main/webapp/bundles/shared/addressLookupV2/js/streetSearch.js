;(function ($, undefined) {

  var base = meerkat.modules.addressLookupV2.base;

  var streetSearch = {
    results: [],
    init: function(xpath) {
      this.xpath = base.formatXpath(xpath);
      this.cacheDom();
      this.bindEvents();
      this.setupAutocomplete();
    },
    setupAutocomplete: function() {
      var _this = this;
      this.autocomplete = new meerkat.modules.autocompleteV2.initInput({
            selector: _this.searchInput,
            minChars: 4,
            delay: 250,
            cache: false,
            source: function(term, response) {
                var settings = _this.getSettings();
                settings.data = JSON.stringify({ addressLine: term });
                $.ajax(settings).done(function(data) {
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
        this.$checkbox.prop('checked', true).change();
      } else {
        var selectedData = this.results.find(function(result) {
          return result.text === text;
        });
        this.fillFields(selectedData);
      }
    },
    handleData: function(data) {
      this.results = data;
      var displayData = [];
      for (var i = 0; i < data.length; i++) {
        displayData.push(data[i].text);
      }
      displayData.push(base.noAddressFound);
      return displayData;
    },
    cacheDom: function() {
      this.searchInput = '.addressSearchV2--street .addressSearchV2__searchContainer input';
      this.$el = $('.addressSearchV2--street');
      this.$searchContainer = this.$el.find('.addressSearchV2__searchContainer');
      this.$cantFindField = this.$el.find('.addressSearchV2__cantFindFields');
      this.$checkbox = this.$el.find('.addressSearchV2__checkbox input');
      this.$search = this.$searchContainer.find('input');
    },
    bindEvents: function() {
      this.$checkbox.on('change', this.toggleCheckbox.bind(this));
    },
    fillFields: function(data) {
        console.log('DATA [streetSearch]', data);
        console.log('this.xpath', this.xpath);
      $(this.xpath + '_state').val(data.state);
      if ($(this.xpath + '_suburbName').find('option[value="'+ data.suburbName +'"]').length === 0) {
        var element = meerkat.modules.utils.createElement('option', { children: data.suburbName, value: data.suburbName });
        $(this.xpath + '_suburbName').append(element);
      }
      $(this.xpath + '_nonStdPostCode').val(data.postCode);
      $(this.xpath + '_postCode').val(data.postCode);
      $(this.xpath + '_suburb').val(data.suburbName);
      $(this.xpath + '_suburbName').find('option[value="'+ data.suburbName +'"]').prop('selected', true);
      $(this.xpath + '_streetName').val(data.streetName);
      $(this.xpath + '_nonStdStreet').val(data.streetName);
      $(this.xpath + '_streetNum').val(data.houseNoSel);
      $(this.xpath + '_houseNoSel').val(data.houseNoSel);
      $(this.xpath + '_unitSel').val(data.unitSel);
      $(this.xpath + '_fullAddress').val(data.text);
      $(this.xpath + '_fullAddressLineOne').val(data.text);
      $(this.xpath + '_gnafID').val(data.gnafId);
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
    getSettings: function() {
      return {
        method: 'POST',
        url: base.getURL() + 'street',
        data: {},
        dataType: 'json',
        contentType: 'application/json'
      }
    }
  };

  function getStreetSearch() {
    return $.extend(true, {}, streetSearch);
  }

  meerkat.modules.extend("addressLookupV2", {
    getStreetSearch: getStreetSearch
  });

})(jQuery);
