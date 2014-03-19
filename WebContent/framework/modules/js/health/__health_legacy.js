/* jshint -W058 *//* Missing closure */
/* jshint -W032 *//* Unnecessary semicolons */
/* jshint -W041 *//* Use '!==' to compare with '' */
/*

	All this code is legacy and needs to be reviewed at some point (turned into modules etc).
	The filename is prefixed with underscores to bring it to the top alphabetically for compilation.

*/
function returnAge(_dobString, round){
	var _now = new Date;
		_now.setHours(0,0,0);
	var _dob = returnDate(_dobString);
	var _years = _now.getFullYear() - _dob.getFullYear();

	if(_years < 1){
		return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
	};

	//leap year offset
	var _leapYears = _years - ( _now.getFullYear() % 4);
	_leapYears = (_leapYears - ( _leapYears % 4 )) /4;
	var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;
	var _offset2;

	//birthday offset - as it's always so close
	if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
		_offset2 = -0.005;
	} else {
		_offset2 = +0.005;
	};

	var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
	if (round) {
		return Math.floor(_age);
	}
	else {
		return _age;
	}
};

function returnDate(_dateString){
	if(_dateString === '') return null;
	var dateComponents = _dateString.split('/');
	if(dateComponents.length < 3) return null;
	return new Date(dateComponents[2], dateComponents[1] - 1, dateComponents[0]);
};

$(document).ready(function(){

	$("#health_contactDetails_optin").on("click", function(){
		$("#health_contactDetails_optInEmail").val( $(this).is(":checked") ? "Y" : "N" );
	})

	$('input.phone').on('blur', function(event) {
		var id = $(this).attr('id');
		var hiddenFieldName = id.substr(0, id.indexOf('input'));
		var hiddenField = $('#' + hiddenFieldName);
	});

	var applicationEmailElement;
	var emailOptinElement;
	var optIn;

	if( $('#health_altContactFormRendered') ) {

		applicationEmailElement = $('#health_application_email');
		emailOptinElement = $('#health_application_optInEmail');

		applicationEmailElement.on('blur', function(){
			optIn = false;
			var email = $(this).val();
			if(isValidEmailAddress(email)) {
				optIn = true;
			}

		});

		$(document).on(meerkat.modules.events.saveQuote.EMAIL_CHANGE, function(event, optIn, emailAddress) {
			if(!isValidEmailAddress(applicationEmailElement.val()) && isValidEmailAddress(emailAddress) && optIn) {
				applicationEmailElement.val(emailAddress).trigger('blur');
			}
		});

	} else {
		applicationEmailElement = $('#health_application_email');
		emailOptInElement = $('#health_application_optInEmail');

		emailOptInElement.change(function() {
			optIn = $(this).is(':checked');
		});
		applicationEmailElement.change(function() {
			optIn = emailOptInElement.is(':checked');
			emailOptInElement.show();
			$("label[for='health_application_optInEmail']").show();
		});

		$(document).on(meerkat.modules.events.saveQuote.EMAIL_CHANGE, function(event, optIn, emailAddress) {
			if(!isValidEmailAddress(applicationEmailElement.val())) {
				applicationEmailElement.val(emailAddress);
			}
			if(applicationEmailElement.val() == emailAddress) {
				if(optIn) {
					emailOptInElement.prop('checked', true);
					emailOptInElement.hide();
					$("label[for='health_application_optInEmail']").hide();
				} else {
					emailOptInElement.prop('checked', null);
					emailOptInElement.show();
					$("label[for='health_application_optInEmail']").show();
				}
			}
		});
	}

	// from dependants.tag
	healthDependents.init();
	// end from dependants.tag

});

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
		healthCoverDetails.setTiers(initMode);

		//// If price filter is present update it
		if(typeof priceMinSlider !== "undefined"){
			priceMinSlider.reset();
		};
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
		} else if (HealthSettings.isFromBrochureSite) {
			//Crappy input which doesn't get validated on brochureware quicklaunch should be cleared as they didn't get the opportunity to see results via typeahead on our side.
			//console.debug('valid loc:',healthChoices.isValidLocation(location),'| from brochure:',HealthSettings.isFromBrochureSite,'| action: clearing');
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
		healthCoverDetails.setTiers();
		$('.health_cover_details_dependants').hide();
		$('#health_healthCover_tier').hide();
		$('#health_rebates_group').hide();
	}

}


