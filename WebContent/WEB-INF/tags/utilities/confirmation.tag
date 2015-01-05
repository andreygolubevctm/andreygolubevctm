<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- HTML --%>
<div id="utilities-confirmation" class="utilities-confirmation">
	<div class="wrapper">
		<div class="column left">
			<div class="inner left">
				<div class="panel nobdr lgetxt">
					<div id="thank_you">
						<p><strong>Thank you for choosing comparethemarket.com.au (powered by Thought World) to compare your energy options and save on your energy bills. Thought World's energy specialists will be in contact shortly to discuss your application. Please print this page with your reference number for your records.</strong></p>
						<p>
							If you have any questions about your energy application, please call our trusted partner ThoughtWorld on: 1300 850 730
						</p>
					</div>
				</div>
			</div>
			<div class="inner left">
				<div class="panel nobdr lgetxt">
					<form:scrape id="1" />
				</div>
			</div>
		</div>
		<div class="column right">
			<div id="orderNoContainer">
				<div id="orderNoTitle">Reference Number</div>
				<h2 id="orderNo"> </h2>

			</div>
			<agg:panel>
				<p><strong>Compare</strong>the<strong>market</strong>.com.au is an online comparison website.</p>
				<core:clear />
			</agg:panel>

			<agg:panel>
				<form:scrape id="2" />
			</agg:panel>
		</div>
	</div>
</div>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var UtilitiesConfirmationPage = {

	init: function() {

	},

	show: function(applicationObj) {
		

		var product = Results.getSelectedProduct();

		UtilitiesQuote.updateReceiptId( applicationObj.uniquePurchaseId, product );

		$("#utilities-confirmation #orderNo").html(applicationObj.uniquePurchaseId);

		Track.onConfirmation( product );

		QuoteEngine._allowNavigation = false;
		$("#navContainer .active").removeClass('active');

		$("#page").slideUp("fast", function(){
			$("#start-new-quote").slideDown("fast", function(){
				$("#utilities-confirmation").slideDown("fast");
			});
		});
		
	}
};
</go:script>
<go:script marker="onready">
	UtilitiesConfirmationPage.init();
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
#utilities-confirmation {
	min-width:				980px;
	max-width:				980px;
	width:					980px;
	display: 				none;
	overflow:				hidden;
}

#utilities-confirmation {margin:0 auto;padding-top:22px;}

#utilities-confirmation .clear
{clear:both;}

#utilities-confirmation .wrapper .column,
#utilities-confirmation .wrapper .column .inner {
	float:					left;
}

#utilities-confirmation .wrapper .column.left {
	width:					664px;
	/*height:					400px;*/
}

#utilities-confirmation .wrapper .column.right {
	width:					296px;
	/*height:					400px;*/
	margin-left:			20px;
}

#utilities-confirmation .wrapper .column.left .inner.top {
	width:					604px;
}

#utilities-confirmation .wrapper .column.left .inner.left {
	width:					604px;
}

#utilities-confirmation .wrapper .column.left .inner.bottom {
	width:					604px;
}

#utilities-confirmation .wrapper .panel {
	padding:					10px;
	margin:						0 0 10px 0;
	border:						1px solid #DAE0E4;
	-moz-border-radius: 		5px;
	-webkit-border-radius: 		5px;
	-khtml-border-radius: 		5px;
	border-radius: 				5px;
}

#utilities-confirmation .wrapper .panel.nobdr {
	border-color:				#FFFFFF;
}

#utilities-confirmation .wrapper .panel.nopad {
	padding:					0;
}

#utilities-confirmation .wrapper .panel.dark {
	background-color:			#F4F9FE;
}

#utilities-confirmation .wrapper p {
	font-size:					105%;
	line-height:				110%;
}

#utilities-confirmation .wrapper p {
	padding:					5px 0;
}

#utilities-confirmation .wrapper .panel.lgetxt p {
	font-size:					120%;
}

#utilities-confirmation .wrapper h4,
#utilities-confirmation .wrapper h5 {
	margin:						15px 0 5px 0;
}

#utilities-confirmation .wrapper h4.first,
#utilities-confirmation .wrapper h5.first,
#utilities-confirmation .wrapper h6.first {
	margin-top:					0;
}

#utilities-confirmation .wrapper h5 {
	font-size:					140%;
}

#utilities-confirmation .wrapper h6 {
	font-size:					120%;
	margin:						20px 0 5px 0;
}

#utilities-confirmation .wrapper .right-panel {
	margin-left:				0px !important;
}

#utilities-confirmation .wrapper .right-panel .right-panel-top,
#utilities-confirmation .wrapper .right-panel .right-panel-bottom {
	height:						5px !important;
}

#utilities-confirmation .wrapper .right-panel .right-panel-bottom {
	background-position:		bottom center !important;
}

#utilities-confirmation .wrapper .right-panel-middle .panel {
	margin-bottom: 				0px;
}

#utilities-confirmation .wrapper .head {
	height:						25px;
}

#utilities-confirmation .wrapper .head.space {
	border:						1px solid #FFFFFF;
}

#utilities-confirmation .wrapper .head div {
	float:						left;
	margin:						22px 0 0 5px;
	font-size:					130%;
	font-weight:				900;
}

#utilities-confirmation .wrapper .head div span {
	font-size:					130%;
}

#utilities-confirmation .wrapper .head .reference {
	float:						right;
	margin-top:					9px;
}

#utilities-confirmation .promotion {
	margin-top:					10px;
}

#utilities-confirmation .promotion .innertube {
	width:						272px;
	margin-left:				auto;
	margin-right:				auto;
}

#utilities-confirmation a {
	font-size:					14px;
	font-weight:				normal;
	color:						#4A4F51;
	padding:					2px 0 2px 10px;
	background:					transparent url(brand/ctm/images/bullet_edit.png) center left no-repeat;
}

#utilities-confirmation #orderNoContainer{
	margin-bottom: 10px;
	color: grey;
}
#utilities-confirmation #orderNoTitle{
	color: #0B0161;
	font-size: 23px;
	margin-bottom: 5px;
}
#utilities-confirmation h2{
	font-size: 20px;
	font-weight: normal;
	margin-bottom: 5px;
	font-family: Arial, sans-serif;
}

</go:style>