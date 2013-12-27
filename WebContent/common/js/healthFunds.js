/*
Fund Specific JS
- See the tag "healthFunds" for the parent object
- NOTE: see also the healthfunds.css which may provide visual differences
*/



/* HCF
======================= */
//HCF is usually setting the default values
var healthFunds_HCF = {
	set: function(){
	},
	unset: function(){
	}
};



/* AHM
======================= */
var healthFunds_AHM = {
	set: function(){
		//Dependants
		healthFunds._dependants('ahm Health Insurance provides cover for your children up to the age of 21 plus students who are single and studying full time aged between 21 and 25. Adult dependants outside this criteria can be covered by an additional premium on certain covers so please call Compare the Market on 1800777712 or chat to our consultants online to discuss your health cover needs.');
		//change age of dependants and school
		healthDependents.maxAge = 25;
		//schoolgroups and defacto
		$.extend(healthDependents.config, { 'school':true, 'schoolMin':21, 'schoolMax':24, 'schoolID':true, 'schoolIDMandatory':true, 'schoolDate':true, 'schoolDateMandatory':true });

		//School list
		var list = '<select><option value="">Please choose...</option>';
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
		$('.health_dependant_details_schoolGroup .fieldrow_value').each(function(i) {
			var name = $(this).find('input').attr('name');
			var id = $(this).find('input').attr('id');
			$(this).append(list);
			$(this).find('select').attr('name', name).attr('id', id+'select');
			$(this).find('select').rules('add', {required:true, messages:{required:'Please select dependant '+(i+1)+'\'s school'}});
		});
		$('.health_dependant_details_schoolIDGroup input').attr('maxlength', '10');
		$('.health_dependant_details_schoolDateGroup input').mask('99/99/9999', {placeholder: 'DD/MM/YYYY'});
		//Change the Name of School label
		healthFunds_AHM.tmpSchoolLabel = $('.health_dependant_details_schoolGroup .fieldrow_label').html();
		$('.health_dependant_details_schoolGroup .fieldrow_label').html('Tertiary Institution this dependant is attending');
		$('.health_dependant_details_schoolGroup .help_icon').hide();

		//Previous fund
		$('#health_previousfund_primary_authority').rules('add', {required:true, messages:{required:'AHM require authorisation to contact your previous fund'}});
		$('#health_previousfund_partner_authority').rules('add', {required:true, messages:{required:'AHM require authorisation to contact your partner\'s previous fund'}});
		$('#health_previousfund_primary_memberID').attr('maxlength', '10');
		$('#health_previousfund_partner_memberID').attr('maxlength', '10');

		//Authority
		healthFunds._authority(true);

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':true, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };

		//claims account
		paymentSelectsHandler.creditBankSupply = true;
		paymentSelectsHandler.creditBankQuestions = true;

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//selections for payment date
		$('#update-step').on('click.AHM', function() {
			var freq = paymentSelectsHandler.getFrequency();
			if (freq == 'W' || freq == 'F') {
				healthFunds._payments = { 'min':3, 'max':8, 'weekends':false };
			} else {
				healthFunds._payments = { 'min':3, 'max':32, 'weekends':true };
			}
			var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
			if (freq == 'M' || freq == 'A') {
				$('.health-bank_details-policyDay option, .health-credit-card_details-policyDay option').each(function (index) {
					if (this.value.length >= 3) {
						var end = this.value.substring(this.value.length - 3);
						if (end=='-29' || end=='-30' || end=='-31') {
							$(this).remove();
						}
					}
				});
			}
		});

		//calendar for start cover
		healthCalendar._min = 1;
		healthCalendar._max = 28;
		healthCalendar.update();

		//Payment gateway
		healthFunds.paymentGateway = paymentGateway;
		healthFunds.paymentGateway.init();
		healthFunds.paymentGateway.handledType.credit = true;
		healthFunds.paymentGateway.handledType.bank = false;
	},
	unset: function(){
		//Dependants
		healthFunds._dependants(false);
		//schoolgroups and defacto
		healthDependents.resetConfig();

		//School list
		$('.health_dependant_details_schoolGroup select').remove();
		$('.health_dependant_details_schoolIDGroup input').removeAttr('maxlength');
		$('.health_dependant_details_schoolDateGroup input').unmask();
		//Change the Name of School label
		$('.health_dependant_details_schoolGroup .fieldrow_label').html(healthFunds_AHM.tmpSchoolLabel);
		delete healthFunds_AHM.tmpSchoolLabel;
		$('.health_dependant_details_schoolGroup .help_icon').show();

		//Previous fund
		$('#health_previousfund_primary_authority').rules('remove', 'required');
		$('#health_previousfund_partner_authority').rules('remove', 'required');
		$('#health_previousfund_primary_memberID').removeAttr('maxlength');
		$('#health_previousfund_partner_memberID').removeAttr('maxlength');

		//Authority off
		healthFunds._authority(false);

		//credit card & bank account frequency & day frequncy
		paymentSelectsHandler.resetFrequencyCheck();

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#update-step').off('click.AHM');

		//calendar for start cover
		healthCalendar.reset();

		//Payment gateway
		healthFunds.paymentGateway.reset();
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
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true };

		//calendar for start cover
		healthCalendar._min = 0;
		healthCalendar._max = 30;
		healthCalendar.update();

		//selections for payment date
		healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
		$('#health_payment_details_start').on('change.AUF', function(){
			var _html = healthFunds._paymentDays( $(this).val()  );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
		});

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
		creditCardDetails.render();

		//failed application
		healthFunds.applicationFailed = function(){
			referenceNo.generateNewTransactionID(3);
		};
	},
	unset: function(){
		//dependant definition off
		healthFunds._dependants(false);

		//fund IDs become mandatory (default)
		$('#clientMemberID').find('input').rules("add", "required");
		$('#partnerMemberID').find('input').rules("add", "required");

		//schoolgroups and defacto
		healthDependents.resetConfig();

		//credit card & bank account frequency & day frequncy
		paymentSelectsHandler.resetFrequencyCheck();

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#health_payment_details_start').off('change.AUF');

		//failed application
		healthFunds.applicationFailed = function(){ return false; };
	}
};



