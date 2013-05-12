<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- CSS --%>
<go:style marker="css-head">

	/* SORT TABLE */
	#sortTable {
		overflow:auto;
		height:400px;
	}
	#sortTable td{
		padding:1px;
		width:50px;
		border-color:gray;
	}
	#sortTable table{
		margin-bottom:5px;
	}

	/* Brand specific styling */

	#resultsPage {
		background-color: white;
		display: none;
		margin: 0 auto;
		position: relative;
		width: 980px;
		height:800px;
	}
	#results-information {
		padding: 0 40px;
		height: 60px;
		line-height: 60px;
		position:relative;
		top:-7px;
	}

	#results-information h2 {
		display: inline;
		font-weight: bold;
		font-size: 20px;
	}
	#resultsCarDes{
		color:#4A4F51;
		font-weight:bold;
		font-size:15px;
	}
	#summary-header {
		position:relative;
		width:960px;
		height:44px;
		margin:0 auto;
	}
		#summary-header #revise {
			position:absolute;
			right:150px;
			top:15px;
		}
		#summary-header h2 {
			color: #4A4F51;
			font-family: "SunLT Light",Arial,Helvetica,sans-serif;
			font-size: 22px;
			font-weight: normal;
			line-height:44px;
		}
	.smlbtn {
		width: 120px;
	}
	#save-quote {
		position:relative;
		top: 60px;
		z-index: 100;
	}
	#revise {
		color: #0C4DA2;
		font-size: 16px;
		text-decoration: none;
		position:absolute;
		right:0px;
		top:0px;
		top:-75px;
	}
	#revise:hover {
	}

	div.compare-header {
		position: absolute;
		top: 50px;
		left: 40px;
		background: transparent url('common/images/results-header.png') no-repeat;
		width: 879px;
		height: 135px;
		z-index: 0;
		padding: 25px 0 0 25px;
	}
	.compare-header h3 {
		color: #EE5301;
		font-size: 17px;
		margin-bottom: 11px;
	}

	.compare-header h3 span {
		color: #4686e8;
	}

	.compare-header p {
		font-size: 13px;
		width: 189px;
	}
	.compare-pick-one, .compare-pick-two {
		font-weight:bold;
		text-align:center;
		color:#4A4F51;
		padding:8px 0px 4px 0px;
	}
	div.boxes {
		position: relative;
		z-index: 1;
	}

	div.boxes {
		float: left;
		width: 220px;
		margin-top: 150px;
		margin-left: 40px;
	}
	.filter-separator {
		background: url("common/images/filter_quotes_separator.png") no-repeat scroll center top transparent;
		height: 10px;
		margin-top: 15px;
		margin-bottom:-5px;
	}
	h4.filter-quotes {
		padding-left: 7px;
		padding-top:5px;
	}

	/* Compare Box/Basket */
	.compare-box, .tab-box {
		margin: 8px 0 10px 0;
	}

	.compare-box h4 {
		background: transparent url('common/images/compare-results-header.gif') no-repeat;
		height: 29px;
		width: 196px;
		line-height: 34px;
		padding: 5px 12px 0;
		text-align:center;
	}

	.compare-box .content {
		background:url('common/images/compare-window-container.gif') no-repeat bottom left;
		padding: 10px;
		*background-color:#EEF6FF;
	}

	.compare-box a.remove {
		float: right;
		text-indent: -9999px;
		margin-left: 4px;
		display: block;
		width: 10px;
		height: 10px;
		background: transparent url('common/images/button-compare-remove.gif') no-repeat;
	}

	.compare-box .item {
		width: 180px;
		border-bottom: 1px solid #E3E8EC;
		margin: 4px auto 8px auto;
		background-color:transparent;
	}

	.compare-box .thumb {
		float: left;
		width: 53px;
		border: 1px solid #777;
		text-align: center;
		padding: 1px 0px 3px 0px;
		background-color: #fff;
		margin-right:5px;
	}

	.compare-box .thumb img {
		max-width: 45px;
		margin: 0 auto;
	}

	.compare-box .description {
		margin-left: 48px;
		color: #777;
		padding: 0 0 15px 0;
		min-height:26px;
	}

	.compare-box .description h5 {
		font-size: 11px;
		color: #000;
		display: inline;
	}

	.compare-box .description p {
		margin-top: 2px;
		line-height: 110%;
	}

	.compare-box .compare-selected {
		display: block;
		width: 120px;
		margin: 0 auto;
	}

	/* Side Tabs */
	.tab-box .tabs {
		height: 42px;
		width: 220px;
		padding-top: 8px;
	}

	.tab-box .tab {
		display: inline-block;
		text-align: center;
		zoom:1;
		*display:inline;
	}

	.tab-box .tabs a {
		text-decoration: none;
		color: #1f419b;
		font-weight: bold;
		font-size: 12px;
	}

	.tab-box .tabs .active span a {
		color: #079E3F;
	}

	.tab-box .first {
		background: transparent url('common/images/compare-slider-tabs.gif') no-repeat 0 -50px;
	}

	.tab-box .toggle {
		background-position: 0px 0px;
	}

	/* Rubbish individual styles for the tabs because they're different widths -.- */
	#tab_first {
		width: 100px;
		margin: 4px;
	}

	#tab_second {
		width: 100px;
	}

	#tab_second_pane p{
		font-weight:bold;
		font-size:10px;
		margin-bottom:10px;
	}
	.tab-box .content {
		padding:10px 9px;
		background: transparent url('common/images/compare-slider-container.gif') no-repeat bottom left;
		font-size: 11px;
		line-height: 120%;
		zoom:1;
	}

	.update-results {
		display: block;
		width: 98px;
		height: 22px;
		text-indent: -9999px;
		background: transparent url('common/images/button-update-results.png') no-repeat;
		margin-top:10px;
	}
	.update-results:hover {

	}
	.update-disabled,
		.update-disabled:hover {
		background: transparent url('common/images/button-update-results-disabled.png') no-repeat;
		cursor:pointer;
	}
	.update-payment {
		margin-bottom:25px;
	}
	.update-excess {
		margin-bottom:10px;
	}
	.excess-disclaimer{
		color: #999999;
		font-size: 9px;
		margin-top: 20px;
	}
	/* Re-Rank sliders */
	#smallSliders .slider {
		width:168px;
		height:20px;
		margin-left:0px;
		border-width:0px;
		cursor:pointer;
		cursor:hand;
	}
	#smallSliders .sliderWrapper {
		margin-top:12px;
		margin-bottom:16px;
		background: transparent url('common/images/slider-background-small.gif') no-repeat 0 20px;
	}
	#smallSliders .sliderWrapper label {
		font-weight: bold;
		font-size: 11px;
	}
	#smallSliders .sliderWrapper span {
		color: #0554df;
		font-size: 11px;
	}
	#smallSliders .help_icon {
		margin-top:-20px;
		margin-left:185px;
	}
	#smallSliders .ui-slider-handle {
		border: none;
		background: transparent url('common/images/slider-handle-small.png') no-repeat top left;
		height: 21px;
		width: 23px;
		padding: 0;
		margin-left: 0px;
		margin-top: 5px;
		cursor:e-resize;
	}
