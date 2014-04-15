
/*-- --------------------------------------------------------------- --*/
/*-- --- Common utilitarian bits for the whole vehicle selection --- --*/
/*-- --------------------------------------------------------------- --*/

/*-- Re-used HTML snippets --*/
var pleaseChooseOptionHTML = "<option value=''>Please choose...</option>";
var resetOptionHTML = "<option value=''>&nbsp;</option>";
var notFoundOptionHTML = "<option value=''>No match for above choices</option>"; //None found. Change above.

//Initialise Legacy variable for other change handlers
var resetCar = false;

/*-- Store everything that is vehicle selection in it's own object name-space like a good boy now --*/
var car = { vehicleSelect : {} };

/*-- A placeholder for a cached selector for all select boxes which the JS will work with --*/
var $allSelects = $();

/*-- Initialise variables for use in data loading situations --*/
//car.vehicleSelect.isPreload = false;
//car.vehicleSelect.urlAction = '';

/*-- Capturing params passed to the page, like preload and action --*/
//if (getUrlParamByName('preload')) car.vehicleSelect.isPreload = true; //preload modes of 1 and 2 will be truthy in the if statement.
//car.vehicleSelect.urlAction = getUrlParamByName('action'); /*-- By the way, this function was added to common/js/utils.js --*/

car.vehicleSelect.data = {
	year 	: "",
	make 	: "",
	model 	: "", //is actually "${data[xpathModel]}" above
	body 	: "",
	trans 	: "",
	fuel 	: "",
	redbookCode : "" //is actually the 'type' ${data[xpathType]} above
/*-- However all these optional bits will also be returned in the ajax request for data bucket object
 *-- which will be great once we have time to chuck out the old accessories options code */
/*--
	accessories: 		"Y",
	annualKilometres:	20000,
	damage:				"N",
	factoryOptions:		"N",
	finance:			"HP",
	marketValue:		21050,
	modifications:		"N",
	parking:			1,
	securityOption:		"A",
	use: 				2
--*/
};

/*-- Here we make an ajax request to see if the data bucket is primed with vehicle data --*/
/*-- Since we're doing a page load, maybe we should just bring it into the page here? --*/
car.vehicleSelect.getSessionVehicleData = function(eventTarget) {
	// Ajax: Get the data bucket subs for quote/vehicle.
	var data = {
		transactionId:referenceNo.getTransactionID()
	};
	$.ajax({
		url: "ajax/json/car_session_vehicle.jsp",
		data:data,
		dataType: "json",
		async: false,
		timeout: 25000,
		cache: false,
		beforeSend : function(xhr,setting) {
			var url = setting.url;
			var label = "uncache",
			url = url.replace("?_=","?" + label + "=");
			url = url.replace("&_=","&" + label + "=");
			setting.url = url;
		},
		success: function(data){
			if (data.vehicle) {
				//console.log('Completed call for ajax/json/quote/vehicle', data.vehicle);
				$(eventTarget).trigger('car.vehicleSelect.primed', data.vehicle); //fire an event in the dom to track
				$.extend(car.vehicleSelect.data, data.vehicle);
			} else {
				return false; //Backend must be stupid somehow
			}
		},
		error : function(xhr){ return false; /*The request bombed out*/ },
		complete: function(xhr){ return true; }
	});
};

/*-- Concertina: Hide all rows with class of showOnPopulateSelect until their select fields are updated with results --*/
/*-- Next Sibling row is shown too in the event that the passed element's row does
not require user to select anything as it was prefilled --*/
var showRowAfter = function(elem) {
	var $theRow = $(elem).closest(".fieldrow");
	var $nextRow = $($theRow).next(".showOnPopulateSelect");
	/*-- This removes the onShown class on the initiating row to cancel the css
	highlight anim and only the show it on the next field requiring attention --*/
	$theRow.removeClass('onShown');

	/*-- This shows and highlights the row --*/
	$nextRow.removeClass('onShown showOnPopulateSelect').addClass('onShown');
};

var hideRowAfter = function(elem) {
	var $theRow = $(elem).closest(".fieldrow");
	var $nextRow = $($theRow).next(".onShown");
	/*-- This removes the onShown class on the initiating row to cancel the css
	highlight anim and only the show it on the next field requiring attention --*/
	$theRow.removeClass('onShown');

	/*-- This shows and highlights the row --*/
	$nextRow.removeClass('onShown').addClass('onShown showOnPopulateSelect');
};

