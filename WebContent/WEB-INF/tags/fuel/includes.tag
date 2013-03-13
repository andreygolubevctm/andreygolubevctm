<%@ tag language="java" pageEncoding="ISO-8859-1"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<go:script marker="onready">
	QuoteEngine.completed(function(){
		fuel.fetchPrices();
		$("#revise").show();
	});	
	
	//if parameters are set - than send off the form!
	if(  ($('#fuelTypes').find(':checked').length > 0) && ($('#fuel_location').val() !== '' )  ) {	
		QuoteEngine.validate(true); //validate and submit!
	}
</go:script>
