<%@ tag description="The Apply Online Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">

	/* DIALOG */
		.applyOnline{
			background-image: url(common/images/dialog/header_920.png);
			background-position: 0 38px;
		}
			.applyOnline .ui-dialog-titlebar{
				background-image: none;
				height: 26px;

				padding: 0 4em !important;
				margin-top: 38px;
			}
			.applyOnline .ui-dialog-titlebar span{
				display: none;
			}
			.applyOnline .ui-dialog-content{
				background-image: url(common/images/dialog/content_920.png) !important;
				padding: .5em 1em;
			}

		.ui-dialog.no-close .ui-dialog-titlebar-close,
		.ui-dialog.no-title .ui-dialog-title  {
			display:none;
		}

		.apply-online-template {
			overflow-x: none;
			overflow-y: auto;
			padding: 0px 2em;
		}

		#applyOnlineClose {
			background: url(common/images/dialog/close.png) no-repeat;
			width: 39px;
			height: 31px;
			position: absolute;
			top:5px;
			right: -7px;
			cursor: pointer;
			display: none;
		}
		#applyOnlineFooter {
			background: url("common/images/dialog/footer_920.png") no-repeat scroll left top transparent;
			width: 920px;
			height: 20px;
			clear:both;
		}
		#applyOnlineDialog {
			overflow:hidden;
		}

	/* STRUCTURE */
		#columns{
			width: 100%;
		}
		.aol-left-column{
			float: left;
			width: 64%;
		}
		.aol-right-column{
			float: right;
			width: 34%;
		}

	/* GENERAL */
		#aol-header,
		.apply-online-template h3,
		.apply-online-template h5{
			margin-left: -10px;
		}

		.apply-online-template h5{
			margin-top: 25px;
			margin-bottom: .3em;
			color: #0C4DA2;
		}
		.apply-online-template h6{
			font-size: 15px;
			font-weight: normal;
			padding: 15px 0 5px 0;
		}

		.apply-online-template a{
			font-size: 100%;
		}

		.apply-online-template ul{
			margin-bottom: 15px;
		}
		.apply-online-template ul li{
			list-style-image: url(brand/ctm/images/bullet_edit.png);
			list-style-position: inside;
			text-indent: -14px;
			margin: 0 0 0.4em 14px;
		}

		.apply-online-template .green{
			color: #0DB14B;
		}
		.apply-online-template .red{
			color: red;
		}


		.apply-online-template hr{
			border: none;
			border-bottom: 1px solid #E3E8EC;
			margin: 15px 10px;
		}

		.rounded-corners {
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px;
			-khtml-border-radius: 5px;
			border-radius: 5px;
		}

	/* SPECIFIC */

		#aol-header{
			margin-bottom: 20px;
		}
		#aol-logo{
			border: 2px solid #E3E8EC;
			background-color: white;
			background-position: center center;
			background-repeat: no-repeat;
			width: 75px;
			height: 75px;
			float: left;
		}
			#aol-logo img{
				position: absolute;
				top: 0;
				bottom: 0;
				left: 0;
				right: 0;
				margin: auto;
				max-width: 75px;
				max-height: 75px;

			}

		#aol-main-info{
			float: left;
			vertical-align: bottom;
			margin-left: 10px;
		}
			#aol-main-info table{
				text-align: left;
				margin-top: 10px;
			}
				#aol-main-info table th{
					padding: 5px 15px;
				}
				#aol-main-info table td{
					color: #0DB14B;
				}

		.aol-features p{
			margin-bottom: 5px;
		}

		.aol-price-info p,
		#aol-about-price p{
			margin: 15px 0 5px 0;
		}
			.aol-price-info table{
				margin-bottom: 10px;
			}
				.aol-price-info table tr th,
				.aol-price-info table tr td{
					padding-bottom: 10px;
				}
				.aol-price-info table th{
					text-align: left;
					vertical-align: middle;
				}
					.aol-price-info table th.tariff{
						width: 43%;
					}
					.aol-price-info table th.no-gst{
						width: 19%;
					}
					.aol-price-info table th.gst{
						width: 19%;
					}
					.aol-price-info table th.period{
						width: 19%;
					}

		#aol-savings{
			background-color: white;
			border: 2px solid #E3E8EC;
			padding: 15px;
			margin-bottom: 15px;
		}
			#aol-savings-amount{
				border: 1px solid #E3E8EC;
				width: 125px;
				height: 40px;
				padding: 1px;
				float: left;
				margin-right: 10px;
				display: table;
			}
				#aol-savings-amount span.extraCost{
					font-size: 13px;
				}
				#aol-savings-amount div{
					background-color: #E3E8EC;
					height: 100%;
					text-align: center;
					font-size: 19px;
					font-weight: bold;
					display: table-cell;
					vertical-align: middle;
					padding-bottom: 3px;
				}
				#aol-savings-amount div span{
					display: inline-block;
				}
			#aol-savings-text{
				height: 40px;
				display: table;
			}
				#aol-savings-text p{
					font-weight: bold;
					font-size: 15px;
					display: table-cell;
					vertical-align: middle;
				}
			#aol-savings-not-available-text{
				margin-top: 10px;
			}

		#aol-savings-not-available{
			background-color: white;
			border: 2px solid #E3E8EC;
			padding: 15px;
			margin-bottom: 15px;
		}

			#aol-savings-not-available,
			#aol-savings-not-available-text {
			font-size: 110%;
			font-weight: bold;
			color: #0DB14B;
		}

		#aol-call-to-action{
			border: 2px solid #E3E8EC;
			background-color: white;
			margin-bottom: 15px;
		}
			#aol-call-to-action-top-left{
				background-image: url(brand/ctm/images/left_panel_top.png);
				height: 5px;
				width: 30px;
				margin-top: -2px;
				margin-left: -2px;
				float: left;
			}
			#aol-call-to-action-top-right{
				background-image: url(brand/ctm/images/left_panel_top.png);
				background-position: top right;
				height: 5px;
				width: 30px;
				float: right;
				margin-top: -2px;
				margin-right: -2px;
			}
			#aol-call-to-action-top-center{
				height: 4px;
				width: 100%;
				background-color: #0DB14B;
				margin-top: -1px;
			}

		.apply-online-template .narrower{
			width: 70%;
			margin: 20px auto 0px auto;
		}

		#applyOnlineDialog #aolApplyButton a.button {
			width: 100%;
		}

		.aol-documentation h5{
			margin: 15px 0 5px 0;
		}

		#aol-partners{
			margin: 15px;
			padding: 15px;
			border: 2px solid #E3E8EC;
			background-color: white;
		}
			#aol-logo-switchwise{
				float: right;
				margin-top: 10px;
			}

