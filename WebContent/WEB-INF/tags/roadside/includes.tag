<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<go:script marker="onready">
	QuoteEngine.completed(function(){
		Roadside.fetchPrices();
		$("#revise").show();
	});	
</go:script>
