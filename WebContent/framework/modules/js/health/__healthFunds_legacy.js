/*

Fund Specific JS
- This is legacy, as health funds are now in common/js/health/*.jsp
- NOTE: see also the healthfunds.css which may provide visual differences

*/



/* HCF
======================= */
//HCF is usually setting the default values
var healthFunds_HCF = {
	set: function(){
		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
	},
	unset: function(){
	}
};



/* AHM
======================= */
var healthFunds_AHM = {
	set: function(){

		//Dependants
		var dependantsString = 'ahm Health Insurance provides cover for your children up to the age of 21 plus students who are single and studying full time aged between 21 and 25. Adult dependants outside this criteria can be covered by an additional premium on certain covers';

		if(meerkat.site.content.callCentreNumber !== ''){
			dependantsString += ' so please call '+meerkat.site.content.brandDisplayName+' on <span class=\"callCentreNumber\">'+meerkat.site.content.callCentreNumberApplication+"</span>";
			if(meerkat.site.liveChat.enabled) dependantsString += ' or chat to our consultants online';
			dependantsString += ' to discuss your health cover needs.';
		}else{
			dependantsString += '.';
		}

		healthFunds._dependants(dependantsString);
		//change age of dependants and school
		healthDependents.maxAge = 25;
		//schoolgroups and defacto
		$.extend(healthDependents.config, { 'school':true, 'schoolMin':21, 'schoolMax':24, 'schoolID':true, 'schoolIDMandatory':true, 'schoolDate':true, 'schoolDateMandatory':true });

		//School list
		var list = '<select class="form-control"><option value="">Please choose...</option>';
			list += '<option value="ACP">Australian College of Phys. Ed</option>';
			list += '<option value="ACT">Australian College of Theology</option>';
			list += '<option value="ACTH">ACT High Schools</option>';
			list += '<option value="ACU">Australian Catholic University</option>';
			list += '<option value="ADA">Australian Defence Force Academy</option>';
			list += '<option value="AFTR">Australian Film, TV &amp; Radio School</option>';
			list += '<option value="AIR">Air Academy, Brit Aerospace Flight Trng</option>';
			list += '<option value="AMC">Austalian Maritime College</option>';
			list += '<option value="ANU">Australian National University</option>';
			list += '<option value="AVO">Avondale College</option>';
			list += '<option value="BC">Batchelor College</option>';
			list += '<option value="BU">Bond University</option>';
			list += '<option value="CQU">Central Queensland Universty</option>';
			list += '<option value="CSU">Charles Sturt University</option>';
			list += '<option value="CUT">Curtin University of Technology</option>';
			list += '<option value="DU">Deakin University</option>';
			list += '<option value="ECU">Edith Cowan University</option>';
			list += '<option value="EDUC">Education Institute Default</option>';
			list += '<option value="FU">Flinders University of SA</option>';
			list += '<option value="GC">Gatton College</option>';
			list += '<option value="GU">Griffith University</option>';
			list += '<option value="JCUNQ">James Cook University of Northern QLD</option>';
			list += '<option value="KVBVC">KvB College of Visual Communication</option>';
			list += '<option value="LTU">La Trobe University</option>';
			list += '<option value="MAQ">Maquarie University</option>';
			list += '<option value="MMCM">Melba Memorial Conservatorium of Music</option>';
			list += '<option value="MTC">Moore Theological College</option>';
			list += '<option value="MU">Monash University</option>';
			list += '<option value="MURUN">Murdoch University</option>';
			list += '<option value="NAISD">Natn\'l Aborign\'l &amp; Islander Skills Dev Ass.</option>';
			list += '<option value="NDUA">Notre Dame University Australia</option>';
			list += '<option value="NIDA">National Institute of Dramatic Art</option>';
			list += '<option value="NSWH">NSW High Schools</option>';
			list += '<option value="NSWT">NSW TAFE</option>';
			list += '<option value="NT">Northern Territory High Schools</option>';
			list += '<option value="NTT">NT TAFE</option>';
			list += '<option value="NTU">Northern Territory University</option>';
			list += '<option value="OLA">Open Learnng Australia</option>';
			list += '<option value="OTHER">Other Registered Tertiary Institutions</option>';
			list += '<option value="PSC">Photography Studies College</option>';
			list += '<option value="QCM">Queensland Conservatorium of Music</option>';
			list += '<option value="QCU">Queensland College of Art</option>';
			list += '<option value="QLDH">QLD High Schools</option>';
			list += '<option value="QLDT">QLD TAFE</option>';
			list += '<option value="QUT">Queensland University of Technology</option>';
			list += '<option value="RMIT">Royal Melbourne Institute of Techn.</option>';
			list += '<option value="SA">South Australian High Schools</option>';
			list += '<option value="SAT">SA TAFE</option>';
			list += '<option value="SCD">Sydney College of Divinity</option>';
			list += '<option value="SCM">Sydney Conservatorium of Music</option>';
			list += '<option value="SCU">Southern Cross University</option>';
			list += '<option value="SCUC">Sunshine Coast University College</option>';
			list += '<option value="SIT">Swinburn Institute of Technology</option>';
			list += '<option value="SJC">St Johns College</option>';
			list += '<option value="SYD">University of Sydney</option>';
			list += '<option value="TAS">TAS High Schools</option>';
			list += '<option value="TT">TAS TAFE</option>';
			list += '<option value="UA">University of Adelaide</option>';
			list += '<option value="UB">University of Ballarat</option>';
			list += '<option value="UC">University of Canberra</option>';
			list += '<option value="UM">University of Melbourne</option>';
			list += '<option value="UN">University of Newcastle</option>';
			list += '<option value="UNC">University of Capricornia Rockhampton</option>';
			list += '<option value="UNE">University of New England</option>';
			list += '<option value="UNSW">University Of New South Wales</option>';
			list += '<option value="UQ">University of Queensland</option>';
			list += '<option value="USA">University of South Australia</option>';
			list += '<option value="USQ">University of Southern Queensland</option>';
			list += '<option value="UT">University of Tasmania</option>';
			list += '<option value="UTS">University of Technlogy Sydney</option>';
			list += '<option value="UW">University of Wollongong</option>';
			list += '<option value="UWA">University of Western Australia</option>';
			list += '<option value="UWS">University of Western Sydney</option>';
			list += '<option value="VCAH">VIC College of Agriculture &amp; Horticulture</option>';
			list += '<option value="VIC">Victorian High Schools</option>';
			list += '<option value="VICT">VIC TAFE</option>';
			list += '<option value="VU">Victoria University</option>';
			list += '<option value="VUT">Victoria University of Technology</option>';
			list += '<option value="WA">Western Australia-High Schools</option>';
			list += '<option value="WAT">WA TAFE</option>';
			list += '</select>';
		$('.health_dependant_details_schoolGroup .row-content').each(function(i) {
			var name = $(this).find('input').attr('name');
			var id = $(this).find('input').attr('id');
			$(this).append(list);
			$(this).find('select').attr('name', name).attr('id', id+'select');
			$(this).find('select').rules('add', {required:true, messages:{required:'Please select dependant '+(i+1)+'\'s school'}});
		});
		$('.health_dependant_details_schoolIDGroup input').attr('maxlength', '10');
		//$('.health_dependant_details_schoolDateGroup input').mask('99/99/9999', {placeholder: 'DD/MM/YYYY'});
		//Change the Name of School label
		healthFunds_AHM.tmpSchoolLabel = $('.health_dependant_details_schoolGroup .control-label').html();
		$('.health_dependant_details_schoolGroup .control-label').html('Tertiary Institution this dependant is attending');
		$('.health_dependant_details_schoolGroup .help_icon').hide();

		//Previous fund
		$('#health_previousfund_primary_authority').rules('add', {required:true, messages:{required:'AHM require authorisation to contact your previous fund'}});
		$('#health_previousfund_partner_authority').rules('add', {required:true, messages:{required:'AHM require authorisation to contact your partner\'s previous fund'}});
		$('#health_previousfund_primary_memberID').attr('maxlength', '10');
		$('#health_previousfund_partner_memberID').attr('maxlength', '10');

		//Authority
		healthFunds._previousfund_authority(true);

		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });

		//claims account
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//selections for payment date
		$('#update-premium').on('click.AHM', function() {
			if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
				meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 3, false, false);
			}
			else {
				meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 3, false, true);
			}
		});

		$('.health-credit_card_details .fieldrow').hide();
		meerkat.modules.paymentGateway.setup({
			"paymentEngine" : meerkat.modules.healthPaymentGatewayWestpac,
			"name" : 'health_payment_gateway',
			"src" : 'ajax/html/health_paymentgateway.jsp',
			"handledType" :  {
				"credit" : true,
				"bank" : false
			},
			"paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
			"clearValidationSelectors" : $('#health_payment_details_frequency, #health_payment_details_start ,#health_payment_details_type'),
			"getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
		});

		//calendar for start cover
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 28);
	},
	unset: function(){
		healthFunds._reset();
		//Dependants
		healthFunds._dependants(false);

		//School list
		$('.health_dependant_details_schoolGroup select').remove();
		$('.health_dependant_details_schoolIDGroup input').removeAttr('maxlength');
		//Change the Name of School label
		$('.health_dependant_details_schoolGroup .control-label').html(healthFunds_AHM.tmpSchoolLabel);
		delete healthFunds_AHM.tmpSchoolLabel;
		$('.health_dependant_details_schoolGroup .help_icon').show();

		//Previous fund
		$('#health_previousfund_primary_authority').rules('remove', 'required');
		$('#health_previousfund_partner_authority').rules('remove', 'required');
		$('#health_previousfund_primary_memberID').removeAttr('maxlength');
		$('#health_previousfund_partner_memberID').removeAttr('maxlength');

		//Authority off
		healthFunds._previousfund_authority(false);

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#update-premium').off('click.AHM');

		//Payment gateway
		meerkat.modules.paymentGateway.reset();
	}
};



