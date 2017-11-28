;(function($, undefined) {
  var noAddressFound = "Can't find address? <span class=\"underline\">click here</span>";
  var doneTypingTime = 250;
  var addressUrl = meerkat.site.urls.base + 'address/';
  var createElement = document.meerkat.modules.utils.createElement;
  
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
      this.$search
        .on('keyup focus', this.search.bind(this))
        .on('blur', this.clearResults.bind(this));
      this.$checkbox.on('change', this.toggleCheckbox.bind(this));
      $(document).on('mousedown touchstart', '.addressSearchV2--street .addressSearchV2__results div', this.clickHandler.bind(this));
    },
    clearResults: function() {
      this.$results
        .removeClass('addressSearchV2__results--active')
        .empty();
    },
    renderDropdown: function() {
       if (this.htmlElements.length > 0) {
         this.$results
           .append(this.htmlElements)
           .addClass('addressSearchV2__results--active');
       } 
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      for (var i = 0; i < data.length; i++) {
        var element = createElement('div', { innerHTML: data[i].text });
        this.htmlElements.push(element);
      }
      this.clearResults();
      this.renderDropdown();
    },
    fillFields: function(data) {
      $(this.xpath + '_state').val(data.state);
      if ($(this.xpath + '_suburbName').find('option[value="'+ data.suburbName +'"]').length === 0) {
        var element = createElement('option', { innerHTML: data.suburbName, value: data.suburbName });
        $(this.xpath + '_suburbName').append(element);
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
          meerkat.modules.comms.post(_this.settings.bind(_this));
        }, doneTypingTime);
      }
    },
    toggleCheckbox: function(event) {
      this.$searchContainer.toggleClass('addressSearchV2__searchContainer--hidden', event.target.checked);
      this.$cantFindField.toggleClass('addressSearchV2__cantFindFields--hidden', !event.target.checked);
    },
    clickHandler: function(event) {
      var text = event.target.innerHTML;
      if (text.indexOf('click here') > 0) {
        this.$checkbox
          .prop('checked', true)
          .change();
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
      url: addressUrl + 'street',
      dataType: 'json',
      contentType: 'application/json',
      onSuccess: function(data) { this.handleData(data); }
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
        this.htmlElements.push(createEl('option', { text: 'Select suburb', value: '' }));
        for (var i = 0; i < data.length; i++) {
          var element = createElement('option', { innerHTML: data[i].suburb, value: data[i].suburb });
          this.htmlElements.push(element);
        }
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
        this.settings.url = addressUrl + 'suburbpostcode/' + this.query;
        meerkat.modules.comms.get(this.settings.bind(_this));
      }
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json',
      onSuccess: function(data) { this.handleData(data); }
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
      this.$postcodeInput
        .on('focus keyup', this.search.bind(this))
        .on('blur', this.clearResults.bind(this));
      $(document).on('mousedown touchstart', '.addressSearchV2--postcodeSearch .addressSearchV2__results div', this.clickHandler.bind(this));
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      for (var i = 0; i < data.length; i++) {
        var props = { innerHTML: data[i].suburb + ' ' + data[i].postcode + ' ' + data[i].state };
        this.htmlElements.push(createElement('div', props));
      }
      this.clearResults();
      this.renderDropdown();
    },
    clearResults: function() {
      this.$results
        .removeClass('addressSearchV2__results--active')
        .empty();
    },
    renderDropdown: function() {
      if (this.htmlElements.length > 0) {
        this.$results
          .append(this.htmlElements)
          .addClass('addressSearchV2__results--active');
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
        meerkat.modules.comms.get(this.settings.bind(this));
      }
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json',
      onSuccess: function(data) { this.handleData(data); }
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
      this.$buttonContainer.toggleClass('addressSearchV2__buttons--hidden', !show);
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
        meerkat.modules.comms.get(this.settings.bind(this));
      }
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json',
      onSuccess: function(data) { this.handleData(data); }
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
      this.$searchField
        .on('keyup focus', this.search.bind(this))
        .on('blur', this.clearResults.bind(this));
      
      $(document).on('mousedown touchstart', '.addressSearchV2--' + this.prefix + ' .addressSearchV2__results div', this.clickResults.bind(this));
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      for (var i = 0; i < data.length; i++) {
        var element = createElement('div', { innerHTML: data[i].text });
        this.htmlElements.push(element);
      }
      this.htmlElements.push(createElement('div', { innerHTML: noAddressFound }));
      this.clearResults();
      this.renderDropdown();
    },
    clearResults: function() {
      this.$results
        .removeClass('addressSearchV2__results--active')
        .empty();
    },
    renderDropdown: function() {
      if (this.htmlElements.length > 0) {
        this.$results
          .append(this.htmlElements)
          .addClass('addressSearchV2__results--active');
      }
    },
    search: function(event) {
      this.query = event.target.value;
      clearTimeout(this.typingTimer);
      var _this = this;
      if (this.query.length > 4 && this.$postcodeInput.val().length === 4) {
        this.settings.data = JSON.stringify({ addressLine: this.query, postCodeOrSuburb: this.$postcodeInput.val() });
        this.typingTimer = setTimeout(function() {
          meerkat.modules.comms.post(_this.settings.bind(_this));
        }, doneTypingTime);
      }
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
        this.$checkbox
          .prop('checked', true)
          .change();
      } else {
        setValues(this.$searchField, text);
        var addressObj = this.results.find(function(result) {
          return result.text === text;
        });
        this.fillFields(addressObj);
      }
    },
    toggleCheckbox: function(event) {
      this.$searchContainer.toggleClass('addressSearchV2__searchContainer--hidden', event.target.checked);
      this.$cantFindField.toggleClass('addressSearchV2__cantFindFields--hidden', !event.target.checked);
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json',
      url: addressUrl + '/streetsuburb',
      onSuccess: function(data) { this.handleData(data); }
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