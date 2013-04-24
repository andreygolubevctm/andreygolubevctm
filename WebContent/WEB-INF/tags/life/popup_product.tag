<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="life-product-dialog" class="life-product-dialog" title="Life Product">
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
						<li class="term">Life</li>
						<li class="trauma">Trauma</li>
						<li class="tpd">TPD</li>
					</ul>
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
						<a href="javascript:LifeProductDialog.callMeBack();" class="button"><span>Call Me Back</span></a>
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
				<p class="disclaimer">This is an indicative quote based on the information you have provided.  The information you have provided and other factors will be taken into account when setting the premium.</p>
			</div>
		</div>
	</div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<life:popup_common_css />

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var LifeProductDialog = {
	
	_product : null,
	_close_callback : null,

	init: function() {

		// Initialise the search quotes dialog box
		// =======================================
		$('#life-product-dialog').dialog({
			autoOpen: false,
			show: {
				effect: 'clip',
				complete: function(){
					$(".ui-dialog.life-product-dialog").first().center();
					//QuoteEngine.scrollTo('.ui-dialog:visible');
				}
			},
			hide: 'clip', 
			position: 'center',
			'modal':true, 
			'width':737, 
			'minWidth':737,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'life-product-dialog',
			'title':'Life product details dialog.',
			open: function() {
				LifeProductDialog.show(); 
			},
			close: function(){
				LifeProductDialog.hide();	
		  	}
		});	
	},
	
	launch: function() {
		$('#life-product-dialog').dialog("open");
	},
	
	close: function( callback ) {
		if( typeof callback == "function" )
		{
			LifeProductDialog._close_callback = callback;
		}
		$('#life-product-dialog').dialog("close");
	},
	
	hide: function() {
	
		// Re-enable the more button on the results page
		btnInit.enable();
		
		$("#life-product-dialog").hide("fast", LifeProductDialog._close_callback);
	},

	show: function() {	
		
		LifeProductDialog._product = Results.getSelectedProduct();
		
		// Disable the more button on the results page
		btnInit.disable();
		
		$("#life-product-dialog .logo").first().attr("src","common/images/logos/life/120x60/" + LifeProductDialog._product.thumb);
		$("#life-product-dialog .logo").first().attr("alt",LifeProductDialog._product.company);
		$("#life-product-dialog .logo").first().attr("title",LifeProductDialog._product.company);
				
		$("#life-product-dialog .stars").each(function(){
			StarRating.render($(this), LifeProductDialog._product.stars);
		});	
		$("#life-product-dialog .reference_no").each(function(){
			$(this).empty().append( LifeProductDialog._product.transaction_id );
		});	
		$("#life-product-dialog .premium .amount span").each(function(){
			$(this).empty().append("$" + LifeProductDialog._product.price);
		});
		$("#life-product-dialog .head .product_name").each(function(){
			$(this).empty().append( LifeProductDialog._product.name );
		});	
		
		if( $("#life_cover_term").is(":checked") ) 
		{
			$("#life-product-dialog .policy_benefits .term").show();
		}
		else
		{
			$("#life-product-dialog .policy_benefits .term").hide();
		}
		
		if( $("#life_cover_trauma").is(":checked") ) 
		{
			$("#life-product-dialog .policy_benefits .trauma").show();
		}
		else
		{
			$("#life-product-dialog .policy_benefits .trauma").hide();
		}
		
		if( $("#life_cover_tpd").is(":checked") ) 
		{
			$("#life-product-dialog .policy_benefits .tpd").show();
		}
		else
		{
			$("#life-product-dialog .policy_benefits .tpd").hide();
		}
		
		/*$("#life-product-dialog .product_link a").each(function(){
			$(this).attr("href", LifeProductDialog._product.info_url);
		});*/
		
		$("#life-product-dialog .pds a").each(function(){
			$(this).attr("href", LifeProductDialog._product.pds);
		});
		
		var count = 0;
		$("#life-product-dialog .policy_details .inclusions").empty();
		for(var i in LifeProductDialog._product.features.available)
		{
			if(count++ < 5)
			{
				var name = LifeProductDialog._product.features.available[i];
				var li = $("<li>" + name + "</li>").data("id", i);
				$("#life-product-dialog .policy_details .inclusions").append( li );
			}
		}
		
		count = 0;
		$("#life-product-dialog .policy_details .exclusions").empty();
		for(var i in LifeProductDialog._product.features.unavailable)
		{
			if(count++ < 5)
			{
				var name = LifeProductDialog._product.features.unavailable[i];
				var li = $("<li>" + name + "</li>").data("id", i);
				$("#life-product-dialog .policy_details .exclusions").append( li );
			}
		}
		
		$("#life-product-dialog .policy_details .extras").empty();
		for(var i in LifeProductDialog._product.features.extras)
		{
			var name = LifeProductDialog._product.features.extras[i];
			var li = $("<li>" + name + "</li>");
			$("#life-product-dialog .policy_details .extras").append( li );
		}
			
		$('#life-product-dialog').find('.reference_no').each(function(){
			$(this).empty().append( ReferenceNo.getTransactionID(ReferenceNo._FLAG_DEFAULT) );
		});
			
		$('#life-product-dialog .text span').first().empty().append( LifeQuote.getPremiumFrequencyTerm() );
		
		$("#life-product-dialog").show("fast");
	},
	
	callMeBack : function()
	{
		LifeQuote.submitApplication(LifeProductDialog._product);
	}
};
</go:script>
<go:script marker="onready">
LifeProductDialog.init();
</go:script>