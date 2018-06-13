;(function ($, undefined) {

  var base = meerkat.modules.addressLookupV2.base;
  var url;

  var postCodeWithBtns = {
    init: function(xpath) {
      url = base.getURL();
      this.xpath = base.formatXpath(xpath);
      this.cacheDom();
      this.bindEvents();
    },
    cacheDom: function() {
      this.$el = $('.addressSearchV2--postcode');
      this.$postcodeInput = this.$el.find('.addressSearchV2__input');
      this.$buttonContainer = this.$el.find('.addressSearchV2__buttons');
      this.$buttons = this.$el.find('.addressSearchV2__buttons button');
      this.$stateValue = this.$el.find('.addressSearchV2__stateValue');
      this.$suburbDropdown = $(this.xpath + '_suburb');
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
        this.appendSuburbDropdown(this.data);
        this.appendState(event.target.textContent);
      }
    },
    showButtons: function(show) {
      this.$buttonContainer.toggleClass('addressSearchV2__buttons--hidden', !show);
    },
    appendState: function(state) {
      this.$stateValue.val(state);
    },
    appendSuburbDropdown: function(suburbData) {
      if (suburbData.length > 0) {
        this.$suburbDropdown.empty();
        this.$suburbDropdown.append(base.buildOptions(suburbData, 'suburb', 'suburb', 'Select suburb'));
      }
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
        this.appendSuburbDropdown(data);
      }
    },
    handleData: function(data) {
      if (data.length > 0) {
        this.data = data;
        this.checkMultipleState(data);
      }
    },
    search: function(event) {
      var _this = this;
      this.query = event.target.value;
      this.showButtons(false);
      if (this.query.length === 4) {
        this.settings.url = url + 'suburbpostcode/' + this.query;
        $.ajax(this.settings).done(function(data) { _this.handleData(data); });
      }
    },
    settings: {
      dataType: 'json',
      contentType: 'application/json'
    }
  };

  function getPostCodeWithBtns() {
    return $.extend(true, {}, postCodeWithBtns);
  }

  meerkat.modules.extend("addressLookupV2", {
    getPostCodeWithBtns: getPostCodeWithBtns
  });

})(jQuery);
