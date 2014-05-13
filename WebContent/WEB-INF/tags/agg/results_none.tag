<%@ tag description="Conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="providerType" 	required="true" rtexprvalue="true"	 description="Type of Provider" %>

<%-- TODO: Change to get the root url from settings --%>
<c:set var="rootUrl" value="${pageSettings.getRootUrl()}" />

<%-- CSS --%>
<go:style marker="css-head">
	#no-result-popup {
		width:540px;
		height:auto;
		z-index:2001;
		display: none;
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

	#no-result-popup .panel {
		zoom:1;
		*display:inline;
	}
	#no-result-popup .panel-row {
		display:block;
		text-align: center;
		margin-top: 25px;
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
			$('#revise').click();
		});
	},
	show : function(){
		this._overlay = $("<div>").attr("id","no-result-overlay")
								.addClass("ui-widget-overlay")
								.css({	"height":$(document).height() + "px",
										"width":$(document).width()+"px"
									});
		$("body").append(this._overlay);
		$(this._overlay).fadeIn("fast");

		// Show the popup
		$("#no-result-popup").center().fadeIn("fast");
		//omnitureReporting(5);

	},
	hide : function(){
		$(this._overlay).hide();
		$("#no-result-popup").hide();
	}
}

</go:script>

<go:script marker="onready">
	NoResult.init();
</go:script>

<%-- HTML --%>
<div id="no-result-popup">
	<a href="javascript:void(0);" class="close-button"></a>

	<div class="content">
		<div class="brand">${providerType}</div>

		<c:choose>
			<c:when test="${providerType == 'Home and Content insurance'}">
				<p>Unfortunately our providers were unable to provide a quote based on the information you have entered. This could be due to a variety of factors depending upon individual circumstances, such as property location, the age of the property, body corporate membership or running a business from the home.</p>
				<p>If you are unable to get a quote from one of our providers, you may want to refer to the Insurance Council of Australia's "Find an Insurer" website at http://www.findaninsurer.com.au/ and they may be able to provide you with a list of companies who can assist you with cover.</p>
				<p>In the meantime, why not compare your other insurances and utilities to see if you can find a better deal.</p>
			</c:when>
			<c:otherwise>
				<p>Unfortunately our <span>${providerType}</span> providers were unable to supply a quote based on the details you entered... sorry about that!</p>
				<p>However, the good news is that we compare more than just <span>${providerType}</span>. If you'd like to compare something else, just choose from the below to start comparing:</p>
			</c:otherwise>
		</c:choose>

		<div class="panels">
			<div class="panel-row">


				<div class="panel" id="health-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}health-insurance/"><span>Health Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="car-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}car-insurance"><span>Car Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="life-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}life-insurance/"><span>Life Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="travel-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}travel-insurance/"><span>Travel Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="income-protection-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}income-protection/"><span>Income Protection</span></a>
					</div>
				</div>

				<div class="panel" id="roadside-box">
					<div class="box">
						<a class="button compare-button  buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}roadside-assistance/"><span>Roadside Assistance</span></a>
					</div>
				</div>

				<div class="panel" id="energy-box">
					<div class="box">
						<a class="button compare-button  buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}energy/"><span>Energy</span></a>
					</div>
				</div>

				<div class="panel" id="fuel-prices-box">
					<div class="box">
						<a class="button compare-button  buybtnbig alt" href="${pageSettings.getSetting('exitUrl')}fuel/"><span>Fuel Prices</span></a>
					</div>
				</div>


			</div>
		</div>
		<div class="footer"></div>
	</div>
</div>
