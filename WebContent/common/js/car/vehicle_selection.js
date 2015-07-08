/*-- --------------------------------------------------------------- --*/
/*-- --- Common utilitarian bits for the whole vehicle selection --- --*/
/*-- --------------------------------------------------------------- --*/

/*-- Re-used HTML snippets --*/
var pleaseChooseOptionHTML = "<option value=''>Select vehicle {{label}}...</option>";
var resetOptionHTML = "<option value=''>&nbsp;</option>";
var notFoundOptionHTML = "<option value=''>No match for above choices</option>"; //None found. Change above.

//Initialise Legacy variable for other change handlers
var resetCar = false;

/*-- Store everything that is vehicle selection in it's own object name-space like a good boy now --*/
var car = {
	vehicleSelect: {},
	RETRY_LIMIT: 3,
	tryCount: 1
};

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
	$allSelects.each(function(){
		$this = $(this);

		if ($this.find("option").length < 2) {
			if (!($this.prop('disabled'))) {
				$this.prop('disabled', true);
			}
		} else {
			if ($this.prop('disabled')) {
				$this.prop('disabled', false);
			}
		}
	});
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
	var labelForContext = $.trim($context.parent().siblings('.fieldrow_label').first().text()); //used for option group labels

	// Retry on request timeout, up to three times.
	if (xhr.statusText == "timeout" && car.tryCount < car.RETRY_LIMIT) {
		car.tryCount++;
		// Get the last updated dropdown and trigger the change event to trigger the ajax request again.
		var $latestDropdownSelector = $($context.context);

		car.vehicleSelect.selectChange('change', $latestDropdownSelector);
	} else {
		var $latestDropdownSelector = $('#'+$context.parent().siblings('.fieldrow_label').first().prev().context.id);
		if (car.tryCount >= car.RETRY_LIMIT) {
			if (typeof FatalErrorDialog != 'undefined') {
				// Get data that we're going to log.
				var logData = {'xhr': xhr, 'data': getCarFieldValues(), 'user agent': navigator.userAgent};
				FatalErrorDialog.exec({
					message: "Unfortunately, your request has timed out while getting the Vehicle "+labelForContext+" information. <br /><br />Your Internet connection may be slow or your network has been interrupted. Please refresh this page and try again.",
					page: "common/vehicle_selection.js:ajaxError",
					// Detailed timeout log which includes the selected lookup to help identify any requests that may be taking too long.
					description: "A timeout request has occurred after "+car.tryCount+" attempts while trying to retrieve "+$context.attr('id')+" for "+$latestDropdownSelector.get(0).name,
					data: logData
				});
			}
			car.tryCount = 1;
		} else {
			car.tryCount = 1;
			if (typeof FatalErrorDialog != 'undefined') {
				FatalErrorDialog.exec({
					message:		"Unfortunately, something went wrong while getting Vehicle "+labelForContext+" info. \nThis is likely very temporary, so please try to refresh this page and try again.",
					page:			"common/vehicle_selection.js:ajaxError",
					description:	"An ajax error occurred trying to retrieve data for "+ $context.attr('id'),
					data:			xhr
				});
			}
		}
	}

};

// Get all the current name and value pairs for all dropdown boxes, used when adding the error to the DB.
var getCarFieldValues = function() {

	var carFieldValues = {};

	$allSelects.each(function(index) {
		$element = $(this);
		carFieldValues[$element.get(0).id] = $element.val();
	});

	return carFieldValues;
};

/*-- 404 Failed with xhr status --*/
var error404 = function(xhr){
	var $context = $(this);
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
	if(resetCar) {
		//The quicklaunch page wouldn't have the reset accessories JS - so this is an important check.
		if (typeof resetSelectedNonStdAcc != 'undefined') { resetSelectedNonStdAcc(); }
	}
};