/* FRA (Frank)
======================= */
var healthFunds_FRA = {
	set: function(){
		//dependant definition
		healthFunds._dependants('This policy provides cover for children until their 21st birthday. Adult dependants over 21 years old can be covered by applying for a separate singles policy.');

		//Authority
		healthFunds._authority(true);

		//remove the DR in your details
		healthFunds.$_optionDR = $('.person-title').find('option[value=DR]').first();
		$('.person-title').find('option[value=DR]').remove();

		//selections for payment date
		$('#health_payment_details_start').on('change.FRA', function(){
			var _html = healthFunds._earliestDays( $(this).val(), new Array(1,15), 7);
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
		});

		//change age of dependants and school
		healthDependents.config.school = false;
		healthDependents.maxAge = 21;

		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };

		//claims account
		paymentSelectsHandler.creditBankQuestions = true;

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//calendar for start cover
		healthCalendar._min = 0;
		healthCalendar._max = 30;
		healthCalendar.update();

	},
	unset: function(){
		//dependant definition off
		healthFunds._dependants(false);

		//Authority off
		healthFunds._authority(false);

		//re-insert the DR in your details
		$('.person-title').append( healthFunds.$_optionDR    );

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		$('#health_payment_details_start').off('change.FRA');

		//reset age of dependants, schoolgroups and defacto
		healthDependents.resetConfig();

		//fund IDs become mandatory (default)
		$('#clientMemberID').find('input').rules("add", "required");
		$('#partnerMemberID').find('input').rules("add", "required");

		//credit card & bank account frequency & day frequncy
		paymentSelectsHandler.resetFrequencyCheck();

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		//calendar for start cover
		healthCalendar.reset();

	}
};