/*	#smallSliders .help_icon {
		width:19px;
		height:19px;
		background-image: url("common/images/info-small.png");
		background-color:white;
	}
*/

	/* Results table */
	#results-header {
		height:30px;
		left:260px;
		position:absolute;
		top:57px;
		width:695px;
		z-index:0;
		padding-top:11px;
		margin-left: 5px;
	}

	#results-header div {
		font-weight:bold;
		font-size:11px;
		color:#4C4D4F;
		text-align:left;
		float:left;
	}
	#results-header .brand {
		margin-left: 22px;
		width: 108px;
	}
	#results-header .feature {
		width: 88px;
	}

	#results-header .excess {
		padding-left: 4px;
	}
	#results-header .price {
		margin-left: 3px;
	}
	#results-header .link {
		padding-left: 12px;
	}
	div.brand {
		width:120px;
	}
	div.des {
		width:198px;
	}
	div.feature {
		width:90px;
	}
	div.excess {
		width:57px;
	}
	div.price {
		width:71px;
	}
	div.link {
		width:108px;
		padding-left: 6px;
	}

#results-table a.more-details {
	background-repeat: no-repeat;
	display:block;
	height:27px;
	background-image:url("common/images/button_bg_sml_gr.png");
	cursor:pointer; cursor:hand;
	margin-left:7px;
	margin-bottom: 4px;
	text-decoration: none;
	top: 20px;
}

#results-table a.more-details span {
	color: #ffffff;
	background-image:url("common/images/button_bg_sml_gr_right.png");
	background-position: top right;
	color: #FFFFFF;
	font-weight:bold;
	display: block;
	height: 11px;
	margin-left: 8px;
	padding: 8px 8px 8px 0;
	text-align: center;
	text-shadow: 0px 1px 1px rgba(0,0,0,0.5);
}

	#results-table {
		position:absolute;
		left:260px;
		top:102px;
		width:695px;
	}
	.result-row {
		width:695px;
		height:107px;
		border-bottom: 1px solid #DBE0E4;
		margin-left:2px;
		background-color:white;
	}
	#results-table .top-result{
		border-bottom: 0;
		background-color:transparent;
	}
	#results-table .top-result > div {
		border-color:#F4A97F;
		background-color:#FFF8F0;
	}
	.result-row div {
		display:inline-block;
		vertical-align: top;
		zoom:1;
		*display:inline;
	}
	.result-row>div {
		padding-top:8px
	}
	.result-row div.brand .thumb {
		border: 1px solid #999;
		margin: 0 22px;
		height: 50px;
		width: 86px;
		line-height: 50px;
		text-align: center;
		background-color: #fff;
	}
	.result-row div.brand .thumb img{
		width:70px;
		height:auto;
	}
	.result-row div.brand a.compare {
		display: block;
		text-indent: -9999px;
		background: transparent url('common/images/compare-checkbox.png') no-repeat 0 0;
		height: 19px;
		width: 88px;
		margin:5px 22px;
		float:left;
	}
	.result-row div.brand a.compare-on {
		background-position: 0 -19px;
	}
	.result-row div.data {
		display:none;
	}
	.result-row div.des h5{
		font-size: 12px;
		font-weight:bold;
		color: #000;
		display: inline-block;
		margin-bottom: 4px;
		margin-left:10px;
		zoom:1;
		*display:inline;
	}

	.result-row div.des p{
		font-size: 11px;
		color: #55595A;
		line-height: 120%;
		margin-left:10px;
		position:relative;
	}
	.result-row div.des,
	.result-row div.excess {
		border-left: 1px solid #DBE0E4;
		border-right: 1px solid #DBE0E4;
		background-color:#F8F9FB;
	}
	.result-row > div.link {
		border-left: 1px solid #CDCDCD;
	}
	.result-row>div {
		height: 99px;
	}

	.result-row div.feature span {
		font-size: 11px;
		line-height:11px;
		display:block;
		margin:5px;
	}
	.result-row div.feature a {
		display:block;
		color: #777777;
		font-size:9px;
	}
	.result-row div.excess {
		text-align:center;
	}
	.result-row div.excess span {
		font-size:15px;
		position:relative;
		top:25px;
	}
	.result-row div.price.headline {
		text-align:right;
		display:inline-block !important;
	}
	.result-row div.price span.annualPayment{
		position:relative;
		top:25px;
		font-weight:bold;
		font-size:17px;
		margin-right:15px;
		color:#0CB24E;
	}
	.result-row div.price span.instalmentTotal {
		display:inline-block;
		font-weight:bold;
		font-size:15px;
		margin-right:8px;
		margin-top:8px;
		color:#0CB24E;
	}

	#premiumAmount .annualPayment,
	#premiumAmount .instalmentTotal {
		color:#0CB24E;
	}

	.result-row div.price span.instalmentDetail {
		display:inline-block;
		font-size:10px;
		text-align:right;
		margin-right:0;
		margin-top:5px;
	}
	.result-row div.price span.instalmentNotAvailable {
		display:inline-block;
		font-weight:bold;
		font-size:8px;
		margin-right:8px;
		margin-top:5px;
		text-align:center;
	}

	.result-row div.link a {
		position:relative;
		top:5px;
	}
	.animation-mock-item {
		border: 1px solid #DBE0E4;
		left: 0;
		position: absolute;
		top: 0;
		background-color: #EFEFEF;
		opacity: 0.5;
		filter:alpha(opacity=50);
	}

	.productName {
		color: #0C4DA2;
		cursor: pointer;
	}
	.unavailable div.des p {
		color:#7F7F7F;
		font-size: 11px;
		position: relative;
	}
	.unavailable div span.annualPayment {
		text-align: center;
		margin: 0px;
		display: inline-block;
	}
	#loading3 {
		width:57px;
		height:19px;
		display:inline-block;
		background: url("common/images/loading3.gif") no-repeat scroll left top transparent;
	}
	.price-disclaimer {
		padding-top: 10px;
	}
