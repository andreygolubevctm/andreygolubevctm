/* jshint -W058 *//* Missing closure */
/* jshint -W032 *//* Unnecessary semicolons */
/* jshint -W041 *//* Use '!==' to compare with '' */
/*

	All this code is legacy and needs to be reviewed at some point (turned into modules etc).
	The filename is prefixed with underscores to bring it to the top alphabetically for compilation.

*/

/* Utilities functions for health */

function returnDate(_dateString){
	if(_dateString === '') return null;
	var dateComponents = _dateString.split('/');
	if(dateComponents.length < 3) return null;
	return new Date(dateComponents[2], dateComponents[1] - 1, dateComponents[0]);
};

/**
 * isLessThan31Or31AndBeforeJuly1() test whether the dob provided makes the user less than
 * 31 or is currently 31 but the current datea is before 1st July following their birthday.
 *
 * @param _dobString	String representation of a birthday (eg 24/02/1986)
 * @returns {Boolean}
 */
function isLessThan31Or31AndBeforeJuly1(_dobString) {
	if(_dobString === '') return false;
	var age = Math.floor(meerkat.modules.utils.returnAge(_dobString));
	if( age < 31 ) {
		return false;
	} else if( age == 31 ){
		var dob = returnDate(_dobString);
		var birthday = returnDate(_dobString);
		birthday.setFullYear(dob.getFullYear() + 31);
		var now = new Date();
		if ( dob.getMonth() + 1 < 7 && (now.getMonth() + 1 >= 7 || now.getFullYear() > birthday.getFullYear()) ) {
			return true;
		} else if (dob.getMonth() + 1 >= 7 && now.getMonth() + 1 >= 7 && now.getFullYear() > birthday.getFullYear()) {
			return true;
		} else {
			return false;
		}
	} else if(age > 31){
		return true;
	} else {
		return false;
	}
}

//reset the radio object from a button container
function resetRadio($_obj, value){

	if($_obj.val() != value){
		$_obj.find('input').prop('checked', false);
		$_obj.find('label').removeClass('active');

		if(value !== null){
			$_obj.find('input[value='+ value +']').prop('checked', 'checked');
			$_obj.find('input[value='+ value +']').parent().addClass("active");
		}
	}

};

//return a number with comma for thousands
function formatMoney(value){
	var parts = value.toString().split(".");
	parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	return parts.join(".");
}

/**
 * FATAL ERROR TAG
 */
var FatalErrorDialog = {
	display:function(sentParams){
		FatalErrorDialog.exec(sentParams);
	},
	init:function(){},
	exec:function(sentParams){

		var params = $.extend({
			errorLevel: "silent",
			message: "A fatal error has occurred.",
			page: "undefined.jsp",
			description: null,
			data: null
		}, sentParams);

		meerkat.modules.errorHandling.error(params);

	}
};


// Used in split_test.tag
var Track = {
	splitTest:function splitTesting(result, supertagName){
		meerkat.modules.tracking.recordSupertag('splitTesting',{
			version:result,
			splitTestName: supertagName
		});
	}
};