/* GMF
======================= */
var healthFunds_GMF = {
	set: function(){
		//dependant definition
		healthFunds._dependants('This policy provides cover for your children up to their 21st birthday. Dependants aged under 25 may also be added to the policy provided they are not married or in a defacto relationship and earn less than $20,500 p/annum. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':false, 'defacto':true, 'defactoMin':21, 'defactoMax':24 };

		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		//medicare message - once a medicare number has been added - show the message (or if prefilled show the message)
		healthFunds_GMF.$_medicareMessage = $('#health_medicareDetails_message');
		healthFunds_GMF.$_medicareMessage.text('GMF will send you an email shortly so that your rebate can be applied to the premium');
			//check if filled or bind
			if( healthFunds_GMF.$_medicareMessage.siblings('input').val() != '' ){
				healthFunds_GMF.$_medicareMessage.fadeIn();
			} else {
				healthFunds_GMF.$_medicareMessage.hide();
				healthFunds_GMF.$_medicareMessage.siblings('input').on('change.GMF', function(){
					//FIX: REFINE: check for validity once medicare validation created
					if( $(this).val() != '' ){
						healthFunds_GMF.$_medicareMessage.fadeIn();
					};
				});
			};

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.frequency = { 'weekly':28, 'fortnightly':28, 'monthly':28, 'quarterly':28, 'halfyearly':28, 'annually':28 };

			//claims account
			paymentSelectsHandler.creditBankQuestions = true;

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

	},
	unset: function(){
		//dependant definition off
		healthFunds._dependants(false);

		//schoolgroups and defacto
		healthDependents.resetConfig();

		//fund IDs become mandatory (default)
		$('#clientMemberID').find('input').rules("add", "required");
		$('#partnerMemberID').find('input').rules("add", "required");

		//medicare message
		healthFunds_GMF.$_medicareMessage.text('').hide();
		healthFunds_GMF.$_medicareMessage.siblings('input').unbind('change.GMF');
		delete healthFunds_GMF.$_medicareMessage;

		//credit card & bank account frequency & day frequncy
		paymentSelectsHandler.resetFrequencyCheck();

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();
	}
};



/* GMH (GMHBA)
======================= */
var healthFunds_GMH = {
	set: function(){
		//Authority
		healthFunds._authority(true);

		//dependant definition
		healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':21, 'schoolMax':24 };

		//school labels
		healthFunds._schoolLabel = $('#mainform').find('.health_dependant_details_schoolGroup').first().find('.fieldrow_label').text();
		$('#mainform').find('.health_dependant_details_schoolGroup').find('.fieldrow_label').text('Name of school/employer/educational institution your child is attending');

		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':true, 'halfyearly':true, 'annually':true };
		paymentSelectsHandler.frequency = { 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 };

		//claims account
		paymentSelectsHandler.creditBankQuestions = true;

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//calendar for start cover
		healthCalendar._min = 0;
		healthCalendar._max = 30;
		healthCalendar.update();

		//selections for payment date
		$('#health_payment_details_start').on('change.GMH', function(){
			var _html = healthFunds._earliestDays( $(this).val(), [1], 7);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
		});

	},
	unset: function(){
		//Authority off
		healthFunds._authority(false);

		//dependant definition off
		healthFunds._dependants(false);

		//schoolgroups and defacto
		healthDependents.resetConfig();

		//school labels off
		$('#mainform').find('.health_dependant_details_schoolGroup').find('.fieldrow_label').text( healthFunds._schoolLabel );

		//fund IDs become mandatory (default)
		$('#clientMemberID').find('input').rules("add", "required");
		$('#partnerMemberID').find('input').rules("add", "required");

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.resetFrequencyCheck();

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		//calendar for start cover
		healthCalendar.reset();

		//selections for payment date
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		$('#health_payment_details_start').off('change.GMH');

	}
};



/* NIB
======================= */
var healthFunds_NIB = {
	set: function(){
		//Contact Point question
		healthFunds.$_contactPointGroup = $('#mainform').find('.health_application-details_contact-group');
		healthFunds.$_contactPoint = healthFunds.$_contactPointGroup.find('.fieldrow_label').find('span');
		healthFunds.$_contactPointText = healthFunds.$_contactPoint.text();
		healthFunds.$_contactPoint.text( Results._selectedProduct.info.providerName );
		healthFunds.$_contactPointGroup.find('input').rules('add', {required:true, messages:{required:'Please choose how you would like the fund to contact you'}});

		//Authority
		healthFunds._authority(true);

		//dependant definition
		healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependants aged between 21 and 24 who are studying full time. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':21, 'schoolMax':24 };

		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		//calendar for start cover
		healthCalendar._min = 0;
		healthCalendar._max = 29;
		healthCalendar.update();

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.frequency = { 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 };

		//claims account
		paymentSelectsHandler.creditBankSupply = true;
		paymentSelectsHandler.creditBankQuestions = true;

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
		creditCardDetails.render();

		$('#update-step').on('click.NIB', function() {
			var freq = paymentSelectsHandler.getFrequency();
			if (freq == 'F') {
				healthFunds._payments = { 'min':0, 'max':10, 'weekends':false, 'countFrom' : 'effectiveDate'};
			} else {
				healthFunds._payments = { 'min':0, 'max':27, 'weekends':true , 'countFrom' : 'today', 'maxDay' : 27};
			}
			var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
		});
	},
	unset: function(){
		//Contact Point question
		healthFunds.$_contactPointGroup.find('input').rules('remove', 'required');
		healthFunds.$_contactPoint.text( healthFunds.$_contactPointText );
		delete healthFunds.$_contactPoint;
		delete healthFunds.$_contactPointText;
		delete healthFunds.$_contactPointGroup;

		//Authority off
		healthFunds._authority(false);

		//dependant definition off
		healthFunds._dependants(false);

		//schoolgroups and defacto
		healthDependents.resetConfig();

		//fund IDs become mandatory (default)
		$('#clientMemberID').find('input').rules("add", "required");
		$('#partnerMemberID').find('input').rules("add", "required");

		//calendar for start cover
		healthCalendar.reset();

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.resetFrequencyCheck();

		//credit card options
		creditCardDetails.resetConfig();
		creditCardDetails.render();
	}
};



