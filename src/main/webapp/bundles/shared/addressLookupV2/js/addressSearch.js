;(function($, undefined) {
  var noAddressFound = "Can't find address? <span class=\"underline\">click here</span>";
  var doneTypingTime = 250;
  var addressUrl = 'https://nxi.secure.comparethemarket.com.au/address/';
  
  function getTemplate(value) {
    return '<div>'+ value + '</div>';
  }
  
  function getTemplateOptions(value, text) {
    return '<option value="'+ value + '"'+ text + '</option>';
  }
  
  function setValues($element, value) {
    $element.val(value);
  }
  
  var streetAddress = {
    results: [],
    init: function() {
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
      $(document).on('mousedown', '.addressSearchV2__results div', this.clickHandler.bind(this));
    },
    clearResults: function() {
      this.$results.removeClass('addressSearchV2__results--active');
      this.$results.empty();
    },
    renderDropdown: function() {
       this.$results.append(this.htmlElements);
       this.$results.addClass('addressSearchV2__results--active');
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
    search: function(event) {
      this.query = event.target.value;
      clearTimeout(this.typingTimer);
      
      if (this.query.length > 4) {
        this.settings.data = JSON.stringify({ addressLine: this.query });
        this.typingTimer = setTimeout(function() {
          $.ajax(streetAddress.settings).done(function(data) { streetAddress.handleData(data) });
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
      if (event.target.innerHTML === noAddressFound) {
        this.$checkbox.prop('checked', true);
        this.$checkbox.change();
      } else {
        setValues(this.$search, event.target.innerHTML);
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
    init: function() {
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2__cantFindFields');
      this.$postcodeInput = this.$el.find('.addressSearchV2__postcodeSearch input');
      this.$suburbDropdown = this.$el.find('.addressSearchV2__suburbSelect select');
    },
    bindEvents: function() {
      this.$postcodeInput.on('focus keyup', this.search.bind(this));
    },
    renderDropdown: function() {
      this.suburbDropdown.append(this.htmlElements);
    },
    handleData: function(data) {
      this.results = data;
      this.htmlElements = [];
      if (data.length > 0) {
        this.$suburbDropdown.prop('disabled', false);
        for (var i = 0; i < data.length; i++) {
          this.htmlElements.push(getTemplateOptions(data[i].postcode, data[i].suburb));
        }
      } else {
        this.htmlElements.push('Enter Postcode');
        this.$suburbDropdown.prop('disabled', true);
      }
      this.renderDropdown(this.htmlElements);
    },
    search: function(event) {
      this.query = event.target.value;
      if (this.query.length === 4) {
        this.settings.url = addressUrl + 'suburbpostcode/' + this.query;
        $.ajax(this.settings).done(this.handleData);
      }
    },
    settings: {
      type: 'GET',
      dataType: 'json',
      contentType: 'application/json',
    }
  };
  
  var postcodeSearch = {
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
  }
  
  var smartSearch = {
    init: function() {
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      
    },
    bindEvents: function() {
      
    },
    search: function(event) {
      
    },
    settings: {
      type: 'POST',
      dataType: 'json',
      contentType: 'application/json'
    }
  }
  
  function init() {
    streetAddress.init();
    postcodeSearchInCantFindFields.init();
    postcodeSearch.init();
  }
  
	meerkat.modules.register("addressLookupV2", {
    init: init
	});

})(jQuery);