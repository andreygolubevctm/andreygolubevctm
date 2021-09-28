;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		form: {
			
		}
	},
	moduleEvents = events.form;

	function init(){

	}

	// This function can be used to get data out of any $element really, not just forms even if the module is named like that!
	function getData( $element, optionalSearchCriteria ){

		return filterData( $element, optionalSearchCriteria ).serializeArray();

	}

	function getSerializedData( $element ){
		return filterData( $element ).serialize();
	}

	function filterData( $element, optionalSearchCriteria ){
		return $element.find(":input:visible, input[type=hidden], :input[data-visible=true], :input[data-initValue=true]," +
			" :input[data-attach=true]" + (!optionalSearchCriteria ? "" : ", " + optionalSearchCriteria)).filter(function(){
			return $(this).val() !== "" && $(this).val() !== "Please choose..." && !$(this).attr('data-ignore');
		});
	}

	
	function markFieldsAsVisible($parentElement){
		clearInitialFieldsAttribute($parentElement);
		$parentElement.find(':input[data-visible]').removeAttr('data-visible');
		$parentElement.find(':input:visible').attr('data-visible', "true");

	}

	function clearInitialFieldsAttribute($parentElement){
		$parentElement.find(':input[data-initValue]').removeAttr('data-initValue');
	}

	function markInitialFieldsWithValue($parentElement){
		$elements = $parentElement.find(":input").filter(function(){
			return $(this).val() !== "" && $(this).val() !== "Please choose...";
		});
		$elements.attr('data-initValue', 'true');
	}

	function appendHiddenField( $form, name, value ){
		$form.append('<input type="hidden" id="' + name + '" name="' + name + '" data-visible="true" value="' + value + '" />');
	}

	meerkat.modules.register("form", {
		init: init,
		events: events,
		getData: getData,
		getSerializedData: getSerializedData,
		appendHiddenField: appendHiddenField,
		markFieldsAsVisible:markFieldsAsVisible,
		markInitialFieldsWithValue:markInitialFieldsWithValue,
		clearInitialFieldsAttribute: clearInitialFieldsAttribute
	});

})(jQuery);