/*-- Completed with data returned --*/
var ajaxSuccess = function(data,xhr,jqxhr){

	// Reset the try count for the next ajax request.
	car.tryCount = 1;

	var $context = $(this);
	var options = {
			intro : pleaseChooseOptionHTML,
			popular : "",
			normal : ""
	};
	var firstValidVal = '';
	var $labelForContext = $.trim($context.closest('.form-group').find('.control-label').first().text()); //used for option group labels

	if (jQuery.isEmptyObject(data)) {
		options.intro = notFoundOptionHTML;
		car.vehicleSelect.noDataError($context,"No data was in the returned object");
	} //TODO: probably convert whole thing to try catch

	for (var set in data) {
		/*-- Set is eg. 'car_model', at the moment only 1 set will exist per call but a future unified ajax endpoint will likely have multiple --*/
		var dataSet = data[set];
		var localDataModelName = ''+set.slice(car.vehicleSelect.fields.ajaxPfx.length,set.length);

		/*-- ERROR: Double check, when we don't return any data in the key, log error and freak out! --*/
		if ((typeof dataSet === 'undefined')||(dataSet.length==0)) {
			//car.vehicleSelect.noDataError($context,"No data found in the key returned from the server lookup"); //Not quite - the db might legit not have data for their selection.
			options.intro = notFoundOptionHTML;
		} else if ((typeof dataSet[0].code === 'undefined')||(typeof dataSet[0].label === 'undefined')) {
			car.vehicleSelect.noDataError($context,"Required value and label was not found in the key returned from the server lookup");
			options.intro = notFoundOptionHTML;
		} else {
			if(set == "models") {
				options.intro = options.intro.replace("{{label}}", "Model");
				options.popular = dataSet.length ? '<optgroup label="Top Models">' : "";
				options.normal = '<optgroup label="All Models">';
			} else {
				options.intro = options.intro.replace("{{label}}", "Year");
				options.normal = '<optgroup label="'+$labelForContext+'">';
			}
			/*--
			 * This object should be an array. Look into the array return and extract the right values per key.
			 * If it was a for (var item in dataSet) we'd end up looping into the .filter prototype we are shim-ing in on ie
			 * --*/
			for (var i = 0; i < dataSet.length; i++) {
				var objectItem = dataSet[i];

				/*-- The data might be pre-populated, or if there's only 1 result select the first one --*/
				var sel = "";
				var rel = "";
				if ((dataSet.length == 1) || (car.vehicleSelect.data[localDataModelName] == objectItem.code)) {
					sel = " selected";
				}
				if (typeof objectItem.rel !== 'undefined' && objectItem.rel != null) {
					rel = ' rel="' + objectItem.rel + '"';
				}

				/*-- Write the option --*/
				var temp = "<option value='" + objectItem.code + "'" + sel + rel + ">" + objectItem.label + "</option>";
				if(dataSet.length > 1 && objectItem.hasOwnProperty("isTopModel") && objectItem.isTopModel === true) {
					options.popular += temp;
				} else {
					options.normal += temp;
				}

				if (firstValidVal == '') firstValidVal = objectItem.code;
			}
		}

		options.normal += '</optgroup>'; //Closing the stupidity for mobile safari.
		if(options.popular != "") {
			options.popular += '</optgroup>'
		}
	}

	$context.html(options.intro + options.popular + options.normal);

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
	var fieldTypeName = ''+$(thisSelect).attr('name');
	return fieldTypeName.substring((formPrefix.length)+1, fieldTypeName.length); //+1 compensates for an underscore in the formPrefix
};

