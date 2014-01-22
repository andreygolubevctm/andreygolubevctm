<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<%-- Load the params into data --%>



<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>


<%-- CSS --%>
<go:style marker="css-head">

	#results-container {
		min-height:420px;
		margin:0 auto;
	}

	#results-container .moreinfobtn, #results-container .buybtn {
		width:120px;
		text-align:center;
		text-shadow: 0 1px 1px rgba(0, 0, 0, 0.5);
		font-weight:bold;
	}

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
	#left-panel {
		width:170px;
		height:350px;
		float:left;
	}
	#resultsPage {
		display:none;
		position:relative;
	}
	#results-information {
		padding:0;
		padding-top:40px;
		background: url('common/images/results-shadow.png') repeat-x top left;
		height: 20px;
		position:relative;
		top:-7px;
	}
	#results-information>div {
		margin:0 auto;
		width:920px;
		position:relative;
	}
	#results-information h2 {
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		color:#0db14b;
		font-weight: normal;
		font-size: 20px;
		padding-right:200px;
	}
		#results-information h2 em {
			font-style:normal;
			color:#4a4f51;
		}
		#results-information h2 span {
			color:#4a4f51;
		}
	#summary-header {
		position:relative;
		width:960px;
		height:44px;
		margin:0 auto;
	}
		#summary-header #revise {
			position:absolute;
			right:-10px;
			top:5px;
			padding: 8px 15px 10px 15px;
			font-size: 10pt;
			font-weight: 600;
		}
		#summary-header h2 {
			color: #4A4F51;
			font-family: "SunLT Light",Arial,Helvetica,sans-serif;
			font-size: 22px;
			font-weight: normal;
			line-height:44px;
		}
	#revise {
	}
	#revise:hover {
	}
	div.compare-header {
		position: absolute;
		top: 62px;
		left: 170px;
		width: 785px;
		height: 35px;
		z-index: 0;
		background-position: 0pt -36px;
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
	/* Results table */
	#results-header {
		height: 50px;
		left: 0px;
		margin: 24px auto 0 auto;
		position: relative;
		width: 920px;
		z-index: 0;
		background-color:#FFF;
		border-bottom: 1px solid #F4A97F;
	}
	#results-header div.sortable:hover {
		background-color:none;
	}
	#results-header .link {
		border-right:none;
		text-align:center;
		width:92px;
	}
	.sortable {
		cursor:pointer;
	}
	.roadside #results-header div,
	.roadside .result-row div {
		float:left;
		display:inline-block;
		padding:10px;
		margin:0 0 0 0;
		border:none;
		background:none;
		height:auto;
		width:auto;
		text-align:left;
	}
	.roadside #results-header div {
		color:#4a4f51;
		font-size:13px;
		font-weight:bold;
		height:30px;
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		position:relative;
	}
	.roadside #results-header div.address,
	.roadside #results-header div.price2 {
		border-right:none;
	}
	.roadside .result-row div {
		height:50px;
		border-bottom: 1px solid #DAE0E4;
		border-left: 1px solid #DAE0E4;
	}
	#results-table {
		position:relative;
		margin:0 auto;
		top:0px;
		width:920px;
	}

	/* Container Sizes */
	.roadside #results-container .provider {
		width:80px;
	}
		.roadside .result-row .provider {
			border-left:none;
			padding-top:0;
			padding-bottom:0;
			height:70px;
		}
	.result-row div.provider .thumb {
		text-align: center;
		border: 0;
		vertical-align:top;
		padding:5px 0 0 0;
	}
	.result-row div.provider .thumb img{
		max-width:79px;
		max-height:60px;
	}
	.roadside  #results-container .price {
		width:75px;
	}
		#results-container .result-row .price span {
			font-weight:bold;
			color:#0DB14B;
			font-size:14px;
			display:inline-block;
			margin-top:2px;
			width:100%;
		}
		.roadside .result-row .price {
			background-color:#f8f9fa;
			text-align: center;
		}
	.roadside #results-container .des {
		width:130px;
	}
		.roadside #results-container .result-row.unavailable .des {
			width:799px;
			line-height:50px;
		}
		.roadside #results-container .result-row.unavailable .link,
		.roadside #results-container .result-row.unavailable .data {
			position:absolute;
			width:0;
			height:0;
			border:none;
			top:0;
			right:0;
		}
	.roadside #results-container .roadsideCallouts {
		width:85px;
	}
		#results-container .result-row .roadsideCallouts {
			text-align:center;
		}
	.roadside #results-container .key {
		width:85px;
	}
	.roadside #results-container .towing {
		width:87px;
	}
	.roadside #results-container .towingCountry {
		width:99px;
	}
	.roadside #results-container .link {
		width:112px;
	}
		.roadside .result-row .link {
			padding-top:0;
			padding-bottom:0;
			height:70px;
		}
		#results-table .link a {
			margin: 4px auto;
		}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var Results = new Object();
