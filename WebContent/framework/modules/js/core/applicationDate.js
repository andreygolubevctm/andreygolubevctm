;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var postData = {},
		elements = {
			applicationDate: $('.applicationDate'),
			applicationDateContainer: $('.applicationDateContainer')
		},
		selectedDate,
		moduleEvents = {
		};


	function changeApplicationDate() {

		selectedDate = $('#health_searchDate').val();
		var date = selectedDate.split('/');
		var newDate = date[2]+'-'+date[1]+'-'+date[0];
		postData.applicationDateOverrideValue = (selectedDate !== '' ? newDate + " 00:00:01" : null);

		meerkat.modules.comms.post({
			url:"ajax/write/setApplicationDate.jsp",
			data: postData,
			cache: false,
			errorLevel: "warning",
			onSuccess:function onApplicationUpdateSuccess(data){
				updateDisplay(data);
				toggleDisplay ();
			}
		});
	}

	function setApplicationDateCalendar() {
		meerkat.modules.comms.post({
			url:"ajax/load/getApplicationDate.jsp",
			cache: false,
			errorLevel: "warning",
			onSuccess:function onApplicationUpdateSuccess(dateResult){
				updateCalendar(dateResult);
			}
		});
	}
	function updateCalendar (dateResult) {
		if (dateResult !== null){
			var date = new Date(dateResult);
			var newDate = ("0" + date.getDate()).slice(-2)+"/"+("0" + (date.getMonth() + 1)).slice(-2)+"/"+date.getFullYear();
			$('#health_searchDate').val(newDate);
		}
	}

	function updateDisplay (data) {
		elements.applicationDate.html(data);
	}
	function toggleDisplay () {
		if (elements.applicationDate.html() === ""){
			elements.applicationDateContainer.hide();
		}
		else {
			elements.applicationDateContainer.show();
		}
	}

	/**
	 * Initialise
	 */
	function initApplicationDate(){

		jQuery(document).ready(function($) {
			if ($('.simples').length === 0){ // Dont want this set once the simples page loads for the first time
				setApplicationDateCalendar();
			}
			$('#health_searchDate').on('change',function() {
				changeApplicationDate();
			});

			toggleDisplay ();
		});
	}

	meerkat.modules.register("application_date", {
		init: initApplicationDate,
		events: moduleEvents,
		changeApplicationDate: changeApplicationDate,
		setApplicationDateCalendar: setApplicationDateCalendar
	});

})(jQuery);