/* AUF
======================= */
var healthFunds_AUF = {
	set: function(){
		//dependant definition
		healthFunds._dependants('This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependants do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		//school Age
		healthDependents.config.schoolMin = 23;

		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit', {'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true });

		//calendar for start cover
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

		//selections for payment date
		healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
		$('#update-premium').on('click.AUF', function(){
			var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
		});

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//failed application
		healthFunds.applicationFailed = function(){
			meerkat.modules.transactionId.getNew();
		};
	},
	unset: function(){
		healthFunds._reset();
		//dependant definition off
		healthFunds._dependants(false);

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#update-premium').off('click.AUF');

		//failed application
		healthFunds.applicationFailed = function(){ return false; };
	}
};



/* FRA (Frank)
======================= */
var healthFunds_FRA = {
	$policyDateCreditMessage : $('.health_credit-card-details_policyDay-message'),
	$policyDateBankMessage : $('.health_bank-details_policyDay-message'),
	set: function(){
		//dependant definition
		healthFunds._dependants('This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.');

		//Authority
		healthFunds._previousfund_authority(true);

		//remove the DR in your details
		healthFunds.$_optionDR = $('.person-title').find('option[value=DR]').first();
		$('.person-title').find('option[value=DR]').remove();

		//selections for payment date
		$('#update-premium').on('click.FRA', function(){
			var messageField = null;
			if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
				messageField = healthFunds_FRA.$policyDateCreditMessage;
			} else {
				messageField = healthFunds_FRA.$policyDateBankMessage;
			}
			meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay(messageField, $('#health_payment_details_start').val(), [1,15], 7);
		});

		//change age of dependants and school
		healthDependents.config.school = false;
		healthDependents.maxAge = 21;

		//fund ID's become optional
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");

		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

		//claims account
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//calendar for start cover
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

	},
	unset: function(){
		healthFunds._reset();

		//dependant definition off
		healthFunds._dependants(false);

		//Authority off
		healthFunds._previousfund_authority(false);

		//re-insert the DR in your details
		$('.person-title').append( healthFunds.$_optionDR    );

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		$('#update-premium').off('click.FRA');

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

	}
};

