/**
 * If business activity is conducted at the premises then further details will be asked
 * Depending upon the type of the business, further options for number of rooms, employees and child care questions may be presented
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var initialised = false;
	var elements = {
			name:					"home_businessActivity",
			businessRooms:			".businessRooms",
			employees:				".hasEmployees",
        	dayCarChildren:		    ".dayCareChildren",
        	registeredDayCare:	    ".registeredDayCare",
			businessType:			".businessType",
			employeeAmount:			".employeeAmount"
	};
	
	function businessFieldChange() {
		$(document).on('click', '#businessTypeContainer input' , function() {
			toggleBusinessFields();
		});
		
		$(document).on('change', '#businessTypeContainer select[name=home_businessActivity_businessType_drop-down-selector]', function() {
			toggleBusinessFields();
		});
	}

	/* Here you put all functions for use in your module */
	function toggleBusinessFields(speed){
		var businessTypeValue = $('#'+elements.name+'_businessType').find('option:selected').val().toLowerCase();
		if ( businessTypeValue === 'home office' || businessTypeValue === 'surgery/consulting rooms') {
			$(elements.businessRooms+', '+elements.employees).slideDown(speed);
			$(elements.dayCarChildren+', '+elements.registeredDayCare).slideUp(speed);
			toggleEmployeeAmount();
		} else if ( businessTypeValue === 'day care') {
			$(elements.dayCarChildren+', '+elements.registeredDayCare).slideDown(speed);
			$(elements.businessRooms+', '+elements.employees+', '+elements.employeeAmount).slideUp(speed);
		} else {
			$(elements.businessRooms+', '+elements.employees+', '+elements.employeeAmount+', '+elements.dayCarChildren+', '+elements.registeredDayCare).slideUp(speed);
		}

	}

	function toggleBusinessType(speed){
		if( $('input[name='+elements.name+'_conducted]:checked').val() == 'Y' ){
			$(elements.businessType).slideDown(speed);
			toggleBusinessFields(speed);
		} else {
			hideBusinessActivityFields(speed);
		}
	}

	function toggleEmployeeAmount(speed){
		if( $('input[name='+elements.name+'_employees]:checked').val() == 'Y' ){
			$(elements.employeeAmount).slideDown(speed);
		} else {
			$(elements.employeeAmount).slideUp(speed);
		}
	}

	function hideBusinessActivityFields (speed) {
		$(elements.businessType+', '+elements.businessRooms+', '+elements.employees+', '+elements.employeeAmount+', '+elements.dayCarChildren+', '+elements.registeredDayCare).slideUp(speed);
	}
	function applyEventListeners() {
		businessFieldChange();
		$(document).ready(function() {
			$('input[name='+elements.name+'_conducted]').on('change', function(){
				toggleBusinessType();
			});

			$('#'+elements.name+'_businessType').on('change', function() {
				toggleBusinessFields();
			});

			$('input[name='+elements.name+'_employees]').on('change', function(){
				toggleEmployeeAmount();
			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomeBusiness() {
		if(!initialised) {
			initialised = true;
			log("[HomeBusiness] Initialised"); //purely informational
			applyEventListeners();
			toggleBusinessFields(0);
			toggleEmployeeAmount(0);
			toggleBusinessType(0);
		}
	}

	meerkat.modules.register('homeBusiness', {
		initHomeBusiness: initHomeBusiness, //main entrypoint to be called.
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);