</go:style>

<%-- HTML --%>
<div id="applyOnlineDialog" class="applyOnlineDialog"></div>

<core:js_template id="apply-online-template">

	<div class="apply-online-template">

		<div id="columns">

			<div class="aol-left-column">

				<div id="aol-header">
					<div id="aol-logo" class="rounded-corners" style="background-image:url(common/images/logos/utilities/[#= retailerId #]_logo.jpg);"><!-- logo image --></div>
					<div id="aol-main-info">
						<table>
							<tr>
								<th>Estimated costs</th>
								<td>[#= formatted.price #]</td>
							</tr>
							<tr>
								<th>Contract term</th>
								<td>[#= contractPeriod #]</td>
							</tr>
						</table>
					</div>
					<core:clear />
				</div>
				<core:clear />

				<div id="aol-plan">
					<h3>[#= retailerName #] - [#= planName #]</h3>
				</div>

				<div id="aol-features" class="aol-features">
					<h5>Plan Features</h5>
					[#= contractDetails #]
					[#= billingOptions #]
				</div>

				<div id="aol-payment-options">
					<h5>Payment Options</h5>
					[#= paymentDetails #]
				</div>

				<div id="aol-price-info" class="aol-price-info">
					<h5>Pricing Information</h5>
					[#= pricingInformation #]
				</div>

				<div id="aol-disclaimer">
					<h5>Disclaimer</h5>
					<p>This information is kindly provided by Thought World.</p>
				</div>

			</div>

			<div class="aol-right-column">

				<div id="aol-savings" class="rounded-corners">

					<div id="aol-savings-amount" class="rounded-corners">
						<div class="rounded-corners green">[#= formatted.yearlySavings #]</div>
					</div>

					<div id="aol-savings-text"><p>Estimated Savings in 1st year</p></div>
				</div>

				<div class='thoughtworld-contact-panel'><div class='option call-us-now'></div></div>

				<div id="aol-call-to-action" class="rounded-corners">
					<div id="aol-call-to-action-top-left"></div>
					<div id="aol-call-to-action-top-right"></div>
					<div id="aol-call-to-action-top-center"></div>

					<div class="narrower">
						<div id="aolApplyButton">
							<a href="javascript:void(0);" data-applyonlinedialog="true" data-id="[#= planId #]" class="button" id="aol-apply-button"><span>Apply Now</span></a>
						</div>

						<div id="aol-documentation" class="aol-documentation">
							<h5>Documentation to Download</h5>
							<ul>
								<li><a href="[#= termsUrl #]" target="_blank">Terms &amp; Conditions</a></li>
								<li><a href="[#= privacyPolicyUrl #]" target="_blank">Privacy Policy</a></li>
							</ul>
						</div>
					</div>

					<div id="aol-partners" class="rounded-corners">
						<%-- for some reason JS is not getting run when the modal opens --%>
						<p><content:optin content="<strong>compare</strong>the<strong>market</strong>.com.au" useSpan="true"/> is an online comparison website. Energy product information is provided by our trusted affiliate, Thought World.</p>
						<core:clear />
					</div>

				</div>

			</div>
			<core:clear />
		</div>

		<core:clear />
	</div>

</core:js_template>

<core:js_template id="apply-online-features-template">
	<h6>[#= Name #]</h6>
	<div>[#= Lines #]</div>
</core:js_template>

<core:js_template id="apply-online-price-info-template">
	<p>Network Area: [#= NetworkArea #]<span class="effectiveFromDate"> - last updated on [#= EffectiveFromDate #]</span></p>
	<table class="price-info-table" id="price-info-table-[#= index #]">
		<tr>
			<th class="tariff">[#= TariffDescription #]</th>
			<th class="no-gst">Rates in cents no GST</th>
			<th class="gst">Rates in cents with GST</th>
			<th class="period">Period rates apply</th>
		</tr>
	</table>
</core:js_template>

<core:js_template id="apply-online-price-info-rate-template">
	<tr>
		<td>[#= Description  #]</td>
		<td>[#= Amount #] [#= UOM #]</td>
		<td>[#= GSTAmount #]  [#= UOM #]</td>
		<td>[#= Period #]</td>
	</tr>
</core:js_template>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$('#applyOnlineDialog').dialog({
		title: 'Apply Online',
		autoOpen: false,
		show: {
			effect: 'clip',
			complete: function() {
				$(this).center();
			}
		},
		hide: 'clip',
		'modal':true,
		'width':920,
		'minWidth':920, 'minHeight':200,
		'draggable':true,
		'resizable':false,
		open: function() {
			$('#applyOnlineDialog, .apply-online-template').css({'max-height': ($(window).height()-150)});
		},
		close: function(){
			$(".applyOnlineDialog").hide();
		},
		dialogClass: 'applyOnline'
	});

	$('.applyOnline').append('<div id="applyOnlineClose" onclick="ApplyOnlineDialog.close()" class="applyOnlineDialog"></div><div id="applyOnlineFooter" class="applyOnlineDialog"></div>');
</go:script>

<go:script marker="js-head">

	var ApplyOnlineDialog = new Object();
	ApplyOnlineDialog = {

		_hideApplyBtn: false,
		_product: false,

		init : function( product, no_apply_btn, passive ){

			ApplyOnlineDialog._product = product;

			no_apply_btn = no_apply_btn || false;
			ApplyOnlineDialog._hideApplyBtn = ApplyOnlineDialog._product.available == 'N' || no_apply_btn === true;

			ApplyOnlineDialog.update();

			if( typeof passive == 'undefined' ) {
				ApplyOnlineDialog.open();
			}

		},

		update : function(){

			// TEMPLATES
			var applyOnlineTemplate 				= $("#apply-online-template").html();

			// MAIN TEMPLATE PARSING

			// Prepare
			var noLogo = "";

			Results.updateProductInfo( ApplyOnlineDialog._product );

			// Parse
			var dialogContent = $(parseTemplate(applyOnlineTemplate, ApplyOnlineDialog._product));

				// hide estimated savings if Moving In
				if(utilitiesChoices._movingIn == 'Y'){
					$(dialogContent).find('#aol-savings').hide();

					if(ApplyOnlineDialog._product.available == 'N'){
						$(dialogContent).find('#aol-savings-not-available').show();
					} else {
						$(dialogContent).find('#aol-savings-not-available').hide();
					}
				} else {
					$(dialogContent).find('#aol-savings-not-available').hide();
				}



			// ADD HTML TO POPUP
			$("#applyOnlineDialog").html(dialogContent);

			Results.negativeValues(ApplyOnlineDialog._product.yearlySavings, $("#aol-savings-amount div"), 'extra' );
		},

		open: function(){
			btnInit.disable();
			$('#applyOnlineDialog').dialog('open');
			$(".applyOnlineDialog").show();
		},

		close: function(){
			$('#applyOnlineDialog').dialog('close');
			btnInit.enable();
		},

		confirmProduct: function(){
			Results.continueOnline(ApplyOnlineDialog._product.planId);
			/*QuoteEngine.gotoSlide({
				index: QuoteEngine.getCurrentSlide()+1
			});*/
		}
	}

</go:script>

<go:script marker="onready">
$('.ui-widget-overlay').live("click", function() {
	//Close the dialog
	ApplyOnlineDialog.close();
});

$('#applyOnlineDialog').on('click','#aol-apply-button',function(){
	ApplyOnlineDialog.confirmProduct($(this).data('id'));
});

</go:script>