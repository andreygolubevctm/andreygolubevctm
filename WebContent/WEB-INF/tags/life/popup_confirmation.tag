<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="life-confirmation" class="life-confirmation" title="Life Product">
	<div class="dialog_header"></div>
	<div class="wrapper">
		<div class="column left">
			<div class="inner top">
				<div class="panel head intro">
					<div class="logo"><!-- empty --></div>
				</div>
			</div>
			<div class="inner left">
				<div class="panel dark lgetxt">
					<p><strong>Thank you</strong> for submitting your insurance application. A consultant will be in contact with you shortly to discuss your insurance requirements and process your application.</p>
					<p>An email has been sent to the email address provided with a summary of your details and your reference number.</p>
				</div>
			</div>
			<div class="inner right">
				<div class="panel dark lgetxt">
					<p>Have you considered your other insurance needs?</p>
					<p><strong>Compare</strong>the<strong>market</strong>.com.au also does Car Insurance, Health Insurance as well as Roadside Assistance, Fuel price comparison and more.</p>
				</div>
			
				<div class="panel">
					<p>Special Feature</p>
				</div>
			</div>
			<div class="inner bottom">
				<div class="panel nobdr nopad">
					<div class="right-panel promotion">
						<div class="right-panel-top"><!-- empty --></div>
						<div class="right-panel-middle">
							<div class="innertube">
								<h6 class="first">Promotional Content</h6>
								<p>Integer eleifend vestibulum dolor eu laoreet. Integer sed nibh vel metus euismod congue quis et eros. Suspendisse potenti. Duis gravida est ac sapien sollicitudin quis pretium purus adipiscing. Nunc eu ligula nibh. Etiam pharetra tempor ligula eu ornare. Integer lacus sem, ultricies in fringilla vel, vehicula eget dolor. Vestibulum a hendrerit nisl. Donec fermentum velit non odio vulputate in tincidunt nunc commodo.</p>
							</div>
						</div>
						<div class="right-panel-bottom"><!-- empty --></div>
					</div>
					<div class="clear"><!-- empty --></div>
				</div>
			</div>
		</div>
		<div class="column right">
			<div class="panel head nobdr">
				<div class="reference">Your reference no. <span class="reference_no"></span></div>
			</div>
			<div class="right-panel">
				<div class="right-panel-top"><!-- empty --></div>
				<div class="right-panel-middle">
					<div class="panel">
						<p><strong>Compare</strong>the<strong>market</strong>.com.au is an online comparison website aimed at delivering our clients competitively priced yet comprehensive policies.  Information and quotes are provided by our trusted partner, Lifebroker Pty Ltd.</p>
					</div>
				</div>
				<div class="right-panel-bottom"><!-- empty --></div>
			</div>
		</div>
	</div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<life:popup_common_css />

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var LifeConfirmationDialog = {

	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#life-confirmation').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip', 
			'modal':true, 
			'width':737, 
			'minWidth':737,
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'life-confirmation',
			'title':'Life product details dialog.',
			open: function() {
				LifeConfirmationDialog.show(); 
			},
			close: function(){
				LifeConfirmationDialog.hide();	
		  	}
		});	
	},
	
	launch: function() {
		$('#life-confirmation').dialog("open");
	},
	
	hide: function() {
	
		// Re-enable the more button on the results page
		btnInit.enable();
		
		$("#life-confirmation").hide();
	},

	show: function() {	
		Track.onCallMeBackClick(Results.getSelectedProduct());
	
		product = Results.getSelectedProduct();
		
		// Disable the more button on the results page
		btnInit.disable();
				
		$("#life-confirmation .stars").each(function(){
			StarRating.render($(this), product.stars);
		});	
		$("#life-confirmation .reference_no").each(function(){
			$(this).empty().append( product.transaction_id );
		});	
		$("#life-confirmation .premium .amount span").each(function(){
			$(this).empty().append("$" + product.price);
		});
		$("#life-confirmation .head .product_name").each(function(){
			$(this).empty().append( product.name );
		});	
		
		if( $("#life_cover_term").is(":checked") ) 
		{
			$("#life-confirmation .policy_benefits .term").show();
		}
		else
		{
			$("#life-confirmation .policy_benefits .term").hide();
		}
		
		if( $("#life_cover_trauma").is(":checked") ) 
		{
			$("#life-confirmation .policy_benefits .trauma").show();
		}
		else
		{
			$("#life-confirmation .policy_benefits .trauma").hide();
		}
		
		if( $("#life_cover_tpd").is(":checked") ) 
		{
			$("#life-confirmation .policy_benefits .tpd").show();
		}
		else
		{
			$("#life-confirmation .policy_benefits .tpd").hide();
		}
		
		$("#life-confirmation .product_link a").each(function(){
			$(this).attr("href", product.info_url);
		});
		
		$("#life-confirmation .pds a").each(function(){
			$(this).attr("href", product.pds);
		});
		
		var count = 0;
		$("#life-confirmation .policy_details .inclusions").empty();
		for(var i in product.features.available)
		{
			if(count++ < 5)
			{
				var name = product.features.available[i];
				var li = $("<li>" + name + "</li>").data("id", i);
				$("#life-confirmation .policy_details .inclusions").append( li );
			}
		}
		
		count = 0;
		$("#life-confirmation .policy_details .exclusions").empty();
		for(var i in product.features.unavailable)
		{
			if(count++ < 5)
			{
				var name = product.features.unavailable[i];
				var li = $("<li>" + name + "</li>").data("id", i);
				$("#life-confirmation .policy_details .exclusions").append( li );
			}
		}
		
		$("#life-confirmation").show();
	},
	
	callMeBack : function()
	{
		Track.onCallMeBackClick(Results.getSelectedProduct());
	}
};
</go:script>
<go:script marker="onready">
LifeConfirmationDialog.init();
</go:script>