var healthCoverDetails = {

	//// //RESOLVE: this object was quickly constructed from an anon. function, and can be cleaner

	getRebateChoice: function(){
		return $('#health_healthCover-selection').find('.health_cover_details_rebate :checked').val();
	},

	setIncomeBase: function(initMode){
		if(healthChoices._cover == 'S' && healthCoverDetails.getRebateChoice() == 'Y'){
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

	getRebateAmount: function(base, age_bonus) {
		age_bonus = age_bonus || 0;

		// "Old" percentages
		//return base + age_bonus;

		// "New" percentages HLT-871
		return ((base + age_bonus) * HealthSettings.rebate_multiplier_current).toFixed(HealthSettings.rebate_multiplier_current !== 1 ? 3 : 0);
	},

	//// Manages the descriptive titles of the tier drop-down
	setTiers: function(initMode){

		//// Set the dependants allowance and income message
		var _allowance = ($('#health_healthCover_dependants').val() - 1);

		if( _allowance > 0 ){
			_allowance = _allowance * 1500;
			$('#health_healthCover_incomeMessage').text('this includes an adjustment for your dependants');
		} else {
			_allowance = 0;
			$('#health_healthCover_incomeMessage').text('');
		};

		//// Set the tier type based on hierarchy of selection
		var _cover;
		if( $('#health_healthCover_incomeBase').is(':visible') && $('#health_healthCover_incomeBase').find(':checked').length > 0 ) {
			_cover = $('#health_healthCover_incomeBase').find(':checked').val();
		} else {
			_cover = healthChoices.returnCoverCode();
		};

		//// Reset and then loop through all of the options
		$('#health_healthCover_income').find('option').each( function(){
			//set default vars
			var $this = $(this);
			var _value = $this.val();
			var _text = '';

			//// Calculate the Age Bonus
			if( meerkat.modules.health.getRates() === null){
				_ageBonus = 0;
			} else {
				_ageBonus = parseInt(meerkat.modules.health.getRates().ageBonus);
			};

			if(_cover == 'S' || _cover == ''){
				//// Single tiers
				switch(_value)
				{
				case '0':
					//_text = '$'+ (88000 + _allowance) +' or less ('+ healthCoverDetails.getRebateAmount(30, _ageBonus) +'% rebate)';
					_text = '$'+ (88000 + _allowance) +' or less';
					break;
				case '1':
					//_text = '$'+ (88001 + _allowance) +' - $'+ (102000 + _allowance) + ' ('+ healthCoverDetails.getRebateAmount(20, _ageBonus) +'% rebate)';
					_text = '$'+ (88001 + _allowance) +' - $'+ (102000 + _allowance);
					break;
				case '2':
					//_text = '$'+ (102001 + _allowance) +' - $'+ (136000 + _allowance) + ' ('+ healthCoverDetails.getRebateAmount(10, _ageBonus) +'% rebate)';
					_text = '$'+ (102001 + _allowance) +' - $'+ (136000 + _allowance);
					break;
				case '3':
					_text = '$'+ (136001 + _allowance) + '+ (no rebate)';
					break;
				};
			} else {
				//// Family tiers
				switch(_value)
				{
				case '0':
					//_text = '$'+ (176000 + _allowance) +' or less ('+ healthCoverDetails.getRebateAmount(30, _ageBonus) +'% rebate)';
					_text = '$'+ (176000 + _allowance) +' or less';
					break;
				case '1':
					//_text = '$'+ (176001 + _allowance) +' - $'+ (204000 + _allowance) + ' ('+ healthCoverDetails.getRebateAmount(20, _ageBonus) +'% rebate)';
					_text = '$'+ (176001 + _allowance) +' - $'+ (204000 + _allowance);
					break;
				case '2':
					//_text = '$'+ (204001 + _allowance) +' - $'+ (272000 + _allowance) + ' ('+ healthCoverDetails.getRebateAmount(10, _ageBonus) +'% rebate)';
					_text = '$'+ (204001 + _allowance) +' - $'+ (272000 + _allowance);
					break;
				case '3':
					_text = '$'+ (272000 + _allowance) + '+ (no rebate)';
					break;
				};
			};

			//// Set Description
			if(_text != ''){
				$this.text(_text);
			};

			//// Hide these questions as they are not required
			if( healthCoverDetails.getRebateChoice() == 'N' || !healthCoverDetails.getRebateChoice() ) {
				if(initMode){
					$('#health_healthCover_tier').hide();
				}else{
					$('#health_healthCover_tier').slideUp();
				}

				$('.health-medicare_details').hide();
			} else {

				if(initMode){
					$('#health_healthCover_tier').show();
				}else{
					$('#health_healthCover_tier').slideDown();
				}

				$('.health-medicare_details').show();
			}
		});


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



/**
 * isLessThan31Or31AndBeforeJuly1() test whether the dob provided makes the user less than
 * 31 or is currently 31 but the current datea is before 1st July following their birthday.
 *
 * @param _dobString	String representation of a birthday (eg 24/02/1986)
 * @returns {Boolean}
 */
function isLessThan31Or31AndBeforeJuly1(_dobString) {
	if(_dobString === '') return false;
	var age = Math.floor(returnAge(_dobString));
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

		if(value != null){
			$_obj.find('input[value='+ value +']').prop('checked', 'checked');
			$_obj.find('input[value='+ value +']').parent().addClass("active");
		}
	}

};

//return a number with a leading zero if required
function leadingZero(value){
	if(value < 10){
		value = '0' + value;
	};
	return value;
}

Number.prototype.formatMoney = function(c, d, t){
	c = isNaN(c = Math.abs(c)) ? 2 : c;
	d = d == undefined ? "." : d;
	t = t == undefined ? "," : t;
	var n = this,
		s = n < 0 ? "-" : "",
		i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
		j = (j = i.length) > 3 ? j % 3 : 0;

	return '$' + s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

isValidEmailAddress = function(emailAddress) {
	var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
	return pattern.test(emailAddress);
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

			$.ajax({
				url: 'common/js/health/healthFunds_'+fund+'.jsp',
				dataType: 'script',
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
					//console.log('error', obj, txt)
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
		if(required) {
			$('#clientMemberID').find('input').rules('add', 'required');
			$('#partnerMemberID').find('input').rules('add', 'required');
		} else {
			$('#clientMemberID').find('input').rules('remove', 'required');
			$('#partnerMemberID').find('input').rules('remove', 'required');
		}
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
		};
		var effectiveDate = returnDate(effectiveDateString)
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
				var _dayString = leadingZero( _date.getDate() );
				var _monthString = leadingZero( _date.getMonth() + 1 );
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
						var _dayString = leadingZero( _date.getDate() );
						var _monthString = leadingZero( _date.getMonth() + 1 );
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
		var contactPointText = contactPoint.text();
		contactPoint.text( providerName);
		if (required) {
			contactPointGroup.find('input').rules('add', {required:true, messages:{required:'Please choose how you would like ' + providerName + ' to contact you'}});
		}
		else {
			contactPointGroup.find('input').rules('remove', 'required');
		}
		contactPointGroup.removeClass('hidden');
	},
	hideHowToSendInfo: function() {
		var contactPointGroup = $('#health_application_contactPoint-group');
		contactPointGroup.addClass('hidden');
	},
	addOption: function(labelText, formValue) {
		var el = $('#health_application_contactPoint');

		el.append('<label class="btn btn-default"><input id="health_application_contactPoint_' + formValue + '" type="radio" data-msg-required="Please choose " value="' + formValue + '" name="health_application_contactPoint">' + labelText + '</label>');

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



// FROM POPUP_PAYMENT_EXTERNAL.TAG
var paymentGateway = {

	name: '',
	handledType: {},
	_hasRegistered: false,
	_type: '',
	_calledBack: false,
	_timeout: false,
	modalId: '',

	hasRegistered: function() {
		return this._hasRegistered;
	},

	success: function(params) {
		if (!params || !params.number || !params.type || !params.expiry || !params.name) {
			this.fail('Registration response parameters invalid');
			return false;
		}
		this._hasRegistered = true;
		this._outcome(true);
		$('#' + paymentGateway.name + '-registered').val('1').valid(); // Mark registration as valid
		$('#' + paymentGateway.name + '_number').val(params.number); // Populate hidden fields with values returned by Westpac
		$('#' + paymentGateway.name + '_type').val(params.type);
		$('#' + paymentGateway.name + '_expiry').val(params.expiry);
		$('#' + paymentGateway.name + '_name').val(params.name);

		$('.' + paymentGateway.name + ' .launcher').slideUp();
		$('.' + paymentGateway.name + ' .success').slideDown();
		$('.' + paymentGateway.name + ' .fail').slideUp();
	},

	fail: function(_msg) {

		this._outcome(false);

		$('#' + paymentGateway.name + '-registered').val(''); // Reset hidden fields
		$('#' + paymentGateway.name + '_number').val('');
		$('#' + paymentGateway.name + '_type').val('');
		$('#' + paymentGateway.name + '_expiry').val('');
		$('#' + paymentGateway.name + '_name').val('');

		$('.' + paymentGateway.name + ' .launcher').slideDown();
		$('.' + paymentGateway.name + ' .success').slideUp();
		$('.' + paymentGateway.name + ' .fail').slideDown();

		if (_msg && _msg.length > 0) {
			meerkat.modules.errorHandling.error({
				message:		_msg,
				page:			'health_quote.jsp',
				description:	'paymentGateway.fail()',
				silent:			true
			});
		}
	},

	_outcome: function(success) {
		this._calledBack = true;
		meerkat.modules.dialogs.destroyDialog(paymentGateway.modalId);
	},

	setType: function(type) {
		if (this._type != type) {
			this._hasRegistered = false;
		}
		if ((type == 'cc' && this.handledType.credit) || (type == 'ba' && this.handledType.bank)) {
			this._type = type;
		}
		else {
			this._type = '';
		}
		this.togglePanels();
		return (this._type != '');
	},

	setTypeFromControl: function() {
		this.setType(meerkat.modules.healthPaymentStep.getSelectedPaymentMethod());
		this.setType($("input[name='health_payment_details_type']:checked").val());
	},

	togglePanels: function() {

		if (this.hasRegistered()) {
			$('.' + paymentGateway.name + ' .launcher').slideUp();
			$('.' + paymentGateway.name + ' .success').slideDown();
			$('.' + paymentGateway.name + ' .fail').slideUp();
		}
		else {
			$('#' + paymentGateway.name + '-registered').val('');
			$('.' + paymentGateway.name + ' .launcher').slideDown();
			$('.' + paymentGateway.name + ' .success').slideUp();
			$('.' + paymentGateway.name + ' .fail').slideUp();
		}

		switch (this._type) {
			case 'cc':
				$('.' + paymentGateway.name + '-credit').slideDown();
				$('#' + paymentGateway.name + '-registered').rules('add', {required:true, messages:{required:'Please register your credit card details'}});
				break;
			default:
				$('.' + paymentGateway.name + '-credit').slideUp('','', function(){ $(this).hide(); });
				$('#' + paymentGateway.name + '-registered').rules('remove', 'required');
		}
	},

	// Reset settings and unhook
	reset: function() {
		this.handledType = {'credit': false, 'bank': false };
		this._type = '';
		this._hasRegistered = false;
		this.togglePanels();

		$('body').removeClass(paymentGateway.name + '-active');
		this.clearValidation();
		$('#' + paymentGateway.name + '-registered').val('');

		// Turn off events
		$('#health_payment_details_claims').find('input').off('change.' + paymentGateway.name);
		$('#update-premium').off('click.' + paymentGateway.name);

		// Reset normal question panels in case user is moving between different products
		$('#health_payment_details_type').trigger('change');
	},

	clearValidation: function() {
		$('#' + paymentGateway.name + '-registered').rules('remove', 'required');
	},

	init: function(name) {
		paymentGateway.name = name;

		this.reset();

		$('body').addClass(paymentGateway.name + '-active');

		// Hook into: "update premium" button to determine which panels to display
		$('#update-premium').on('click.' + paymentGateway.name, function() {
			paymentGateway.setTypeFromControl();
		});

	},

	// MODAL
	launch: function() {

		paymentGateway._calledBack = false;

		meerkat.modules.tracking.recordSupertag('trackCustomPage', 'Payment gateway popup');

		paymentGateway.modalId = meerkat.modules.dialogs.show({
			htmlContent: meerkat.modules.loadingAnimation.getTemplate(),
			onOpen: function(id) {
				clearTimeout(paymentGateway._timeout);
				paymentGateway._timeout = setTimeout(function() {
					var type = '';
					if (paymentGateway._type == 'ba') {
						type = 'DD';// For westpac
					}
					// Switch content to the iframe
					meerkat.modules.dialogs.changeContent(id, '<iframe width="100%" height="340" frameBorder="0" src="ajax/html/health_paymentgateway.jsp?type=' + type + '"></iframe>');
				}, 1000);
			},
			onClose: function() {
				clearTimeout(paymentGateway._timeout);

				if (!paymentGateway._calledBack) {
					paymentGateway.fail();
				}
			}
		});
	}
};
// END POPUP_PAYMENT_EXTERNAL.TAG

// END FROM payment.tag

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
				$_obj = $('#health_application_dependants_dependant' + healthDependents._dependents)
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

	addSchool: function(index, age){
		if( healthDependents.config.school === false ){
			$('#health_application_dependants-selection').find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
			return false;
		};
		if( (age >= healthDependents.config.schoolMin) && (age <= healthDependents.config.schoolMax) ){
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').show();
			// Show/hide ID number field, with optional validation
			if( healthDependents.config.schoolID === false ) {
				$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolIDGroup').hide();
			}
			else {
				if (this.config.schoolIDMandatory === true) {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolID').rules('add', {required:true, messages:{required:'Please enter dependant '+index+'\'s student ID'}});
				}
				else {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolID').rules('remove', 'required');
				}
			};
			// Show/hide date study commenced field, with optional validation
			if (this.config.schoolDate !== true) {
				$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolDateGroup').hide();
			}
			else {
				if (this.config.schoolDateMandatory === true) {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolDate').rules('add', {required:true, messages:{required:'Please enter date that dependant '+index+' commenced study'}});
				}
				else {
					$('#health_application_dependants-selection').find('#health_application_dependants_dependant' + index + '_schoolDate').rules('remove', 'required');
				}
			};
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
		};
	},

	addDefacto: function(index, age){
		if( healthDependents.config.defacto === false ){
			return false;
		};
		if( (age >= healthDependents.config.defactoMin) && (age <= healthDependents.config.defactoMax) ){
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').show();
		} else {
			$('#health_application_dependants-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').hide();
		};
	},

	hasChanged: function( ){
		var $_obj = $('#health_application_dependants-selection').find('.health-dependants-tier');
		if(healthCoverDetails.getRebateChoice() == 'N' ) {
			$_obj.slideUp();
		} else if( healthDependents._dependents > 0 ){
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

// from credit_card_details.tag
creditCardDetails = {

	resetConfig: function(){
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex':true, 'diners':false };
	},

	render: function(){
		var $_obj = $('#health_payment_credit_type');
		var $_icons = $('#health_payment_credit-selection .cards');
		$_icons.children().hide();

		var _html = '<option id="health_payment_credit_type_" value="">Please choose...</option>';
		var _selected = $_obj.find(':selected').val();


		if( creditCardDetails.config.visa === true ){
			_html += '<option id="health_payment_credit_type_v" value="v">Visa</option>';
			$_icons.find('.visa').show();
		};

		if( creditCardDetails.config.mc === true ){
			_html += '<option id="health_payment_credit_type_m" value="m">Mastercard</option>';
			$_icons.find('.mastercard').show();
		};

		if( creditCardDetails.config.amex === true ){
			_html += '<option id="health_payment_credit_type_a" value="a">AMEX</option>';
			$_icons.find('.amex').show();
		};

		if( creditCardDetails.config.diners === true ){
			_html += '<option id="health_payment_credit_type_d" value="d">Diners Club</option>';
			$_icons.find('.diners').show();
		};

		$_obj.html( _html ).find('option[value='+ _selected +']').attr('selected', 'selected');
		return;
	},

	set: function(){
		creditCardDetails.$_obj = $('#health_payment_credit_number');
		creditCardDetails.$_objCCV = $('#health_payment_credit_ccv');
		var _type = creditCardDetails._getType();

		field_credit_card_validation.set(_type, creditCardDetails.$_obj, creditCardDetails.$_objCCV);
	},

	_getType: function(){
		return $('#health_payment_credit_type').find(':selected').val();
	}
};
// end from credit_card_details.tag