Results = {
	_currentPrices : new Object(),
	_priceCount : 0,
	_initialSort : true,
	_loadingLeadNo : false,
	_revising : false,
	_sortBy : false,
	_sortDir : 'asc',

	// INITIALISATION


	init : function(){

		Results._initSortIcons();

		if(Results._initialSort === true ) {
			$('#summary-header').appendTo('#navContainer');
			$('#steps').hide();
		}

	},


	// SHOW/ANIMATE THE RESULTS
	show : function(){

		this.init();
		this._updateSummaryText();

	$('#page').hide();
	$('#resultsPage').fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
		});

		var delay = 1000;
		var fadeTime = 350;
		var container_height = 200;
		$("#results-table .result-row").each(function(){
			container_height += 65;
			delay += fadeTime;
			$(this).hide();
			$(this).delay(delay).show("slide",{direction:"right",easing:"easeInOutQuart"},400);

		});


		//
		$('#resultsCarDes').text($('#roadside_riskAddress_state').val());


		$('#resultsPage').css({'min-height':container_height+'px'});

		var lastRow = $("#results-table .result-row").last();

		$(lastRow).queue("fx", function(next) {

			if (Results._priceCount == 0) {
				NoResult.show();
			} else {
				Results._sortBy="";
				Results.sort('price');
			}
			next();
		});
	},

	// GET RESULT
	getResult : function(id){



		var i =0;
		while (i < this._currentPrices.length) {
			if (this._currentPrices[i].productId == id ){
				return this._currentPrices[i];
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

	// GET THE REFERENCE NUMBER
	getLeadNo : function(id, destDiv){
		var r=this.getResult(id);
		if (r){
			if (r.leadNo != ""){
				return r.leadNo;
			} else if (r.refnoUrl != ""){
				this._loadLeadNo(r, destDiv);
			}
		}
		return "";
	},
	_updateSummaryText : function(){
		// Build the summary text based on the entered information.

		$('#results-summary span.year').text( $('#roadside_vehicle_year option:selected').val() );
		$('#results-summary span.make').text( $('#roadside_vehicle_make option:selected').text() );

		/*
		// Update the vehicle description from the variant select box
		var vehDes = $("#quote_vehicle_year :selected").text()
					+ ' ' + $("#quote_vehicle_make :selected").text()
					+ ' ' + $("#quote_vehicle_model :selected").text();
		$("#resultsCarDes").html(vehDes);
		$("#resultsCarDes").show();
		*/



	},
	// SORT PRICES
	sort : function(sortBy){
		if (sortBy == this._sortBy) {
			this._sortDir = (this._sortDir=='asc')?'desc':'asc';
		}
		this._sortBy = sortBy;

		for (var i =0; i < this._currentPrices.length; i++){
		/* get price from priceText instead of price for decimal points and convert to float */

		//sometimes there will not be a price so default to a ridiculous number
		if( this._currentPrices[i].priceText === undefined) {
			var newPrice = '$999999';
		} else {
			var newPrice = this._currentPrices[i].priceText;
		};

		this._currentPrices[i].price = parseFloat(newPrice.replace("$", ""));
			this._calcSortValue(this._currentPrices[i], this._sortBy);
		}

		// Retrieve the prices
		var prices = this._currentPrices;

		$("#sortTable").html("");
		sortedPrices = $(prices).sort(this._sortPrices);

		var rowHeight = 70+1;

		$("#results-table .result-row").removeClass("top-result bottom-result");

		var newTop = 0;
		var i = 0;
		var lastRow = sortedPrices.length-1;
		var delay = 0;
		var data 	= {
				rankBy :		sortBy + "-" + this._sortDir,
				rank_count :	sortedPrices.length
		};

		while (i < sortedPrices.length) {
			this._currentPrices[i] = sortedPrices[i];
			var prodId= sortedPrices[i].productId;

			data["rank_productId" + i] = prodId;

			// If the is the first time sorting, send the prm as well
			if (Results._initialSort == true) {
				data["rank_premium" + i] = sortedPrices[i].price;
			}

			var row=$("#result_"+prodId);
			if (i == 0){
				row.addClass("top-result");
			} else if (i == lastRow) {
				row.addClass("bottom-result");
			}
			if (newTop != row.position().top) {

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
			}
			newTop+=rowHeight;
			i++;
		}
		Results._updateSortIcons();
		Results._initialSort = false;
		Results._submitRankingData(data);
		//omnitureReporting(1);
		btnInit._show();
	},

	_submitRankingData : function( data ) {
		$.ajax({
			url :		"ajax/write/roadside_quote_ranking.jsp",
			data :		data,
			type: 		'POST',
			async: 		true,
			timeout:	30000,
			cache: 		false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			}
		});
	},

	// Sort the prices
	// We do this by comparing each rank in turn and
	// Attributing a score value based on the selection made
	_sortPrices : function(priceA, priceB){

		// If there is no premium - instant FAIL.
		if (isNaN(priceA.price)){
			if (priceB.available == "Y"){
				return 1;
			} else {
				return -1;
			}
		}
		if (isNaN(priceB.price)){
			if (priceA.available == "Y"){
				return -1;
			} else {
				return 1;
			}
		}
		if (priceA.sortValue > priceB.sortValue){
			rtn = 1;

		} else if (priceA.sortValue < priceB.sortValue){
			rtn = -1;

		// No clear winner by score.. default to sort by price
		} else {
			rtn = (priceA.price - priceB.price);
		}

		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_calcSortValue : function(price, sortBy){
		if (sortBy=='price'){
			price.sortValue=0;

		} else if (price.info) {
			for (var prop in price.info) {
				if (prop == sortBy) {
					price.sortValue = price.info[prop].value;
					return;
				}
			}
		}
	},
	clear : function(){
		this._currentPrices = new Object();
		this._initialSort = true;
	},
	update : function(prices){
		prices=[].concat(prices);

		this._currentPrices = prices;

		var resultTemplate		= $("#result-template").html();
		var unavailableTemplate	= $("#unavailable-template").html();

		var priceShown = false;
		$("#results-table").hide();
		$("#results-table").html("");

		Results._priceCount = 0;
		var topPos = 0;
		var rowHeight = 70+1;
		if (prices != undefined) {
			$.each(prices, function() {
				/* appending quoteUrl */
				this.quoteUrl = this.quoteUrl+"&service="+this.service;
				var newRow;
				if (this.available == "Y") {
					/* calling sortDecimal object to reformat to 2 decimal places */
						if(this.price){
							this.price = Results.sortDecimal(this.price);
							this.priceText = '$'+this.price;
						}
					newRow = $(parseTemplate(resultTemplate, this));
					Results._priceCount++;

				} else {

					if (this.error == "Y") {
						this.message="Unavailable at this time";
					} else {
						this.message="This provider chose not to quote";
					}
					newRow = $(parseTemplate(unavailableTemplate, this));
				}

				// Online price exists and is a value
				// adding hack to convert price to a number as we a pulling directly from xml and not db
				//this.price = parseInt(this.price);
				if (this.price && !isNaN(this.price)){
					// Populate the price tag
					var tag = $(newRow).find("#price_" + this.productId);
					$(tag).show();

				} else {
					$(newRow).find(".apply").hide();
					$(newRow).find("#price_" + this.productId).hide();
				}

				// Position the row.
				$(newRow).css({position:"absolute", top:topPos});
				topPos+=rowHeight;

				var t = $(newRow).text();
				if (t.indexOf("ERROR") == -1 ) {
					$("#results-table").append(newRow);
					priceShown=true;
				} else {
					FatalErrorDialog.display("HTML Template Error: " + t, this);
				}
			});
		}

		// always show the results table (even when no prices returned)
		var resultRows = $("#results-table .result-row");
		//$(resultRows).first().addClass("top-result");
		$(resultRows).last().addClass("bottom-result");
		$("#results-table").show();

	},

	reload : function() {

		initialClick = true;
		$(".update-results").addClass("update-disabled");

		Loading.show("Updating Quotes &nbsp; &nbsp; Back in a tick...");
		Results.clear();

		var dat = $("#mainform").serialize();
		$.ajax({
			url: "ajax/json/sar_quote_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				if(jsonResult.error == "VALIDATION_FAILED") {
					Roadside.ajaxPending = false;
					Loading.hide();
					FatalErrorDialog.display("An error occurred when fetching prices : fields have not been set");
				}
				Results.update(jsonResult.results.price);
				resultsAvailable = true;

				Loading.hide();

				// animate the rows
				var delay = 100;
				var fadeTime = 350;
				$("#results-table .result-row").each(function(){
					delay += fadeTime;
					$(this).delay(delay).show("slide",{direction:"right",easing:"easeInOutQuart"},400);
				});

				// Perform initial re-sort.
				var lastRow = $("#results-table .result-row").last();
				$(lastRow).queue("fx", function(next) {

					if (Results._priceCount == 0) {
						NoResult.show();
					} else {
						Results.sort();
					}

					next();
				});

				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				FatalErrorDialog.display("An error occurred when fetching prices:" + txt, dat);
			},
			timeout:50000
		});
	},
	_initSortIcons: function(){

		$('#results-header .sortable').each(function(){
			if ($(this).find('.sort-icon').length == 0){
				var icon = $('<span></span>')
								.attr('class','sort-icon')
								.css({width:$(this).css('width')});
				$(this).append(icon);

				$(this).click(function(){
					var cls =$(this).attr('class');
					var sortBy="";
					$.each(cls.split(' '), function(idx,value){
						if (value !== '' && value != 'sortable') {
							sortBy=value;
						}
					});
					Results.sort(sortBy);
					$(this).mouseout();
					$(this).mouseover();
				});
				$(this).mouseover(function(){
					var icon=$(this).find('.sort-icon');
					if ($(icon).hasClass('sort-icon-hidden')){
						$(icon).toggleClass('sort-icon-asc sort-icon-hidden');
					} else {
						$(icon).toggleClass('sort-icon-asc sort-icon-desc');
					}
				});
				$(this).mouseout(function(){
					var icon=$(this).find('.sort-icon');
					var sortBy=Results._sortBy?Results._sortBy:'price';
					if ($(this).hasClass(sortBy)){
						$(icon).removeClass('sort-icon-asc sort-icon-desc sort-icon-hidden');

						if (Results._sortDir=='asc'){
							$(icon).addClass('sort-icon-asc');
						} else {
							$(icon).addClass('sort-icon-desc');
						}
					} else {
						$(icon).removeClass('sort-icon-asc sort-icon-desc');
						$(icon).addClass('sort-icon-hidden');
					}
				});
			}
		});
	},

// RE-FORMAT PRICES WITH DECIMAL PLACES TO HAVE .##
	sortDecimal : function(price){
		if (!isNaN(price) && price != "undefined" && price != ''){
			price = price.toFixed(2);
		}
		return price;
	},
	_updateSortIcons: function(){
		$('#results-header .sortable').each(function(){
			$(this).mouseout();
		});
	}
}

