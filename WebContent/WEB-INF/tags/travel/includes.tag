<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:if test="${param.action == 'results'}">
<go:script marker="onready">
		Travel.fetchPrices();
	</go:script>
</c:if>
<go:script marker="onready">
	$('#travel_oldest').bind('keypress', function(e) {
		if (e.which == 13) {
			$("#next-step").click();
			return false;
		}
	});
	QuoteEngine.completed(function(){
		Travel.fetchPrices();
		$("#revise").show();
	});
</go:script>
<c:if test="${param.action == 'load'}">
	<go:script marker="onready">
		Loading.show("Loading Your Quotes...");
	
		var dat = "vertical=travel&action=load&id=${param.id}&hash=${param.hash}&type=${param.type}";

				$.ajax({
					url: "ajax/json/remote_load_quote.jsp",
					data: dat,
					dataType: "json",
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
		},
					success: function(json){
						Loading.hide(function(){
							var url = json.result.destUrl+'&ts='+ +new Date();
							window.location.href = json.result.destUrl+'&ts='+ +new Date();
						});
						return false;
					},
					error: function(obj,txt){
						Loading.hide(function(){
							Retrieve.error("A problem occurred when trying to communicate with our network.");
						});
					},
					timeout:30000
				});
		
</go:script>
</c:if>
	

<go:script marker="onready">
	Track.onQuoteEvent('Start', referenceNo.getTransactionID(false), 'Travel Details');
	Track._transactionID = referenceNo.getTransactionID();
</go:script>