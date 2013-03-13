<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="ip-product-dialog" class="ip-product-dialog" title="IP Product">
	<div class="dialog_header"></div>
	<div class="wrapper">
		<div class="column left">
			<div class="inner top">
				<div class="panel head intro">
					<img class="logo" />
					<div class="product_name"><!-- empty --></div>
				</div>
			</div>
			<div class="inner left">
				<div class="panel dark couple benefits">
					<h4>Policy Benefits</h4>
					<ul class="policy_benefits">
						<li class="income">Income</li>
					</ul>
				</div>
			
				<div class="panel dark couple rating">
					<h4>Star Rating</h4>
					<div class='stars'><!-- empty --></div>
				</div>
			</div>
			<div class="inner left">
				<div class="panel nobdr policy_details">
					<h5 class="first">What's Included</h5>
					<ul class="inclusions"></ul>
					<h5>Exclusions</h5>
					<ul class="exclusions"></ul>
					<h5>Optional Extras</h5>
					<ul class="extras"></ul>
				</div>
			</div>
			<div class="inner bottom">
				<div class="panel nobdr">
					<h6 class="first">Product disclosure statement</h6>
					<p class="pds"><a href="javascript:void(0);" target="_BLANK" title="view the PDS">Product Disclosure Statement</a></p>
				</div>
				<div class="clear"><!-- empty --></div>
			</div>
			<div class="clear"><!-- empty --></div>
		</div>
		<div class="column right">
			<div class="panel head premium">
				<div class="amount">
					<span><!-- empty --></span>
				</div>
				<div class="text">Estimated<br/><span>Monthly</span> Premium</div>
			</div>
			<div class="right-panel">
				<div class="right-panel-top"><!-- empty --></div>
				<div class="right-panel-middle">
					<div class="call-me-back">
						<a href="javascript:IPProductDialog.callMeBack();" class="button"><span>Call Me Back</span></a>
						<p class="sub">A Lifebroker consultant can call you back to discuss this option and process your insurance policy</p>
						<h5>OR<br/>Call Lifebroker Now<br /><em><span>1800 204 124</span></em></h5>
						<p class="ref">Remember to quote your reference no. <span class="reference_no"><!-- empty --></span>
					</div>
					<div class="panel nopad nobdr">
						<p><strong>Compare</strong>the<strong>market</strong>.com.au is an online comparison website aimed at delivering our clients competitively priced yet comprehensive policies.  Information and quotes are provided by our trusted partner, Lifebroker Pty Ltd.</p>
					</div>
				</div>
				<div class="right-panel-bottom"><!-- empty --></div>
			</div>
		</div>
		<div class="clear"><!-- empty --></div>
		<div class="full">
			<div class="panel nobdr">
				<h6>Disclaimer</h6>
				<p class="disclaimer">This is an indicative quote based on the information you have provided.  The information you have provided and other factors will be taken into account when setting the premium.<br /><br />The star ratings used in respect of the Life Products are provided by Lifebroker and are based on their internal comparison rating that compares general benefits and features between each product. These ratings are maintained by a leading actuary and are updated monthly.</p>
			</div>
		</div>
	</div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<ip:popup_common_css />


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var IPProductDialog = {

	_product : null,
	_close_callback : null,

	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#ip-product-dialog').dialog({
			autoOpen: false,
			show: {
				effect: 'clip',
				complete: function(){
					$(".ui-dialog.ip-product-dialog").first().center();
					//QuoteEngine.scrollTo('.ui-dialog:visible');
				}
			},
			hide: 'clip', 
			'modal':true, 
			'width':737, 
			'minWidth':737,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'ip-product-dialog',
			'title':'IP product details dialog.',
			open: function() {
				IPProductDialog.show();
			},
			close: function(){
				IPProductDialog.hide();	
		  	}
		});	
	},
	
	launch: function() {
		$('#ip-product-dialog').dialog("open");
	},
	
	close: function( callback ) {
		if( typeof callback == "function" )
		{
			IPProductDialog._close_callback = callback;
		}
		$('#ip-product-dialog').dialog("close");
	},
	
	hide: function() {
	
		// Re-enable the more button on the results page
		btnInit.enable();
		
		$("#ip-product-dialog").hide("fast", IPProductDialog._close_callback);
	},

	show: function() {		
	
		IPProductDialog._product = Results.getSelectedProduct();
		
		// Disable the more button on the results page
		btnInit.disable();
		
		$("#ip-product-dialog .logo").first().attr("src","common/images/logos/life/120x60/" + IPProductDialog._product.thumb);
		$("#ip-product-dialog .logo").first().attr("alt",IPProductDialog._product.company);
		$("#ip-product-dialog .logo").first().attr("title",IPProductDialog._product.company);
				
		$("#ip-product-dialog .stars").each(function(){
			StarRating.render($(this), IPProductDialog._product.stars);
		});	
		$("#ip-product-dialog .reference_no").each(function(){
			$(this).empty().append( IPProductDialog._product.transaction_id );
		});	
		$("#ip-product-dialog .premium .amount span").each(function(){
			$(this).empty().append("$" + IPProductDialog._product.price);
		});
		$("#ip-product-dialog .head .product_name").each(function(){
			$(this).empty().append( IPProductDialog._product.name );
		});	
		
		$("#ip-product-dialog .policy_benefits .income").show();
		
		/*$("#ip-product-dialog .product_link a").each(function(){
			$(this).attr("href", IPProductDialog._product.info_url);
		});*/
		
		$("#ip-product-dialog .pds a").each(function(){
			$(this).attr("href", IPProductDialog._product.pds);
		});
		
		var count = 0;
		$("#ip-product-dialog .policy_details .inclusions").empty();
		for(var i in IPProductDialog._product.features.available)
		{
			if(count++ < 5)
			{
				var name = IPProductDialog._product.features.available[i];
				var li = $("<li>" + name + "</li>").data("id", i);
				$("#ip-product-dialog .policy_details .inclusions").append( li );
			}
		}
		
		count = 0;
		$("#ip-product-dialog .policy_details .exclusions").empty();
		for(var i in IPProductDialog._product.features.unavailable)
		{
			if(count++ < 5)
			{
				var name = IPProductDialog._product.features.unavailable[i];
				var li = $("<li>" + name + "</li>").data("id", i);
				$("#ip-product-dialog .policy_details .exclusions").append( li );
			}
		}
		
		$("#ip-product-dialog .policy_details .extras").empty();
		for(var i in IPProductDialog._product.features.extras)
		{
			var name = IPProductDialog._product.features.extras[i];
			var li = $("<li>" + name + "</li>");
			$("#ip-product-dialog .policy_details .extras").append( li );
		}
			
		$('#ip-product-dialog').find('.reference_no').each(function(){
			$(this).empty().append( ReferenceNo.getTransactionID(ReferenceNo._FLAG_DEFAULT) );
		});
			
		$('#ip-product-dialog .text span').first().empty().append( IPQuote.getPremiumFrequencyTerm() );
		
		$("#ip-product-dialog").show('fast');
	},
	
	callMeBack : function()
	{
		IPQuote.submitApplication(IPProductDialog._product);
	}
};
</go:script>
<go:script marker="onready">
IPProductDialog.init();
</go:script>