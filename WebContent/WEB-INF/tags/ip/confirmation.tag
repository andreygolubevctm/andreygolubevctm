<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="ip-confirmation" class="ip-confirmation">
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
		</div>
	</div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#ip-confirmation {
	min-width:				980px;
	max-width:				980px;
	width:					980px;
	display: 				none;
	overflow:				hidden;
}

#ip-confirmation {margin:0 auto;padding-top:52px;}

#ip-confirmation .clear
{clear:both;}

#ip-confirmation .wrapper .column,
#ip-confirmation .wrapper .column .inner {
	float:					left;
}

#ip-confirmation .wrapper .column.left {
	width:					664px;
	/*height:					400px;*/
}

#ip-confirmation .wrapper .column.right {
	width:					296px;
	/*height:					400px;*/
	margin-left:			20px;
}

#ip-confirmation .wrapper .column.left .inner.top {
	width:					604px;
}

#ip-confirmation .wrapper .column.left .inner.left {
	width:					604px;
}

#ip-confirmation .wrapper .column.left .inner.bottom {
	width:					604px;
}

#ip-confirmation .wrapper .panel {
	padding:					10px;
	margin:						0 0 10px 0;
	border:						1px solid #DAE0E4;
	-moz-border-radius: 		5px;
	-webkit-border-radius: 		5px;
	-khtml-border-radius: 		5px;
	border-radius: 				5px;
}

#ip-confirmation .wrapper .panel.nobdr {
	border-color:				#FFFFFF;
}

#ip-confirmation .wrapper .panel.nopad {
	padding:					0;
}

#ip-confirmation .wrapper .panel.dark {
	background-color:			#F4F9FE;
}

#ip-confirmation .wrapper p {
	font-size:					105%;
	line-height:				110%;
}

#ip-confirmation .wrapper p {
	padding:					5px 0;
}

#ip-confirmation .wrapper .panel.lgetxt p {
	font-size:					120%;
}

#ip-confirmation .wrapper h4,
#ip-confirmation .wrapper h5 {
	margin:						15px 0 5px 0;
}

#ip-confirmation .wrapper h4.first,
#ip-confirmation .wrapper h5.first,
#ip-confirmation .wrapper h6.first {
	margin-top:					0;
}

#ip-confirmation .wrapper h5 {
	font-size:					140%;
}

#ip-confirmation .wrapper h6 {
	font-size:					120%;
	margin:						20px 0 5px 0;
}

#ip-confirmation .wrapper .right-panel {
	margin-left:				0px !important;
}

#ip-confirmation .wrapper .right-panel .right-panel-top,
#ip-confirmation .wrapper .right-panel .right-panel-bottom {
	height:						5px !important;
}

#ip-confirmation .wrapper .right-panel .right-panel-bottom {
	background-position:		bottom center !important;
}

#ip-confirmation .wrapper .right-panel-middle .panel {
    margin-bottom: 				0px;
}

#ip-confirmation .wrapper .head {
	height:						25px;
}

#ip-confirmation .wrapper .head.space {
	border:						1px solid #FFFFFF;
}

#ip-confirmation .wrapper .head div {
	float:						left;
	margin:						22px 0 0 5px;
	font-size:					130%;
	font-weight:				900;
}

#ip-confirmation .wrapper .head div span {
	font-size:					130%;
}

#ip-confirmation .wrapper .head .reference {
	float:						right;
	margin-top:					9px;
}

#ip-confirmation .promotion {
	margin-top:					10px;
}

#ip-confirmation .promotion .innertube {
	width:						272px;
	margin-left:				auto;
	margin-right:				auto;
}

#ip-confirmation a {
	font-size:					14px;
	font-weight:				normal;
	color:						#4A4F51;
	padding:					2px 0 2px 10px;
	background:					transparent url(brand/ctm/images/bullet_edit.png) center left no-repeat;
}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var IPConfirmationPage = {

	init: function() {
	},

	show: function() {	
	
		IPQuote.checkQuoteOwnership(function(){
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
					index:	3
				});

					$('#start-new-quote').show();
					$("#resultsPage").slideUp("fast", function(){
				$("#ip-confirmation").slideDown("fast", function(){
					IPQuote.touchQuote("C");
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
IPConfirmationPage.init();
</go:script>