jQuery.fn.sort = function() {
	return this.pushStack( [].sort.apply( this, arguments ), []);
};

function format_results_filter(){

	// Assign specific styles
	$("#qe-wrapper").addClass('resultsform');
	$("#qe-wrapper").removeClass('nonresultsform');
	$("#qe-wrapper").css({'background':'none', 'margin':'0 0 0 21px'});
	$("#help_213").css({'left':'410px'});
	$("#helpHide").css({'background':'none', 'left':'760px'});
	$("#helpPanel").css({'left':'760px', 'top':'150px','height':'220px'});
	$("#helpHead").css({'background-image':'url("common/images/help/header_no_speech.gif")'});
	$("#helpFoot").css({'background-image':'url("common/images/help/footer_trans.gif")'});

	// Layout JS Tweaks
	$(".tip").hide();
	$("#slide-next").hide();
	$("#next-step").remove();
	$(".right-panel").remove();
	$(".scrollable").width(900);
	$(".scrollable").height(360);
	$(".updatebtn").show();
	$(".cancelbtn").show();
	$("#slideErrorContainer").addClass("revise");
	$("#results-contacting").addClass("revise");

	$("#content").addClass("results");
}

function view_details(id, url){
	ResultsPopup.show(id, url);
	//omnitureReporting(2);
}

