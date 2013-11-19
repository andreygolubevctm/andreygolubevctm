<%@ tag description="Conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="providerType" 	required="true" rtexprvalue="true"	 description="Type of Provider" %>

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
		<p>Unfortunately our <span>${providerType}</span> providers were unable to supply a quote based on the details you entered... sorry about that!</p>
		<p>However, the good news is that we compare more than just <span>${providerType}</span>. If you'd like to compare something else, just choose from the below to start comparing:</p>

		<div class="panels">
			<div class="panel-row">


				<div class="panel" id="health-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${data['settings/exit-url']}health-insurance/"><span>Health Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="car-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${data['settings/exit-url']}car-insurance"><span>Car Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="life-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${data['settings/exit-url']}life-insurance/"><span>Life Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="travel-insurance-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${data['settings/exit-url']}travel-insurance/"><span>Travel Insurance</span></a>
					</div>
				</div>

				<div class="panel" id="income-protection-box">
					<div class="box">
						<a class="button compare-button buybtnbig alt" href="${data['settings/exit-url']}income-protection/"><span>Income Protection</span></a>
					</div>
				</div>

				<div class="panel" id="roadside-box">
					<div class="box">
						<a class="button compare-button  buybtnbig alt" href="${data['settings/exit-url']}roadside-assistance/"><span>Roadside Assistance</span></a>
					</div>
				</div>

				<div class="panel" id="ctp-box">
					<div class="box">
						<a class="button compare-button  buybtnbig alt" href="${data['settings/exit-url']}ctp-insurance/"><span>CTP</span></a>
					</div>
				</div>

				<div class="panel" id="fuel-prices-box">
					<div class="box">
						<a class="button compare-button  buybtnbig alt" href="${data['settings/exit-url']}fuel/"><span>Fuel Prices</span></a>
					</div>
				</div>


			</div>
		</div>
		<div class="footer"></div>
	</div>
</div>
