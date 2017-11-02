;(function($, undefined) {
  var noAddressFound = "Can't find address? <span class=\"underline\">click here</span>";
  var doneTypingTime = 250;
  var addressUrl = meerkat.site.environment === 'pro' ? 'https://secure.comparethemarket.com.au/address/' : 'https://nxi.secure.comparethemarket.com.au/address/';
  
  function getTemplate(value) {
    return '<div>'+ value + '</div>';
  }
  
  function getTemplateOptions(text) {
    return '<option value="'+ text + '">'+ text + '</option>';
  }
  
  function setValues($element, value) {
    $element.val(value);
  }
  
  var streetSearch = {
    results: [],
    init: function(xpath) {
      this.xpath = '#' + xpath.replace(/\//g, '_');
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2--street');
      this.$searchContainer = this.$el.find('.addressSearchV2__searchContainer');
      this.$cantFindField = this.$el.find('.addressSearchV2__cantFindFields');
      this.$results = this.$el.find('.addressSearchV2__results');
      this.$checkbox = this.$el.find('.addressSearchV2__checkbox input');
      this.$search = this.$searchContainer.find('input');
    },
    bindEvents: function() {
      this.$search.on('keyup focus', this.search.bind(this));
      this.$search.on('blur', this.clearResults.bind(this));
      this.$checkbox.on('change', this.toggleCheckbox.bind(this));
      $(document).on('mousedown', '.addressSearchV2--street .addressSearchV2__results div', this.clickHandler.bind(this));
    },
    clearResults: function() {
      this.$results.removeClass('addressSearchV2__results--active');
      this.$results.empty();
    },
    renderDropdown: function() {
       if (this.htmlElements.length > 0) {
         this.$results.append(this.htmlElements);
         this.$results.addClass('addressSearchV2__results--active');
       } 
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      for (var i = 0; i < data.length; i++) {
        this.htmlElements.push(getTemplate(data[i].text));
      }
      this.clearResults();
      this.renderDropdown();
    },
    fillFields: function(data) {
      $(this.xpath + '_state').val(data.state);
      if ($(this.xpath + '_suburbName').find('option[value="'+ data.suburbName +'"]').length === 0) {
        $(this.xpath + '_suburbName').append(getTemplateOptions(data.suburbName));
      }
      $(this.xpath + '_postCode').val(data.postCode);
      $(this.xpath + '_suburb').val(data.suburbName);
      $(this.xpath + '_suburbName').find('option[value="'+ data.suburbName +'"]').prop('selected', true);
      $(this.xpath + '_streetName').val(data.streetName);
      $(this.xpath + '_streetNum').val(data.houseNoSel);
      $(this.xpath + '_unitType').val(data.unitSel);
      $(this.xpath + '_fullAddressLineOne').val(data.text);
      if (data.unitType.length > 0) {
        var str = data.unitType.toLowerCase();
        var fixStringFormat = str.charAt(0).toUpperCase() + str.slice(1);
        $(this.xpath + '_unitType').find('option[text="'+ fixStringFormat +'"]').prop('selected', true);
      }
    },
    search: function(event) {
      this.query = event.target.value;
      clearTimeout(this.typingTimer);
      var _this = this;
      if (this.query.length > 4) {
        this.settings.data = JSON.stringify({ addressLine: this.query });
        this.typingTimer = setTimeout(function() {
          $.ajax(_this.settings).done(function(data) { _this.handleData(data); });
        }, doneTypingTime);
      }
    },
    toggleCheckbox: function(event) {
      if (event.target.checked) {
        this.$searchContainer.addClass('addressSearchV2__searchContainer--hidden');
        this.$cantFindField.removeClass('addressSearchV2__cantFindFields--hidden');
      } else {
        this.$searchContainer.removeClass('addressSearchV2__searchContainer--hidden');
        this.$cantFindField.addClass('addressSearchV2__cantFindFields--hidden');
      }
    },
    clickHandler: function(event) {
      var text = event.target.innerHTML;
      if (text.indexOf('click here') > 0) {
        this.$checkbox.prop('checked', true);
        this.$checkbox.change();
      } else {
        setValues(this.$search, text);
        var addressObj = this.results.find(function(result) {
          return result.text === text;
        });
        this.fillFields(addressObj);
      }
    },
    settings: {
      data: {},
      type: 'POST',
      url: addressUrl + 'street',
      dataType: 'json',
      contentType: 'application/json'
    }
  };
  
  var postcodeSearchInCantFindFields = {
    results: [],
    init: function(prefix) {
      this.prefix = prefix;
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
      this.results = data;
      this.htmlElements = [];
      this.$suburbDropdown.empty();
      if (data.length > 0) {
        this.$suburbDropdown.prop('disabled', false);
        this.htmlElements.push(getTemplateOptions('Select suburb'));
        for (var i = 0; i < data.length; i++) {
          this.htmlElements.push(getTemplateOptions(data[i].suburb));
        }
      } else {
        this.htmlElements.push('Enter Postcode');
        this.$suburbDropdown.prop('disabled', true);
      }
      this.renderDropdown(this.htmlElements);
    },
    preloadFields: function() {
    },
    search: function(event) {
      this.query = event.target.value;
      var _this = this;
      if (this.query.length === 4 && this.$postcodeLastSearch.val() !== this.query) {
        this.$postcodeLastSearch.val(this.query);
        this.settings.url = addressUrl + 'suburbpostcode/' + this.query;
        $.ajax(this.settings).done(this.handleData.bind(_this));
      }
    },
    settings: {
      type: 'GET',
      dataType: 'json',
      contentType: 'application/json',
    }
  };
  
  var postcodeSearch = {
    init: function(xpath) {
      this.xpath = '#' + xpath.replace(/\//g, '_');
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2--postcodeSearch');
      this.$postcodeInput = this.$el.find('.addressSearchV2__inputField');
      this.$results = this.$el.find('.addressSearchV2__results');
    },
    bindEvents: function() {
      this.$postcodeInput.on('focus keyup', this.search.bind(this));
      this.$postcodeInput.on('blur', this.clearResults.bind(this));
      $(document).on('mousedown', '.addressSearchV2--postcodeSearch .addressSearchV2__results div', this.clickHandler.bind(this));
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      for (var i = 0; i < data.length; i++) {
        var displayPostcode = data[i].suburb + ' ' + data[i].postcode + ' ' + data[i].state;
        this.htmlElements.push(getTemplate(displayPostcode));
      }
      this.clearResults();
      this.renderDropdown();
    },
    clearResults: function() {
      this.$results.removeClass('addressSearchV2__results--active');
      this.$results.empty();
    },
    renderDropdown: function() {
      if (this.htmlElements.length > 0) {
        this.$results.append(this.htmlElements);
        this.$results.addClass('addressSearchV2__results--active');
      }
    },
    fillFields: function(data) {
      $(this.xpath + '_suburb').val(data.suburb);
      $(this.xpath + '_state').val(data.state);
      $(this.xpath + '_postcode').val(data.postcode);
    },
    clickHandler: function(event) {
      this.$postcodeInput.val(event.target.innerHTML);
      var addressObj = this.results.find(function(result) {
        return event.target.innerHTML.indexOf(result.suburb) === 0;
      });
      this.fillFields(addressObj);
    },
    search: function() {
      this.query = event.target.value;
      if (this.query.length === 4) {
        this.settings.url = addressUrl + 'suburbpostcode/' + this.query;
        $.ajax(this.settings).done(this.handleData.bind(this));
      }
    },
    settings: {
      type: 'GET',
      dataType: 'json',
      contentType: 'application/json',
    }
  };
  
  //verticals used: health_v4
  var postcode = {
    init: function() {
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2--postcode');
      this.$postcodeInput = this.$el.find('.addressSearchV2__input');
      this.$buttonContainer = this.$el.find('.addressSearchV2__buttons');
      this.$buttons = this.$el.find('.addressSearchV2__buttons button');
      this.$stateValue = this.$el.find('.addressSearchV2__stateValue');
    },
    bindEvents: function() {
      this.$postcodeInput.on('focus keyup', this.search.bind(this));
      this.$buttons.on('click', this.buttonClick.bind(this));
    },
    renderStateButtons: function(states) {
      this.showButtons(true);
      this.$buttons[0].textContent = states[0];
      this.$buttons[1].textContent = states[1];
    },
    buttonClick: function(event) {
      var $target = $(event.target);
      if (!$target.hasClass('selected')) {
        this.$buttons.removeClass('selected');
        $target.addClass('selected');
        this.appendState(event.target.textContent);
      }
    },
    showButtons: function(show) {
      if (show) {
        this.$buttonContainer.removeClass('addressSearchV2__buttons--hidden');
      } else {
        this.$buttonContainer.addClass('addressSearchV2__buttons--hidden');
      }
    },
    appendState: function(state) {
      this.$stateValue.val(state);
    },
    checkMultipleState: function(data) {
      var states = [data[0].state];
      for (var i = 1; i < data.length; i++) {
        if (states[0] !== data[i].state) {
          states.push(data[i].state);
          this.renderStateButtons(states);
          break;
        }
      }
      if (states.length === 1) {
        this.appendState(states[0]);
      }
    },
    handleData: function(data) {
      if (data.length > 0) {
        this.checkMultipleState(data);
      }
    },
    search: function(event) {
      this.query = event.target.value;
      this.showButtons(false);
      if (this.query.length === 4) {
        this.settings.url = addressUrl + 'suburbpostcode/' + this.query;
        $.ajax(this.settings).done(this.handleData.bind(this));
      }
    },
    settings: {
      type: 'GET',
      dataType: 'json',
      contentType: 'application/json',
    }
  };
  
  var smartSearch = {
    init: function(prefix, xpath) {
      this.prefix = prefix;
      this.xpath = '#' + xpath.replace(/\//g, '_');
      this.cacheDom();
      this.bindEvents();
      this.setUpDefault();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2--' + this.prefix);
      this.$postcode = this.$el.find('.addressSearchV2__postcodeSearch');
      this.$postcodeInput = this.$postcode.find('input');
      this.$checkbox = this.$el.find('.addressSearchV2__checkbox input');
      this.$searchContainer = this.$el.find('.addressSearchV2__searchContainer');
      this.$searchField = this.$searchContainer.find('input');
      this.$cantFindField = this.$el.find('.addressSearchV2__cantFindFields');
      this.$results = this.$el.find('.addressSearchV2__results');
    },
    bindEvents: function() {
      this.$checkbox.on('change', this.toggleCheckbox.bind(this));
      this.$searchField.on('keyup focus', this.search.bind(this));
      this.$searchField.on('blur', this.clearResults.bind(this));
      $(document).on('mousedown', '.addressSearchV2--' + this.prefix + ' .addressSearchV2__results div', this.clickResults.bind(this));
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      for (var i = 0; i < data.length; i++) {
        this.htmlElements.push(getTemplate(data[i].text));
      }
      this.htmlElements.push(getTemplate(noAddressFound));
      this.clearResults();
      this.renderDropdown();
    },
    clearResults: function() {
      this.$results.removeClass('addressSearchV2__results--active');
      this.$results.empty();
    },
    renderDropdown: function() {
      if (this.htmlElements.length > 0) {
        this.$results.append(this.htmlElements);
        this.$results.addClass('addressSearchV2__results--active');
      }
    },
    search: function(event) {
      this.query = event.target.value;
      clearTimeout(this.typingTimer);
      var _this = this;
      if (this.query.length > 4 && this.$postcodeInput.val().length === 4) {
        this.settings.data = JSON.stringify({ addressLine: this.query, postCodeOrSuburb: this.$postcodeInput.val() });
        this.typingTimer = setTimeout(function() {
          $.ajax(_this.settings).done(function(data) { _this.handleData(data); });
        }, doneTypingTime);
      }
    },
    setUpDefault: function() {
      if (this.prefix === 'Residential') {
        this.$postcodeInput.val($('#health_situation_postcode').val());
      } else {
        this.$checkbox.prop('checked', true);
        this.$checkbox.change();
      }
    },
    fillFields: function(data) {
      $(this.xpath + '_state').val(data.state);
      $(this.xpath + '_suburb').find('option[value="'+ data.suburbName +'"]').prop('selected', true);
      $(this.xpath + '_nonStdStreet').val(data.streetName);
      $(this.xpath + '_streetNum').val(data.houseNoSel);
      $(this.xpath + '_unitShop').val(data.unitSel);
      if (data.unitType.length > 0) {
        $(this.xpath + '_unitType').find('option[text="'+ data.unitType +'"]').prop('selected', true);
      }
    },
    clickResults: function(event) {
      var text = event.target.innerHTML;
      if (text.indexOf('click here') > 0) {
        this.$checkbox.prop('checked', true);
        this.$checkbox.change();
      } else {
        setValues(this.$searchField, text);
        var addressObj = this.results.find(function(result) {
          return result.text === text;
        });
        this.fillFields(addressObj);
      }
    },
    toggleCheckbox: function(event) {
      if (event.target.checked) {
        this.$searchContainer.addClass('addressSearchV2__searchContainer--hidden');
        this.$cantFindField.removeClass('addressSearchV2__cantFindFields--hidden');
      } else {
        this.$searchContainer.removeClass('addressSearchV2__searchContainer--hidden');
        this.$cantFindField.addClass('addressSearchV2__cantFindFields--hidden');
      }
    },
    settings: {
      type: 'POST',
      dataType: 'json',
      contentType: 'application/json',
      url: addressUrl + '/streetsuburb'
    }
  };
  
  function getPostCodeWithBtns() {
    return $.extend(true, {}, postcode);
  }
  
  function getPostCodeSearch() {
    return $.extend(true, {}, postcodeSearch);
  }
  
  function getSmartSearch() {
    return $.extend(true, {}, smartSearch);
  }
  
  function getStreetSearch() {
    return $.extend(true, {}, streetSearch);
  }
  
  function getHiddenPostcodeSearch() {
    return $.extend(true, {}, postcodeSearchInCantFindFields);
  }
  
	meerkat.modules.register("addressLookupV2", {
    getSmartSearch: getSmartSearch,
    getHiddenPostcodeSearch: getHiddenPostcodeSearch,
    getStreetSearch: getStreetSearch,
    getPostCodeSearch: getPostCodeSearch,
    getPostCodeWithBtns: getPostCodeWithBtns
	});

})(jQuery);