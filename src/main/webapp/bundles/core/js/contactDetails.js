;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		contactDetails: {
			name:{
				FIELD_CHANGED: "NAME_FIELD_CHANGED",
				OPTIN_FIELD_CHANGED: "NAME_OPTIN_FIELD_CHANGED"
			},
			email:{
				FIELD_CHANGED: "EMAIL_FIELD_CHANGED",
				OPTIN_FIELD_CHANGED: "EMAIL_OPTIN_FIELD_CHANGED"
			},
			phone:{
				FIELD_CHANGED: "PHONE_FIELD_CHANGED",
				OPTIN_FIELD_CHANGED: "PHONE_OPTIN_FIELD_CHANGED"
			},
			mobile:{
				FIELD_CHANGED: "MOBILE_FIELD_CHANGED",
				OPTIN_FIELD_CHANGED: "MOBILE_OPTIN_FIELD_CHANGED"
			},
			otherPhone:{
				FIELD_CHANGED: "OTHERPHONE_FIELD_CHANGED",
				OPTIN_FIELD_CHANGED: "OTHERPHONE_OPTIN_FIELD_CHANGED"
			},
			flexiPhone:{
				FIELD_CHANGED: "FLEXIPHONE_FIELD_CHANGED",
				OPTIN_FIELD_CHANGED: "FLEXIPHONE_OPTIN_FIELD_CHANGED"
			},
			flexiPhoneV2:{
				FIELD_CHANGED: "FLEXIPHONE_FIELD_CHANGED_V2",
				OPTIN_FIELD_CHANGED: "FLEXIPHONE_OPTIN_FIELD_CHANGED_V2"
			}
		}
	},
	moduleEvents = events.contactDetails;

	var fields = {
		/* example:
		name: [],
		email: [],
		phone: [],
		mobile: [],
		otherPhone: []
		*/
	};

	prefillLaterFields = true; // this can be used to turn forward populating on preload/retrieve quote or not

	function init(){

	}

	function configure( contactDetailsFields ){

		$(document).ready(function() {
			// record provided fields in module
			if(!_.isMatch(fields,contactDetailsFields)) {
				$.extend(fields, contactDetailsFields);
			}

			// run through all field type (name, phone, email, etc.)
			_.each(fields, function(fieldTypeEntities, fieldType){

				// run through all fields in a type
				_.each(fieldTypeEntities, function(fieldTypeEntity, index){

					var fieldDetails = $.extend( fieldTypeEntity, {index: index, type: fieldType, fieldIndex: 1} );

					// set change events on provided field and optin fields
					setFieldChangeEvent( fieldDetails );
					setOptinFieldChangeEvent( fieldDetails );

					// if otherField exists (i.e. for combined fields like "first name" and "last name"), the second field also needs the change event
					if( typeof fieldDetails.$otherField !== "undefined" ){
						fieldDetails = $.extend({}, fieldDetails, { alternateOtherField: true, fieldIndex: 2 } );
						setFieldChangeEvent( fieldDetails );
					}

				});

			});

			prefillLaterFields = true; // turn on the prefilling once all the change events have been set up (allows to not prefill on preload/retrive quotes)
		});

	}

	function setFieldChangeEvent( fieldDetails ){

		// work out which field is the input one (for fields like mobile number which have both a hidden field for the value and an input field)
		var $fieldElement = getInputField(fieldDetails);
		if( typeof fieldDetails.alternateOtherField !== "undefined" && fieldDetails.alternateOtherField){

			$fieldElement = fieldDetails.$otherField;
		}

		// set change events on field
		$fieldElement.on("change.contactDetails", function(){
			$this = $(this);
			// give time to other potential events to execute first before checking if the field is valid
			_.defer(function(){
				onFieldChangeEvent( $this, fieldDetails );
			});
		});

		// trigger the change event function without publishing the change for preload/retrieve a quote
		onFieldChangeEvent( $fieldElement, fieldDetails, false );
	}

	function onFieldChangeEvent($element, fieldDetails, publishEvent){

		if( typeof publishEvent === "undefined" ) publishEvent = true;

		// publish event only if the field is valid
		if( $element.isValid() ){

			if( needsOptInValueCheckFromDbOnChange( fieldDetails ) ){
				// get the optInValue, the FIELD_CHANGED event will be triggered on callback of the result
				fetchOptIn( fieldDetails, publishEvent );
			} else {
				// publish event straight away
				var eventObject = getChangeEventObject( fieldDetails );
				if( publishEvent ){
					publishFieldChangeEvent( eventObject );
				}
				fieldChanged( eventObject );
			}

		}

	}

	function needsOptInValueCheckFromDbOnChange( fieldDetails ){

		var supportedOptIns = ["email"]; // if we add support for more field types to be bound to their db optin value, add it here (see fetchOptIn() too)

		if( fieldDetails.$optInField != "undefined" && $.inArray(fieldDetails.type, supportedOptIns) !== -1 ){
			return true;
		}

		return false;
	}

	function fetchOptIn( fieldDetails, publishEvent ){

		meerkat.modules.loadingAnimation.showAfter( fieldDetails.$field );

		var fieldInfo = {
			data: {
				type: fieldDetails.type,
				value: fieldDetails.$field.val()
			},
			onComplete: function(){
				meerkat.modules.loadingAnimation.hide( fieldDetails.$field );
			},
			onSuccess: function(result){

				var optins = {
					optins: {
						email: result.optInMarketing
						//phone: result.phoneOptInMarketing // if the ajax returns more than the email optin value in the future, this could be added here
					}
				};
				var eventObject = $.extend( getChangeEventObject( fieldDetails ), optins );
				if( publishEvent ){
					publishFieldChangeEvent( eventObject );
				}
				fieldChanged( eventObject );

			},
			onError: function(){
				// extra ajax error handling if required
				showOptInField( fieldDetails.$optInField );
			}
		};

		meerkat.modules.optIn.fetch( fieldInfo );

	}

	function setOptinFieldChangeEvent( fieldDetails ){

		// if any optinField defined
		if( typeof fieldDetails.$optInField !== "undefined"){

			// set change events on optin fields
			fieldDetails.$optInField.on("change.contactDetails", function(){
				var eventObject = getChangeEventObject( fieldDetails );
				publishOptInFieldChangeEvent( eventObject );
				optInFieldChanged( eventObject );
			}); //.trigger("change"); // trigger change straight away for preload?

		}

	}

	function getChangeEventObject( fieldDetails ){

		var eventObject = {
			index: fieldDetails.index, // index of that field in the array of that type of fields
			type: fieldDetails.type, // what kind of field it is (i.e. email, phone, name, etc.)
			$field: getInputField(fieldDetails), // the input field (i.e. not necessarily the one that's going to the db)
			$otherField: fieldDetails.$otherField, // a potential related field (i.e. a "last name" could be related to first name)
			fieldIndex: fieldDetails.fieldIndex, // used to figure out which field comes first or second when an $otherField is defined for combined fields (i.e. "first name" comes before "last name")
			$savedField: fieldDetails.$field, // selector of the field that's going to end up into the db (i.e. )
			$optInField: fieldDetails.$optInField // the related optIn Field (checkbox/radio) related to that field
		};

		if( typeof fieldDetails.alternateOtherField !== "undefined" && fieldDetails.alternateOtherField ){
			eventObject.$otherField = eventObject.$field;
			eventObject.$field = fieldDetails.$otherField;
		}

		return eventObject;
	}

	function publishFieldChangeEvent( eventObject ){
		msg.publish( eventObject.type.toUpperCase() + "_FIELD_CHANGED", eventObject );
	}

	function publishOptInFieldChangeEvent( eventObject ){
		msg.publish( eventObject.type.toUpperCase() + "_OPTIN_FIELD_CHANGED", eventObject );
	}

	function fieldChanged(fieldDetails){

		// update visibility of related optin field if we can
		if( typeof fieldDetails.$optInField !== "undefined" && isOptInFieldVisibilityUpdatable( fieldDetails ) ){
			updateOptInFieldVisibility( fieldDetails.$optInField, fieldDetails.optins[fieldDetails.type] );
		}

		if( prefillLaterFields && fieldDetails.index !== fields[fieldDetails.type].length ){
			updateLaterFieldsValues( fieldDetails );
		}

	}

	function isOptInFieldVisibilityUpdatable( fieldDetails ){
		return hasOptInValue( fieldDetails ) && !isPartOfOptInGroup( fieldDetails );
	}

	function hasOptInValue( fieldDetails ){
		if( typeof fieldDetails.optins !== "undefined" && typeof fieldDetails.optins[fieldDetails.type] !== "undefined"){
			return true;
		}
		return false;
	}

	function isPartOfOptInGroup( fieldDetails ){
		return getFieldsFromOptInGroup( fieldDetails ).length > 1;
	}

	// not used currently, but can be useful to figure out if an opin gorup is valid
	function isOptInGroupValid( fieldDetails ){
		var fieldsInOptInGroup = getFieldsFromOptInGroup( fieldDetails );
		var valid = true;
		_.each(fieldsInOptInGroup, function( currentFieldDetails ){
			if( !currentFieldDetails.$field.isValid() ){
				valid = false;
			}
		});
		return valid;
	}

	function getFieldsFromOptInGroup( fieldDetails ){
		var listOfFieldsWithSameOptInField = [];
		_.each( getAllFieldsArray(), function( currentFieldDetails ){
			if( typeof currentFieldDetails.$optInField !== "undefined" && currentFieldDetails.$optInField.is( fieldDetails.$optInField ) ){
				listOfFieldsWithSameOptInField.push( currentFieldDetails );
			}
		});

		return listOfFieldsWithSameOptInField;
	}

	function getAllFieldsArray(){
		var allFields = [];
		_.each(fields, function(fieldTypeEntities, fieldType){
			_.each(fieldTypeEntities, function(fieldTypeEntity, index){
				allFields.push( $.extend( fieldTypeEntity, {type: fieldType} ) );
			});
		});
		return allFields;
	}

	function updateOptInFieldVisibility( $optInField, isOptedIn ){

		if( isOptedIn ){
			hideOptInField( $optInField );
		} else {
			showOptInField( $optInField );
		}

	}

	function showOptInField( $element ){
		setOptInFieldValue( $element, false );
		$element.parents(".fieldrow").first().slideDown();
	}

	function hideOptInField( $element ){
		$element.parents(".fieldrow").first().slideUp();
		$element.attr("data-visible", "true");
		setOptInFieldValue( $element, true );
	}

	function optInFieldChanged(fieldDetails){

		if( prefillLaterFields && fieldDetails.index !== fields[fieldDetails.type].length ){
			updateLaterOptInFields( fieldDetails );
		}

	}

	function getInputField( fieldEntity ){
		var $fieldElement = null;

		if( typeof fieldEntity.$fieldInput !== "undefined" ){
			$fieldElement = fieldEntity.$fieldInput;
		}
		else if( typeof fieldEntity.$otherFieldInput !== "undefined" ){
			$fieldElement = fieldEntity.$otherFieldInput;
		}
		else {
			$fieldElement = fieldEntity.$field;
		}
		return $fieldElement;
	}

	function updateLaterFieldsValues( fieldDetails ){

		var $updatedElement = fieldDetails.$field; // updated field
		var updatedElementPreviousValue = typeof $updatedElement.attr("data-previous-value") === "undefined" ? "" : $updatedElement.attr("data-previous-value"); // get prev value
		var updatedElementValue = $updatedElement.val(); // new value
		$updatedElement.attr("data-previous-value", updatedElementValue); // set new prev value

		var updatedElementOptInValue;
		if( typeof fieldDetails.$optInField === "undefined" ){
			updatedElementOptInValue = null;
		} else if( hasOptInValue( fieldDetails ) ){
			updatedElementOptInValue = fieldDetails.optins[fieldDetails.type] || getOptInFieldIsChecked( fieldDetails.$optInField );
		} else {
			updatedElementOptInValue = getOptInFieldIsChecked( fieldDetails.$optInField );
		}

		for ( var i = fieldDetails.index+1; i < fields[fieldDetails.type].length; i++ ){
			var laterFieldDetails = $.extend( fields[fieldDetails.type][i], {type: fieldDetails.type} );
			var $fieldElement = getInputField( laterFieldDetails );

			if(fieldDetails.type.indexOf("flexiPhone") >= 0 && typeof laterFieldDetails.$otherField !== "undefined") {
				var flexiNumber = updatedElementValue.replace(/\D/g, "");
				var $elementToChange;
				if (flexiNumber.match(/^(04|61)/g)) { // Match mobile or landline/mobile prefixed with 61
					$fieldElement.val(meerkat.modules.phoneFormat.cleanNumber(updatedElementValue));
					laterFieldDetails.$otherField.val("");
					$elementToChange = $fieldElement;
				} else {// Other
					laterFieldDetails.$otherField.val(meerkat.modules.phoneFormat.cleanNumber(updatedElementValue));
					$fieldElement.val("");
					$elementToChange = laterFieldDetails.$otherField;
				}

				$elementToChange.trigger("change").trigger("blur").trigger("focusout");
			}

			// if (later field is empty or its value=the previous value of updated field) and (no other related field or other field is empty)
			if( ($fieldElement.val() === "" || updatedElementPreviousValue === $fieldElement.val()) ) {

				if (typeof laterFieldDetails.$otherField === "undefined" || laterFieldDetails.$otherField.val() === "") {

					// name field gets split into first and last name
					if( fieldDetails.type == "name" && typeof laterFieldDetails.$otherField !== "undefined" ){
						if(typeof updatedElementValue !== "undefined") {
							var splitName = updatedElementValue.split(" ");
							$fieldElement.val(splitName[0]);
							laterFieldDetails.$otherField.val( splitName.slice(1).join(" ") );
						}
					} else if(fieldDetails.type === "alternatePhone"  && typeof laterFieldDetails.$otherField !== "undefined") {
						var testableNumber = updatedElementValue.replace(/\D/g, "");
						if(testableNumber.match(/^(04|614|6104)/g)) {
							$fieldElement.val(testableNumber);
						} else {
							laterFieldDetails.$otherField.val(updatedElementValue);
						}
					} else {
						$fieldElement.val( updatedElementValue ).attr("data-previous-value", updatedElementValue);
					}
				}

				if(meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()){
					if( typeof laterFieldDetails.$fieldInput !== "undefined" ){
						meerkat.modules.placeholder.invalidatePlaceholder(laterFieldDetails.$fieldInput);
					} else {
						meerkat.modules.placeholder.invalidatePlaceholder($fieldElement);
					}
				}

				if(_.indexOf(["mobile","otherPhone"], fieldDetails.type) !== -1) {
					// Force populate these - don't relay on triggers
					// This is a dirty hack to resolve issue with health application fields not updating correctly
					laterFieldDetails.$field.val(meerkat.modules.phoneFormat.cleanNumber($fieldElement.val()));
				}
				// if the later field has both a hidden field and aninput field
				// let's trigger change, blur and focusout events on the input field to run the required logic to fill the hidden fields
				else if( typeof laterFieldDetails.$fieldInput !== "undefined" ){
					$fieldElement.trigger("change").trigger("blur").trigger("focusout");
				}

				if( typeof laterFieldDetails.$optInField !== "undefined" && !isPartOfOptInGroup( laterFieldDetails ) ){
					updateOptInFieldVisibility( laterFieldDetails.$optInField, updatedElementOptInValue );
				}

			}

		}

	}

	function updateLaterOptInFields( fieldDetails ){

		var updatedElementIsChecked = getOptInFieldIsChecked( fieldDetails.$optInField );

		var updatedElementOptInValue = null;
		if( hasOptInValue( fieldDetails ) ){
			updatedElementOptInValue = fieldDetails.optins[fieldDetails.type];
		}

		if( typeof updatedElementIsChecked !== "undefined" ){

			for ( var i = fieldDetails.index+1; i < fields[fieldDetails.type].length; i++ ){

				var laterFieldDetails = $.extend( fields[fieldDetails.type][i], {type: fieldDetails.type} );

				if( typeof laterFieldDetails.$optInField !== "undefined" ){

					if( updatedElementIsChecked && !isPartOfOptInGroup( laterFieldDetails ) ){
						updateOptInFieldVisibility( laterFieldDetails.$optInField, updatedElementIsChecked );
					} else {
						showOptInField( laterFieldDetails.$optInField );
						setOptInFieldValue( laterFieldDetails.$optInField, updatedElementIsChecked );
					}

				}

			}

		}

	}

	function getOptInFieldIsChecked( $element ){

		var updatedElementType = $element.attr("type");
		var updatedElementIsChecked = null;

		if( updatedElementType == "checkbox" ){
			updatedElementIsChecked = $element.is(":checked");
		} else if( updatedElementType == "radio" ) {
			$element.each(function(){
				if( $(this).is(":checked") ){
					updatedElementIsChecked = $element.val() == "Y";
					return false; // break
				}
			});
		} else {
			// @todo report that this optIn field type is not supported or the selector used is wrong
			return false;
		}

		return updatedElementIsChecked;
	}

	function setOptInFieldValue( $element, isChecked ){

		var updatedElementType = $element.attr("type");

		if( updatedElementType == "checkbox" ){
			$element.prop("checked", isChecked);
		} else if( updatedElementType == "radio" ) {
			var updateElementValue = null;
			if(isChecked){
				updateElementValue = "Y";
			} else {
				updateElementValue = "N";
			}
			$element.each(function(){
				if( $(this).val() == updateElementValue ){
					$(this).prop("checked", true).trigger("change"); // change event is required to update the radio group look
					return false; // break
				}
			});
		} else {
			// @todo report that this optIn field type is not supported or the selector used is wrong
		}

	}

	function getFields() {
		return fields;
	}

	function getLatestValue(type){
		var value = "";
		var fieldsForType = getFields()[type];
		_.each(fieldsForType, function(fieldObj){
			if( typeof fieldObj.$field !== 'undefined' && fieldObj.$field.val() !== ""){
				value = fieldObj.$field.val();
			}
		});
		return value;
	}

	meerkat.modules.register("contactDetails", {
		init: init,
		events: events,
		configure: configure,
		getFields: getFields,
		getFieldsFromOptInGroup: getFieldsFromOptInGroup,
		isOptInGroupValid: isOptInGroupValid,
		isPartOfOptInGroup: isPartOfOptInGroup,
		getLatestValue : getLatestValue
	});

})(jQuery);