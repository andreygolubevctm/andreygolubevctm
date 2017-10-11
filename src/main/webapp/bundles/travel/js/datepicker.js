(function ($, undefined) {

  var departurePicker;
  var returnPicker;
  var currentDate = new Date();
  var dateDiff = '';

  var elements = {
    departure: document.getElementById('departure'),
    returned: document.getElementById('return'),
    hiddenDeparture: document.getElementById('travel_dates_fromDate'),
    hiddenReturned: document.getElementById('travel_dates_toDate'),
  };

  var display = {
    departure: document.getElementById('departureDisplay'),
    returned: document.getElementById('returnDisplay')
  };

  var options = {
    departureOptions: {
      dateFormat: "d/m/y",
      minDate: 'today',
      maxDate: new Date(currentDate.getFullYear() + 1, currentDate.getMonth(), currentDate.getDate()),
      onOpen: function() {
        display.departure.classList.add('dp__input__item--active');
      },
      onChange: function(selectedDates, dateStr, instance) {
        var dateArray = dateStr.split('/');
        dateArray[2] = '20' + dateArray[2];
        display.departure.value = dateArray.join('/');
        removeValidationErrors(instance);
        setValueToHiddenFields(
          {
            name: 'fromDate',
            dateString: dateStr
          }
        );
      },

    	onClose: function(selectedDates, dateStr) {
        display.departure.classList.remove('dp__input__item--active');
        var dates = returnPicker.selectedDates;
        if (dates.length === 2 && dates[0] > dates[1]) {
          dates.reverse();
        }
        if (dates.length === 0 || selectedDates.length === 0 || dates[0].getTime() !== selectedDates[0].getTime()) {
          var dateArray = display.departure.value.split('/').reverse();
          returnPicker.set('minDate', dateStr);
          returnPicker.set('maxDate', new Date(Number(dateArray[0]) + 1, dateArray[1], dateArray[2]));
          returnPicker.setDate(dateStr, true);
          returnPicker.open();
        }
      }
    },
    returnOptions: {
      dateFormat: "d/m/y",
    	mode: 'range',
      minDate: 'today',
      maxDate: new Date(currentDate.getFullYear() + 1, currentDate.getMonth(), currentDate.getDate()),
      onOpen: function(selectedDates, dateStr, instance) {
        display.returned.classList.add('dp__input__item--active');
        if (selectedDates.length === 0 && departurePicker.selectedDates.length === 1) {
          returnPicker.setDate(elements.departure.value, true);
        }
        if (selectedDates.length > 0 && display.returned.value !== '' && selectedDates[0] > new Date(reverseDateStr(display.returned.value))) {
          display.returned.value = '';
        }
        if (selectedDates.length === 2) {
          instance.jumpToDate(selectedDates[1]);
        }
      },
      onChange: function(selectedDates, dateStr, instance) {
        if (instance.selectedDates.length === 1 && departurePicker.selectedDates.length === 1 && instance.selectedDates[0].toString() !== departurePicker.selectedDates[0].toString()) {
          returnPicker.setDate([departurePicker.selectedDates[0], instance.selectedDates[0]], true);
        } else if (instance.selectedDates.length > 1) {
          var dates = instance.selectedDates;
          if (dates[0] > dates[1]) {
            dates.reverse();
          }
          departurePicker.setDate(dates[0], true);
          display.returned.value = formatDate(dates[1]);
          elements.hiddenReturned.value = formatDate(dates[1]);
          dateDiff = calcDatesDifference(dates);
          setValueToHiddenFields(
            {
              name: 'toDate',
              dateString: display.returned.value
            }
          );
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
      return [day, month, year].join('/');
    }
    return '';
  }
  
  function calcDatesDifference(dates) {
    var dep = new Date(dates[0]);
    var ret = new Date(dates[1]);
    var timeDiff = Math.abs(ret.getTime() - dep.getTime());
    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
    return diffDays;
  }
  
  function getDateDiff() {
    return dateDiff;
  }
  
  function removeValidationErrors(target) {
    var errorElement = document.getElementById(target.element.id + 'Display-error');
    var inputElement = document.getElementById(target.element.id + 'Display');
    if (errorElement && inputElement) {
      errorElement.parentNode.removeChild(errorElement);
      inputElement.classList.remove('has-error');
    }
  }
  
  function setValueToHiddenFields(target) {
    var dateArray = target.dateString.split('/');
    var dateFix = dateArray[2].length === 4 ? dateArray[2] : '20' + dateArray[2];
    var mainValue = [dateArray[0], dateArray[1], dateFix].join('/');
    
    document.getElementById('travel_dates_' + target.name).value = mainValue;
    if (dateArray.length === 3) {
      document.getElementById('travel_dates_' + target.name + 'InputD').value = dateArray[0];
      document.getElementById('travel_dates_' + target.name + 'InputM').value = dateArray[1];
      document.getElementById('travel_dates_' + target.name + 'InputY').value = (dateFix);
    }
  }
  
  function reverseDateStr(date) {
    return date.split('/').reverse().join('/');
  }
  
  function preloadFields() {
    var fromDate = document.getElementById('travel_dates_fromDate');
    var toDate = document.getElementById('travel_dates_toDate');
    var hasValues = toDate.value.length > 0 && fromDate.value.length > 0;
    if (hasValues) {
      setValueToHiddenFields({name: 'fromDate', dateString: fromDate.value });
      setValueToHiddenFields({name: 'toDate', dateString: toDate.value });
      display.departure.value = fromDate.value;
      display.returned.value = toDate.value;
    }
  }

  function init() {
    departurePicker = flatpickr(elements.departure, options.departureOptions);
    returnPicker = flatpickr(elements.returned, options.returnOptions);
    preloadFields();
  }

meerkat.modules.register("travelDatepicker", {
  init: init,
  getDateDiff: getDateDiff
});

})(jQuery);
