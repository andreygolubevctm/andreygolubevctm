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
      dateFormat: "dd/mm/y",
      minDate: 'today',
      onOpen: function() {
        display.departure.classList.add('dp__input__item--active');
      },
      onChange: function(selectedDates, dateStr, instance) {
        display.departure.value = formatDate(instance.selectedDates[0]);
        elements.hiddenDeparture.value = formatDate(instance.selectedDates[0]);    
      },
    	onClose: function(selectedDates, dateStr) {
        display.departure.classList.remove('dp__input__item--active');
        returnPicker.set('minDate', dateStr);
        returnPicker.setDate(dateStr, true);
        returnPicker.open();
      }
    },
    returnOptions: {
      dateFormat: "dd/mm/y",
    	mode: 'range',
      minDate: 'today',
      onOpen: function() {
        display.returned.classList.add('dp__input__item--active');
      },
      onChange: function(selectedDates, dateStr, instance) {
        if (instance.selectedDates.length > 1) {
          display.returned.value = formatDate(instance.selectedDates[1]);
          elements.hiddenReturned.value = formatDate(instance.selectedDates[1]);
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
      var month = date.getMonth() < 10 ? '0' + date.getMonth() : date.getMonth();
      var year = date.getFullYear();
      return day + '/' + month + '/' + year;
    }
    return '';
  }

  function init() {
    departurePicker = flatpickr(elements.departure, options.departureOptions);
    returnPicker = flatpickr(elements.returned, options.returnOptions);
  }

meerkat.modules.register("travelDatepicker", {
  init: init
});

})(jQuery);