// from choices.tag
var healthChoices = {
	_cover : '',
	_situation : '',
	_state : '',
	_benefits : new Object,
	_performUpdate:false,

	initialise: function(cover, situation, benefits) {
		healthChoices.setCover(cover, true, true);
		var performUpdate = this._performUpdate;
		healthChoices.setSituation(situation, performUpdate);
	},

	hasSpouse : function() {
		switch(this._cover) {
			case 'C':
			case 'F':
				return true;
			default:
				return false;
		};
	},

	hasChildren : function() {
		switch(this._cover) {
			case 'F':
			case 'SPF':
				return true;
			default:
				return false;
		};
	},

	setCover : function(cover, ignore_rebate_reset, initMode) {
		ignore_rebate_reset = ignore_rebate_reset || false;
		initMode = initMode || false;

		healthChoices._cover = cover;

		if( !ignore_rebate_reset ) {
			healthChoices.resetRebateForm();
		}

		if(!healthChoices.hasSpouse()) {
			healthChoices.flushPartnerDetails();
			$('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').hide();
		} else {
			$('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').show();
		};

		//// See if Children should be on or off
		healthChoices.dependants(initMode);

		//// Set the auxillary data
		//Health.setRates();
		healthCoverDetails.displayHealthFunds();
		meerkat.modules.healthTiers.setTiers(initMode);
	},

	setSituation: function(situation, performUpdate) {
		if (performUpdate !== false)
			performUpdate = true;

		//// Change the message
		if (situation != healthChoices._situation) {
			healthChoices._situation = situation;
		};

		$('#health_benefits_healthSitu, #health_situation_healthSitu').val( situation );

	},

	isValidLocation : function( location ) {

		var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(location));

		if( value != '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}

		return false;
	},

	setLocation : function(location) {

		if( healthChoices.isValidLocation(location) ) {
			var value = $.trim(String(location));
			var pieces = value.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');
			$('#health_situation_state').val(state);
			$('#health_situation_postcode').val(postcode).trigger("change");
			$('#health_situation_suburb').val(suburb);

			healthChoices.setState(state);
		} else if (meerkat.site.isFromBrochureSite) {
			//Crappy input which doesn't get validated on brochureware quicklaunch should be cleared as they didn't get the opportunity to see results via typeahead on our side.
			//console.debug('valid loc:',healthChoices.isValidLocation(location),'| from brochure:',meerkat.site.isFromBrochureSite,'| action: clearing');
			$('#health_situation_location').val("");
		}
	},

	setState : function(state) {
		healthChoices._state = state;
	},

	setDob : function(value, $_obj) {
		if(value != ''){
			$_obj.val(value);
		};
	},

	dependants: function(initMode) {

		if( healthChoices.hasChildren() && $('.health_cover_details_rebate :checked').val() == 'Y' ) {
			// Show the dependants questions
			if(initMode === true){
				$('.health_cover_details_dependants').show();
			}else{
				$('.health_cover_details_dependants').slideDown();
			}
		} else {
			// Reset questions and hide
			if(initMode === true){
				$('.health_cover_details_dependants').hide();
			}else{
				$('#health_healthCover_dependants option:selected').prop("selected", false);
				$('#health_healthCover_income option:selected').prop("selected", false);
				$('.health_cover_details_dependants').slideUp();
			}
		}
	},

	//return readable values
	returnCover: function() {
		return $('#health_situation_healthCvr option:selected').text();
	},

	returnCoverCode: function() {
		return this._cover;
	},

	flushPartnerDetails : function() {
		$('#health_healthCover_partner_dob').val('').change();
		$('#partner-health-cover input[name="health_healthCover_partner_cover"]:checked').each(function(){
			$(this).checked = false;
		});
		resetRadio($('#health_healthCover_partnerCover'));
		$('#partner-health-cover input[name="health_healthCover_partner_healthCoverLoading"]:checked').each(function(){
			$(this).checked = false;
		});
		resetRadio($('#health-continuous-cover-partner'));
	},

	resetRebateForm : function() {
		$('#health_healthCover_health_cover_rebate input[name="health_healthCover_rebate"]:checked').each(function(){
			$(this).checked = false;
		});
		resetRadio($('#health_healthCover_health_cover_rebate'));
		$('#health_healthCover_dependants option').first().prop("selected", true);
		$('#health_healthCover_dependants option:selected').prop("selected", false);
		$('#health_healthCover_income option').first().prop("selected", true);
		$('#health_healthCover_income option:selected').prop("selected", false);
		$('#health_healthCover_incomelabel').val('');
		healthCoverDetails.setIncomeBase();
		healthChoices.dependants();
		meerkat.modules.healthTiers.setTiers();
		$('.health_cover_details_dependants').hide();
		$('#health_healthCover_tier').hide();
		$('#health_rebates_group').hide();
	}

};


