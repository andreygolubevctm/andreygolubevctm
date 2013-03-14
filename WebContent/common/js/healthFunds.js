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
	},
	unset: function(){
	}
};



/* AUF
======================= */
var healthFunds_AUF = {
	set: function(){
		//dependant definition
		healthFunds._dependants('This policy provides cover for children under the age of 23 or who are aged between 23-25 years and engaged in full time study. Student dependents do not need to be living at home to be added to the policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');
		
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
			ReferenceNo.getTransactionID( ReferenceNo._FLAG_INCREMENT );
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
		healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependents aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');	
		
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
		healthFunds._dependants('This policy provides cover for your children up to their 21st birthday and dependents aged between 21 and 24 who are studying full time. Adult dependents outside these criteria can still be covered by applying for a separate policy.');
		
		//schoolgroups and defacto
		healthDependents.config = { 'school':true, 'defacto':false, 'schoolMin':21, 'schoolMax':24 };
		
		//fund ID's become optional
		$('#clientMemberID').find('input').rules("remove", "required");
		$('#partnerMemberID').find('input').rules("remove", "required");
		
		//credit card & bank account frequency & day frequency
		paymentSelectsHandler.bank = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		paymentSelectsHandler.frequency = { 'weekly':27, 'fortnightly':27, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 };
		
			//claims account
			paymentSelectsHandler.creditBankSupply = true;
			paymentSelectsHandler.creditBankQuestions = true;
				
		//credit card options
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
		creditCardDetails.render();
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
			var _html = healthFunds._earliestDays( $(this).val(), [1], 3);
			healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
			healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
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
	unset: function(){
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
