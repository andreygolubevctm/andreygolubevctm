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
	function getData( $element ){

		return filterData( $element ).serializeArray();

	}

	function getSerializedData( $element ){
		return filterData( $element ).serialize();
	}

	function filterData( $element ){
		return $element.find(":input:visible, input[type=hidden], :input[data-visible=true], :input[data-initValue=true]").filter(function(){
			return $(this).val() !== "" && $(this).val() !== "Please choose...";
		});
	}

	
	function markFieldsAsVisible($parentElement){

		$parentElement.find(':input[data-initValue]').removeAttr('data-initValue');
		$parentElement.find(':input[data-visible]').removeAttr('data-visible');
		$parentElement.find(':input:visible').attr('data-visible', "true");

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
		markInitialFieldsWithValue:markInitialFieldsWithValue
	});

})(jQuery);