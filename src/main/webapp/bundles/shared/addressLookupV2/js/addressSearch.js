;(function($, undefined) {
  var noAddressFound = "Can't find address? <span class=\"underline\">click here</span>";
  var doneTypingTime = 250;
  var createElement = meerkat.modules.utils.createElement;
  
  var addressService = {
    smartSearch: {},
    streetSearch: {},
    postcodeSearchInCantFindFields: {},
    postCodeWithBtns: {},
    postcodeSearch: {},
    toggleBtns: {}
  }; 
  
  function getURL() {
    switch(meerkat.site.environment) {
      case 'nxi':
      case 'localhost': return 'https://nxi.secure.comparethemarket.com.au/address/';
      case 'nxq': return 'https://nxq.secure.comparethemarket.com.au/address/';
      default: return 'https://secure.comparethemarket.com.au/address/';
    }
  }

  function setValues($element, value) {
    $element.val(value);
  }
  
  function formatXpath(xpath) {
    return '#' + xpath.replace(/\//g, '_');
  }
  
  function init() {
    addressBase = getURL();
    
    addressService.streetSearch = {
      results: [],
      init: function(xpath) {
        this.xpath = formatXpath(xpath);
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
        this.htmlElements.push(createElement('div', { innerHTML: noAddressFound }));
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
            $.ajax(_this.settings).done(function(data) { _this.handleData(data); });
          }, doneTypingTime);
        }
      },
      toggleCheckbox: function(event) {
        this.$searchContainer.toggleClass('addressSearchV2__searchContainer--hidden', event.target.checked);
        this.$cantFindField.toggleClass('addressSearchV2__cantFindFields--hidden', !event.target.checked);
      },
      clickHandler: function(event) {
        var text = event.target.innerHTML;
        if (text.indexOf('click here') !== -1) {
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
        method: 'POST',
        url: addressBase + 'street',
        data: {},
        dataType: 'json',
        contentType: 'application/json'
      }
    };
    
    addressService.postcodeSearchInCantFindFields = {
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
          this.htmlElements.push(createElement('option', { text: 'Select suburb', value: '' }));
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
          this.settings.url = addressBase + 'suburbpostcode/' + this.query;
          $.ajax(this.settings).done(function(data) { _this.handleData(data); });
        }
      },
      settings: {
        dataType: 'json',
        contentType: 'application/json'
      }
    };
    
    addressService.postcodeSearch = {
      init: function(xpath) {
        this.xpath = formatXpath(xpath);
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
        var _this = this;
        this.query = event.target.value;
        if (this.query.length > 3) {
          this.settings.url = addressBase + 'suburbpostcode/' + this.query;
          $.ajax(this.settings).done(function(data) { _this.handleData(data); });
        }
      },
      settings: {
        dataType: 'json',
        contentType: 'application/json'
      }
    };
    
    //verticals used: health_v4
    addressService.postCodeWithBtns = {
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
        var _this = this;
        this.query = event.target.value;
        this.showButtons(false);
        if (this.query.length === 4) {
          this.settings.url = addressBase + 'suburbpostcode/' + this.query;
          $.ajax(this.settings).done(function(data) { _this.handleData(data); });
        }
      },
      settings: {
        dataType: 'json',
        contentType: 'application/json'
      }
    };
    
    addressService.smartSearch = {
      init: function(prefix, xpath) {
        this.prefix = prefix;
        this.xpath = formatXpath(xpath);
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
            $.ajax(_this.settings).done(function(data) { _this.handleData(data); });
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
        if (text.indexOf('click here') !== -1) {
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
        method: 'POST',
        url: addressBase + 'streetsuburb',
        dataType: 'json',
        contentType: 'application/json'
      }
    };
    
    addressService.toggleBtns = {
      init: function(checkboxId, targetId) {
        this.targetId = '#' + targetId;
        this.checkboxId = '#' + checkboxId;
        this.cacheDom();
        this.bindEvents();
        this.toggleCheckbox(this.checkboxInput);
      },
      cacheDom: function() {
        this.$target = $(this.targetId);
        this.$checkbox = $(this.checkboxId);
        this.checkboxInput = this.$checkbox.find('input[type=checkbox]');
      },
      bindEvents: function() {
        var _this = this;
        this.checkboxInput.change(function(e) { _this.toggleCheckbox(e.target); });
      },
      toggleCheckbox: function(target) {
        if (target.checked) {
          this.$target.hide();
        } else {
          this.$target.show();
        }
      }
    }
  }
  
  function getToggleBtn() {
    return $.extend(true, {}, addressService.toggleBtns);
  }
  
  function getPostCodeWithBtns() {
    return $.extend(true, {}, addressService.postCodeWithBtns);
  }
  
  function getPostCodeSearch() {
    return $.extend(true, {}, addressService.postcodeSearch);
  }
  
  function getSmartSearch() {
    return $.extend(true, {}, addressService.smartSearch);
  }
  
  function getStreetSearch() {
    return $.extend(true, {}, addressService.streetSearch);
  }
  
  function getHiddenPostcodeSearch() {
    return $.extend(true, {}, addressService.postcodeSearchInCantFindFields);
  }
  
	meerkat.modules.register("addressLookupV2", {
    init: init,
    getSmartSearch: getSmartSearch,
    getHiddenPostcodeSearch: getHiddenPostcodeSearch,
    getStreetSearch: getStreetSearch,
    getPostCodeSearch: getPostCodeSearch,
    getPostCodeWithBtns: getPostCodeWithBtns,
    getToggleBtn: getToggleBtn
	});

})(jQuery);