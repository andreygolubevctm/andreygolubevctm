;(function ($, undefined) {

  var toggleBtns = {
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
  };

  function getToggleBtn() {
    return $.extend(true, {}, toggleBtns);
  }

	meerkat.modules.extend("addressLookupV2", {
    getToggleBtn: getToggleBtn
	});

})(jQuery);