var healthCoverDetails = {

	//// //RESOLVE: this object was quickly constructed from an anon. function, and can be cleaner

	getRebateChoice: function(){
		return $('#health_healthCover-selection').find('.health_cover_details_rebate :checked').val();
	},

	setIncomeBase: function(initMode){
		if((healthChoices._cover == 'S' || healthChoices._cover == 'SM' || healthChoices._cover == 'SF') && healthCoverDetails.getRebateChoice() == 'Y'){
			if(initMode){
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').show();
			}else{
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').slideDown();
			}
		} else {
			if(initMode){
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').hide();
			}else{
				$('#health_healthCover-selection').find('.health_cover_details_incomeBasedOn').slideUp();
			}
		};
	},

	//// Previous funds, settings
	displayHealthFunds: function(){
		var $_previousFund = $('#mainform').find('.health-previous_fund');
		var $_primaryFund = $('#clientFund').find('select');
		var $_partnerFund = $('#partnerFund').find('select');

		if( $_primaryFund.val() != 'NONE' && $_primaryFund.val() != ''){
			$_previousFund.find('#clientMemberID').slideDown();
			$_previousFund.find('.membership').addClass('onA');
		} else {
			$_previousFund.find('#clientMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onA');
		}

		if( healthChoices.hasSpouse() && $_partnerFund.val() != 'NONE' && $_partnerFund.val() != ''){
			$_previousFund.find('#partnerMemberID').slideDown();
			$_previousFund.find('.membership').addClass('onB');
		} else {
			$_previousFund.find('#partnerMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onB');
		}
	},

	setHealthFunds: function(initMode){
		//// Quick variables
		var _primary = $('#health_healthCover_primaryCover').find(':checked').val();
		var _partner = $('#health_healthCover_partnerCover').find(':checked').val();
		var $_primaryFund = $('#clientFund').find('select');
		var $_partnerFund = $('#partnerFund').find('select');

		//// Primary Specific
		if( _primary == 'Y' ) {

			if( isLessThan31Or31AndBeforeJuly1($('#health_healthCover_primary_dob').val()) ) {
				if(initMode){
					$('#health-continuous-cover-primary').show();
				}else{
					$('#health-continuous-cover-primary').slideDown();
				}

			}else{
				if(initMode){
					$('#health-continuous-cover-primary').hide();
				}else{
					$('#health-continuous-cover-primary').slideUp();
				}

			}

		} else {
			if( _primary == 'N'){
				resetRadio($('#health-continuous-cover-primary'),'N');
			};
			if(initMode){
				$('#health-continuous-cover-primary').hide();
			}else{
				$('#health-continuous-cover-primary').slideUp();
			}

		};

		if( _primary == 'Y' && $_primaryFund.val() == 'NONE'){
			$_primaryFund.val('');
		} else if(_primary == 'N'){
			$_primaryFund.val('NONE');
		};

		//// Partner Specific
		if( _partner == 'Y' ) {

			if( isLessThan31Or31AndBeforeJuly1($('#health_healthCover_partner_dob').val()) ) {
				if(initMode){
					$('#health-continuous-cover-partner').show();
				}else{
					$('#health-continuous-cover-partner').slideDown();
				}

			}else{
				if(initMode){
					$('#health-continuous-cover-partner').hide();
				}else{
					$('#health-continuous-cover-partner').slideUp();
				}

			}
		} else {
			if( _partner == 'N'){
				resetRadio($('#health-continuous-cover-partner'),'N');
			};
			if(initMode){
				$('#health-continuous-cover-partner').hide();
			}else{
				$('#health-continuous-cover-partner').slideUp();
			}

		};

			if( _partner == 'Y' && $_partnerFund.val() == 'NONE'){
				$_partnerFund.val('');
			} else if(_partner == 'N'){
				$_partnerFund.val('NONE');
			};

		//// Adjust the questions further along
		healthCoverDetails.displayHealthFunds();
	},

	getAgeAsAtLastJuly1: function( dob )
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(6 < month || (6 == month && 1 < day))
		{
			age--;
		}

		return age;
	}
};

