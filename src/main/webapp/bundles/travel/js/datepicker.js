(function ($, undefined) {

  var departurePicker;
  var returnPicker;

  var elements = {
    departure: document.getElementById('departure'),
    returned: document.getElementById('return'),
    hiddenDeparture: document.getElementById('travel_dates_fromDate'),
    hiddenReturned: document.getElementById('travel_dates_toDate')
  };

  var display = {
    departure: document.getElementById('departureDisplay'),
    returned: document.getElementById('returnDisplay')
  };

  var options = {
    departureOptions: {
      dateFormat: "d/m/y",
      minDate: 'today',
      onOpen: function() {
        display.departure.classList.add('dp__input__item--active');
      },
      onChange: function(selectedDates, dateStr, instance) {
        display.departure.value = dateStr;
        elements.hiddenDeparture.value = dateStr;
        removeValidationErrors(instance);
      },
    	onClose: function(selectedDates, dateStr) {
        display.departure.classList.remove('dp__input__item--active');
        var dates = returnPicker.selectedDates;
        if (dates.length === 2 && dates[0] > dates[1]) {
          dates.reverse();
        }
        if (dates.length === 0 || selectedDates.length === 0 || dates[0].getTime() !== selectedDates[0].getTime()) {
          returnPicker.set('minDate', dateStr);
          returnPicker.setDate(dateStr, true);
          returnPicker.open();
        }
      }
    },
    returnOptions: {
      dateFormat: "d/m/y",
    	mode: 'range',
      minDate: 'today',
      onOpen: function() {
        display.returned.classList.add('dp__input__item--active');
      },
      onChange: function(selectedDates, dateStr, instance) {
        if (instance.selectedDates.length > 1) {
          var dates = instance.selectedDates;
          if (dates[0] > dates[1]) {
            dates.reverse();
          }
          departurePicker.setDate(dates[0], true);
          display.returned.value = formatDate(dates[1]);
          elements.hiddenReturned.value = formatDate(dates[1]);
          removeValidationErrors(instance);
        }
      },
      onClose: function() {
        display.returned.classList.remove('dp__input__item--active');
      }
    }
  };

  function formatDate(date) {
    if (typeof date.getMonth === 'function') {
      var day = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
      var month = date.getMonth() < 9 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1;
      var year = date.getFullYear();
      return day + '/' + month + '/' + year;
    }
    return '';
  }
  
  function removeValidationErrors(target) {
    
  }

  function init() {
    departurePicker = flatpickr(elements.departure, options.departureOptions);
    returnPicker = flatpickr(elements.returned, options.returnOptions);
  }

meerkat.modules.register("travelDatepicker", {
  init: init
});

})(jQuery);
