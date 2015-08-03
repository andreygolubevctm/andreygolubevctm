meerkat.modules.loadingAnimation = {
	getTemplate : function() {
		return "";
	}
};

$(function () {
	QUnit.test("should launch dialog on click", function(assert) {
		var meerkat = window.meerkat;
		var resultHtmlContent = "";

		meerkat.modules.dialogs.changeContent = function(dialogId, htmlContent, callback){
			resultHtmlContent = htmlContent;
		}

		console.log("ready");

		// mock all ajax calls
		meerkat.modules.comms.post = function (instanceSettings) {
		};
		meerkat.modules.comms.get = function (instanceSettings) {
		};


		var meerkat = window.meerkat = window.meerkat || {};

		module("launch");
		console.log("setup");

		meerkat.modules.paymentGateway.setup({
			"paymentEngine": meerkat.modules.healthPaymentGatewayNAB,
			"name": 'health_payment_gateway',
			"src": 'www.fake.org',
			"handledType": {
				"credit": true,
				"bank": false
			}
		});

		console.log("click");

		$('#health_payment_gateway-content > p.launcher.row-content > button').click();
		assert.equal(resultHtmlContent, "<iframe width=\"100%\" height=\"390\" frameBorder=\"0\" src=\"www.fake.orgexternal/hambs/nab_ctm_iframe.jsp?providerCode=undefined&b=undefined\"></iframe>", "checking src");
	});
});