// FROM HEALTH_FUNDS.TAG
var healthFunds = {
	_fund: false,
	name: 'the fund',

	countFrom : {
		TODAY: 'today' , NOCOUNT: '' , EFFECTIVE_DATE: 'effectiveDate'
	},
	minType : {
		FROM_TODAY: 'today' , FROM_EFFECTIVE_DATE: 'effectiveDate'
	},

	// If retrieving a quote and a product had been selected, inject the fund's application set.
	// This is in case any custom form fields need access to the data bucket, because write_quote will erase the data when it's not present in the form.
	// A fund must implement the processOnAmendQuote property for this to occur.
	checkIfNeedToInjectOnAmend: function(callback) {
		if ($('#health_application_provider').val().length > 0) {
			var provider = $('#health_application_provider').val(),
				objname = 'healthFunds_' + provider;

			$(document.body).addClass('injectingFund');

			healthFunds.load(
				provider,
				function injectFundLoaded() {
					if (window[objname].processOnAmendQuote && window[objname].processOnAmendQuote === true) {
						window[objname].set();
						window[objname].unset();
					}

					$(document.body).removeClass('injectingFund');

					callback();
				},
				false
			);

		}else{
			callback();
		}
	},

	// Create the 'child' method over-ride
	load: function(fund, callback, performProcess) {

		if (fund == '' || !fund) {
			healthFunds.loadFailed('Empty or false');
			return false;
		};

		if (performProcess !== false) performProcess = true;

		// Load separate health fund JS
		if (typeof window['healthFunds_' + fund] === 'undefined' || window['healthFunds_' + fund] == false) {
			var returnval = true;

			var data = {
				transactionId:meerkat.modules.transactionId.get()
			};

			$.ajax({
				url: 'common/js/health/healthFunds_'+fund+'.jsp',
				dataType: 'script',
				data:data,
				async: true,
				timeout: 30000,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache";
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function() {
					// Process
					if (performProcess) {
						healthFunds.process(fund);
					}
					// Callback
					if (typeof callback === 'function') {
						callback(true);
					}
				},
				error: function(obj,txt){
					healthFunds.loadFailed(fund, txt);

					if (typeof callback === 'function') {
						callback(false);
					}
				}
			});

			return false; //waiting
		}

		// If same fund then don't need to re-apply the rules
		if (fund != healthFunds._fund && performProcess) {
			healthFunds.process(fund);
		};

		// Success callback
		if (typeof callback === 'function') {
			callback(true);
		}

		return true;
	},

	process: function(fund) {

		// set the main object's function calls to the specific provider
		var O_method = window['healthFunds_' + fund];

		healthFunds.set = O_method.set;
		healthFunds.unset = O_method.unset;

		// action the provider
		$('body').addClass(fund);

		healthFunds.set();
		healthFunds._fund = fund;

	},

	loadFailed: function(fund, errorTxt) {
		FatalErrorDialog.exec({
			message:		"Unable to load the fund's application questions",
			page:			"health:health_funds.tag",
			description:	"healthFunds.update(). Unable to load fund questions for: " + fund,
			data:			errorTxt
		});
	},

	// Remove the main provider piece
	unload: function(){
		if(healthFunds._fund !== false){
			healthFunds.unset();
			$('body').removeClass( healthFunds._fund );
			healthFunds._fund = false;
			healthFunds.set = function(){};
			healthFunds.unset = function(){};
		}
	},

	// Fund customisation setting, used via the fund 'child' object
	set: function(){
	},

	// Unpicking the fund customisation settings, used via the fund 'child' object
	unset: function(){
	},

	// Additional sub-functions to help render application questions

	applicationFailed: function(){
		return false;
	},

	_memberIdRequired: function(required){
		$('#clientMemberID input[type=text], #partnerMemberID input[type=text]').setRequired(required);
	},

	_dependants: function(message){
		if(message !== false){
			// SET and ADD the dependant definition
			healthFunds.$_dependantDefinition = $('#mainform').find('.health-dependants').find('.definition');
			healthFunds.HTML_dependantDefinition = healthFunds.$_dependantDefinition.html();
			healthFunds.$_dependantDefinition.html(message);
		} else {
			healthFunds.$_dependantDefinition.html( healthFunds.HTML_dependantDefinition );
			healthFunds.$_dependantDefinition = undefined;
			healthFunds.HTML_dependantDefinition = undefined;
		};
	},

	_previousfund_authority: function(message) {
		if(message !== false){
			// SET and ADD the authority 'label'
			healthFunds.$_authority = $('.health_previous_fund_authority label span');
			healthFunds.$_authorityText = healthFunds.$_authority.eq(0).text();
			healthFunds.$_authority.text( meerkat.modules.healthResults.getSelectedProduct().info.providerName );
			$('.health_previous_fund_authority').removeClass('hidden');
		}
		else if (typeof healthFunds.$_authority !== 'undefined') {
			healthFunds.$_authority.text( healthFunds.$_authorityText );
			healthFunds.$_authority = undefined;
			healthFunds.$_authorityText = undefined;
			$('.health_previous_fund_authority').addClass('hidden');
		};
	},

	_partner_authority: function(display) {
		if (display === true) {
			$('.health_person-details_authority_group').removeClass('hidden');
		} else {
			$('.health_person-details_authority_group').addClass('hidden');
		}
	},

	_reset: function() {
		healthApplicationDetails.hideHowToSendInfo();
		healthFunds._partner_authority(false);
		healthFunds._memberIdRequired(true);
		healthDependents.resetConfig();
	},

	// Create payment day options on the fly - min and max are in + days from the selected date;
	//NOTE: max - min cannot be a negative number
	_paymentDays: function( effectiveDateString ){
		// main check for real value
		if( effectiveDateString == ''){
			return false;
		}
		var effectiveDate = returnDate(effectiveDateString);
		var today = new Date();

		var _baseDate = null;
		if(healthFunds._payments.countFrom == healthFunds.countFrom.TODAY ) {
			_baseDate = today;
		} else {
			_baseDate = effectiveDate;
		}
		var _count = 0;

		var _days = 0;
		var _limit = healthFunds._payments.max;
		if(healthFunds._payments.minType == healthFunds.minType.FROM_TODAY ) {
			var difference = Math.round((effectiveDate-today)/(1000*60*60*24));
			if(difference < healthFunds._payments.min) {
				_days = healthFunds._payments.min - difference;
			}
		} else {
			_days = healthFunds._payments.min;
			_limit -= healthFunds._payments.min;
		}



		var _html = '<option value="">Please choose...</option>';

		// The loop to create the payment days
		var continueCounting = true;
		while (_count < _limit) {
			var _date = new Date( _baseDate.getTime() + (_days * 24 * 60 * 60 * 1000));
			var _day = _date.getDay();
			// up to certain payment day
			if( typeof(healthFunds._payments.maxDay) != 'undefined' && healthFunds._payments.maxDay < _date.getDate() ){
				_days++;
				// Parse out the weekends
			} else if( !healthFunds._payments.weekends && ( _day == 0 || _day == 6 ) ){
				_days++;
			} else {
				var _dayString = meerkat.modules.numberUtils.leadingZero( _date.getDate() );
				var _monthString = meerkat.modules.numberUtils.leadingZero( _date.getMonth() + 1 );
				_html += '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'">'+ healthFunds._getNiceDate(_date) +'</option>';
				_days++;
				_count++;
			};
		};

		// Return the html
		return _html;
	},

	// Creates the earliest date based on any of the matching days (not including an exclusion date)
	_earliestDays: function(euroDate, a_Match, _exclusion){
			if( !$.isArray(a_Match) || euroDate == '' ){
				return false;
			};
			// creating the base date from the exclusion
			var _now = returnDate(euroDate);
			// 2014-03-05 Leto: Why is this hardcoded when it's also a function argument?
			_exclusion = 7;
			var _date = new Date( _now.getTime() + (_exclusion * 24 * 60 * 60 * 1000));
			var _html = '<option value="">No date has been selected for you</option>';
			// Loop through 31 attempts to match the next date
			for (var i=0; i < 31; i++) {
				/*var*/ _date = new Date( _date.getTime() + (1 * 24 * 60 * 60 * 1000));
				// Loop through the selected days and attempt a match
				for(a=0; a < a_Match.length; a++) {
					if(a_Match[a] == _date.getDate() ){
						var _dayString = meerkat.modules.numberUtils.leadingZero( _date.getDate() );
						var _monthString = meerkat.modules.numberUtils.leadingZero( _date.getMonth() + 1 );
						/*var*/ _html = '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'" selected="selected">'+ healthFunds._getNiceDate(_date) +'</option>';
						i = 99;
						break;
					};
				};
			};
			return _html;
	},

	// Renders the payment days text
	_paymentDaysRender: function($_object,_html){
		if(_html === false){
			healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
			_html = '<option value="">Please choose...</option>';
		};
		$_object.html(_html);
		$_object.parent().siblings('p').text( 'Your payment will be deducted on: ' + $_object.find('option').first().text() );
		$('.health-bank_details-policyDay, .health-credit-card_details-policyDay').html(_html);
	},


	_getDayOfWeek: function( dateObj ) {
		var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		return  days[dateObj.getDay()];
	},

	_getMonth: function( dateObj ) {
		var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		return  months[dateObj.getMonth()];
	},

	_getNiceDate : function( dateObj ) {
		var day = dateObj.getDate();
		var year = dateObj.getFullYear();
		return healthFunds._getDayOfWeek(dateObj) + ", " + day + " " + healthFunds._getMonth(dateObj) + " " + year;
	}
};

