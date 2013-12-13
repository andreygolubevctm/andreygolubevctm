var Unsubscribe = new Object();
Unsubscribe = {

	init : function(emailData, dat , vertical) {
		// parse template
		emailData.name = "";
		if (emailData.firstName != "") {
			emailData.name += " " + emailData.firstName;
		}
		if (emailData.lastName != "") {
			emailData.name += " " + emailData.lastName;
		}

		var unsubscribeTemplate = $("#unsubscribe-template").html();
		var unsubscribeHtml = parseTemplate(unsubscribeTemplate, emailData);
		$(".unsubscribeTemplatePlaceholder").html(unsubscribeHtml);
		$(".unsubscribe-button").on("click", function() {
			if ($(this).hasClass('vertical')) {
				Unsubscribe.submitEml(true, dat , vertical);
			} else {
				Unsubscribe.submitEml(false, dat);
			}
		});
		if (emailData.name.length > 0) {
			$('.unsubscribeName').show();
		}
	},

	submitEml : function(hasVertical, dat , vertical) {
		Loading.show();
		if (hasVertical) {
			dat += "&vertical=" + vertical;
		}

		$.ajax({
			url : "ajax/json/unsubscribe.jsp",
			data : dat,
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