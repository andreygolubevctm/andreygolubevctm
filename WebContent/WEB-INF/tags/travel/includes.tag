<%@ tag language="java" pageEncoding="ISO-8859-1"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
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
<go:script marker="js-head">
	var Transaction = new Object(); 
	Transaction = {
		_transId : 0,
		_reset : true,
	
		init: function() {
			this._reset = true;
		},
		
		getId: function() {
			if(this._reset) {
				this._transId=Track._getTransactionId();
			}
	
			this._reset = false;
			return this._transId;
		}
	};
</go:script>
<go:script marker="onready">
	Track.onQuoteEvent('Start', Transaction.getId(), 'Travel Details');
</go:script>