/* WFD
======================= */
var healthFunds_WFD = {
	set: function(){
		//calendar for start cover
		healthCalendar._min = 0;
		healthCalendar._max = 30;
		healthCalendar.update();

		//dependant definition
		healthFunds._dependants('As a member of Westfund, your children aged between 18-24 are entitled to stay on your cover at no extra charge if they are a full time or part-time student at School, college or University TAFE institution or serving an Apprenticeship or Traineeship.');

		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':18, 'schoolMax':24, 'schoolID':true };

		//Adding a statement to the join declaration
		var msg = 'Please note that the LHC amount quoted is an estimate and will be confirmed once Westfund has verified your details.';
		healthFunds_WFD.$_declaration = $('#health_declaration-selection');
		healthFunds_WFD.$_declaration.find('.fieldrow_value').prepend('<p class="statement">' + msg + '</p>');

		//fund Name's become optional
		$('#health_previousfund_primary_fundName').rules("remove", "required");
		$('#health_previousfund_partner_fundName').rules("remove", "required");

		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");

		//Authority
		healthFunds._authority(true);

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };

			//claims account
			paymentSelectsHandler.creditBankQuestions = true;

		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':false, 'diners':false };
		creditCardDetails.render();

		//selections for payment date
		$('#health_payment_details_start').on('change.WFD', function(){

			var deductionDate = returnDate($(this).val());
			var distance = 4 - deductionDate.getDay();
			if(distance < 1) {
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
			$('.health_bank-details_policyDay-message option').val(deductionDateValue);

		});

		//Age requirements for applicants
		//primary
		healthFunds_WFD.$_dobPrimary = $('#health_application_primary_dob');
		healthFunds_WFD.defaultAgeMin = dob_health_application_primary_dob.ageMin;
		dob_health_application_primary_dob.ageMin = 18;
		healthFunds_WFD.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_WFD.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );
		//partner
		healthFunds_WFD.$_dobPartner = $('#health_application_partner_dob');
		dob_health_application_partner_dob.ageMin = 18;
		healthFunds_WFD.$_dobPartner.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_WFD.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

	},
	unset: function() {
		//calendar for start cover
		healthCalendar.reset();

		//dependant definition off
		healthFunds._dependants(false);

		//schoolgroups and defacto
		healthDependents.resetConfig();

		//Removing a statement to the join declaration
		healthFunds_WFD.$_declaration.find('.statement').remove();
		delete healthFunds_WFD.$_declaration;

		//fund Name's become mandaory (back to default)
		$('#health_previousfund_primary_fundName').rules("add", "required");
		$('#health_previousfund_partner_fundName').rules("add", "required");

		//fund IDs become mandatory (back to default)
		$('#clientMemberID').find('input').rules("add", "required");
		$('#partnerMemberID').find('input').rules("add", "required");

		//Authority Off
		healthFunds._authority(false);

		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.resetFrequencyCheck();

		//selections for payment date OFF
		healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), false);
		healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), false);
		$('#health_payment_details_start').off('change.WFD');

		//Age requirements for applicants (back to default)
		dob_health_application_primary_dob.ageMin = healthFunds_WFD.defaultAgeMin;
		healthFunds_WFD.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_primary_dob': healthFunds_WFD.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );

		dob_health_application_partner_dob.ageMin = healthFunds_WFD.defaultAgeMin;
		healthFunds_WFD.$_dobPrimary.rules('add', {messages: {'min_dob_health_application_partner_dob': healthFunds_WFD.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

		delete healthFunds_WFD.defaultAgeMin;
		delete healthFunds_WFD.$_dobPrimary;
		delete healthFunds_WFD.$_dobPartner;
	}
};