/* GMH (GMHBA)
======================= */
var healthFunds_GMH = {
	$policyDateHiddenField : $('.health_details-policyDate'),
	$policyDateCreditMessage : $('.health_credit-card-details_policyDay-message'),
	paymentDayChange : function(value) {
		healthFunds_GMH.$policyDateHiddenField.val(value);
	},

	set: function() {

		//Authority
		healthFunds._previousfund_authority(true);

		//dependant definition
		healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':21, 'schoolMax':24 };

		//school labels
		healthFunds._schoolLabel = $('.health_dependant_details_schoolGroup').first().find('.control-label').text();
		$('.health_dependant_details_schoolGroup').find('.control-label').text('Name of school/employer/educational institution your child is attending');

		//fund ID's become optional
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");

		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

		//claims account
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//calendar for start cover
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

		meerkat.messaging.subscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);

		//selections for payment date
		$('#update-premium').on('click.GMH', function(){
			if(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod() == 'cc'){
				meerkat.modules.healthPaymentDate.paymentDaysRenderEarliestDay(healthFunds_GMH.$policyDateCreditMessage, $('#health_payment_details_start').val(), [1], 7);
			}
			else {
				meerkat.modules.healthPaymentDate.populateFuturePaymentDays($('#health_payment_details_start').val(), 14, true, true);
			}
		});

	},
	unset: function(){
		meerkat.messaging.unsubscribe(meerkat.modules.healthPaymentDate.events.POLICY_DATE_CHANGE, healthFunds_GMH.paymentDayChange);

		healthFunds._reset();

		//Authority off
		healthFunds._previousfund_authority(false);

		//dependant definition off
		healthFunds._dependants(false);


		//school labels off
		$('#mainform').find('.health_dependant_details_schoolGroup').find('.control-label').text( healthFunds._schoolLabel );

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();
		//selections for payment date
		$('#update-premium').off('click.GMH');

	}
};

