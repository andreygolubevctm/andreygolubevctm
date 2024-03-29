;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		optIn: {

		}
	},
	moduleEvents = events.optIn;

/*
	var optInMap = {
		email: {
			form: {
				type: "form"
			},
			database: {
				type: "database"
			},
			saveForm: {
				type: "saveForm"
			}
		},
		phone: {
			form: {
				type: "form"
			},
			database: {
				type: "database"
			},
			saveForm: {
				type: "saveForm"
			}
		}
	}
	*/

	function init(){

		/*
		jQuery(document).ready(function($) {
			$("input[type=email]").on("change", manageEmailMarketing);
		});
		*/

	}
	/**
	 * Determine whether privacy optin is checked based on whether the class exists.
	 */
	function isPrivacyOptedIn() {
		var $cBox = $(':input[id$="privacyoptin"]');
		if($cBox.attr('type') == "checkbox") {
			return $cBox.is(':checked');
		}
		return $cBox.val() === "Y";

	}
	function manageEmailMarketing(){

		meerkat.modules.loadingAnimation.showAfter( $(this) );

		var emailInfo = {
			data: {
				type: "email", // not currently used but in prevision that we can retrieve other types of marketing (i.e. phone, etc.)
				value: $(this).val()
			},
			onComplete: function(){
				meerkat.modules.loadingAnimation.hide( $(this) );
			},
			onSuccess: function(result){
				// hide related optin field?
			},
			onError: function(){
				// handle ajax error
			}
		};

		fetch( emailInfo );

	}

	function updateOptinText() {
		$('.optinText:contains(comparethemarket.com.au)').html(
			function(i,h){
				return h.replace(/(comparethemarket.com.au)/g,'<strong>compare</strong>the<strong>market</strong>.com.au');
			});
	}

	function fetch( infoToCheck ){

		// @todo = improve "ajax/json/get_user_exists.jsp" to accept any kind of marketing type and adapt the sent data below accordingly
		var data = {
			save_email: infoToCheck.data.value,
			vertical: meerkat.site.vertical
		};

		var settings = {
			url: '/' + meerkat.site.urls.context + "ajax/json/get_user_exists.jsp",
			data: data,
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			onSuccess:  function fetchSuccess(result){
				if( typeof infoToCheck.onSuccess === "function" ) infoToCheck.onSuccess(result);
			},
			onError: function fetchError(){
				if( typeof infoToCheck.onError === "function" ) infoToCheck.onError();
			},
			onComplete: function(){
				if( typeof infoToCheck.onComplete === "function" ) infoToCheck.onComplete();
			}
		};

		if (infoToCheck.hasOwnProperty('returnAjaxObject')) {
			settings.returnAjaxObject = infoToCheck.returnAjaxObject;
		}

		return meerkat.modules.comms.post(settings);
	}

	meerkat.modules.register("optIn", {
		init: init,
		events: events,
		fetch: fetch,
		isPrivacyOptedIn: isPrivacyOptedIn,
		updateOptinText: updateOptinText
	});

})(jQuery);