</go:style>
<go:script marker="js-head">

var Results = new Object();
Results = {
	_currentPrices : new Object(),
	_ranks : new Array(),
	_priceCount : 0,
	_paymentType : "",
	_excess : 500,
	_initialSort : true,
	_loadingLeadNo : false,

	// INITIALISATION
	init : function(){

		$("#resultsCarDes").hide();
		$('#steps').hide();

		//Add this change so we can detect back button clicks
		window.location.hash = "/?stage=result";

		if( $('#navContainer #summary-header').length === 0   ) {
			$('#summary-header').appendTo('#navContainer');
			$('#summary-header').show();
		} else {
			$('#summary-header').show();
		};

	},

	eventMode: function(){ //used with superTag
		if(Results._eventMode == undefined){
			Results._eventMode = 'Refresh';
			return 'Load';
		};
		return Results._eventMode;
	},

	// SHOW/ANIMATE THE RESULTS
	show : function(){

		Kampyle.setFormId("85252");
		this.init();

		// Update the vehicle description from the variant select box
		var vehDes = $("#quote_vehicle_year :selected").text()
					+ ' ' + $("#quote_vehicle_make :selected").text()
					+ ' ' + $("#quote_vehicle_model :selected").text();
		$("#resultsCarDes").html(vehDes);
		$("#resultsCarDes").show();
		$('#save-quote').show();
		$('#save-quote').css('display','block');

		// Update the payment type to show
		this.showPaymentType($(".paymentType").first().val());

		$('#page').fadeOut(300);
		//$('#navContainer').slideUp();
		$('#resultsPage').delay(200).fadeIn(300, function(){
			//$.address.parameter("stage", "results", false );
		});

		var delay = 1000;
		var fadeTime = 350;

		// Disable the sliders while the rows animate in.
		$("#smallSliders .slider").slider("disable");

		$("#results-table .result-row").each(function(){
			delay += fadeTime;
			$(this).hide();
			$(this).delay(delay).show("slide",{direction:"right",easing:"easeInOutQuart"},400);

		});

		var lastRow = $("#results-table .result-row").last();

		$(lastRow).queue("fx", function(next) {

			switch (Results._priceCount) {
			case 0:
				NoResult.show();
				break;

			default:
				$("#smallSliders .slider").slider("enable");
				Results.sort();
				break;
			}
			next();
		});

		//Transaction.init();
	},

	// SHOW THE PAYMENT TYPE (INSTALLMENT/ANNUAL)
	showPaymentType : function(newType){
		Results._paymentType = newType;
		if (newType == "I"){
			$(".annualPayment").each(function(){
				$(this).hide();
				$(this).siblings(".instalmentPayment").fadeIn(200);
			});
		} else {
			$(".instalmentPayment").each(function(){
				$(this).hide()
				$(this).siblings(".annualPayment").fadeIn(200);
			});
		}
	},

	// GET RESULT
	getResult : function(id){
		var i =0;
		while (i < this._currentPrices.length) {
			if (this._currentPrices[i].productId == id ){

				return this._currentPrices[i];
				var deci = $(".decimal").text();


				//$(".decimal").html((deci).toFixed( 2 ));
			}
			i++;
		}
		return false;
	},

	// GET RESULT POSITION
	getResultPosition : function(id){
		var i =0;
		while (i < this._currentPrices.length) {
			if (this._currentPrices[i].productId == id ){
				return i;
			}
			i++;
		}
		return -1;
	},

	// GET TOP POSITION
	getTopPosition : function(){
		return this._currentPrices[0].productId;
	},
	getTranId : function(id){
		return "${data['current/transactionId']}";		
	},
	// SORT PRICES
	sort : function(){

		// Retrieve the prices
		var prices = this._currentPrices;
		var qs = "";

		// Build the array of ranks from the sliders
		Results._ranks = new Array();
		Results._allNeutral = true;
		var i=0;

		$("#smallSliders .sliderWrapper").each(function() {
			var related=$(this).find('input');

			var rankId = $(related).attr("id").substring(6); // remove the "small-"
			var rankVal = $(related).val();

			if (rankVal != 2){
				Results._allNeutral = false;
			}

			Results._ranks[i]= {id: rankId, value: rankVal};

			qs += "ranking_values_"+rankId + "=" + rankVal + "&";
			i++;
		});

		$("#sortTable").html("");
		// set Results.all neutral here
		sortedPrices = $(prices).sort(this._sortPrices);

		var rowHeight = 108+1;

		$("#results-table .result-row").removeClass("top-result bottom-result");

		var newTop = 0;
		var i = 0;
		var lastRow = sortedPrices.length-1;
		var delay = 0;
		while (i < sortedPrices.length) {
			this._currentPrices[i] = sortedPrices[i];
			var prodId= sortedPrices[i].productId;
			qs+="ranking_results_prodid"+i+"="+prodId+"&";

			// If the is the first time sorting, send the prm as well
			if (Results._initialSort == true && sortedPrices[i].headline) {
				qs+="ranking_results_prm"+i+"="+sortedPrices[i].headline.lumpSumTotal+"&";
			}

			var row=$("#result_"+prodId);
			if (i == 0){
				row.addClass("top-result");
			} else if (i == lastRow) {
				row.addClass("bottom-result");
			}

				// Exploder (all versions) just mangles the content when opacity is applied
				// so no nice fades :(
				if ($.browser.msie || $(row).hasClass("unavailable")) {
					row.delay(delay).animate({ top:newTop }, 400, 'easeInOutQuart');

				// Every one else gets gorgeous fading..
				} else {
					row.delay(delay)
						.fadeTo(5,0.80)
						.animate({ top:newTop }, 400, 'easeInOutQuart')
						.fadeTo(5,1.0);
				}

				delay+=50;

			newTop+=rowHeight;
			i++;
		}

		var _resultHeight = (newTop+150 > 800) ? newTop+150 : 800; //page needs to be a minimum height for side panels
		$('#resultsPage').css( { 'height':_resultHeight +'px' } );

		Results._initialSort = false;
		$.ajax({url:"ajax/write/car_quote_ranking.jsp",data:qs,cache: false, 
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			}
		});
		Track.resultsShown(Results.eventMode());
	},

	// Sort the prices
	// We do this by comparing each rank in turn and
	// Attributing a score value based on the selection made
	_sortPrices : function(priceA, priceB){
		var scoreA=0;
		var scoreB=0;
		var premiumA, premiumB;
		var failA = false;
		var failB = false;

		// Get the prices to sort with from the headline
		if (Results._paymentType == "I") {
			premiumA = (priceA.headlineOffer == 'OFFLINE')?
						priceA.offlinePrice.instalmentTotal:priceA.onlinePrice.instalmentTotal;
			premiumB = (priceB.headlineOffer == 'OFFLINE')?
						priceB.offlinePrice.instalmentTotal:priceB.onlinePrice.instalmentTotal;
		} else {
			premiumA = (priceA.headlineOffer == 'OFFLINE')?
						priceA.offlinePrice.lumpSumTotal:priceA.onlinePrice.lumpSumTotal;
			premiumB = (priceB.headlineOffer == 'OFFLINE')?
						priceB.offlinePrice.lumpSumTotal:priceB.onlinePrice.lumpSumTotal;
		}
		// If there is no premium - instant FAIL.
		if (isNaN(premiumA)){
			if (priceB.available == "Y"){
				return 1;
			} else {
				return -1;
			}
		}
		if (isNaN(premiumB)){
			if (priceA.available == "Y"){
				return -1;
			} else {
				return 1;
			}
		}

		if (Results._allNeutral != true){
			for (var i in Results._ranks){
				var rankId = Results._ranks[i].id;
				var rankVal = Results._ranks[i].value;

				var inc = 0;
				if (rankVal == 2) {
					inc = 1;
				} else if (rankVal == 3){
					inc = 10;
				}

				// no increment.. skip this rank
				if (inc > 0) {
					// Handle price differently
					if (rankId == "price") {
						if (premiumA > premiumB){
							scoreB+=inc;
						} else if (premiumA < premiumB){
							scoreA+=inc;
						}
					// All other ranks
					} else {
						if (priceA.ranking[rankId] > priceB.ranking[rankId]){
							scoreA+=inc;
						} else if (priceA.ranking[rankId] < priceB.ranking[rankId]) {
							scoreB+=inc;
						}
					}
				}
			}
		}

		if (scoreA > scoreB){
			return -1;

		} else if (scoreA < scoreB){
			return 1;

		// No clear winner by score.. default to sort by price
		} else {
			return premiumA - premiumB;
		}


	},

	clear : function(){
		this._currentPrices = new Object();
		this._initialSort = true;
	},
	resetExcess : function(){
		$("#quote_baseExcess").val("");
		$("#quote_excess").val("500");
		this._excess = 500;
	},
	update : function(prices){
		this._currentPrices = prices;

		var resultTemplate		= $("#result-template").html();
		var unavailableTemplate	= $("#unavailable-template").html();
		var excessTemplate		= $("#excess-template").html();
		var priceTemplate		= $("#price-template").html();
		var priceShown = false;
		$("#results-table").hide();
		$("#results-table").html("");
		Basket.clear();

		Results._priceCount = 0;
		var topPos = 0;
		var rowHeight = 107+1;
		var baseExcess = 500;
		if (prices != undefined) {
			$.each(prices, function() {
				var newRow;

				if (this.available == "Y") {

				/* calling sortDecimal object to reformat to 2 decimal places */
						if(this.onlinePrice){
							this.onlinePrice.instalmentPayment = Results.sortDecimal(this.onlinePrice.instalmentPayment);
							this.onlinePrice.instalmentTotal = Results.sortDecimal(this.onlinePrice.instalmentTotal);
							this.onlinePrice.instalmentFirst = Results.sortDecimal(this.onlinePrice.instalmentFirst);
							this.onlinePrice.lumpSumTotal = Results.sortDecimal(this.onlinePrice.lumpSumTotal);
						}
						if(this.offlinePrice){
							this.offlinePrice.instalmentPayment = Results.sortDecimal(this.offlinePrice.instalmentPayment);
							this.offlinePrice.instalmentTotal = Results.sortDecimal(this.offlinePrice.instalmentTotal);
							this.offlinePrice.instalmentFirst = Results.sortDecimal(this.offlinePrice.instalmentFirst);
							this.offlinePrice.lumpSumTotal = Results.sortDecimal(this.offlinePrice.lumpSumTotal);
						}

					// Work out which product is the headline
					this.headline = (this.headlineOffer == 'ONLINE')?this.onlinePrice:this.offlinePrice;

					newRow = $(parseTemplate(resultTemplate, this));
					Results._priceCount++;

				} else {

					if (this.error == "Y") {
						this.message="Unavailable at this time";
					} else {
						this.message="This provider chose not to quote";
					}
					this.headline = (this.headlineOffer == 'ONLINE')?this.onlinePrice:this.offlinePrice;
					newRow = $(parseTemplate(unavailableTemplate, this));
				}

				// Basket handler
				$(newRow).find('.compare').click(function() {
					var id = $(this).closest('.result-row').attr('id');

					if (Basket.addItem(id)) {
						$(this).addClass('compare-on');
					} else if (Basket.removeItem(id)) {
						$(this).removeClass('compare-on');
					}
				});

				// Check Instalment Amounts
				var p = $(newRow).find(".onlinePrice");
				if (this.onlinePrice && isNaN(this.onlinePrice.instalmentTotal)){
					$(p).find(".instalmentTotal").hide();
					$(p).find(".instalmentDetail").hide();
					$(p).find(".instalmentNotAvailable").show();
				} else {
					$(p).find(".instalmentNotAvailable").hide();
				}

				var p = $(newRow).find(".offlinePrice");
				if (this.offlinePrice && isNaN(this.offlinePrice.instalmentTotal)){
					$(p).find(".instalmentTotal").hide();
					$(p).find(".instalmentDetail").hide();
					$(p).find(".instalmentNotAvailable").show();
				} else {
					$(p).find(".instalmentNotAvailable").hide();
				}

				// Online price exists and is a value
				if (this.onlinePrice
						&& !isNaN(this.onlinePrice.lumpSumTotal)){
					// Populate the price tag
					var tag = $(newRow).find("#onlinePrice_" + this.productId);
					tag.append($(parseTemplate(priceTemplate, this.onlinePrice)));

					// Is this the headline offer?
					if (this.headlineOffer == 'ONLINE') {
						$(tag).addClass("headline");
						$(tag).show();
					} else {
						$(tag).hide();
					}

					// Installments not available?
					if (isNaN(this.onlinePrice.instalmentTotal)){
						$(tag).find(".instalmentTotal").hide();
						$(tag).find(".instalmentDetail").hide();
						$(tag).find(".instalmentNotAvailable").show();
					} else {
						$(tag).find(".instalmentNotAvailable").hide();
					}

					// Feature text and terms link
					$(newRow).find("#onlineFeature_"+this.productId).append(this.onlinePrice.feature);
					if (this.onlinePrice.terms && this.onlinePrice.terms!=''){
						var termsLink = $("<a>").attr("href","javascript:Terms.show('"+this.productId+"');").text("*offer terms");
						$(newRow).find("#onlineFeature_"+this.productId).append(termsLink.clone());

						if (this.headlineOffer == 'ONLINE'){
							$(newRow).find(".feature span").append(termsLink);
						}
					}
				} else {
					$(newRow).find("#onlinePrice_" + this.productId).hide();
				}
				// Offline price exists and is a value
				if (this.offlinePrice
					&& !isNaN(this.offlinePrice.lumpSumTotal)){

					// Populate the price tag
					var tag = $(newRow).find("#offlinePrice_" + this.productId);
					tag.append($(parseTemplate(priceTemplate, this.offlinePrice)));

					if (this.headlineOffer == 'OFFLINE') {
						$(tag).addClass("headline");
						$(tag).show();
					} else {
						$(tag).hide();
					}

					// Installments not available?
					if (isNaN(this.offlinePrice.instalmentTotal)){
						$(tag).find(".instalmentTotal").hide();
						$(tag).find(".instalmentDetail").hide();
						$(tag).find(".instalmentNotAvailable").show();
					} else {
						$(tag).find(".instalmentNotAvailable").hide();
					}

					// Feature text and terms link
					$(newRow).find("#phoneFeature_"+this.productId).append(this.offlinePrice.feature);
					if (this.offlinePrice.terms && this.offlinePrice.terms!=''){
						var termsLink = $("<a>").attr("href","javascript:Terms.show('"+this.productId+"');").text("*offer terms");
						$(newRow).find("#phoneFeature_"+this.productId).append(termsLink.clone());

						if (this.headlineOffer == 'OFFLINE'){
							$(newRow).find(".feature span").append(termsLink);
						}
					}
				} else {
					$(newRow).find("#offlinePrice_" + this.productId).hide();

				}

				// Add offer terms link (if terms exist)
				//if (this.headline && this.headline.terms && this.headline.terms!=''){
				//	var termsLink = $("<a>").attr("href","javascript:Terms.show('"+this.productId+"');").text("*offer terms");
				//	$(newRow).find(".feature span").append(termsLink);
				//}

				// Add any conditions
				if (this.conditions){
					var condTag = $(newRow).find("#conditions_" + this.productId);

					if (this.conditions.condition instanceof Array) {
						$.each(this.conditions.condition, function() {
							condTag.append("<p>"+this+"</p>");
						});
					} else {
						condTag.append("<p>"+this.conditions.condition+"</p>");
					}
				}

				// Position the row.
				$(newRow).css({position:"absolute", top:topPos});
				topPos+=rowHeight;

				// Add any additional excesses
				if (this.excess) {
					if (this.excess.excess) {
						var excessTag = $(newRow).find("#excessTable_" + this.productId);
						$.each(this.excess.excess, function() {
							excessTag.append($(parseTemplate(excessTemplate, this)));
						});
					}

					// Check the base excess
					if (this.excess.base) {
						baseExcess = Math.max(this.excess.base, baseExcess);
					}
				}

				var t = $(newRow).text();
				if (t.indexOf("ERROR") == -1 ) {
					$("#results-table").append(newRow);
					priceShown=true;
				} else {
					FatalErrorDialog.display("HTML Template Error: " + t, this);
				}
			});
		}

		$("#quote_baseExcess").val(baseExcess);

		// Reload the excess list
		Results._updateExcessList(baseExcess);


		// always show the results table (even when no prices returned)
		var resultRows = $("#results-table .result-row");
		$(resultRows).first().addClass("top-result");
		$(resultRows).last().addClass("bottom-result");
		$("#results-table").show();
		$("#smallSliders .slider").slider("enable");

		if (Results._priceCount < 2) {
			$("#results-header .brand").text("Brand");
			$(".compare").hide();
		} else  {
			$("#results-header .brand").text("Select brands to compare");
		}
	},
	// RE-FORMAT PRICES WITH DECIMAL PLACES TO HAVE .##
	sortDecimal : function(price){
		if (price != Math.floor(price) && !isNaN(price) && price != "undefined" && price != ''){
			price = parseFloat(price).toFixed(2);
		}
		return price;
	},

	// UPDATE THE EXCESS SELECTION
	_updateExcessList : function(baseExcess){
		var MAX_EXCESS = 2000;
		var EXCESS_INC = 100;

		$("#quote_excess option").remove();

		var amt = 500;
		var selected=false;
		while(amt <= MAX_EXCESS){
			var opt=$("<option></option>").val(amt).html("$"+amt+" Excess");
			if (!selected && amt == Results._excess){
				opt.attr("selected","SELECTED");
				selected=true;
			}
			$("#quote_excess").append(opt);

			amt+=EXCESS_INC;
		}
	},

	reload : function() {

		initialClick = true;
		$(".update-results").addClass("update-disabled");

		Loading.show("Updating Quotes...");
		Results.clear();
		Basket.clear();

		Results._excess = $("#quote_excess").val();
		var dat = $("#mainform").serialize();
		$.ajax({
			url: "ajax/json/car_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){

				Results.update(jsonResult.results.price);
				resultsAvailable = true;

				// Hide/Show the Instalment or Annual Lump Sum option
				Results.showPaymentType($(".paymentType").val());

				// Disable the sliders while the rows animate in.
				$("#smallSliders .slider").slider("disable");

				Loading.hide();

				// animate the rows
				var delay = 100;
				var fadeTime = 350;
				$("#results-table .result-row").each(function(){
					delay += fadeTime;
					$(this).delay(delay).show("slide",{direction:"right",easing:"easeInOutQuart"},400);
				});

				// Show the sliders and re-sort.
				var lastRow = $("#results-table .result-row").last();
				$(lastRow).queue("fx", function(next) {

					switch (Results._priceCount) {
					case 0:
						NoResult.show();
						break;

					case 1:
						Results.sort();
						break;

					default:
						$("#smallSliders .slider").slider("enable");
						Results.sort();
					}
					next();
				});
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				Loading.hide();
				FatalErrorDialog.display("An error occurred when fetching prices:" + txt, dat);
			},
			timeout:50000
		});
	},
	fetchPrices : function(){

		Loading.show("Fetching Quotes...");
		var dat = $("#mainform").serialize();
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/car_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				Results.update(jsonResult.results.price);

				Loading.hide();

				Results.show();
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				this.ajaxPending = false;
				Loading.hide();
				FatalErrorDialog.display("An error occurred when fetching prices:" + txt, dat);
			},
			timeout:60000
		});
	}
}