/* NIB
======================= */
var healthFunds_NIB = {
	set: function(){
		//Contact Point question
		healthApplicationDetails.showHowToSendInfo('NIB', true);

		// Partner authority
		healthFunds._partner_authority(true);

		//dependant definition
		healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 25 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':21, 'schoolMax':24 };

		//fund ID's become optional
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");
		healthFunds._previousfund_authority(true);

		//calendar for start cover
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);

		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('frequency',{ 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 });

		//claims account
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply',true);
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
		creditCardDetails.render();

		$('#update-premium').on('click.NIB', function() {
			var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
			if (freq == 'fortnightly') {
				healthFunds._payments = { 'min':0, 'max':10, 'weekends':false, 'countFrom' : 'effectiveDate'};
			} else {
				healthFunds._payments = { 'min':0, 'max':27, 'weekends':true , 'countFrom' : 'today', 'maxDay' : 27};
			}
			var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
		});

		function onChangeNoEmailChkBox(){
			var $applicationEmailGroup = $('#health_application_emailGroup'),
				$applicationEmailField = $("#health_application_email"),
				$contactPointPost = $("#health_application_contactPoint_P"),
				$contactPointEmail = $("#health_application_contactPoint_E");

			if( $("#health_application_no_email").is(":checked") ) {
				$applicationEmailGroup.find('*').removeClass("has-success").removeClass("has-error");
				$applicationEmailGroup.find('.error-field').remove();

				$applicationEmailField.val('');
				$applicationEmailField.prop('required', false);
				$applicationEmailField.prop('disabled', true);

				$contactPointPost.prop("checked",true);
				$contactPointPost.parents().first().addClass("active");

				$contactPointEmail.attr('disabled', true);
				$contactPointEmail.parents('.btn-form-inverse').removeClass("active").attr('disabled',true);

				$('#health_application_optInEmail-group').slideUp();
			}else{
				$applicationEmailField.prop('required', true);
				$applicationEmailField.prop('disabled', false);
				$contactPointEmail.parents('.btn-form-inverse').attr('disabled',false);
				$contactPointEmail.prop('disabled', false);
			}
		}
		onChangeNoEmailChkBox();
		$("#health_application_no_email").on("click.NIB",function() {onChangeNoEmailChkBox();});

	},
	unset: function(){
		$('#update-premium').off('click.NIB');

		$("#health_application_email").prop('required', true);
		$("#health_application_email").prop('disabled', false);
		$("#health_application_contactPoint_E").prop('disabled', false);
		$("#health_application_contactPoint_E").parents('.btn-form-inverse').attr('disabled',false);

		$('#health_application_no_email').off('click.NIB');
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);

		//Contact Point question
		healthApplicationDetails.hideHowToSendInfo();

		healthFunds._reset();

		//Authority off
		healthFunds._previousfund_authority(false);

		//dependant definition off
		healthFunds._dependants(false);

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();
	}
};



