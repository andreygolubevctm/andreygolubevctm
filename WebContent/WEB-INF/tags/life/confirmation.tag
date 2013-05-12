<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="life-confirmation" class="life-confirmation">
	<div class="wrapper">
		<div class="column left">
			<div class="inner top">
				<div class="panel head space"><!-- empty --></div>
			</div>
			<div class="inner left">
				<div class="panel nobdr lgetxt">
					<p><strong>Thank you</strong> for submitting your insurance application. A consultant will be in contact with you shortly to discuss your insurance requirements and process your application.</p>
					<p>An email has been sent to the email address provided with a summary of your details and your reference number.</p>
				</div>
			</div>
			<div class="inner left">
				<div class="panel nobdr lgetxt">
					<form:scrape id="1" />
				</div>
			</div>
		</div>
		<div class="column right">
			<div class="panel head nobdr">
				<div class="reference"><!-- empty --></div>
			</div>
			<div class="right-panel">
				<div class="right-panel-top"><!-- empty --></div>
				<div class="right-panel-middle">
					<div class="panel nopad nobdr">
						<p><strong>Compare</strong>the<strong>market</strong>.com.au is an online comparison website aimed at delivering our clients competitively priced yet comprehensive policies.  Information and quotes are provided by our trusted partner, Lifebroker Pty Ltd.</p>
					</div>
				</div>
				<div class="right-panel-bottom"><!-- empty --></div>
			</div>
			<div class="right-panel promotion">
				<div class="right-panel-top"><!-- empty --></div>
				<div class="right-panel-middle">
					<div class="innertube">
						<form:scrape id="2" />
					</div>
				</div>
				<div class="right-panel-bottom"><!-- empty --></div>
			</div>
			<div class="right-panel rightad">
				<img src="brand/ctm/images/ad_bridgingPage.png" alt="7 ways we are different. No sneaky charges, secure date, no data selling, contact with consent, no junk, no cold calling, we love simple">
			</div>
		</div>
	</div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#life-confirmation {
	min-width:				980px;
	max-width:				980px;
	width:					980px;
	display: 				none;
	overflow:				hidden;
}

#life-confirmation {margin:0 auto;padding-top:52px;}

#life-confirmation .clear
{clear:both;}

#life-confirmation .wrapper .column,
#life-confirmation .wrapper .column .inner {
	float:					left;
}

#life-confirmation .wrapper .column.left {
	width:					630px;
	/*height:					400px;*/
}

#life-confirmation .wrapper .column.right {
	width:					330px;
	/*height:					400px;*/
	margin-left:			20px;
}

#life-confirmation .wrapper .column.left .inner.top {
	width:					604px;
}

#life-confirmation .wrapper .column.left .inner.left {
	width:					604px;
}

#life-confirmation .wrapper .column.left .inner.bottom {
	width:					604px;
}

#life-confirmation .wrapper .panel {
	padding:					10px;
	margin:						0 0 10px 0;
	border:						1px solid #DAE0E4;
	-moz-border-radius: 		5px;
	-webkit-border-radius: 		5px;
	-khtml-border-radius: 		5px;
	border-radius: 				5px;
}

#life-confirmation .wrapper .panel.nobdr {
	border-color:				#FFFFFF;
}

#life-confirmation .wrapper .panel.nopad {
	padding:					0;
}

#life-confirmation .wrapper .panel.dark {
	background-color:			#F4F9FE;
}

#life-confirmation .wrapper p {
	font-size:					105%;
	line-height:				110%;
}

#life-confirmation .wrapper p {
	padding:					5px 0;
}

#life-confirmation .wrapper .panel.lgetxt p {
	font-size:					120%;
}

#life-confirmation .wrapper h4,
#life-confirmation .wrapper h5 {
	margin:						15px 0 5px 0;
}

#life-confirmation .wrapper h4.first,
#life-confirmation .wrapper h5.first,
#life-confirmation .wrapper h6.first {
	margin-top:					0;
}

#life-confirmation .wrapper h5 {
	font-size:					140%;
}

#life-confirmation .wrapper h6 {
	font-size:					120%;
	margin:						20px 0 5px 0;
}

#life-confirmation .wrapper .right-panel {
	margin-left:				0px !important;
}

#life-confirmation .wrapper .right-panel .right-panel-top,
#life-confirmation .wrapper .right-panel .right-panel-bottom {
	height:						5px !important;
}

#life-confirmation .wrapper .right-panel .right-panel-bottom {
	background-position:		bottom center !important;
}

#life-confirmation .wrapper .right-panel-middle .panel {
	margin-bottom: 				0px;
}

#life-confirmation .wrapper .head {
	height:						25px;
}

#life-confirmation .wrapper .head.space {
	border:						1px solid #FFFFFF;
}

#life-confirmation .wrapper .head div {
	float:						left;
	margin:						22px 0 0 5px;
	font-size:					130%;
	font-weight:				900;
}

#life-confirmation .wrapper .head div span {
	font-size:					130%;
}

#life-confirmation .wrapper .head .reference {
	float:						right;
	margin-top:					9px;
}

#life-confirmation .promotion {
	margin-top:					10px;
}
#life-confirmation .rightad {
	width:						296px !important;
	height:						280px;
}
#life-confirmation .promotion .innertube {
	width:						272px;
	margin-left:				auto;
	margin-right:				auto;
}

#life-confirmation a {
	font-size:					14px;
	font-weight:				normal;
	color:						#4A4F51;
	padding:					2px 0 2px 10px;
	background:					transparent url(brand/ctm/images/bullet_edit.png) center left no-repeat;
}
#life-confirmation .wrapper div.right .right-panel {
	float: right;
}


</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var LifeConfirmationPage = {

	init: function() {
	},

	show: function() {
		LifeQuote.checkQuoteOwnership( function() {
			Track.onCallMeBackClick(Results.getSelectedProduct());

			var link_labels = ['revise_link','save_link'];
			var links = {};

			$('#summary-header').find("a").each(function(index){
				links[link_labels[index]] = $(this).hide().detach();
			});

			$('#summary-header').find("h2").first().empty().append("Thank You...");

			for(var i in link_labels)
			{
				if( links.hasOwnProperty(link_labels[i]) )
				{
					$('#summary-header').find("h2").first().append(links[link_labels[i]]);
				}
			}

			QuoteEngine.gotoSlide({
				index:	4,
				speed:	1
			});

			$('#start-new-quote').show();
			$("#resultsPage").slideUp("fast", function(){
				$("#life-confirmation").slideDown("fast", function(){
					LifeQuote.touchQuote("C");
				});
			});
		});
	},

	callMeBack : function()
	{
		Track.onCallMeBackClick(Results.getSelectedProduct());
	}
};
</go:script>
<go:script marker="onready">
LifeConfirmationPage.init();
</go:script>