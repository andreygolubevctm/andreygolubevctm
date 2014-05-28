var Unsubscribe = new Object();
Unsubscribe = {

	init : function(brand ,vertical) {
		$(".unsubscribe-button").on("click", function() {
			Unsubscribe.submitEml();
		});
	},

	submitEml : function() {
		Loading.show();

		$.ajax({
			url : "ajax/json/unsubscribe.jsp",
			dataType : "json",
			success : function(json) {
				Loading.hide();

				json = $.trim(json);
				if (json.error) {
					FatalErrorDialog.display("An error occurred :"
							+ json.errorMsg, json);
					return false;
				}

				unsubscribeFeedbackDialog.open();
				return true;
			},
			error : function(obj, txt) {
				FatalErrorDialog.display("An error occurred :" + txt, dat);
			},
			timeout : 30000
		});
	}
};