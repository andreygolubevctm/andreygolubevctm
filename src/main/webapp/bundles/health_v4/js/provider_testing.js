;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var postData = {},
		elements = {
			applicationDate: $('.applicationDate'),
			applicationDateContainer: $('.applicationDateContainer'),
			productTitleSearchContainer: $('.productTitleSearchContainer'),
			productTitleSearch:$(".productTitleSearch")
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
			url:"/" + meerkat.site.urls.context + "ajax/write/setApplicationDate.jsp",
			data: postData,
			cache: false,
			errorLevel: "warning",
			onSuccess:function onApplicationUpdateSuccess(data){
				refreshPage();
			}
		});

	}

	function setApplicationDateCalendar() {
		meerkat.modules.comms.post({
			url:"/" + meerkat.site.urls.context + "ajax/load/getApplicationDate.jsp",
			cache: false,
			errorLevel: "warning",
			onSuccess:function onApplicationUpdateSuccess(dateResult){
				updateCalendar(dateResult);
			}
		});
	}
	function updateCalendar (dateResult) {
		if (dateResult !== null && dateResult !== ''){
			var date = new Date(dateResult.replace(/ [A]?EST/, ''));
			var newDate = meerkat.modules.dateUtils.dateValueFormFormat(date);
			$('#health_searchDate').val(newDate);
		}
	}
	function refreshPage () {
		meerkat.modules.leavePageWarning.disable();
		location.reload(true);
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

	function toggleDisplayProductTitle () {
		if ($("#health_productTitleSearch").val() === ""){
			elements.productTitleSearchContainer.hide();
		}
		else {
			elements.productTitleSearch.html($("#health_productTitleSearch").val());
			elements.productTitleSearchContainer.show();
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

			$('#health_productTitleSearch').on('change',function() {
				toggleDisplayProductTitle();
			});

		});
	}

	meerkat.modules.register("provider_testing", {
		init: initApplicationDate,
		events: moduleEvents,
		changeApplicationDate: changeApplicationDate,
		setApplicationDateCalendar: setApplicationDateCalendar
	});

})(jQuery);