/*-- Concertina: Hide all rows with class of showOnPopulateSelect until their select fields are updated with results --*/
car.vehicleSelect.showAllFields = function() {
	$allSelects.each(function(){
		showRowAfter($(this));
	});
	car.vehicleSelect.updateSelectState();
};

/*-- Handle the clearing and interaction state --*/
car.vehicleSelect.updateSelectState = function() {
	//console.groupCollapsed("Enabled or Disabled Elements:");
	$allSelects.each(function(){
		$this = $(this);

		/*Ensure a visible row is part of jQuery validate*/
		$this.rules("add", {required: true});
		//console.info('Setting validation "Required"', $this);

		if ($this.find("option").length < 2) {
			if (!($this.prop('disabled'))) {
				$this.prop('disabled', true);
				shared.state.clear($this.parent());
				//console.group("Switched to Disabled:");
				//console.log($this);
				//console.groupEnd();
			}
		} else {
			if ($this.prop('disabled')) {
				$this.prop('disabled', false);
				//console.group("Switched to Enabled:");
				//console.log($this);
				//console.groupEnd();
			}
		}
	});
	//console.groupEnd();
	//return ;
};

/* Porting functionality to fill description fields (hidden inputs) in the form.
 * Attempts to look for a sibling description when called in the change event handler.
 * Uses field from provided context and populates the description field with a convention of #idname+'Des'
 */
car.vehicleSelect.handleDescriptionFields = function($changedSelect){
	var $hiddenDescriptionInput = $changedSelect.siblings('input#'+$changedSelect.attr('id')+'Des');
	if ($hiddenDescriptionInput.length == 1) {
		var foundLabelValue = $changedSelect.find(":selected").html();
		$hiddenDescriptionInput.val(foundLabelValue);
	}
};

/*-- ------------------------------------------------- --*/
/*-- ------ HANDLE VARIOUS STATE EVENTS FIRED -------- --*/
/*-- ------------------------------------------------- --*/

/*-- NO DATA - Error State -- Called in ajaxSuccess --*/
car.vehicleSelect.noDataError = function($contextElem,extraInfo) {
	var $context = $($contextElem); //just in case

	if (typeof extraInfo === 'undefined') {
		var extraInfo = "Generic: No data was available to perform operations on";
	}
	shared.state.error($context.parent(),extraInfo);
	$context.html(notFoundOptionHTML);

	var labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels
	if (typeof FatalErrorDialog != 'undefined') {
		FatalErrorDialog.exec({
			message:		"Unfortunately, something went wrong while getting Vehicle "+labelForContext+" info. \nThis is likely very temporary, so please try to refresh this page and try again.",
			page:			"common/vehicle_selection.js:ajaxSuccess",
			description:	"An ajax error occurred trying to retrieve data for "+ $context.attr('id') +" "+extraInfo,
			data:			$context
		});
	}
};

/*-- MISSING INPUTS - Error State --*/
car.vehicleSelect.notEnoughInputError = function(extraInfo,functionName,argumentsPassed) {
	if (typeof extraInfo === 'undefined') {
		var extraInfo = "Generic: Not enough input was provided to the called code, and no specific message was raised.";
	}
	if (typeof FatalErrorDialog != 'undefined') {
		FatalErrorDialog.exec({
			message:		"Unfortunately, there was a problem preparing to collect vehicle information for you to choose from. Our technical team will be notified of this problem. Please refresh the page and try again later.",
			page:			"common/vehicle_selection.js:"+functionName,
			description:	""+extraInfo+" "+functionName+", actual param/s passed: "+argumentsPassed,
			data:			argumentsPassed
		});
	}
};

/*-- --------------------------------------------------------------- --*/
/*-- ------ For each ajax loaded field we should take steps -------- --*/
/*-- --------------------------------------------------------------- --*/

/*-- Ajax functions once data is available --*/
/*-- Failed with xhr status --*/

//This will fire as well as one of the specialist 404,403,500 and ajaxComplete
var ajaxError = function(xhr){
	var $context = $(this);
	shared.state.error($context.parent());
	var labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels
	if (typeof FatalErrorDialog != 'undefined') {
		FatalErrorDialog.exec({
			message:		"Unfortunately, something went wrong while getting Vehicle "+labelForContext+" info. \nThis is likely very temporary, so please try to refresh this page and try again.",
			page:			"common/vehicle_selection.js:ajaxError",
			description:	"An ajax error occurred trying to retrieve data for "+ $context.attr('id'),
			data:			xhr
		});
	}
};

