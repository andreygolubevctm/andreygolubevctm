/* jshint -W058 *//* Missing closure */
/* jshint -W032 *//* Unnecessary semicolons */
/* jshint -W041 *//* Use '!==' to compare with '' */
/*

	All this code is legacy and needs to be reviewed at some point (turned into modules etc).
	The filename is prefixed with underscores to bring it to the top alphabetically for compilation.

*/


/**
 * isLessThan31Or31AndBeforeJuly1() test whether the dob provided makes the user less than
 * 31 or is currently 31 but the current datea is before 1st July following their birthday.
 *
 * @param _dobString	String representation of a birthday (eg 24/02/1986)
 * @returns {Boolean}
 */
function isLessThan31Or31AndBeforeJuly1(_dobString) {
	if(_dobString === '') return false;
	var age = Math.floor(meerkat.modules.age.returnAge(_dobString));
	if( age < 31 ) {
		return true;
	} else if( age == 31 ){
		var dob = meerkat.modules.dateUtils.returnDate(_dobString);
		var birthday = meerkat.modules.dateUtils.returnDate(_dobString);
		birthday.setFullYear(dob.getFullYear() + 31);
		var now = new Date();
		if ( dob.getMonth() + 1 < 7 && (now.getMonth() + 1 >= 7 || now.getFullYear() > birthday.getFullYear()) ) {
			return false;
		} else if (dob.getMonth() + 1 >= 7 && now.getMonth() + 1 >= 7 && now.getFullYear() > birthday.getFullYear()) {
			return false;
		} else {
			return true;
		}
	} else if(age > 31){
		return false;
	} else {
		return false;
	}
}

//reset the radio object from a button container
function resetRadio($_obj, value){

	if($_obj.val() != value){
		$_obj.find('input').prop('checked', false);
		$_obj.find('label').removeClass('active');

		if(typeof value !== "undefined"){
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

	setCover : function(cover) {
		healthChoices._cover = cover;

		healthChoices.updateSituation();
	},

	updateSituation : function() {
		var $familyTile = $('#health_situation_healthSitu_CSF').siblings("span").first();
		var copy = $familyTile.text();

		switch(this._cover) {
			case 'F':
			case 'SPF':
				copy = copy.replace('Start a family','Grow my family');
				break;
			default:
				copy = copy.replace('Grow my family','Start a family');
		};
		$familyTile.text(copy);
	},
	setSituation: function(situation, performUpdate) {
		if (performUpdate !== false)
			performUpdate = true;

		//// Change the message
		if (situation != healthChoices._situation) {
			healthChoices._situation = situation;
		};

		$('#health_benefits_healthSitu').val( situation );

		if (!_.isEmpty(situation)) {
			$("input[name=health_situation_healthSitu]").filter('[value='+situation+']').prop('checked', true).trigger('change');
		}

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
		}
	},

	//return readable values
	returnCover: function() {
		return $('#health_situation_healthCvr option:selected').text();
	},

	returnCoverCode: function() {
		return this._cover;
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