/* WFD
======================= */
var healthFunds_WFD = {

	ajaxJoinDec: false,

	set: function(){
		//calendar for start cover
		meerkat.modules.healthPaymentStep.setCoverStartRange(0, 30);

		//dependant definition
		healthFunds._dependants('As a member of Westfund all children aged up to 21 are covered on a family policy. Children aged between 21-24 are entitled to stay on your cover at no extra charge if they are a full time or part-time student at School, college or University TAFE institution or serving an Apprenticeship or Traineeship.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':18, 'schoolMax':24, 'schoolID':true };

		//Adding a statement
		var msg = 'Please note that the LHC amount quoted is an estimate and will be confirmed once Westfund has verified your details.';
		$('.health-payment-details_premium .row-content').append('<p class="statement" style="margin-top:1em">' + msg + '</p>');

		//fund Name's become optional
		$('#health_previousfund_primary_fundName').removeAttr("required");
		$('#health_previousfund_partner_fundName').removeAttr("required");

		//fund ID's become optional
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");

		//Authority
		healthFunds._previousfund_authority(true);

		//credit card & bank account frequency & day frequency
		meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });

			//claims account
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//selections for payment date
		$('#update-premium').on('click.WFD', function() {

			var deductionDate = returnDate($('#health_payment_details_start').val());
			var distance = 4 - deductionDate.getDay();
			if(distance < 2) { // COB Tue cutoff to make Thu of same week for payment
				distance += 7;
			}
			deductionDate.setDate(deductionDate.getDate() + distance);

			var day = deductionDate.getDate();
			var isTeen = (day > 10 && day < 20);
			if((day % 10) == 1 && !isTeen ) {
					day += "st";
			} else if((day % 10) == 2 && !isTeen ) {
					day += "nd";
			} else if((day % 10) == 3 && !isTeen ) {
					day += "rd";
			} else {
					day += "th";
			}

			var deductionText = 'Please note that your first or full payment (annual frequency) ' +
				'will be debited from your payment method on ' + healthFunds._getDayOfWeek(deductionDate) + " " + day + " " + healthFunds._getMonth(deductionDate);

			$('.health_credit-card-details_policyDay-message').text( deductionText);
			$('.health_bank-details_policyDay-message').text(deductionText);

			var _dayString = leadingZero(deductionDate.getDate() );
			var _monthString = leadingZero(deductionDate.getMonth() + 1 );
			var deductionDateValue = deductionDate.getFullYear() +'-'+ _monthString +'-'+ _dayString;

			$('.health-credit-card_details-policyDay option').val(deductionDateValue);
			$('.health-bank_details-policyDay option').val(deductionDateValue);

		});

		//Age requirements for applicants
		//primary
		healthFunds_WFD.$_dobPrimary = $('#health_application_primary_dob');
		//partner
		healthFunds_WFD.$_dobPartner = $('#health_application_partner_dob');

		meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPrimary, 18 , "primary person's");
		meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPartner, 18, "partner's");

		// Load join dec into label
		healthFunds_WFD.joinDecLabelHtml = $('#health_declaration + label').html();
		healthFunds_WFD.ajaxJoinDec = $.ajax({
			url: 'health_fund_info/WFD/declaration.html',
			type: 'GET',
			async: true,
			dataType: 'html',
			timeout: 20000,
			cache: true,
			success: function(htmlResult) {
				$('#health_declaration + label').html(htmlResult);
				$('a#joinDeclarationDialog_link').remove();
			},
			error: function(obj,txt) {
			}
		});

	},
	unset: function() {
		$('#update-premium').off('click.WFD');
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);

		healthFunds._reset();

		//dependant definition off
		healthFunds._dependants(false);

		//reset the join dec to original general label and abort AJAX request
		if (healthFunds_WFD.ajaxJoinDec) {
			healthFunds_WFD.ajaxJoinDec.abort();
		}
		$('#health_declaration + label').html(healthFunds_WFD.joinDecLabelHtml);

		$('.health-payment-details_premium .statement').remove();

		//fund Name's become mandaory (back to default)
		$('#health_previousfund_primary_fundName').attr('required', 'required');
		$('#health_previousfund_partner_fundName').attr('required', 'required');

		//Authority Off
		healthFunds._previousfund_authority(false);

		//Age requirements for applicants (back to default)
		meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPrimary, dob_health_application_primary_dob.ageMin , "primary person's");
		meerkat.modules.validation.setMinAgeValidation(healthFunds_WFD.$_dobPartner, dob_health_application_partner_dob.ageMin, "partner's");

		delete healthFunds_WFD.$_dobPrimary;
		delete healthFunds_WFD.$_dobPartner;
	}
};