jQuery.fn.sort = function() {
	return this.pushStack( [].sort.apply( this, arguments ), []);
};

</go:script>

<go:script marker="jquery-ui">
	var labels  = ['Not important', 'Neutral', 'Important'];
	var min 	= 1;
	var max 	= 3;

	var theTabs = $('.tab a');
	var thePanels = $('.tabPane');

	$(theTabs).each(function(i) {
		$(this).click(function() {
			var theParent = $(this).closest('.tab');

			$('.tab').removeClass('active');
			theParent.addClass('active');

			$('.tab-pane').hide();
			$('#' + theParent.attr('id') + '_pane').fadeIn("fast");

			$(this).closest('.tabs').toggleClass('toggle');
		});
	});

	var smallSliderId = '';
	$('#smallSliders .sliderWrapper').each(function() {
		var related = $(this).find('input');
		var label = $(this).find('span');

		$(this).find('.slider').slider({
			'min': min,
			'max': max,
			'value': related.val(),
			'animate': true,
			change: function(event, ui) {
				$(related).val(ui.value);
				$(label).html(labels[ui.value-1]);

				if (event.originalEvent!=undefined) {
					Results.sort();
					smallSliderId = $(event.target).closest(".sliderWrapper").find("input").attr("id").substring(6);
					//omnitureReporting(9);
				}
			}
		});

		// Manually set the label
		$(label).html(labels[related.val()-1]);

	});


	// Init basket listeners
	Basket.create('#basket');

	// If they click revise - return to page 1
	$("#revise").click(function(){
		Transaction.init();
		Transaction.getId();
		
		$('#save-quote').hide();
		$('#summary-header').hide();
		$('#steps').show();
		History.showStart();
	});

	$(".update-payment").click(function(event,ui){
		$(".update-payment").addClass("update-disabled");
		Results.showPaymentType($(this).siblings(".paymentType").first().val());
		Results.sort();
		//omnitureReporting(11);
	});

	$(".update-excess").click(function(event,ui){
		$(".update-excess").addClass("update-disabled");
		var newExcess = $("#quote_excess").val();
		if (newExcess != Results._excess) {
			Results.reload();
			//omnitureReporting(12);
		}
	});
	$("#quote_excess").change(function(event,ui){
		if ($(this).val() != Results._excess) {
			$(".update-excess").removeClass("update-disabled");
		} else {
			$(".update-excess").addClass("update-disabled");
		}
	});
	$("#quote_paymentType").change(function(event,ui){
		if ($(this).val() != Results._paymentType) {
			$(".update-payment").removeClass("update-disabled");
		} else {
			$(".update-payment").addClass("update-disabled");
		}
	});
	$(".update-results").addClass("update-disabled");

