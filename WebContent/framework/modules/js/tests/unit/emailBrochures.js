$(function () {
// to test open the following in your browser
// file:///C:/Dev/web_ctm/WebContent/framework/modules/js/tests/index.html?notrycatch=true

	//Setup the DOM elements
	var $form = $("<form id='email-brochure-component' class='form-horizontal' novalidate='novalidate'></form>");
	var $marketing = $("<input type='checkbox' name='send_marketing' id='send_marketing' value='Y'>");
	var $emailInput = $("<input required='true' type='email' name='emailAddress' class='form-control has-success sendBrochureEmailAddress' />");
	var $emailButton = $("<a href='javascript:;' class='btn btn-save btn-block disabled btn-email-brochure'>Email Brochures</a>");

	$( "#testBody" ).append($form);
	$form.append($emailInput);
	$form.append($emailButton);
	$form.append($marketing);

	//Setup the test data
	var vertical = "health";
	var hospitalPDSUrl="hospitalPDSUrl";
	var extrasPDSUrl="extrasPDSUrl";
	var frequency="Monthly";
	var product = getProduct();

	settings = {
		identifier : 'test' ,
		emailInput : $emailInput,
		submitButton : $emailButton,
		form : $form,
		marketing : $marketing,
		productData : [
			{
				name:"hospitalPDSUrl",
				value: hospitalPDSUrl
			},
			{
			name:"extrasPDSUrl",
				value: extrasPDSUrl
			}
		],
		product : product
	};

	meerkat.modules.contactDetails.init();

	module( "meerkat.modules.emailBrochures" );

	QUnit.test( "should validate email", function(assert) {
		meerkat.modules.emailBrochures.setup(settings);
		ok($emailButton.hasClass( "disabled" ), "email button should be disabled");
		// don't enable submit if invalid email
		$emailInput.val('invalid');
		$emailInput.change();

		setTimeout(1000);
		ok($emailButton.hasClass( "disabled" ), "email button should be disabled");

		// enter email address
		$emailInput.val('preload.testing@comparethemarket.com.au');
		$emailInput.change();

	});

	QUnit.test( "should send email", function(assert) {
		meerkat.modules.emailBrochures.setup(settings);
		var coverType="";
		var marketing="Y";
		var email = 'preload.testing@comparethemarket.com.au';

		// mock out server call
		meerkat.modules.optIn = {
			fetch : function(settings){
				var result = {
					optInMarketing : true
				};
				settings.onSuccess(result);
			}
		};

		// enter email address
		$emailInput.val(email);
		$emailInput.change();
		// wait for event
		setTimeout(1000);
		// mock out send email call
		var emailSent = false;
		var data = null;
		meerkat.modules.comms = {
				post : function(request){
					data = request.data;
					var result = {
						transactionId : 100000000,
					};
					request.onSuccess(result);
					request.onComplete(result);
					emailSent = true;
				}
		};
		$emailButton.click();
		// wait for fake email send
		setTimeout(1000);
		ok(emailSent, "email should have been send");

		var returnedpremiumFrequency = null;
		var returnedhospitalPDSUrl =  null;
		var returnedextrasPDSUrl =  null;
		var returnedmarketing =  null;

		for(var i = 0 ; i < data.length ; i++){
			var obj = data[i];
			if(obj.name ==="premium"){
				returnedPremium = obj.value;
			}
			if(obj.name ==="premiumFrequency"){
				returnedpremiumFrequency = obj.value;
			}
			if(obj.name ==="hospitalPDSUrl"){
				returnedhospitalPDSUrl = obj.value;
			}
			if(obj.name ==="extrasPDSUrl"){
				returnedextrasPDSUrl = obj.value;
			}
			if(obj.name ==="marketing"){
				returnedmarketing = obj.value;
			}

			if(obj.name ==="vertical"){
				resultVertical = obj.value;
			}

			if(obj.name ==="email"){
				resultEmail = obj.value;
			}
		}

		assert.equal(returnedpremiumFrequency, frequency, "checking premiumFrequency");
		assert.equal(returnedhospitalPDSUrl, hospitalPDSUrl, "checking hospitalPDSUrl" );
		assert.equal(returnedextrasPDSUrl, extrasPDSUrl, "checking extrasPDSUrl");
		assert.equal(returnedmarketing, marketing, "checking marketing ");
		assert.equal(resultVertical, vertical, "checking vertical");
		assert.equal(resultEmail, email, "checking email");

	});
	setTimeout(1000);
	// test clean up
	$form.remove();
});

