<%@ tag description="The Bridging Page Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">

	/* STRUCTURE */
		#columns{
			display: table;
			width: 100%;
			height: 100%;
			position: relative;
		}
		.md-left-column{
			float: left;
			width: 49%;
			border-right: 1px solid #E3E8EC;
			padding-right: 5px;
			height: 100%;
			position: absolute;
		}
		.md-right-column{
			float: right;
			width: 49%;
		}
	
	/* SPECIFIC */
		#md-brand {
			width: 100%;
			border-bottom: 1px solid #E3E8EC;
			padding-bottom: 20px;
			margin-bottom: 10px;
		}
			#md-brand .icon {
				float:left;
		    	margin:0 24px 12px 12px;
			}
			#md-brand .title {
				font-size:17px;
				margin-bottom:12px;
			}
			#md-brand .uws,
			#brand .afs {
				font-size:11px;
				color:#808080;
			}
		
		#md-included h5{
			margin-top: 0;
		}
		
		#md-additional-excess .excessRow{
			width: 100%;
			font-size: 12px;
			padding-bottom: 5px;
			margin-left: 0;
		}
			#md-additional-excess .excessRow .excessDesc{
				width: 85%;
			}
			#md-additional-excess .excessVal{
				width: 10%;
			}
		
		#md-pds p{
			padding: 3px 0;
		}
		
		#md-quote {
			background-color: #fbfbfb;
			border: 1px solid #E3E8EC;
			padding: 10px;
		}
			#md-lead-no{
				font-size: 18px;
				font-weight: bold;
			}
			#md-special-offer{
				margin-bottom: 10px;
			}
			#md-price{
				background-color: white;
				border: 1px solid #E3E8EC;
				padding: 10px;
			}
				#md-price p{
					padding: 4px 0;
				}
				#md-price > div{
					border-top: 1px solid #E3E8EC;
					padding: 10px 0;
				}
				#md-price > div:first-child{
					border-top: none;
					padding-top: 5px;
				}
					#md-price #md-annual-price,
					#md-call-to-action #md-phone-no{
						font-size: 22px;
						font-weight: bold;
					}
					
		.moreDetailsDialog a.button#go-to-insurer {
			width: 100%;
		}
		
		#md-call-to-action #md-phone-no{
			margin: 7px 0;
		}
		#md-call-to-action #md-call-me-back{
			margin: 15px auto;
			position: static;
			float: none;
		}
		#md-call-to-action .fieldrow_label{
			position: absolute;
			width: auto;
			margin: 12px 14px 10px 5px;
		}
		#md-call-to-action .fieldrow_legend{
			width: 0px;
			padding: 0;
			margin: 0;
		}
		#md-call-to-action .fieldrow_value{
			margin-left: 0px;
			padding-right: 10px;
		}
			#md-call-to-action .fieldrow_value input{
				height: 26px;
				padding-left: 110px;
			}
			#md-call-to-action .fieldrow_value,
			#md-call-to-action .fieldrow_value .contact-name{
				width: 317px;
			}
			#md-call-to-action .fieldrow_value .contact-phone{
				width: 170px;
			}
		#md-call-to-action #md-submit{
			margin-top: -38px;
		}
		
		#md-about hr {
			margin: 10px 0;
		}
	
	/* GENERAL */
		.moreDetailsDialog h5{
			color: #0C4DA2;
			margin-top: 20px;
			margin-bottom: .5em;
		}
		
		.moreDetailsDialog a{
			font-size: 100%;
		}
		
		.moreDetailsDialog ul{
			margin-bottom: 15px;
		}
		.moreDetailsDialog ul li{
			list-style-image: url(brand/ctm/images/bullet_edit.png);
			list-style-position: inside;
		}
		
		.moreDetailsDialog .green{
			color: #0DB14B;
		}
	

		.moreDetailsDialog hr{
			border: none;
			border-bottom: 1px solid #E3E8EC;
			margin: 15px 10px;
		}
		
	
	/* DIALOG */
		.moreDetails{
			background-image: url(common/images/dialog/header_920.png);
			background-position: 0 38px;
		} 
			.moreDetails .ui-dialog-titlebar{
				background-image: none;
				height: 26px;
				padding: 0 4em !important;
				margin-top: 38px;
			}
			.moreDetails .ui-dialog-titlebar span{
				display: none;
			}
			.moreDetails .ui-dialog-content{
				background-image: url(common/images/dialog/content_920.png) !important;
				padding: .5em 1.5em;
			}
		
		.ui-dialog.no-close .ui-dialog-titlebar-close,
		.ui-dialog.no-title .ui-dialog-title  {
			display:none;
		}
				
		#moreDetailsClose {
			background: url(common/images/dialog/close.png) no-repeat;
			width: 36px;
			height: 31px;
			position: absolute;
			top:0px;
			right: -7px;
			cursor: pointer;
			display: none;
		}		  						 
		#moreDetailsFooter {
			background: url("common/images/dialog/footer_920.png") no-repeat scroll left top transparent;
			width: 920px;
			height: 20px;
			clear:both;
		}
		#moreDetailsDialog {
			overflow:hidden;
		}