/*-- 404 Failed with xhr status --*/
var error404 = function(xhr){
	var $context = $(this);
	shared.state.error($context.parent());
	var labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels
	if (typeof FatalErrorDialog != 'undefined') {
		FatalErrorDialog.exec({
			message:		"Unfortunately, a page was not found while retrieving Vehicle "+labelForContext+" info. \nThe technical team will be informed of this problem. Please try again, soon.",
			page:			"common/vehicle_selection.js:error404",
			description:	"Ajax Call Errored - 404 - trying to retrieve data for "+ $context.attr('id'),
			data:			xhr
		});
	}
};

/*-- 403 Failed with xhr status --*/
var error403 = function(xhr){
	var $context = $(this);
	shared.state.error($context.parent());
	var labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels
	if (typeof FatalErrorDialog != 'undefined') {
		FatalErrorDialog.exec({
			message:		"Unfortunately, something went wrong while getting Vehicle "+labelForContext+" info. \nIt's possible you were temporarily disconnected, or your session may have expired for this page. Please try to refresh this page and try again.",
			page:			"common/vehicle_selection.js:error403",
			description:	"Ajax Call Errored - 403 - trying to retrieve data for "+ $context.attr('id'),
			data:			xhr
		});
	}
};

/*-- 500 Failed with xhr status --*/
var error500 = function(xhr){
	var $context = $(this);
	shared.state.error($context.parent());
	var labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels
	if (typeof FatalErrorDialog != 'undefined') {
		FatalErrorDialog.exec({
			message:		"Unfortunately, our service had a temporary problem getting Vehicle "+labelForContext+" info. \nThe technical team will be informed of this problem. Please try to refresh this page and try again.",
			page:			"common/vehicle_selection.js:error500",
			description:	"Ajax Call Errored - 500 - trying to retrieve data for "+ $context.attr('id'),
			data:			xhr
		});
	}
};

var ajaxComplete = function(jqxhr,xhr){
	/*Ported over from the old code, not sure if we need to do this all the time,
	but gets immediate action on removing the additional accessories. Added a check for pre-loaded data.*/
	//console.debug('resetCar is tested inside ajaxComplete');
	if(resetCar) {
		//console.debug('resetCar is true and we now resetSelectedNonStdAcc inside ajaxComplete');
		//The quicklaunch page wouldn't have the reset accessories JS - so this is an important check.
		if (typeof resetSelectedNonStdAcc != 'undefined') { resetSelectedNonStdAcc(); }
	}
};

