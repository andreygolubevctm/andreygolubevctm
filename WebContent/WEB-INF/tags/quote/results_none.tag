<%@ tag description="Conditions popup for results page"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- TODO: Change to get the root url from settings --%>
<c:set var="rootUrl" value="${data['settings/root-url']}" />

<%-- CSS --%>
<go:style marker="css-head">
	#no-result-popup {
		width:540px;
		height:auto;
		z-index:2001;
		display: none;
	}
	#no-result-popup h5 {
	    background: url("common/images/dialog/header_540.gif") no-repeat scroll 0 0 transparent;
	    display: block;
	    font-size: 18px;
	    font-weight: 300;
	    height: 70px;
	    padding-top: 10px;
	    width: 540px;
	    margin-bottom: -12px;
	    color: #4a4f51;
	}
	#no-result-popup .close-button {
	    left: 513px;
	}
	#no-result-popup .content {
		background: white url("common/images/dialog/content_540.gif") repeat-y;
		padding:10px;
		overflow:none;
		height:auto; 
	}
	#no-result-popup .footer {
		background: transparent url("common/images/dialog/footer_540.gif") no-repeat;
		width:540px;
		height:14px;
		display:block;
		position:relative;
		left:-10px;
		top:24px;	
	}	
	#no-result-popup .content p {
	    font-size: 13px;
	    font-weight: bold;
	    margin: 16px 32px;
	    line-height: 15px;
	}	
	#no-result-overlay {
		position:absolute;
		top:0px;
		left:0px;
		z-index:1000;		 
	}
	
	#no-result-popup .panel {
		display:inline-block;	
	}
	
	#no-result-popup .box {
		width: 150px;
		height: 90px;
		background-color: transparent;
		background-image: url("common/images/compare-box.png");
		background-repeat: no-repeat;
		padding-top: 18px;
	}
	
	
	#no-result-popup a.view-more-button, 
		#no-result-popup .compare-button {
		position: relative;
		display: block;
		text-indent: -9001px;
	}
	#no-result-popup  a.view-more-button {
	  	height: 16px;
	    left: 5px;
	    top: 7px;
	    width: 75px;
	    *top:-28px;
		*left:-32px;
	}
	#no-result-popup a.view-more-button:hover {
		background-color: transparent;
		background-image: url("common/images/compare-box.png");
		background-repeat: no-repeat;
		background-attachment: scroll;
		background-position: -5px -111px;
		*top:-28px;
		*left:-32px;
	}	
	
	#no-result-popup a.compare-button {
    	height: 17px;
    	width: 104px;
    	top: 69px;
    	left: 41px;
		*top:33px;
		*left:18px;
	}
 	#no-result-popup a.compare-button:hover {
		background-color: transparent;
		background-image: url("common/images/compare-box.png");
		background-repeat: no-repeat;
		background-attachment: scroll;
		background-position: -40px -187px;
		*top:33px;
		*left:18px;
		
	}
	#no-result-popup .panel {
		display:		inline-block;
		vertical-align: top;
		width:			150px;
		height:			108px;
		margin:			0 2px;
		background-position: 7px 5px;
		background-repeat: no-repeat;
		zoom:1;
		*display:inline;
	}
	
	#no-result-popup .panel h3 {
		text-align: left;
		font-size: 15px;
		font-weight: bold;
		margin: -36px 0px 0px 12px;		
		*margin:0px 0px;
		*position:relative;
		*top:-32px;
		*left:12px;
	}
	#no-result-popup .panel p {
		text-align: left;
		font-size: 11px;
		margin-top: 58px;
		margin-right: 15px;
		margin-bottom: 15px;
		margin-left: 15px;
	}
	#no-result-popup .panel .box p {
	    font-size: 10px;
	    font-weight: bold;
    	color: #8e8e8e;
    	margin-top: 22px;
    	*margin-top:0px;
    	*position:relative;
    	*top:-15px;
	}
	#no-result-popup .panel-row {
		display:block;
		height: 115px;
    	text-align: center;
    	margin-top: 25px;
	}
	#no-result-popup .panels {
		margin-top:45px;
	}	
	#no-result-popup #car-insurance-box {
		background-image: url('../images/car-insurance-box.jpg');
	}
	
	#no-result-popup #mobile-phones-box {
		background-image: url('common/images/mobile-phones-box.jpg');
	}
	
	#no-result-popup #broadband-box {
		background-image: url('common/images/broadband-box.jpg');
	}
	
	#no-result-popup #credit-cards-box {
		background-image: url('common/images/credit-cards-box.jpg');
	}
	
	#no-result-popup #home-loans-box {
		background-image: url('common/images/home-loans-box.jpg');
	}
	
	#no-result-popup #pay-tv-box {
		background-image: url('common/images/pay-tv-box.jpg');
	}
	
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var NoResult = new Object();
NoResult = {
	_overlay : false,
	
	init : function(){
		$("#no-result-popup").hide();
		
		$("#no-result-popup .close-button").click(function(){
			NoResult.hide();
			History.showStart();
		});		
	},
	show : function(){
		this._overlay = $("<div>").attr("id","no-result-overlay")
								.css({	"height":$(document).height() + "px", 
										"width":$(document).width()+"px"
									});
		$("body").append(this._overlay);
		$(this._overlay).fadeIn("fast");

		// Show the popup			
		$("#no-result-popup").center().fadeIn("fast");
		//omnitureReporting(10);
	},
	hide : function(){
		$(this._overlay).hide();
		$("#no-result-popup").hide();
	}
}