</go:style>

<%-- HTML --%>
<div id="moreDetailsDialog" class="moreDetailsDialog">
		
</div>

<core:js_template id="more-details-template">
	
	<div class="more-details-template">
	
		<div id="md-brand">
			<div class="icon"><img src="common/images/logos/results/[#= productId #].png" alt="[#= productDes #]"></div>
			<div class="title">[#= productDes #]</div>
			<div class="uws">Underwriter: [#= underwriter #]</div>
			<div class="afs">AFS Licence No: [#= afsLicenceNo #]</div>
		</div>
		
		<div id="columns">
		
			<div class="md-left-column">
			
				<div id="md-included">
					<h5>What's Included</h5>
					<ul>
						<li>???</li>
						<li>???</li>
						<li>???</li>
					</ul>
					<p>This is a brief summary. Conditions apply. Please read the <a href="#">???Product Disclosure Statement???</a> for more information.</p>
				</div>
				
				<div id="md-extras">
					<h5>Optional Extras</h5>
					<ul>
						<li>???</li>
						<li>???</li>
						<li>???</li>
					</ul>
				</div>
				
				<div id="md-benefits">
					<h5>This insurance comes with some further benefits</h5>
					<ul>
						<li>???</li>
						<li>???</li>
						<li>???</li>
					</ul>
				</div>
				
				<hr/>
				
				<div id="md-conditions">
					<h5 class="green">Special Conditions</h5>
				</div>
				
				<div id="md-additional-excess">
					<h5 class="green">Additional excess</h5>
				</div>
				
				<div id="md-pds">
					<h5>Product Disclosure Statement</h5>
					<p><a href='javascript:showDoc("[#= pdsaUrl #]")'>Product Disclosure Statement Part A</a></p>
					<p><a href='javascript:showDoc("[#= pdsbUrl #]")'>Product Disclosure Statement Part B</a></p>
				</div>
				
				<div id="md-disclaimer">
					<h5>Disclaimer</h5>
					<p>[#= disclaimer #]</p>
				</div>
				
			</div>
			
			<div class="md-right-column">
			
				<div id="md-quote" class="rounded-corners">
				
					<div id="md-lead-no">
						Quote# [#= leadNo #]
					</div>
					
					<div id="md-special-offer">
						<h5>Special Offer</h5>
						<p>???</p>
					</div>
					
					<div id="md-price" class="rounded-corners">
						<div>
							<strong>Annual:</strong> <span id="md-annual-price" class="green">$[#= onlinePrice.lumpSumTotal #]</span> Online Premium
						</div>
						<div>
							<strong>Monthly:</strong> $[#= onlinePrice.instalmentFirst #] and [#= onlinePrice.instalmentCount #] additional payments of $[#= onlinePrice.instalmentPayment #] Online Premium
						</div>
						<div>
							<p><strong>Excess:</strong> $[#= excess.total #]</p>
							<p>Refer to <span class="green">???Special Conditions???</span> and <span class="green">???Additional Excesses???</span></p>
						</div>
					</div>
					
					
				</div>
				
				<div id="md-call-to-action">
					<a href="javascript:applyOnlineToggle('[#= productId #]')" class="button" id="go-to-insurer"><span>Go to Insurer</span></a>
					
					<p class="light-grey text-center small">To buy online please have your payment details ready. You will complete the transaction on the insurer's site.</p>
					<hr/>
					<p class="text-center"><strong>Or phone them direct on</strong></p>
					<p class="text-center green" id="md-phone-no">[#= telNo #]</p>
					<p class="text-center light">[#= openingHours #]</p>
					<p>&nbsp;</p>
					<p class="light-grey text-center small">
						Remember to have your payment details ready<br/>
						Or click below and the insurer will call you back. Please remember to use the quote reference [#= leadNo #]
					</p>
					<p class="text-center"><a href="javascript:applyByPhoneToggle('[#= productId #]')" class="button" id="md-call-me-back"><span>Call me back</span></a></p>
					<hr/>
					<p class="text-center"><strong>Please enter your details below and we will get someone to call you back.</strong></p>
					
					<core:clear />
					
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					???
					<form:form name="callback" action="" id="callbackform" method="post">
						<form:row label="Your name:">
							<field:input xpath="name" title="Your name" required="true" className="contact-name" />
						</form:row>
						<form:row label="Contact Number:">
							<field:contact_telno xpath="contactNo" required="true" className="contact-phone" />
						</form:row>
						<a href="#" class="button" id="md-submit"><span>Submit</span></a>
					</form:form>
				</div>
				
				<core:clear />
				
				<div id="md-promo">
					<form:scrape id="2" />
				</div>
			</div>
			
		</div>

	<%-- CLEAR + FOOTER --%>
		<core:clear />
		
		
		<div id="md-about">
			<hr/>
			<p><strong>About Budget Direct</strong></p>
			<p>???</p>
		</div>
		
	</div>
	
</core:js_template>

<core:js_template id="more-details-excess-template">
	<div class='excessRow'>
		<div class='excessDesc'>[#= description #]</div>
		<div class='excessVal'>[#= amount #]</div>
	</div>
</core:js_template>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$('#moreDetailsDialog').dialog({
		title: 'More Details',
		autoOpen: false,
		show: 'clip',
		hide: 'clip', 
		'modal':true, 
		'width':920,
		'minWidth':920, 'minHeight':600,  
		'draggable':false,
		'resizable':false,
		close: function(){
			$(".moreDetailsDialog").hide();	
   		},
   		dialogClass: 'moreDetails'
	});		
		
	$('.moreDetails').append('<div id="moreDetailsClose" onclick="closeMoreDetailsDialog()" class="moreDetailsDialog"></div><div id="moreDetailsFooter" class="moreDetailsDialog"></div>');
</go:script>

<go:script marker="js-head">

	function moreDetails(prod) {	
		
		//templates
		var moreDetailsTemplate 		= $("#more-details-template").html();
		var moreDetailsExcessTemplate	= $("#more-details-excess-template").html();
		
		// result
		var res = Results.getResult(prod);
		
		// main dialog template
		var dialogContent = $(parseTemplate(moreDetailsTemplate, res));
		
		// Add any conditions
		if (res.conditions){
			var condTag = $(dialogContent).find('#md-conditions');

			if (res.conditions.condition instanceof Array) {
				$.each(res.conditions.condition, function() {
					condTag.append("<p>"+this+"</p>");
				});
			} else {
				condTag.append("<p>"+res.conditions.condition+"</p>");
			}
		}
		
		
		// Add any additional excess
		if (res.excess) {
			if (res.excess.excess) {
				var excessTag = $(dialogContent).find("#md-additional-excess");
				$.each(res.excess.excess, function() {
					excessTag.append($(parseTemplate(moreDetailsExcessTemplate, this)));
				});
			}

			// Check the base excess
			/*
			if (this.excess.base) {
				baseExcess = Math.max(this.excess.base, baseExcess);
			}
			*/
		}
		
		
		$("#moreDetailsDialog").html(dialogContent);
		 
		console.log(res);
		
		$('#moreDetailsDialog').dialog('open');
		$(".moreDetailsDialog").show();	
	}	
		
	function closeMoreDetailsDialog() {
		$('#moreDetailsDialog').dialog('close');
	}
	
</go:script>

<go:script marker="onready">
moreDetails('BUDD-05-04');

$("#moreDetailsDialog .fieldrow_label").on('click', function(){
	$(this).next().children('input').focus();
});
</go:script>				