</go:script>

<go:script marker="jquery-ui">
	// Display form dynamically
	$("#revise").click(function(){
		//omnitureReporting(3);
		$("#revise").fadeOut();
		$("#moreBtn").addClass('ghost');
		$("#moreBtn").fadeOut();
		format_results_filter();

		$('#page').slideDown(500,function(){
			$('#slide0').slideDown(500);
			// Added because IE doesn't take the hint that we want to show the page :/ (and hide the next buttons)
			//$('#page').addClass('invisible');
		});
	});
</go:script>


<go:script marker="onready">
	$(".updatebtn").click(function(){
		QuoteEngine.validate(true);
		QuoteEngine.poke();
		$("#revise").fadeIn();
		$("#moreBtn").removeClass('ghost');
	});


	$(".cancelbtn").click(function(){
		$("#helpPanel").hide();
		$('#page').slideUp(400, function(){
			$("#revise").fadeIn();
			$("#moreBtn").removeClass('ghost');
		});
	});

	// CSS Resets
	$("#qe-wrapper").addClass('nonresultsform');

</go:script>


<%-- HTML --%>

<div id="resultsPage" class="clearFix">

	<div id="summary-header">
		<h2>Compare Roadside Assistance Quotes</h2>
		<a href="javascript:void(0)" id="revise" class="standardButton greenButton">Revise your details</a>
	</div>

	<div class="clear"></div>
	<!-- add the more btn (itemId Id of container want to scroll too + scrollTo position of that item eg: top or bottom) -->
	<agg:moreBtn itemId="footer" scrollTo="top"/>

	<div id="results-container" style="height:auto; position:relative; clear:both;">


		<div id="results-information">
			<div>
				<h2 id="results-summary">Quotes based on a: <span class="year"></span>&nbsp;<span class="make"></span></h2>
			</div>
		</div>

		<%--
		<div id="left-panel"></div>
		--%>

		<div class="compare-header"></div>
		<div id='sort-icon'></div>
		<div id="results-header">
			<div class="provider">Provider</div>
			<div class="des">Product Name</div>
			<div class="price sortable">Annual Price</div>
			<div class="roadsideCallouts sortable">Annual Callout <br />Limit</div>
			<div class="key">Emergency Key <br />Service</div>
			<div class="towing sortable">Towing Limit <br />City</div>
			<div class="towingCountry sortable">Towing Limit <br />Country</div>
			<div class="link">Application Options</div>
		</div>

		<%-- The results table will be inserted here --%>

			<div id="results-table"></div>
			<core:clear/>



		<%-- TEMPLATE FOR PRICE RESULTS --%>
		<core:js_template id="result-template">
			<div class="result-row" id="result_[#= productId #]" style="display:none;">

				<div class="provider" onclick="javascript:view_details('[#= productId #]', '[#= quoteUrl #]')">
					<div class="thumb"><img src="common/images/logos/roadside/[#= productId #].png" /></div>
				</div>
				<div class="des">
					<h5 id="productName_[#= productId #]"><span onclick="javascript:view_details('[#= productId #]', '[#= quoteUrl #]')" class="productName">[#= des #]</span></h5>
					<span id="productSub_[#= productId #]" class="productSub">[#= subTitle #]</span>
				</div>
				<div class="price" id="price_[#= productId #]">
					<span>[#= priceText #]</span>
				</div>
				<div class="roadsideCallouts" id="roadsideCallouts_[#= productId #]">
					<span>[#= info.roadCall.text #]</span>
				</div>
				<div class="key" id="key_[#= productId #]">
					<span>[#= info.keyService.text #]</span>
				</div>
				<div class="towing" id="towing_[#= productId #]">
					<span>[#= info.towing.text #]</span>
				</div>
				<div class="towingCountry" id="towingCountry_[#= productId #]">
					<span>[#= info.towingCountry.text #]</span>
				</div>

				<div class="link">
					<a id="buybtn_[#= productId #]" href="javascript:applyOnline('[#= productId #]');" class="buybtn button" ><span>Continue Online</span></a>
					<a id="moreinfobtn_[#= productId #]" href="javascript:view_details('[#= productId #]', '[#= quoteUrl #]');" class="moreinfobtn button" ><span>More Info</span></a>
				</div>
			</div>
		</core:js_template>

	</div>


	<%-- PRICE UNAVAILABLE TEMPLATE --%>
	<core:js_template id="unavailable-template">
		<div class="result-row unavailable" id="result_[#= productId #]" style="display:none;">

			<div class="provider">
				<div class="thumb"><img src="common/images/logos/roadside/[#= productId #].png" /></div>
			</div>

			<div class="des">
				<p id="productName_[#= productId #]"><span class="productName"></span></p>
				<p id="productDes_[#= productId #]">[#= message #]</p>
			</div>
			<div class="link"></div>
			<div class="data"></div>
		</div>
	</core:js_template>

	<div class="clear"></div>

</div>