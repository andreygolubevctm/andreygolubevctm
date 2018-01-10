;(function($){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        settings = {
			minStartDateOffset: 0,
			maxStartDateOffset: 90,
		    minStartDate: '',
		    maxStartDate: ''
		},
        $elements = {
    	    input : null,
	        row : null
        },
		_weekends = true;

    function init(){
        $(document).ready(function () {
	        $elements.input = $("#health_payment_details_start");
	        $elements.row = $('.cover-start-date-row');
	        applyEventListeners();
        });
    }

    function applyEventListeners() {
        $elements.input.on('changeDate', function updateThePremiumOnCalendar() {
	        meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
        });

	    $elements.row.find('.dateinput-tripleField input').on('change', function updateThePremiumOnInput(){
		    meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
        });
    }

    function onInitialise() {
	    $elements.input
		    .datepicker({clearBtn: false, format: "dd/mm/yyyy"})
		    .on("changeDate", function updateStartCoverDateHiddenField(e) {
			    // fill the hidden field with selected value
			    $elements.input.val(e.format());
			    meerkat.messaging.publish(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
		    });
	    setDefault();
    }

    function onBeforeEnter() {
	    var min = settings.minStartDate,
		    max = settings.maxStartDate;

	    $elements.input
		    .removeRule('earliestDateEUR')
		    .removeRule('latestDateEUR')
		    .addRule('earliestDateEUR', min, 'Please enter a date on or after ' + min)
		    .addRule('latestDateEUR', max, 'Please enter a date on or before ' + max)
		    .datepicker('setStartDate', min)
		    .datepicker('setEndDate', max);

	    meerkat.messaging.publish(meerkatEvents.TRIGGER_UPDATE_PREMIUM);
    }

    function setDefault() {
	    if (_.isEmpty($elements.input.val())) {
		    $elements.input.datepicker("update", new Date());
	    }
    }

    function setToNextDay() {
    	var today = new Date(),
			nextDay = today.setDate(today.getDate() + 1);

    	nextDay = new Date(nextDay);

    	var day = nextDay.getDay();

    	if (!_weekends && _.indexOf([0,6], day) !== -1) {
    		nextDay.setDate(nextDay.getDate() + (day === 0 ? 1 : 2));
		}

    	$elements.input.datepicker("update", nextDay);
	}

    function flush() {
	    $elements.input.val('');
    }

	function setCoverStartRange(min, max){
		settings.minStartDateOffset = min;
		settings.maxStartDateOffset = max;

		// Get today's date in UTC timezone
		var today = meerkat.modules.utils.getUTCToday(),
			start = 0,
			end = 0,
			hourAsMs = 60 * 60 * 1000;

		// Add 10 hours for QLD timezone
		today += (10 * hourAsMs);

		// Add the start day offset
		start = today;
		if (min > 0) {
			start += (min * 24 * hourAsMs);
		}

		// Calculate the end date
		end = today + (max * 24 * hourAsMs);

		today = new Date(start);
		settings.minStartDate = today.getUTCDate() + '/' + (today.getUTCMonth()+1) + '/' + today.getUTCFullYear();
		today = new Date(end);
		settings.maxStartDate = today.getUTCDate() + '/' + (today.getUTCMonth()+1) + '/' + today.getUTCFullYear();

	}


	// Update premium button
	function enable() {
		$elements.row.find(':input,button').prop('disabled', false);
		$elements.row.find('.datepicker').children().css('visibility', 'visible');
	}

	function disable() {
		_.defer(function(){
			$elements.row.find('.row-content').removeClass('has-success');
			$elements.row.find(':input,button').prop('disabled', true);
			$elements.row.find('.datepicker').children().css('visibility', 'hidden');
		});
	}

	// Hook into: (replacement) "update premium" button to determine which panels to display
	function updateValidationSelectorsPaymentGateway(functionToCall, name){
		$elements.input.on('changeDate.' + name, functionToCall);
	}

	// Reset Hook into "update premium"
	function resetValidationSelectorsPaymentGateway( name){
		$elements.input.off('changeDate.' + name);
	}

	function getVal() {
		return $elements.input.val();
	}

	function getNameValue() {
		return {name:$elements.input.attr("id"),value:$elements.input.val()};
	}

    function setDaysOfWeekDisabled(daysOfWeekDisabled) {
		_weekends = daysOfWeekDisabled === "";

        $elements.input.datepicker('setDaysOfWeekDisabled', daysOfWeekDisabled);
	}

    meerkat.modules.register('healthCoverStartDate', {
        init :               init,
	    onInitialise :       onInitialise,
	    onBeforeEnter :      onBeforeEnter,
	    setCoverStartRange : setCoverStartRange,
	    enable :             enable,
	    disable :            disable,
	    flush :              flush,
	    setDefault :         setDefault,
	    getVal :             getVal,
	    getNameValue :       getNameValue,
	    updateValidationSelectorsPaymentGateway : updateValidationSelectorsPaymentGateway,
	    resetValidationSelectorsPaymentGateway : resetValidationSelectorsPaymentGateway,
		setDaysOfWeekDisabled: setDaysOfWeekDisabled,
        setToNextDay: setToNextDay

    });

})(jQuery);