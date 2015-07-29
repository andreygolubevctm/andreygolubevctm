<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Product Information --%>
<agg:product_info />

<%-- ResultsObj none popup --%>
<agg:results_none providerType="Roadside assistance" />


<go:script marker="onready">
	QuoteEngine.completed(function(){
		Roadside.fetchPrices();
		$("#revise").show();
	});
</go:script>
