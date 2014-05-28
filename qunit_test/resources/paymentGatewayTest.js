$(document).ready( function(){
	console.log("ready");
	var meerkat = window.meerkat;

	// mock all ajax calls
	meerkat.modules.comms.post = function (instanceSettings){
	};
	meerkat.modules.comms.get = function (instanceSettings){
	};

	var meerkat = window.meerkat = window.meerkat || {};

	module( "launch" );

	test( "should launch dialog on click", function() {
		console.log("setup" );
		meerkat.modules.paymentGateway.setup({
			"paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
			"name" : 'health_payment_gateway',
			"src" : 'www.fake.org',
			"handledType" :  {
				"credit" : true,
				"bank" : false
			}
		});

		console.log("click");

		$('#health_payment_gateway-content > p.launcher.row-content > button').click();
	});
});