// END FROM HEALTH_FUNDS.TAG


// FROM APPLICATION_DETAILS.TAG
var healthApplicationDetails = {
	preloadedValue: $("#contactPointValue").val(),
	periods: 1,

	init: function(){
		postalMatchHandler.init('health_application');
	},

	showHowToSendInfo: function(providerName, required) {
		var contactPointGroup = $('#health_application_contactPoint-group');
		var contactPoint = contactPointGroup.find('.control-label span');
		contactPoint.text( providerName);
		contactPointGroup.find('input').setRequired(required, 'Please choose how you would like ' + providerName + ' to contact you');

		contactPointGroup.removeClass('hidden');
	},
	hideHowToSendInfo: function() {
		var contactPointGroup = $('#health_application_contactPoint-group');
		contactPointGroup.addClass('hidden');
	},
	addOption: function(labelText, formValue) {
		var el = $('#health_application_contactPoint');

		el.append('<label class="btn btn-form-inverse"><input id="health_application_contactPoint_' + formValue + '" type="radio" data-msg-required="Please choose " value="' + formValue + '" name="health_application_contactPoint">' + labelText + '</label>');

		if (el.find('input:checked').length == 0 && this.preloadedValue == formValue) {
			$('#health_application_contactPoint_' + formValue).prop('checked', true);
		}
	},
	removeLastOption: function() {
		var el = $('#health_application_contactPoint');
		el.find('label').last().remove();
	},
	testStatesParity : function() {
		var element = $('#health_application_address_state');
		if( element.val() != $('#health_situation_state').val() ){

			var suburb = $('#health_application_address_suburbName').val();
			var postcode = $('#health_application_address_postCode').val();
			var state = $('#health_application_address_state').val();
			if( suburb.length && suburb.indexOf('Please select') < 0 && postcode.length == 4 && state.length ) {
				$('#health_application_address_postCode').addClass('error');
				return false;
			}
		}
		return true;
	}
};
// END FROM APPLICATION_DETAILS.TAG

