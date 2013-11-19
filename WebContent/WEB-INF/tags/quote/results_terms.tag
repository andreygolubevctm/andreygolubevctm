<%@ tag description="Terms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<c:set var="termsTitle">
	<div class="icon"><img src="common/images/logos/blank.gif" alt="[#= brand #]"></div>
	<div class="title"><div id="productName"><h2>[#= brand #]</h2></div></div>
	<core:clear />
	<div class="dialogTitle">Offer Terms</div>
</c:set>

<c:set var="termsTitleEscaped">
	${go:replaceAll( go:replaceAll( termsTitle, '"', '\\\\"' ), "\\r\\n", "" )}
</c:set>

<c:set var="onClose">
	<%-- reset with default non parsed HTML, ready for next opening/parsing --%>
	$("#ui-dialog-title-termsDialog").html( "${termsTitleEscaped}" );
</c:set>

<ui:dialog
	id="terms"
	title="${termsTitleEscaped}"
	dialogBackgroundColor="#ffffff"
	width="500"
	onClose="${onClose}"
	/>

<%-- CSS --%>
<go:style marker="css-head">
    .termsDialogContainer span.ui-dialog-title .icon{
		float: left;
		margin: 0 24px 0px 0px;
	}
	.termsDialogContainer .dialogClose{
		position: absolute;
		top: -40px;
		right: -7px;
	}
	.termsDialogContainer .ui-dialog-titlebar{
		padding: .4em 1em !important;
		height: 80px;
		z-index: 10;
		position: relative;
	}
	.termsDialogContainer span.ui-dialog-title .dialogTitle{
	    margin-bottom: -10px;
		background-color: #ffffff;
		display:inline-block;
		padding: 0 5px;
	}
	.termsDialogContainer span.ui-dialog-title .title {
		margin-top: 11px;
		float: left;
	}
	.termsDialogContainer span.ui-dialog-title .title h2{
		font-size: 26px;
		color: #4B5053;
	}
	.termsDialogContainer span.ui-dialog-title .title h3{
		font-size: 18px;
		font-family: "SunLt Light", "Open Sans", Helvetica, Arial, sans-serif;
	}
	
	#termsDialog{
		clear: both;
	}
	#termsDialog p {
	    margin-bottom: 9px;
	    font-size: 11px;
	    margin: 10px 10px;
	}	
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var Terms = new Object();
Terms = {
	_origZ : 0,
	_id: false,
	
	show: function(id, priceType){
	
		var res = Results.getResult("productId", id);
		Terms._id = id;
		var terms=false;
		
		if (res){
			<%-- No price type specified, default to headlineOffer --%>
			if (!priceType){
				priceType = res.headlineOffer;
			}
		
			if (priceType == "OFFLINE") {
				terms = res.offlinePrice.terms;
			} else {
				terms = res.onlinePrice.terms;
			}
		}
		
		if (terms) {
			$("#termsDialog").html(terms);
			
			<%-- default values from DISC --%>
			var titleContent = $("#ui-dialog-title-termsDialog").html();
			titleContent = titleContent.replace(/blank.gif/g, "product_info/" + id + ".png");
			titleContent = titleContent.replace(/\[#= brand #\]/g, res.productDes);
			$("#ui-dialog-title-termsDialog").html( titleContent );
			
			<%-- scrape values if exist --%>
			moreDetailsHandler._productId = id;
			moreDetailsHandler.getScrapes(Terms.scrapesReceived);

			termsDialog.open();
		}
		Track.offerTerms(id);
	}, 
	scrapesReceived: function(){
		
		<%-- replace the product name by the received scrape --%>
		$.each(moreDetailsHandler._scrapes[Terms._id], function(key, scrape){
			if(scrape.cssSelector == "#productName" && scrape.html != "") {
				$("#ui-dialog-title-termsDialog #productName").html(scrape.html);
			};
		});
		
	}, 
	hide : function(){
		termsDialog.close();
	}
}
</go:script>