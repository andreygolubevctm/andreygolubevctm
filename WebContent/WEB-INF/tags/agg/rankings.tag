<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Tag used to record result rankings"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical" 	required="true"	 rtexprvalue="true"	 description="The current vertical (e.g. travel)" %>

<%-- JS --%>
<go:script marker="js-head">

	var Rankings = new Object();
	Rankings = {

		settings: false,

		init: function( userSettings ){

			var settings = {
				paths: {
					productId: "productId",
					price: "price.annual.total"
				},
				parameters:{
					productId: "rank_productId",
					price: "rank_premium"
				}
			};
			$.extend(true, settings, userSettings);

			Rankings.settings = settings;
			$(Results.settings.elements.resultsContainer).on("resultsSorted", function(){
				Rankings.save();
			});

			$(Results.settings.elements.resultsContainer).on("resultsDataReady", function(){
				Rankings.save();
			});

		},

		save: function(){

			var sorted = Results.getSortedResults();
			var filtered = Results.getFilteredResults();
			var vertical = "${vertical}";

			var sortedAndFiltered = new Array();

			for(var i=0; i < sorted.length; i++){
				for(var k=0; k < filtered.length; k++){
					if(sorted[i] == filtered[k]){
						sortedAndFiltered[sortedAndFiltered.length] = sorted[i];
					}
				}
			}

			var qs = new Array();
			qs.push( "rootPath="+vertical );
			qs.push( "rankBy=" + Results.getSortBy() + "-" + Results.getSortDir() );
			qs.push( "rank_count=" + sortedAndFiltered.length );
			qs.push( "transactionId="+referenceNo.getTransactionID() );

			for (var i = 0 ; i < sortedAndFiltered.length; i++) {

				var productId = Object.byString( sortedAndFiltered[i], Rankings.settings.paths.productId );
				var price = Object.byString( sortedAndFiltered[i], Rankings.settings.paths.price );

				qs.push( Rankings.settings.parameters.productId + i + "=" + productId );

				if ( price ) {
					qs.push( Rankings.settings.parameters.price + i + "=" + price );
				}
				
				
				
			}

			$.ajax(
				{
					url: "ajax/write/quote_ranking.jsp",
					data: qs.join("&"),
					type:'POST'
				}
			);

		},

		<%-- @todo = Only used for health, needs to be changed to use the save() function instead when ready --%>
		writeRanking: function(rootPath, sortedPrices, sortBy, sortDir, includePremium) {
			var qs = "rootPath=" + rootPath + "&rankBy=" + sortBy + "-" + sortDir +
					"&rank_count=" + sortedPrices.length + "&";
			for (var i = 0 ; i < sortedPrices.length; i++) {
				var price = sortedPrices[i];
				var prodId= price.productId.replace('PHIO-HEALTH-', '');;
				qs+="rank_productId"+i+"="+prodId+"&";
				if (includePremium) {
					qs+="rank_premium"+i+"="+price.premium.monthly.value+"&";
				}
			}
			$.ajax({url:"ajax/write/quote_ranking.jsp",data:qs});
		}
	}
</go:script>