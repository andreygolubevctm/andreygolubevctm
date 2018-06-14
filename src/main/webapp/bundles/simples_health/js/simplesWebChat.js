;(function($, undefined){

	var meerkat = window.meerkat;

	var $elements = {};

	function init() {
		$(document).ready(function(){
			$elements = {
				snapshot:   $(".simplesSnapshot"),
				phone: {
					quote: {
						mobile: $("#health_contactDetails_contactNumber_mobile"),
						other: $("#health_contactDetails_contactNumber_other")
					},
					application: {
						mobile: $("#health_application_mobile"),
						other: $("#health_application_other")
					}
				}
			};

		});
	}

	function setup(is_webchat) {
		is_webchat = is_webchat || false;
		reset();
		if(is_webchat) {
			render();
			applyEventListeners();
		}
	}

	function reset() {
		if($elements.hasOwnProperty("btns") && $elements.btns.length) {
			$elements.btns.remove();
		}
	}

	function applyEventListeners() {
		$elements.btns.on("click", requestDelay);
	}

	function render() {
		var $btn = $("<a href='javascript:;' class='btn btn-save btn-block btn-delay-dialler'>Delay Dialler<span class='icon icon-clock' /></a>");
		$btn.insertAfter($elements.snapshot);
		$elements.btns = $(".btn-delay-dialler");
	}

	function requestDelay() {
		var phone = getPhone();
		if(!_.isNull(phone)) {
			var ajaxURL = "spring/rest/simples/delaylead/webchat.json";
			return meerkat.modules.comms.post({
				url: ajaxURL,
				dataType: "json",
				data: {
					"styleCodeId": meerkat.site.styleCodeId,
					"phone": phone,
					"source": "webchat"
				},
				onSuccess: function onRequestDelaySuccess(data) {
					if(!_.isEmpty(data) && _.isObject(data) && data.hasOwnProperty("outcome") && data.outcome === "SUCCESS") {
						meerkat.modules.dialogs.show({htmlContent: "<h4>Dialler has been delayed 30 minutes</h4>"});
					} else {
						meerkat.modules.dialogs.show({htmlContent: "<h4>Dialler delay was unsuccessful</h4>"});
					}
				},
				useDefaultErrorHandling: false,
				errorLevel: "silent",
				onError: function onRequestDelayError(obj, txt, errorThrown) {
					meerkat.modules.dialogs.show({htmlContent:"<h4>An error occured attempting to delay the dialler</h4><p>" + errorThrown + "</p>"});
					var transactionId = meerkat.modules.transactionId.get();
					meerkat.modules.errorHandling.error({
						errorLevel: "silent",
						message: "Error triggering dialler delay for webchat user",
						description: "An error occurred while triggering dialler delay for webchat user : " + txt + ' ' + errorThrown,
						data: {
							status: txt,
							error: errorThrown,
							transactionId: transactionId
						},
						id: transactionId
					});

				}
			});
		}
	}

	function getPhone(){
		var mobile = $elements.phone.application.mobile.val();
		if(_.isEmpty(mobile)) {
			var other = $elements.phone.appliction.other.val();
			if(_.isEmpty(other)) {
				mobile = $elements.phone.quote.mobile.val();
				if(_.isEmpty(mobile)) {
					other = $elements.phone.quote.other.val();
					if(_.isEmpty(other)) {
						return null;
					}
					return other;
				}
			}
			return other;
		}
		return mobile;
	}

	meerkat.modules.register('simplesWebChat', {
		init: init,
		setup: setup
	});

})(jQuery);