// from dependants.tag
var healthDependents = {

	_dependents: 0,
	_limit: 12,
	maxAge: 25,

	init: function()
	{
		healthDependents.resetConfig();
	},

	resetConfig: function(){

		healthDependents.config = {
			'fulltime': false,
			'school':true,
			'schoolMin':22,
			'schoolMax':24,
			'schoolID':false,
			'schoolIDMandatory':false,
			'schoolDate':false,
			'schoolDateMandatory':false,
			'defacto':false,
			'defactoMin':21,
			'defactoMax':24
		};

		healthDependents.maxAge = 25;
	},

	setDependants: function()
	{
		var _dependants = $('#mainform').find('.health_cover_details_dependants').find('select').val();
		if( healthCoverDetails.getRebateChoice() == 'Y' && !isNaN(_dependants)) {
			healthDependents._dependents = _dependants;
		} else {
			healthDependents._dependents = 1;
		}

		if( healthChoices.hasChildren() ) {
			$('#health_application_dependants-selection').show();
		} else {
			$('#health_application_dependants-selection').hide();
			return;
		}

		healthDependents.updateDependentOptionsDOM();

		$('#health_application_dependants-selection').find('.health_dependant_details').each( function(){
			var index = parseInt( $(this).attr('data-id') );
			if( index > healthDependents._dependents )
			{
				$(this).hide();
			}
			else
			{
				$(this).show();
			};

			healthDependents.checkDependent( index );
		});
	},
	addDependent: function()
	{
		if( healthDependents._dependents < healthDependents._limit )
		{
			healthDependents._dependents++;
			var $_obj = $('#health_application_dependants_dependant' + healthDependents._dependents);

			// Reset values
			$_obj.find('input[type=text], select').val('');
			resetRadio($_obj.find('.health_dependant_details_maritalincomestatus'),'');

			// Reset validation
			$_obj.find('.error-field label').remove();
			$_obj.find('.has-error, .has-success').removeClass('has-error').removeClass('has-success');

			$_obj.show();
			healthDependents.updateDependentOptionsDOM();
			healthDependents.hasChanged();

			$('html').animate({
				scrollTop: $_obj.offset().top -50
			}, 250);
		}
	},
	dropDependent: function()
	{
		if( healthDependents._dependents > 0 )
		{
			$('#health_application_dependants_dependant' + healthDependents._dependents).find("input[type=text]").each(function(){
				$(this).val("");
			});
			$('#health_application_dependants_dependant' + healthDependents._dependents).find("input[type=radio]:checked").each(function(){
				this.checked = false;
			});
			$('#health_application_dependants_dependant' + healthDependents._dependents).find("select").each(function(){
				$(this).removeAttr("selected");
			});
			$('#health_application_dependants_dependant' + healthDependents._dependents).hide();
			healthDependents._dependents--;
			healthDependents.updateDependentOptionsDOM();
			healthDependents.hasChanged();

			if(healthDependents._dependents > 0){
				$_obj = $('#health_application_dependants_dependant' + healthDependents._dependents);
			}else{
				$_obj = $('#health_application_dependants-selection');
			}

			$('html').animate({
				scrollTop: $_obj.offset().top -50
			}, 250);
		}
	},
	updateDependentOptionsDOM: function()
	{
		if( healthDependents._dependents <= 0 ) {
			// hide all remove dependant buttons
			$("#health_application_dependants-selection").find(".remove-last-dependent").hide();

			$('#health_application_dependants_threshold').slideDown();
			//$("#health_application_dependants_dependantrequired").val("").addClass("validate");
		} else if( !$("#dependents_list_options").find(".remove-last-dependent").is(":visible") ) {
			$('#health_application_dependants_threshold').slideUp();

			// Show ONLY the last remove dependant button
			$("#health_application_dependants-selection").find(".remove-last-dependent").hide(); // 1st, hide all.
			$("#health_application_dependants-selection .health_dependant_details:visible:last").find(".remove-last-dependent").show();


			//$("#health_application_dependants_dependantrequired").val("ignoreme").removeClass("validate");
		};

		if( healthDependents._dependents >= healthDependents._limit ) {
			$("#health-dependants").find(".add-new-dependent").hide();
		} else if( $("#health-dependants").find(".add-new-dependent").not(":visible") ) {
			$("#health-dependants").find(".add-new-dependent").show();
		};
	},
	checkDependent: function(e)
	{
		var index = e;
		if( isNaN(e) && typeof e == 'object' ) {
			index = e.data;
		};
		// Create an age check mechanism
		var dob = $('#health_application_dependants_dependant' + index + '_dob').val();
		var age;

		if( !dob.length){
			age = 0;
		} else {
			age = healthDependents.getAge(dob);
			if( isNaN(age) ){
				return false;
			}
		}

		// Check the individual questions
		healthDependents.addFulltime(index, age);
		healthDependents.addSchool(index, age);
		healthDependents.addDefacto(index, age);
	},

	getAge: function( dob )
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
		{
			age--;
		}

		return age;
	},

	addFulltime: function(index, age){
		if( healthDependents.config.fulltime !== true ){
			$('#health_application_dependants-selection').find('.health_dependant_details_fulltimeGroup').hide();
			// reset validation of dob to original
			//TODO: Fix this to ensure the rules are added/removed properly.
			$('#health_application_dependants_dependant' + index + '_dob').removeRule('validateFulltime').addRule('limitDependentAgeToUnder25');
			return false;
		}

		if( (age >= healthDependents.config.schoolMin) && (age <= healthDependents.config.schoolMax) ){
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_fulltimeGroup').show();
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_fulltimeGroup').hide();
		}

		// change validation method for dob field if fulltime is enabled
		//TODO: Fix this to ensure the rules are added/removed properly.
		$('#health_application_dependants_dependant' + index + '_dob').removeRule('limitDependentAgeToUnder25').addRule('validateFulltime');
		
	},

	addSchool: function(index, age){
		if( healthDependents.config.school === false ){
			$('#health_application_dependants-selection').find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
			return false;
		};
		if( (age >= healthDependents.config.schoolMin) && (age <= healthDependents.config.schoolMax) 
			&& (healthDependents.config.fulltime !== true || $('#health_application_dependants_dependant' + index + '_fulltime_Y').is(':checked')) )
		{
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').show();
			// Show/hide ID number field, with optional validation
			if( healthDependents.config.schoolID === false ) {
				$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolIDGroup').hide();
			}
			else {
				$('#health_application_dependants_dependant' + index + '_schoolID').setRequired(this.config.schoolIDMandatory, 'Please enter dependant '+index+'\'s student ID');
			};
			// Show/hide date study commenced field, with optional validation
			if (this.config.schoolDate !== true) {
				$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolDateGroup').hide();
			}
			else {
				$('#health_application_dependants_dependant' + index + '_schoolDate').setRequired(this.config.schoolDateMandatory, 'Please enter date that dependant '+index+' commenced study');
			};
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
		};
	},

	addDefacto: function(index, age){
		if( healthDependents.config.defacto === false ){
			return false;
		}
		if( (age >= healthDependents.config.defactoMin) && (age <= healthDependents.config.defactoMax) ){
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').show();
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').hide();
		}
	},

	hasChanged: function( ){
		var $_obj = $('#health_application_dependants-selection').find('.health-dependants-tier');
		if(healthCoverDetails.getRebateChoice() == 'N' ) {
			$_obj.slideUp();
		} else if( healthDependents._dependents > 0 ) {
			// Call the summary panel error message
			//healthPolicyDetails.error();

			// Refresh/Call the Dependants and rebate tiers
			$('#health_healthCover_dependants').val( healthDependents._dependents ).trigger('change');

			// Change the income questions
			var $_original = $('#health_healthCover_tier');
			$_obj.find('select').html( $_original.find('select').html() );
			$_obj.find('#health_application_dependants_incomeMessage').text( $_original.find('span').text() );
			if( $_obj.is(':hidden') ){
				$_obj.slideDown();
			};
		} else {
			$_obj.slideUp();
		};
	}
};


// end from dependants.tag