</go:script>


<%-- HTML --%>
<div id="resultsPage" class="clearFix">

	<div id="summary-header">
		<h2>Compare Car Insurance Quotes</h2>
		<a href="javascript:void(0)" id="revise">Revise your details?</a>
	</div>

	<div id="results-information">
		<h2>Car Insurance Quotes for your:</h2>
		<span id="resultsCarDes"></span>
	</div>

	<div class="compare-header">
		<h3>Top Result</h3>
		<p>This quote result is based on best price. Please use the sliders below to re-rank the results based on your own criteria.</p>
	</div>

	<div class="boxes">
		<div class="compare-box" id="basket" style="display:none">
			<h4>Compare your results</h4>
			<div class="content">

				<div class="basket-items"></div>
				<a href="javascript:void(0);" class="compare-selected"><span>Compare selected</span></a>
				<div class="compare-pick-two" style="display:none">Please pick at least one more product to compare</div>
				<div class="compare-pick-one" style="display:none">or pick another product to compare</div>
			</div>
			<div class="filter-separator"></div>
		</div>
		<h4 class="filter-quotes">Filter Quote Results</h4>
		<div class="tab-box">
			<div class="tabs first">
				<div class="tab active" id="tab_first">
					<span><a href="javascript:void(0);">Re-rank your Quote Results</a></span>

				</div>
				<div class="tab" id="tab_second">
					<span><a href="javascript:void(0);">Payment &amp; Excess Options</a></span>
				</div>
			</div>

			<div class="content">
				<div class="tab-pane" id="tab_first_pane">

					<div id="smallSliders">
						<field:slider helpId="16" title="Environment: " 			id="small-env" 			value="2"/>
						<field:slider helpId="17" title="Drive Less Pay Less: " 	id="small-payasdrive" 	value="2"/>
						<field:slider helpId="18" title="Best Price: " 			id="small-price" 		value="2"/>
						<field:slider helpId="19" title="Online Only Offer: " 	id="small-onlinedeal" 	value="2"/>
						<field:slider helpId="21" title="Household Name: " 		id="small-household" 	value="2"/>
					</div>
					<div class="price-disclaimer">Each brand may have different terms as well as price. Please consider the Product Disclosure Statement for each brand before making a decision to buy</div>
				</div>
				<div class="tab-pane" id="tab_second_pane" style="display:none;">
					<p>Display the following payment plan:</p>
					<field:payment_type xpath="quote/paymentType" title="Payment Type" />
					<a href="javascript:void(0)" class="update-results update-payment">Update Results</a>

					<p>Select your preferred excess*</p>
					<field:additional_excess increment="100" minVal="500" xpath="quote/excess" maxCount="6" title="optional additional excess" required="true" omitPleaseChoose="Y" />
					<input type="hidden" name="quote_baseExcess" id="quote_baseExcess">

					<a href="javascript:void(0)" class="update-results update-excess">Update Results</a>

					<div class="excess-disclaimer">*Updated quotes will use the individual provider's closest available excess</div>
				</div>
			</div>
		</div>
	</div>

	<div id="results-header">
		<div class="brand">Select brands to compare</div>
		<div class="des">Product <br>Information</div>
		<div class="feature">Special<br>Feature<span style="font-style: 900">/</span>Offer</div>
		<div class="excess">Excess</div>
		<div class="price">
			<span class="annualPayment">Annual Price</span>
			<span class="instalmentPayment">Instalment <br>Price</span>
		</div>
		<div class="link">&nbsp;</div>
	</div>

	<%-- The results table will be inserted here --%>
	<div id="results-table"></div>

	<%-- TEMPLATE FOR PRICE RESULTS --%>
	<core:js_template id="result-template">
		<div class="result-row" id="result_[#= productId #]" style="display:none;">


			<div class="brand">
				<div class="thumb"><img src="common/images/logos/results/[#= productId #].png" alt=""></div>
				<a href="javascript:void(0)" class="compare">Compare</a>
			</div>

			<div class="des">
				<h5 id="productName_[#= productId #]"><span onclick="javascript:moreDetailsHandler.init('[#= productId #]')" class="productName">[#= headline.name #]</span></h5>
				<p id="productDes_[#= productId #]">[#= headline.des #]</p>
			</div>

			<div class="feature">
				<span id="feature_[#= productId #]">[#= headline.feature #]</span>
			</div>

			<div class="excess" id="excess_[#= productId #]">
				<span>$[#= excess.total #]</span>
			</div>

			<div class="price onlinePrice" id="onlinePrice_[#= productId #]"></div>
			<div class="price offlinePrice" id="offlinePrice_[#= productId #]"></div>

			<div class="link">
				<a href="javascript:moreDetailsHandler.init('[#= productId #]')" class="more-details" id="more_details_[#= productId #]"><span>+ More Details</span></a>
			</div>

			<div class="data">
				<span id="quoteUrl_[#= productId #]" class="quoteUrl">[#= quoteUrl #]</span>
				<span id="acn_[#= productId #]">[#= acn #]</span>
				<span id="afsLicenceNo_[#= productId #]">[#= afsLicenceNo #]</span>
				<span id="underwriter_[#= productId #]">[#= underwriter #]</span>
				<span id="pdsaUrl_[#= productId #]">[#= pdsaUrl #]</span>
				<span id="pdsaDesLong_[#= productId #]">[#= pdsaDesLong #]</span>
				<span id="pdsaDesShort_[#= productId #]">[#= pdsaDesShort #]</span>
				<span id="pdsbUrl_[#= productId #]">[#= pdsbUrl #]</span>
				<span id="pdsbDesLong_[#= productId #]">[#= pdsbDesLong #]</span>
				<span id="pdsbDesShort_[#= productId #]">[#= pdsbDesShort #]</span>
				<span id="fsgUrl_[#= productId #]">[#= fsgUrl #]</span>
				<span id="excess_[#= productId #]"></span>
				<span id="productInfo_[#= productId #]">[#= headline.info #]</span>
				<span id="telNo_[#= productId #]">[#= telNo #]</span>
				<span id="openingHours_[#= productId #]">[#= openingHours #]</span>
				<span id="excessTable_[#= productId #]"></span>
				<span id="conditions_[#= productId #]"></span>
				<span id="phoneFeature_[#= productId #]"></span>
				<span id="onlineFeature_[#= productId #]"></span>
				<span id="disclaimer_[#= productId #]">[#= disclaimer #]</span>
				<span id="transferring_[#= productId #]">[#= transferring #]</span>
			</div>
		</div>
	</core:js_template>

	<core:js_template id="price-template">
		<span class="annualPayment">$[#= lumpSumTotal #]</span>
		<span class="instalmentPayment">
			<span class="instalmentTotal">
				$[#= instalmentTotal #]
			</span>
			<span class="instalmentDetail">
				One initial payment <br> of $[#= instalmentFirst #]<br>
				And [#= instalmentCount #] payments of $[#= instalmentPayment #]
			</span>
			<span class="instalmentNotAvailable">
				Monthly payment available.<br>
				No extra, please call 13 72 93
			</span>
		</span>

	</core:js_template>

	<%-- PRICE UNAVAILABLE TEMPLATE --%>
	<core:js_template id="unavailable-template">
		<div class="result-row unavailable" id="result_[#= productId #]" style="">

			<div class="brand">
				<div class="thumb"><img src="common/images/logos/results/[#= productId #].png" alt=""></div>
			</div>

			<div class="des">
				<h5 id="productName_[#= productId #]"><span onclick="javascript:moreDetailsHandler.init('[#= productId #]')" class="productName">[#= headline.name #]</span></h5>
				<p id="productDes_[#= productId #]">[#= headline.des #]</p>
			</div>

			<div class="feature">
				<span id="feature_[#= productId #]">[#= headline.feature #]</span>
			</div>
			<div class="excess"></div>
			<div class="price"></div>
			<div class="link"><p>[#= message #]</p></div>

			<div class="data"></div>
		</div>
	</core:js_template>

	<core:js_template id="excess-template">
		<div class='excessRow'>
			<div class='excessDesc'>[#= description #]</div>
			<div class='excessVal'>[#= amount #]</div>
		</div>
	</core:js_template>

	<go:script marker="js-head">
		function closeDialogWindow() {
			if ($('#prodInfoDialog').dialog('isOpen')) closeProdInfoDialog();
			if ($('#compareDialog').dialog('isOpen')) closeCompareDialog();
			if ($('#moreDetailsDialog').dialog('isOpen') && typeof closeMoreDetailsDialog == "function") try{closeMoreDetailsDialog();}catch(e){ /* IGNORE */};
			if ($('#applyOnlineDialog').dialog('isOpen')) closeApplyOnlineDialog();
			if ($('#applyByPhoneDialog').dialog('isOpen')) closeApplyByPhoneDialog();
		}
		function applyByPhoneToggle(prod){
			closeDialogWindow();
			setTimeout(function(){
				applyByPhone(prod);
			}, 600);
		}
		function applyOnlineToggle(prod){
			closeDialogWindow();
			setTimeout(function(){
				applyOnline(prod);
			}, 600);
		}
	</go:script>


</div>
