<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Quick Capture sign Up Form --%>
<fuel:quick_capture />

<go:script marker="onready">
	QuoteEngine.completed(function(){
		fuel.fetchPrices();
		$("#revise").show();
	});

	//if parameters are set - than send off the form!
	if(  ($('#fuelTypes').find(':checked').length > 0) && ($('#fuel_location').val() !== '' || ($.browser.msie && $.browser.version < 10 && $('#fuel_location').val() == 'Postcode/Suburb')) ) {
		QuoteEngine.validate(true); //validate and submit!
	}
</go:script>
