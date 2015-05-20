<%@ tag description="Discounts Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">

	/* DIALOG */
		.discount{
			background-image: url(common/images/dialog/header_620.gif);
			background-position: 0 38px;
		}
			.discount .ui-dialog-titlebar{
				background-image: none;
				height: 26px;

				padding: 0 4em !important;
				margin-top: 38px;
			}
			.discount .ui-dialog-titlebar span{
				display: none;
			}
			.discount .ui-dialog-content{
				background-image: url(common/images/dialog/content_620.gif) !important;
				padding: .5em 1em;
			}

		.ui-dialog.no-close .ui-dialog-titlebar-close,
		.ui-dialog.no-title .ui-dialog-title  {
			display:none;
		}

		.discount-template {
			padding: 0px 2em;
		}

		#discountClose {
			background: url(common/images/dialog/close.png) no-repeat;
			width: 39px;
			height: 31px;
			position: absolute;
			top:5px;
			right: -7px;
			cursor: pointer;
			display: none;
		}
		#discountFooter {
			background: url("common/images/dialog/footer_620.gif") no-repeat scroll left top transparent;
			width: 920px;
			height: 20px;
			clear:both;
		}
		#discountDialog {
			overflow:hidden;
		}

	/* STRUCTURE */
		#columns{
			width: 100%;
		}
		.discount-left-column{
			float: left;
			width: 64%;
		}
		.discount-right-column{
			float: right;
			width: 34%;
		}

	/* GENERAL */
		#discount-header
			margin-left: -10px;
		}

		.discount-template h5{
			margin-top: 25px;
			margin-bottom: .3em;
			color: #0C4DA2;
		}
		.discount-template h6{
			font-size: 15px;
			font-weight: normal;
			padding: 15px 0 5px 0;
		}

		.discount-template a{
			font-size: 100%;
		}

		.discount-template ul{
			margin-bottom: 15px;
		}
		.discount-template ul li{
			list-style-image: url(brand/ctm/images/bullet_edit.png);
			list-style-position: inside;
			text-indent: -14px;
			margin: 0 0 0.4em 14px;
		}

		.discount-template .green{
			color: #0DB14B;
		}
		.discount-template .red{
			color: red;
		}


		.discount-template hr{
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

		#discount-header{
			margin-bottom: 20px;
		}
		#discount-logo{
			border: 2px solid #E3E8EC;
			background-color: white;
			background-position: center center;
			background-repeat: no-repeat;
			width: 75px;
			height: 75px;
			float: left;
		}
		#discount-logo img{
			position: absolute;
			top: 0;
			bottom: 0;
			left: 0;
			right: 0;
			margin: auto;
			max-width: 75px;
			max-height: 75px;

		}

		#discount-product{
			vertical-align: bottom;
			margin-left: 90px;
		}
		#discount-disclaimer {
			margin-top: 20px;
		}

</go:style>

<%-- HTML --%>
<div id="discountDialog" class="discountDialog"></div>

<core:js_template id="discount-template">

	<div class="discount-template">

		<div id="columns">

			<div id="discount-header">
					<div id="discount-logo" class="rounded-corners" style="background-image:url(common/images/logos/utilities/[#= retailerId #]_logo.jpg);"><!-- logo image --></div>
					<div id="discount-product">
						<h3>[#= retailerName #] - [#= planName #]</h3>
						<h5>Discount Details</h5>
					</div>
					<core:clear />
				</div>
				<core:clear />

				<div class="discount_details">
					<p id="DiscountDetails_[#= planId #]">[#= discountDetails #]</p>
				</div>
				
				<div id="discount-disclaimer">
					<p>This information is kindly provided by Thought World.</p>
				</div>

			</div>
	</div>

</core:js_template>


<core:js_template id="discount-price-info-rate-template">
	<tr>
		<td>[#= Description  #]</td>
		<td>[#= Amount #] [#= UOM #]</td>
		<td>[#= GSTAmount #]  [#= UOM #]</td>
		<td>[#= Period #]</td>
	</tr>
</core:js_template>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$('#discountDialog').dialog({
		title: 'Discounts',
		autoOpen: false,
		show: {
			effect: 'clip',
			complete: function() {
				$(this).center();
			}
		},
		hide: 'clip',
		'modal':true,
		'width':640,
		'minWidth':640, 'minHeight':200,
		'draggable':true,
		'resizable':false,
		open: function() {
			$('#discountDialog, .discount-template').css({'max-height': ($(window).height()-150)});
		},
		close: function(){
			$(".discountDialog").hide();
		},
		dialogClass: 'discount'
	});

	$('.discount').append('<div id="discountClose" onclick="DiscountDialog.close()" class="discountDialog"></div><div id="discountFooter" class="discountDialog"></div>');
</go:script>

<go:script marker="js-head">

	var DiscountDialog = new Object();
	DiscountDialog = {

		_product: false,

		init : function( product, no_apply_btn, passive ){

			DiscountDialog._product = product;

			DiscountDialog.update();

			if( typeof passive == 'undefined' ) {
				DiscountDialog.open();
			}

		},

		update : function(){

			// TEMPLATES
			var discountTemplate 				= $("#discount-template").html();

			// MAIN TEMPLATE PARSING

			// Prepare
			var noLogo = "";

			Results.updateProductInfo( DiscountDialog._product );

			// Parse
			var dialogContent = $(parseTemplate(discountTemplate, DiscountDialog._product));
			
			// hide estimated savings if Moving In
			if(utilitiesChoices._movingIn == 'Y'){
				$(dialogContent).find('#discount-savings').hide();

				if(DiscountDialog._product.available == 'N'){
					$(dialogContent).find('#discount-savings-not-available').show();
				} else {
					$(dialogContent).find('#discount-savings-not-available').hide();
				}
			} else {
				$(dialogContent).find('#discount-savings-not-available').hide();
			}

			

			// ADD HTML TO POPUP
			$("#discountDialog").html(dialogContent);

			Results.negativeValues(DiscountDialog._product.yearlySavings, $("#discount-savings-amount div"), 'extra' );
		},

		open: function(){
			btnInit.disable();
			$('#discountDialog').dialog('open');
			$(".discountDialog").show();
		},

		close: function(){
			$('#discountDialog').dialog('close');
			btnInit.enable();
		},

	}

</go:script>

<go:script marker="onready">
$('.ui-widget-overlay').live("click", function() {
	//Close the dialog
	DiscountDialog.close();
});
</go:script>