/*-- Completed with data returned --*/
var ajaxSuccess = function(data,xhr,jqxhr){

	var $context = $(this);
	var options = pleaseChooseOptionHTML;
	var firstValidVal = '';
	var $labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels

	/*Clear before we set new states*/
	shared.state.clear($context.parent());

	if (jQuery.isEmptyObject(data)) {
		options = notFoundOptionHTML;
		car.vehicleSelect.noDataError($context,"No data was in the returned object");
	} //TODO: probably convert whole thing to try catch

	for (var set in data) {
		/*-- Set is eg. 'car_model', at the moment only 1 set will exist per call but a future unified ajax endpoint will likely have multiple --*/
		var dataSet = data[set];
		var localDataModelName = ''+set.slice(car.vehicleSelect.fields.ajaxPfx.length,set.length);

		//The insane thing about Mobile Safari (iOS7 at least) is that without an option group, it wont trigger change events immediately.
		options += '<optgroup label="'+$labelForContext+'">';

		/*-- ERROR: Double check, when we don't return any data in the key, log error and freak out! --*/
		if ((typeof dataSet === 'undefined')||(dataSet.length==0)) {
			//car.vehicleSelect.noDataError($context,"No data found in the key returned from the server lookup"); //Not quite - the db might legit not have data for their selection.
			shared.state.error($context.parent());
			options = notFoundOptionHTML;
		} else if ((typeof dataSet[0].value === 'undefined')||(typeof dataSet[0].label === 'undefined')) {
			car.vehicleSelect.noDataError($context,"Required value and label was not found in the key returned from the server lookup");
			options = notFoundOptionHTML;
		}

		/*--
		 * This object should be an array. Look into the array return and extract the right values per key.
		 * If it was a for (var item in dataSet) we'd end up looping into the .filter prototype we are shim-ing in on ie
		 * --*/
		for (var i = 0; i < dataSet.length; i++) {
			var objectItem = dataSet[i];

			/*-- The data might be pre-populated, or if there's only 1 result select the first one --*/
			var sel = ""; var rel = "";
			if ((dataSet.length==1) || (car.vehicleSelect.data[localDataModelName] == objectItem.value)) { sel = " selected"; }
			if (typeof objectItem.rel !== 'undefined' && objectItem.rel != null) { rel = ' rel="'+objectItem.rel+'"'; }

			/*-- Write the option --*/
			options += "<option value='" + objectItem.value + "'" + sel + rel + ">" + objectItem.label + "</option>";
			if (firstValidVal=='') firstValidVal = objectItem.value;
		}

		options += '</optgroup>'; //Closing the stupidity for mobile safari.
	}

	$context.html(options);

	/*-- Fix up interactability --*/
	car.vehicleSelect.updateSelectState();

	/* Would be nice to take focus to the now populated item, but this causes
	 * iOS and android to remove the keyboard again, which is annoying to users.*/
	//$context.focus();

	/*-- If only one value returned - this picks the first non-empty option (firstValidVal) --*/
	if ($context.find("option").length<=2) {
		$context.val(firstValidVal);
		$context.change(); //Wasn't working before but now does?!! it fired change with the event.target of the bloody XHR instead of select element!
		//car.vehicleSelect.selectChange('',$context); //Was a dirty dirty hack because of the above weirdness.
	} else if (car.vehicleSelect.data[localDataModelName] != '') {
		/*-- it's pre-filled so just trigger it as being updated --*/
		$context.change();
	}
};

car.vehicleSelect.getNameForAjaxField = function(thisSelect) {
	/*-- TODO: One day, separate from the JSTL entirely. --*/
	var formPrefix = car.vehicleSelect.fields.namePfx; //When identifying the field name, remove the form name.
	var fieldPrefix = car.vehicleSelect.fields.ajaxPfx; //When sending, it needs this new prefix.
	var fieldTypeName = ''+$(thisSelect).attr('name');
	fieldTypeName = fieldTypeName.substring((formPrefix.length)+1, fieldTypeName.length); //+1 compensates for an underscore in the formPrefix
	return ''+fieldPrefix+fieldTypeName;
};

/*-- -------------------------------------------------------------------------------------------------------- --*/
/*-- The getActionsForField: Makes ajax options based on field in question, passed as a jquery wrapped object --*/
/*-- -------------------------------------------------------------------------------------------------------- --*/
car.vehicleSelect.getActionsForField = function($thisSelect, $prevSelects, $contextTarget, dataType) {
	//We need at least the first 3 params passed
	if (arguments.length < 3) {
		/*-- Validate our params. If this is ever seen blame a developer. --*/
		if (typeof $thisSelect === 'undefined') {
			car.vehicleSelect.notEnoughInputError("getActionsForField requires a $thisSelect jquery wrapped select element","car.vehicleSelect.getActionsForField",arguments[0]);
		} if (typeof $prevSelects === 'undefined') {
			car.vehicleSelect.notEnoughInputError("getActionsForField requires a $prevSelects jquery wrapped set of selects for data collection.","car.vehicleSelect.getActionsForField",arguments[1]);
		} if (typeof $contextTarget === 'undefined') {
			car.vehicleSelect.notEnoughInputError("getActionsForField requires a $contextTarget jquery wrapped select element.","car.vehicleSelect.getActionsForField",arguments[2]);
		}
	}
	if (typeof dataType === 'undefined') { var dataType="json"; }

	/*-- Grab the name of the next field we're aiming to populate for use in calls and searches. --*/
	var ajaxFieldName = car.vehicleSelect.getNameForAjaxField($contextTarget);
	var ajaxData = {}; /*-- Will become the params sent to ajax call --*/

	/*-- Take the current element --*/
	var key1 = car.vehicleSelect.getNameForAjaxField($thisSelect);
	ajaxData[key1] = $thisSelect.val();

	/*-- And everything before it. --*/
	$prevSelects.each(function(){
		var key2 = car.vehicleSelect.getNameForAjaxField(this);
		ajaxData[key2] = $(this).val();
	});

	var ajaxOptions = {
		url: "ajax/"+dataType+"/"+ajaxFieldName+".jsp", /*yeah*/
		dataType: dataType,
		context: $contextTarget,
		async: true,
		timeout: 30000,
		data:ajaxData,
		complete: ajaxComplete,
		success: ajaxSuccess,
		error: ajaxError,
		statusCode: {
			404: error404,
			403: error403,
			500: error500
		}
	}

	return ajaxOptions;
};

