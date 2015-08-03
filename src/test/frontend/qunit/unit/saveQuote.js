$(function () {
// to test open the following in your browser
// file:///C:/Dev/web_ctm/main/webapp/framework/modules/js/tests/index.html?notrycatch=true


	meerkat.modules.utils = {
		scrollPageTo : function(a1,a2,a3, f1){

		}
	};

	//Setup the DOM elements
	var $form = $("<form id='email-quote-component' " +
			"class='form-horizontal' novalidate='novalidate'></form>");
	var $marketing = $("<input type='checkbox' name='send_marketing' " +
			"id='send_marketing' value='Y'>");
	var $emailInput = $("<input required='true' type='email' " +
			"name='save_email' class='form-control has-success' id='save_email' />");

	var $password = $("<input required='true' type='password' name='save_password' id='save_password' />");
	var $confirmationPassword = $("<input required='true' type='password' name='save_confirm' id='save_confirm' />");

	var $submitButton = $("<a href='javascript:;' class='btn-save-quote' >Save Quote</a>");

	$( "#testBody" ).append($form);
	$form.append($emailInput);
	$form.append($marketing);

	$form.append($password);
	$form.append($confirmationPassword);

	$form.append($submitButton);

	meerkat.modules.optIn = {
			fetch : function(settings){
				var result = {
						optInMarketing : true
				};
				settings.onSuccess(result);
			}
	};

	//Setup the test data
	var password="password1";
	var email="preload.testing@comparethemarket.com.au";

	meerkat.modules.contactDetails.init();
	meerkat.modules.saveQuote.init();

	module( "meerkat.modules.saveQuote" );

	function enterValidDetails() {
		$emailInput.val(email);
		$emailInput.change();
		setTimeout(500);
		$password.val(password);
		$password.change();
		setTimeout(500);
		$confirmationPassword.val(password);
		$confirmationPassword.change();
		setTimeout(500);
	}

	QUnit.test( "should validate email", function(assert) {
		enterValidDetails();
		ok(!$submitButton.hasClass("disabled"), "email button should not be disabled");

		// don't enable submit if invalid email
		$emailInput.val('invalid');
		$emailInput.change();

		$password.val('password1');
		$confirmationPassword.val('password1');

		setTimeout(500);
		ok($submitButton.hasClass( "disabled" ), "email button should be disabled");
	});

	QUnit.test( "should validate password", function(assert) {
		enterValidDetails();
		ok(!$submitButton.hasClass("disabled"), "email button should not be disabled");

		// don't enable submit if non matching password
		$emailInput.change();
		$password.val('password1');
		$confirmationPassword.val('password2');
		$password.change();
		setTimeout(500);
		ok($submitButton.hasClass( "disabled" ), "email button should be disabled");

	});

	QUnit.test( "should send email", function(assert) {

		enterValidDetails();

		// wait for event
		setTimeout(500);
		// mock out send email call
		var emailSent = false;
		var data = null;
		meerkat.modules.comms = {
				post : function(request){
					console.log("post recieved");
					data = request.data;
					var result = {
						transactionId : 100000000,
					};
					request.onSuccess(result);
					request.onComplete(result);
					emailSent = true;
				}
		};
		console.log("$submitButton.click()");
		$submitButton.click();
		// wait for fake email send
		setTimeout(500);
		ok(emailSent, "email should have been send");

		var returnedEmail = null;
		var returnedpassword =  null;
		var returnedpasswordConfirm =  null;

		console.log("data" , data);
		ok(data != null, "data should have been sent");
		if(data != null){
			for(var i = 0 ; i < data.length ; i++){
				var obj = data[i];
				if(obj.name ==="save_email"){
					returnedEmail = obj.value;
				}
				if(obj.name ==="save_password"){
					returnedpassword = obj.value;
				}

				if(obj.name ==="save_confirm"){
					returnedpasswordConfirm = obj.value;
				}
			}

			assert.equal(returnedEmail, email, "checking cover type");
			assert.equal(returnedpassword, password, "checking password");
			assert.equal(returnedpasswordConfirm, password, "checking password");
		}
	});


	//	test clean up
	setTimeout(function(){
		$form.remove();
	}, 4000);
})