car.vehicleSelect.getLabelForAjaxRequest = function(thisSelect) {
	/*-- TODO: One day, separate from the JSTL entirely. --*/
	var formPrefix = car.vehicleSelect.fields.namePfx; //When identifying the field name, remove the form name.
	var fieldTypeName = ''+$(thisSelect).attr('name');
	fieldTypeName = fieldTypeName.substring((formPrefix.length)+1, fieldTypeName.length); //+1 compensates for an underscore in the formPrefix
	switch(fieldTypeName) {
		case 'body':
			return 'bodies';
			break;
		default:
			return fieldTypeName + 's';
			break;
	}
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
	var requestLabel = car.vehicleSelect.getLabelForAjaxRequest($contextTarget);
	var ajaxData = {}; /*-- Will become the params sent to ajax call --*/

	/*-- Take the current element --*/
	var key1 = car.vehicleSelect.getNameForAjaxField($thisSelect);
	ajaxData[key1] = $thisSelect.val();

	/*-- And everything before it. --*/
	$prevSelects.each(function(){
		var key2 = car.vehicleSelect.getNameForAjaxField(this);
		ajaxData[key2] = $(this).val();
	});

	//ajaxData['transactionId'] = referenceNo.getTransactionID();

	var ajaxOptions = {
		url: car.vehicleSelect.fields.context + "rest/car/" + requestLabel + "/list.json",
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

	var $thisSelect = $(event.target);

	if (typeof event.target === 'undefined') {
		if (typeof $selectPassed !== 'undefined') {
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

	/*-- Reset options --*/
	$allNextAjaxSelects.each(function(){
		$(this).html(resetOptionHTML);
	});

	car.vehicleSelect.updateSelectState();

	car.vehicleSelect.handleDescriptionFields($thisSelect); //port of legacy functionality filling hidden description fields in the form

	/*-- If we don't already have a value set on the prev select or it doesn't exist, you shouldn't be making
	calls to find things on the next one. Likewise for the last one. Exception being first two. --*/
	if ($thisSelect.val() != "") { /*If person, accidentally picks 'please choose'*/
		//Filling things out top to bottom
		if ((($prevSelect.length > 0 && $prevSelect.val() != "") && $nextSelect.length > 0)
			|| ($prevSelect.length == 0 && $nextSelect.length > 0)) { // And the very first one included - 'make'
			var theAjaxOptions = car.vehicleSelect.getActionsForField($thisSelect,$allPrevSelects,$nextSelect);
			$.ajax(theAjaxOptions);
		} else if (($prevSelect.length > 0 && $nextSelect.length == 0)) {
			// Going to be the last one - 'type'
			$thisSelect.trigger('car.vehicleSelect.complete');
		}
	}

	/*-- Concertina: As our other functions initiate changes in the hidden rows, we can apply update row on that trigger. --*/
	showRowAfter($thisSelect);

};

/*-- --------------------------------------------------------------- --*/
/*-- ---------- Initialisation here which kicks off things ------------*/
/*-- --------------------------------------------------------------- --*/
car.vehicleSelect.init = function(options){

	/*-- --------------------------------------------------------------- --*/
	/*-- ------ Setting up events or calling the functions above^ ------ --*/
	/*-- --------------------------------------------------------------- --*/

	$allSelects = $("#quote_vehicle_selection .fieldrow select"); //Reselect this, because the dom wasn't ready before.

	if(car.vehicleSelect.data.make != '') {

		$selector = $(car.vehicleSelect.fields.make);

		$selector.empty();

		var options = [];
		options.push(
			$('<option/>',{
				value:''
			}).append("Select vehicle Make...")
		);

		options.push(
			$('<optgroup/>',{label:"Top Makes"})
		);
		options.push(
			$('<optgroup/>',{label:"All Makes"})
		);

		for(var i in car.vehicleSelect.data.make){
			if(car.vehicleSelect.data.make.hasOwnProperty(i)) {
				var item = car.vehicleSelect.data.make[i];
				var option = $('<option/>',{
					text:item.label,
					value:item.code
				});

				if(item.isTopMake === true) {
					option.appendTo(options[1], options[2]);
				} else {
					options[2].append(option);
				}
			}
		}

		// Append all the options to the selector
		for(var o=0; o<options.length; o++) {
			$selector.append(options[o]);
		}
	}

	/*-- --------------------------------------------------------------- --*/
	/*-- -The change function: updates each box via ajax or primed data- --*/
	/*-- --------------------------------------------------------------- --*/

	/* When we start the page off we should disable things that users can't access anyway*/
	car.vehicleSelect.updateSelectState();

	//This ensures legacy code is happy to keep going
	$allSelects.click(function(e){
		resetCar = true;
	});

	//Intended to be applying a change handler to everything from the '$allSelects' but jquery .on is crazy
	$("#quote_vehicle_selection").on('change', 'select', function(e) {
		e.preventDefault();
		car.vehicleSelect.selectChange(e);
	});

	// Update form with required attributes that are stripped by core:head
	$('#mainform').attr('action','car_quote.jsp?action=ql')
	.attr('target','_top')
	.attr('method','POST');

	// Add event to submit form to parent frame
	$(car.vehicleSelect.fields.button).on('click', function() {
		document.getElementById('mainform').submit();
	});
};

/*-- ----------------------------------------- --*/
/*-- -- Public access is open here if required --*/
/*-- ----------------------------------------- --*/
window.car = car;