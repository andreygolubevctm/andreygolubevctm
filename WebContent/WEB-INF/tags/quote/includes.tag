<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="onready">
	QuoteEngine.completed(function(){
		Results.fetchPrices();
	});

	function submitForm() {
		$("#mainform").validate().resetNumberOfInvalids();
			$('#slide6 :input').each(function(index) {
				if ($(this).attr("id")){
					$("#mainform").validate().element("#" + $(this).attr("id"));
				}
			});	
			if ($("#mainform").validate().numberOfInvalids() == 0) {
					nav.next();
					progressBar(slideIdx);
					Interim.show();
			}
	}
	
</go:script>
<c:if test="${param.jump == 'results'}">
	<go:script marker="onready">
		$.ajax({
			url: "ajax/json/car_quote_results.txt",
			type: "GET",
			async: true,
			dataType: "json",
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				Results.update(jsonResult.results.price);
				Results.show();
			}
		});
	</go:script>
</c:if>

<%--//REVISE: Remove this--%>
<go:script marker="onready">
	$('body').keyup(function(e){
		if (e.ctrlKey && e.keyCode==39){
			$('.next').click();
		}
	});
</go:script>

<c:if test="${param.action == 'latest'}">
	<go:script marker="onready">
		Loading.show("Loading Your Quotes...");
		
		Results.init()
		$('#page').hide();
		$('#resultsPage').show();
		$.address.parameter("stage", "results", false );
		
		$.ajax({
			url: "ajax/json/car_quote_results.jsp",
			data: "action=latest",
			type: "GET",
			async: true,
			dataType: "json",
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				Loading.hide();
				Results.update(jsonResult.results.price);
				Results.show();
			}
		});			
	</go:script>
</c:if>

<go:script marker="js-head">
var Transaction = new Object(); 
Transaction = {
	_transId : 0,
	_reset : false,

	init: function() {
		this._reset = true;
	},
	
	getId: function() {
		
		this._transId=Track._getTransactionId( this._reset );
		this._reset = false;
		return this._transId;
	}
};
</go:script>

<go:script marker="onready">
Track.startSaveRetrieve(Transaction.getId(), 'Start', 'Your Car');
</go:script>

<go:script marker="jquery-ui">
// Quick config
var labels  = ['Not important', 'Neutral', 'Important'];
var min 	= 1;
var max 	= 3;
</go:script>