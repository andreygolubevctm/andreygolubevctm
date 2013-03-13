<%@ tag language="java" pageEncoding="ISO-8859-1"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<go:script marker="onready">
	QuoteEngine.completed(function(){
		Roadside.fetchPrices();
		$("#revise").show();
	});	
</go:script>