NoResult._overlay.click(function() { FatalErrorDialog.display(''); });
$('#no-result-overlay').on('click', function() { FatalErrorDialog.display('');});
</go:script>

<go:script marker="onready">
	NoResult.init();
</go:script>

<%-- HTML --%>
<div id="no-result-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Sorry...</h5>
	
	<div class="content">
		
		<p>Compare the Market's car insurance providers were unable to supply you with a quote based on the details you have provided.</p>
		<p>However, we do offer the ability to compare a range of other products and services - please select from the following:</p>
		
		<div class="panels">
			<div class="panel-row">
				<div class="panel" id="mobile-phones-box">
					<div class="box">
						<h3>Mobile Phones</h3>
						<a href="${rootUrl}/mobile-phones/" class="view-more-button">View More</a>
						<a href="${rootUrl}/MobilePhones" class="compare-button">Compare Now</a>
						<p>Loads of mobile phones, plans and providers</p>
					</div>
				</div>
				
				<div class="panel" id="broadband-box">
					<div class="box">
			
						<h3>Broadband</h3>
						<a href="${rootUrl}/broadband-plans/" class="view-more-button">View More</a>
						<a href="${rootUrl}/Broadband" class="compare-button">Compare Now</a>
						<p>Compare heaps of providers &amp; plans</p>
					</div>
				</div>
		
				<div class="panel" id="credit-cards-box">
					<div class="box">
						<h3>Credit Cards</h3>
						<a href="${rootUrl}/credit-cards/" class="view-more-button">View More</a>
						<a href="${rootUrl}/CreditCards" class="compare-button">Compare Now</a>
						<p>Compare credit cards from multiple providers</p>
					</div>
				</div>
			</div>
			<div class="panel-row">				
				<div class="panel" id="home-loans-box">
					<div class="box">
						<h3>Home Loans</h3>
						<a href="${rootUrl}/home-loans/" class="view-more-button">View More</a>
						<a href="${rootUrl}/HomeLoans" class="compare-button">Compare Now</a>
						<p>Compare home loans from leading providers</p>	
					</div>
				</div>
				
				<div class="panel" id="pay-tv-box">
					<div class="box">
						<h3>Pay TV</h3>
						<a href="${rootUrl}/pay-tv/" class="view-more-button">View More</a>
						<a href="${rootUrl}/PayTV" class="compare-button">Compare Now</a>
						<p>Compare a range of Pay TV options &amp; plans</p>
					</div>
				</div>
			</div> 
		</div>	
		<div class="footer"></div>	
	</div>
</div>