/*-- Do-It-All Vehicle Select Box Handler:
Tries to unify the functionality that was defined here before --*/
car.vehicleSelect.selectChange = function(event,$selectPassed){

	//console.time("Ajax call and change handler time");
	//console.profile("Ajax call and change handler performance");

	//console.log('event', event,':','Checking the target',event.target, ''+(typeof event));
	var $thisSelect = $(event.target);

	if (typeof event.target === 'undefined') {
		if (typeof $selectPassed !== 'undefined') {
			//console.log('Now passing an overriding param to selectChange', $thisSelect, 'to', $selectPassed);
			$thisSelect = $selectPassed;
		} else {
			//Error shouldn't display to user as it's a .register, not .exec or .display
			if (typeof FatalErrorDialog != 'undefined') {
				FatalErrorDialog.register({
					message: "The selectChange function didn't get a field to target for it's states or ajax call.",
					page:			"common/vehicle_selection.js:selectChange",
					description:	"The event target or an overriding selectPassed object wasn't available when called from the change event handler.",
					data:			{ "event.target":event.target, "event":event, "$selectPassed":$selectPassed }
				});
			}
		}
	}

	/*-- Sets up the state of all selects, this onchange event. Some might be overkill --*/
	var $theRow = $thisSelect.closest(".fieldrow");
	var $prevRow = $theRow.prev(".fieldrow");
	var $nextRow = $theRow.next(".fieldrow");
	var $allNextRows = $theRow.nextAll(".fieldrow");
	var $allPrevRows = $theRow.prevAll(".fieldrow");

	var $nextSelect = $nextRow.find('select');
	var $prevSelect = $prevRow.find('select');
	var $allNextSelects = $allNextRows.find('select');
	var $allPrevSelects = $allPrevRows.find('select');

	var $allNextAjaxSelects = $allNextSelects.not(".initial select");

	//console checks
	/*
	console.groupCollapsed("Vehicle Selection States:");
		console.debug('Change event on:',$thisSelect,$thisSelect.val());
		console.group("Selects:");
		console.log("$prevSelect",$prevSelect.length,$prevSelect,$prevSelect.val());
		console.log("$thisSelect",$thisSelect.length,$thisSelect,$thisSelect.val());
		console.log("$nextSelect",$nextSelect.length,$nextSelect,$nextSelect.val());
		console.log("$allPrevSelects",$allPrevSelects.length,$allPrevSelects);
		console.log("$allNextAjaxSelects",$allNextAjaxSelects.length,$allNextAjaxSelects);
		console.groupEnd();

		console.group("Rows:");
		console.log("$prevRow",$prevRow.length,$prevRow);
		console.log("$nextRow",$nextRow.length,$nextRow);
		console.log("$allNextRows",$allNextRows.length,$allNextRows);
		console.log("$allPrevRows",$allPrevRows.length,$allPrevRows);
		console.groupEnd();
	console.groupEnd();
	*/

	/*-- Clear old values and undo concertina --*/

	/*-- Reset options --*/
	$allNextAjaxSelects.each(function(){
		shared.state.clear($(this).parent());
		$(this).html(resetOptionHTML);
		//hideRowAfter($(this)); //this might work? TODO
	});
	shared.state.clear($thisSelect.parent());
	car.vehicleSelect.updateSelectState();

	car.vehicleSelect.handleDescriptionFields($thisSelect); //port of legacy functionality filling hidden description fields in the form

	/*-- If we don't already have a value set on the prev select or it doesn't exist, you shouldn't be making
	calls to find things on the next one. Likewise for the last one. Exception being first two. --*/
	if ($thisSelect.val() != "") { /*If person, accidentally picks 'please choose'*/
		//Filling things out top to bottom
		if ((($prevSelect.length > 0 && $prevSelect.val() != "") && $nextSelect.length > 0)
			|| ($prevSelect.length == 0 && $nextSelect.length > 0)) { // And the very first one included - 'make'
			shared.state.success($thisSelect.parent());
			var theAjaxOptions = car.vehicleSelect.getActionsForField($thisSelect,$allPrevSelects,$nextSelect);
			shared.state.busy($nextSelect.parent());
			$.ajax(theAjaxOptions);
		} else if (($prevSelect.length > 0 && $nextSelect.length == 0)) {
			// Going to be the last one - 'type'
			shared.state.success($thisSelect.parent());
			$thisSelect.trigger('car.vehicleSelect.complete');
		}
	} else {
		shared.state.clear($thisSelect.parent());
	}

	/*-- Concertina: As our other functions initiate changes in the hidden rows, we can apply update row on that trigger. --*/
	showRowAfter($thisSelect);

	//console.profileEnd();
	//console.timeEnd("Ajax call and change handler time");

};

/*-- --------------------------------------------------------------- --*/
/*-- ---------- Initialisation here which kicks off things ------------*/
/*-- --------------------------------------------------------------- --*/
car.vehicleSelect.init = function(options){

	/*-- --------------------------------------------------------------- --*/
	/*-- ------ Setting up events or calling the functions above^ ------ --*/
	/*-- --------------------------------------------------------------- --*/

	//console.log('=-=-=-=-=-=-=-=-=-=-=-=-=-= Initialised the vehicleSelector JS -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');

	/*-- Old Concertina: As our other functions initiate changes in the hidden rows, we can apply update row on that trigger.*/
	//$(document).on('change',"#quote_vehicle_selection .fieldrow select", function(event){
	//	showRowAfter(event.target);
	//});

	$allSelects = $("#quote_vehicle_selection .fieldrow select"); //Reselect this, because the dom wasn't ready before.

	/* Some code to watch a primed update. Currently not working.
	 * Triggered by the prepopulation getSessionVehicleData function below */
	/*
	$(document).on('car.vehicleSelect.primed', function(event, data) {
		$(event.target).change(); //FIXME doesn't work!!!
		//$("#quote_vehicle_year").change(); //FIXME doesn't work!!!
		//TODO Move to this one instead if we can... see NOTE3
		console.log("Trigger for car.sessionVehicleData.primed is fired");
	});
	*/

	/*-- Initial prepopulation: Query the data bucket and bring that into JS for updating of fields in the change handler of selects --*/
	car.vehicleSelect.getSessionVehicleData("#quote_vehicle_year"); //optional param fires an event 'car.vehicleSelect.events.primed' to this specific dom context.

	/*-- The old code used to hide this button row if it wasn't pre-populated --*/
	// typeof car.vehicleSelect.data.accessories == "undefined" //(could be better to check than the ported code)
	if (car.vehicleSelect.data.redbookCode == null || car.vehicleSelect.data.redbookCode == "") {
		$(car.vehicleSelect.fields.factoryRow).hide();
	}

	/*-- --------------------------------------------------------------- --*/
	/*-- -The change function: updates each box via ajax or primed data- --*/
	/*-- --------------------------------------------------------------- --*/

	/* When we start the page off we should disable things that users can't access anyway*/
	car.vehicleSelect.updateSelectState();

	//This ensures legacy code is happy to keep going
	$allSelects.click(function(e){
		resetCar = true;
		//This isn't working in chrome mac (NO CLUES AS TO WHY!!)
		//console.debug('resetCar is being reset by a click handler placed on allSelects inside init. $allSelects is:',$allSelects,e);
	});

	//Intended to be applying a change handler to everything from the '$allSelects' but jquery .on is crazy
	$("#quote_vehicle_selection").on('change', 'select', function(e) {
		car.vehicleSelect.selectChange(e);
	});

	//TODO: Instead of this!! NOTE3
	// Call this to auto complete car selection when preloaded data exists
	// Just sneakily check if the redbookCode is populated to indicate a complete data set is there
	// Updated to also look at the make to support preloaded data of the quicklaunch.
	if(car.vehicleSelect.data.redbookCode != '' || car.vehicleSelect.data.make != ''){
		//console.debug("Primed From Data Bucket");
		$("#quote_vehicle_selection select").first().change();
	}

	//console.log('=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
};

/*-- ----------------------------------------- --*/
/*-- -- Public access is open here if required --*/
/*-- ----------------------------------------- --*/
window.car = car;