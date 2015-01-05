<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="now" class="java.util.Date" scope="request" />


<%-- Load the params into data --%>



<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

	
<%-- CSS --%>
<go:style marker="css-head">

	#resultsPage a.button-common {
		float: 					right;
		font-size:				9pt;
		font-weight:			bold;
		text-decoration:		none;
		padding: 				11px 10px 10px 35px;
		margin: 				4px 0 0 10px;
		<css:rounded_corners value="6" />
		position: 				relative;
	}

	#resultsPage .button-common:hover {
		cursor: 				pointer;
	}

	#resultsPage .button-common span {
		position: 				absolute;
		left: 					10px;
		top: 					6px;
		width: 					20px;
		height: 				20px;
	}

	#results-container {
		width:920px;
		min-height:420px;
		margin:0 auto;
		padding-top: 20px;
	}
	
	#results-container .moreinfobtn,
	#results-container .buybtn {
		width:110px;
		text-align:center;
		text-shadow: 0 1px 1px rgba(0, 0, 0, 0.5);
		font-weight:bold;
		margin-top: 21px !important;
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
		width:216px;
		float:left;
	}
	#resultsPage {
		display:none;
		position:relative;
	}
	div#results-errors {
		display: none;
		position: relative;
		width: 391px;
		padding: 20px;
		margin: 0 auto 20px auto;
		background: #F8F9FA;
		border:	1px solid #E54200; 
		<css:rounded_corners value="5" />
	}
	div#results-errors p {
		color: #E54200;
	}
	div#results-errors a {
		color: #E54200;
		text-decoration: underline;
		font-size: 100%;
	}
	div#results-error p {
		<css:rounded_corners value="5" />
	}
	div#results-summary {
		position: relative;
		width: 960px;
		height: 100px;
		margin: 0;
		z-index: 0;
	}
	div#results-summary h3{
		position: absolute;
		top: 5px;
		left: 0;
		color: #0CB04D;
	}
	div#results-summary h3 span{
		position: absolute;
		width: 170px;
		top: 0px;
		left:265px;
		color: gray;
		font-size: 11px;
		font-style:italic;
		overflow: visible;
	}
	div#results-summary div.update_provider_plans {
		position:	relative;
		width:	400px;
		height:	42px;
		top: 35px;
		border: 1px solid #cccccc;
		font-family:	"SunLT Bold", "Open Sans", Helvetica, Arial, sans-serif;
		font-size:	14px;
		font-weight:	300;
		padding:	5px;
		background: white url(common/images/results_summary_header/utilities_summary_header_bkg.png) bottom left repeat-x;
		<css:rounded_corners value="6" />
	}

		div#results-summary div.update_provider_plans a {
			position:				absolute;
			right:					5px;
			bottom:					5px;
			color: 					#FFF;
			font-size:				8pt;
			padding:				6px 10px 5px 10px;
			margin: 				4px 0 0 0;
			background:				#009934;
			background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #00B14B), color-stop(100%, #009934));
			background-image: 		-webkit-linear-gradient(#00B14B, #009934);
			background-image: 		-moz-linear-gradient(#00B14B, #009934);
			background-image: 		-o-linear-gradient(#00B14B, #009934);
			background-image: 		linear-gradient(#00B14B, #009934);
			-pie-background: 		linear-gradient(#00B14B, #009934);
			border: 				1px solid #008a25;
			-moz-box-shadow: 		inset 0 1px 0 0 #00C960;
			-webkit-box-shadow: 	inset 0 1px 0 0 #00C960;
			-o-box-shadow: 			inset 0 1px 0 0 #00C960;
			box-shadow: 			inset 0 1px 0 0 #00C960;
		}

		div#results-summary div.update_provider_plans a:hover {
			background:				#00B14B;
			background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #009934), color-stop(100%, #00B14B));
			background-image: 		-webkit-linear-gradient(#009934, #00B14B);
			background-image: 		-moz-linear-gradient(#009934, #00B14B);
			background-image: 		-o-linear-gradient(#009934, #00B14B);
			-pie-background: 		linear-gradient(#009934, #00B14B);
			-moz-box-shadow: 		inset 0 1px 0 0 #ffffff;
			-webkit-box-shadow: 	inset 0 1px 0 0 #ffffff;
			-o-box-shadow: 			inset 0 1px 0 0 #ffffff;
			box-shadow: 			inset 0 1px 0 0 #ffffff;
		}

	div#results-summary div.items{
		float: right;
		height: 85px;
		margin-top: -10px;
	}
	div#results-summary div.items .item{
		position: relative;
		float: right;
		height: 55px;
		padding: 15px 10px;
		background: white url(common/images/results_summary_header/utilities_summary_header_bkg.png) bottom left repeat-x;
	}
	div#results-summary div.items .item.delimeter{
		width: 1px;
		padding: 15px 0;
		background-image: url(common/images/results_summary_header/utilities_summary_header_delimeter.png);
	}
	div#results-summary div.items .item.bestdeal{
		background: white url(common/images/results_summary_header/utilities_summary_header_best_bkg.png) bottom left repeat-x;
	}
	
	div#results-summary div.items .item h5 {
		font-size: 11px;
		color: #BBC0CE;
		margin: 5px 0;
	}
	
	div#results-summary div.items .item p {
		font-size: 12px;
		color: gray;
		font-weight: bold;
		padding-top: 9px;
		background: transparent;
	}
	
	div#results-summary div.items .item p span {
		font-size: 80%;
	}
	
	div#results-summary div.items .item.bestdeal p {
		font-size: 14px;
		color: #0CB04D;
		padding-top: 8px;
	}
	div#results-summary div.items .item.bestdeal p span {
		font-size: 100%;
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
		height: 60px;
	    left: 0px;
	    margin: 0 0 0 0;
	    position: relative;
	    width: 960px;
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
    	width:80px;
    }
	.sortable {
		cursor:pointer;
	}		

	.utilities span.saveupto{
		display: block !important;
		font-size: 12px !important;
	}

	.utilities #results-header div,
	.utilities .result-row > div {
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
	.utilities #results-header div {
		color:#4a4f51;
		font-size:13px;
		font-weight:bold;
		height:40px;
		width: 100px;
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		position:relative;
	}
	.utilities #results-header div.address,
	.utilities #results-header div.price2 {
		border-right:none;
	}
	.utilities .result-row > div {
		height:50px;
		border-bottom: 1px solid #DAE0E4;
    	border-left: 1px solid #DAE0E4;	
	}			
	.utilities .result-row.bestdeal > div {
		background-color: #FFF8F0 !important;
		border-color: #F4A97F !important;
	}		
	.utilities .result-row.beforebestdeal > div {
		border-bottom: 1px solid #F4A97F !important;
	}
	.utilities .result-row h5 {
		font-size: 14px;
	}
	#results-table {
		position:relative;
	    margin:0 0 10px 0;
    	top:0px;
		width:960px; 
	}
	
	/* Container Sizes */
	.utilities #results-container .supplier_and_plan {
		width:290px;	
	}
		.utilities .result-row .supplier_and_plan {
			border-left:none;
			padding-top:0;
			padding-bottom:0;
			width: 365px;
			height:70px;
		}
		.utilities .result-row .supplier_and_plan div{
			float: left;
			margin:5px 0 0 0;
		}
		.result-row div.supplier_and_plan .thumb {
			vertical-align:top;
			width: 72px;
			height: 64px;
			background-color: transparent;
			background-position: 50% 0%;
			background-repeat:	no-repeat;
		}	
		.result-row div.supplier_and_plan .label {
			width: 198px;
			margin-left: 10px;
		}	
		.result-row div.supplier_and_plan .label p {
			color: #0CB24F;
			padding-bottom: 3px;
		}
		.result-row div.supplier_and_plan .label p.title {
			font-weight: bold;
		}
		.result-row div.supplier_and_plan .label p.link {
			color: gray;
		}
		.result-row div.supplier_and_plan .label a {
			font-size:	80%;
			color: gray;
			text-decoration: underline;
		}

	.utilities #results-container .contract_period {
		width:75px;	
	}	
	.utilities #results-container .green_rating {
		width:75px;	
	}	
	.utilities #results-container .green_rating p {
		color: #0CB24F;
	}

	.utilities  #results-container .estimated_saving {
		width:75px;
	}
		.utilities .result-row .estimated_saving {
			background-color:#f8f9fa;
			text-align: center;
			color: #0CB04D;
			font-weight: bold;
			font-size: 16px;
		}
			.utilities .result-row .estimated_saving span{
				display: inline-block;
			}
	.utilities #results-container .max_cancellation_fee {
		width:75px;
	}
	.utilities #results-container .estimated_cost {
		width:75px;
	}
		.utilities #results-container .result-row.unavailable .max_cancellation_fee {
			width:799px;
			line-height:50px;
		}
		.utilities #results-container .result-row.unavailable .link,
		.utilities #results-container .result-row.unavailable .data {
			position:absolute;
			width:0;
			height:0;
			border:none;
			top:0;
			right:0;
		}
	.utilities #results-container .link {
		width:148px;
	}		
		.utilities .result-row .link {
			padding-top:0;
			padding-bottom:0;
			height:70px;
		}	
		#results-table .link a {
			margin: 4px auto;
		}

	#aol-partners {display:block !important;}
	p.results-rows-footer {
		display:none;
		text-align:center;
	}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var Results = new Object(); 
Results = {
	_currentPrices : new Object(), 
	_priceCount : 0,
	_bestPrice: false,
	_estimatedCost : {},
	_initialSort : true, 
	_loadingLeadNo : false, 
	_revising : false,
	_sortBy : false, 
	_sortDir : 'desc',
	_selectedProduct : false,
	_eventMode : false,
	
	// INITIALISATION
	
	
	init : function(){
	
		$('p.results-rows-footer').hide();
		Results.hideErrors();
		Results._initSortIcons();		
	},	
	
	setSelectedProduct : function( product_obj )
	{
		Results._selectedProduct = product_obj;
	},
	
	getSelectedProduct : function()
	{
		return Results._selectedProduct;
	},
	
	getProductByID : function( product_id )
	{
		for(var i=0; i < Results._currentPrices.length; i++)
		{
			if( product_id == Results._currentPrices[i].planId )
			{
				return Results._currentPrices[i];
			}
		}
		
		return false;
	},
	
	updateSelectedProductInfo : function() {
		if( Results._selectedProduct !== false ) {
			Results.updateProductInfo(Results._selectedProduct);
		}
	},

	updateProductInfo : function( product ) {
				logoFileName = "nologo_small.jpg";
		$.extend(product, {LogoFileName: logoFileName});
	},

	continueOnline : function( product_id) {
		Results._selectedProduct = Results.getProductByID( product_id );
		Results.updateSelectedProductInfo();


		UtilitiesQuote.fetchProductDetail( Results._selectedProduct, function(){
			ApplyOnlineDialog.init( Results._selectedProduct, false, true );

			$("#next-step").trigger("click");
		});
	},
	
	viewProduct : function( product_id, no_apply_btn )
	{
		no_apply_btn = no_apply_btn || false;
		Track.onMoreInfoClick( product_id );
		var product = Results.getProductByID( product_id );
		UtilitiesQuote.fetchProductDetail( product, function(){
			ApplyOnlineDialog.init( product, no_apply_btn );
		});
	},
	
	showErrors : function( msgs, transaction_id )
	{
		Results.init();

		transaction_id = transaction_id || false;
		
		$("#results-errors").empty();
		
		for(var i=0; i < msgs.length; i++)
		{
			$("#results-errors").append("<p>" + msgs[i] + "</p>")
		}
		
		$('#page').hide();
		
		$('#resultsPage').fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
			$("#results-table").slideUp("fast", function(){
				$("#results-header").slideUp("fast", function(){
					$("#results-summary").slideUp("fast", function(){
						$("#results-errors").slideDown("fast")
					})
				})
			})
		});
	},	
	
	hideErrors : function() {
	
		$("#results-errors").slideUp("fast", function(){
			$("#results-summary").slideDown("fast", function(){
				$("#results-header").slideDown("fast", function(){
					$("#results-table").slideDown("fast")
				})				
			})
		});
		$('#slideErrorContainer').hide();
	},
	
	eventMode: function() //used with superTag
	{
		switch(Results._eventMode)
		{
			case "Load":
			case "Refresh":
				Results._eventMode = "Refresh";
				break;
			default:
				Results._eventMode = "Load";
				break;
		}
		
		return Results._eventMode;
	},
	
	// SHOW/ANIMATE THE RESULTS
	show : function(){	
	
		Results._updateSummaryText();
		
		// hide or show the estimated savings column if the user is moving in or not
		if(utilitiesChoices._movingIn == 'Y'){
			$('.estimated_cost').removeClass('estimated_saving');
			$('.estcost').removeClass('bestdeal');
			
			$('.estimated_saving, .bestdeal').hide();
			$('.supplier_and_plan').css('width', '440px');
			
			$('.estimated_cost').addClass('estimated_saving');
			$('.estcost').addClass('bestdeal');
			
			Results._sortBy = 'estimated_cost';
			Results._sortDir = 'desc';
		} else {
			$('.estimated_cost').removeClass('estimated_saving');
			$('.estcost').removeClass('bestdeal');
			
			$('.estimated_saving, .bestdeal').show();
			$('.supplier_and_plan').css('width', '365px');
			
			Results._sortBy = 'estimated_saving';
			Results._sortDir = 'asc';
		}
		
		Results.init();
				
		$('#page').hide();
		$('#resultsPage').fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
		});
		
		var rowHeight = 70+1;
		$('#results-table').css('height', Number(Results._currentPrices.length * rowHeight) + 'px');
		
		var delay = 0;
		var fadeTime = 350;
		var container_height = 180;
		var acceleration = 25;
		
		
		$.each(Results._currentPrices, function(key, price){
			element = $('#result_'+price.planId);
			container_height += 71;
			delay += fadeTime;
			element.hide();
			element.delay(delay).show("slide",{direction:"right",easing:"easeInOutQuart"},400);
			if(fadeTime - acceleration >= 0) {
				fadeTime = fadeTime - acceleration;
			}
		});
		
		$('#resultsPage').css({'min-height':container_height+'px'});
		
		var lastRow = $("#results-table .result-row").last();
				
		$(lastRow).queue("fx", function(next) {
			
			if (Results._priceCount == 0) { 
				NoResult.show();
			} else {
				Results.sort(Results._sortBy);
			}
			next();		
		});

		$('p.results-rows-footer').fadeIn('slow');
	},
		
	// GET RESULT
	getResult : function(id){	
		var i =0;
		while (i < Results._currentPrices.length) {
			if (Results._currentPrices[i].planId == id ){
				return Results._currentPrices[i];
			}
			i++;
		}
		return false;
	},
	
	// GET RESULT POSITION	
	getResultPosition : function(id){		
		var i =0;
		while (i < Results._currentPrices.length) {
			if (Results._currentPrices[i].planId == id ){
				return i;
			}
			i++;
		}
		return -1;
	},
	
	// GET TOP POSITION	
	getTopPosition : function(){		
		return Results._currentPrices[0].planId;
	},
	
	// GET BEST PRICE POSITION
	initBestPrice : function(){
	
		var bestPriceIndex 	= 0;
		var bestPrice 		= Results._currentPrices[bestPriceIndex].price;
		
		var i = 0;
		while (i < Results._currentPrices.length) {
			curPriceMax = Results._currentPrices[i].price;
			if (curPriceMax < bestPrice){
				bestPrice = curPriceMax;
				bestPriceIndex = i;
			}
			i++;
		} 
		
		return Results._currentPrices[bestPriceIndex];
		
	},
	
	// Build the summary text based on the entered information.
	_updateSummaryText : function(){
		
		$('#results-summary h3:first span:first').empty();
		if( utilitiesChoices.isEstimateBasedOnStandardTariff() ) {
			$('#results-summary h3:first span:first').append("an assumed standard tariff<br>" + utilitiesChoices.getStandardTariffText());
		}

		var estCost = "";
		
		estCost = "$" + Results._estimatedCost.toFixed(2);


		var details = {
			count:		Results._currentPrices.length,
			postcode:	$("#utilities_householdDetails_postcode").val(),
			estcost:	estCost,
			bestdeal:	"$" + Results._bestPrice.price.toFixed(2)
		};
		
		var output = [];
		output.push("<div class='item postcode'><h5>postcode</h5><p>" + details.postcode + "</p></div>");
		
		var product = $("input[name=utilities_householdDetails_whatToCompare]:checked").val();
		var how		= $("#utilities_householdDetails_howToEstimate").val();
		
		switch( $("#utilities_householdDetails_howToEstimate").val() ) {
			case "U":
				details.peak = {};
				details.offpeak = {};
				details.shoulder = {};
				if( product == "EG" || product == "E" ) {
					details.peak.electricity = {
						amount:	$("#utilities_estimateDetails_usage_electricity_peak_amount").val(),
						period:	$("#utilities_estimateDetails_usage_electricity_peak_period").val()
					};
					details.offpeak.electricity = {
						amount:	$("#utilities_estimateDetails_usage_electricity_offpeak_amount").val() == '' ? '0' : $("#utilities_estimateDetails_usage_electricity_offpeak_amount").val(),
						period:	$("#utilities_estimateDetails_usage_electricity_offpeak_period").val()
					};
					details.shoulder.electricity = {
						amount:	$("#utilities_estimateDetails_usage_electricity_shoulder_amount").val() == '' ? '0' : $("#utilities_estimateDetails_usage_electricity_shoulder_amount").val(),
						period:	$("#utilities_estimateDetails_usage_electricity_shoulder_period").val()
					};
				}
				if( product == "EG" || product == "G" ) {
					details.peak.gas = {
						amount:	$("#utilities_estimateDetails_usage_gas_peak_amount").val(),
						period:	$("#utilities_estimateDetails_usage_gas_peak_period").val()
					};
					details.offpeak.gas = {
						amount:	$("#utilities_estimateDetails_usage_gas_offpeak_amount").val() == '' ? '0' : $("#utilities_estimateDetails_usage_gas_offpeak_amount").val(),
						period:	$("#utilities_estimateDetails_usage_gas_offpeak_period").val()
					};
				}
				break;
			case "S":
				details.spend = {};
				if( product == "EG" || product == "E" ) {
					details.spend.electricity = {
						amount:	$("#utilities_estimateDetails_spend_electricity_amount").val(),
						period:	$("#utilities_estimateDetails_spend_electricity_period").val()
					};
				}
				if( product == "EG" || product == "G" ) {
					details.spend.gas = {
						amount:	$("#utilities_estimateDetails_spend_gas_amount").val(),
						period:	$("#utilities_estimateDetails_spend_gas_period").val()
					};
				}
				break;
			case "H":
				details.household = {
					people:			$("#utilities_estimateDetails_household_people").val(),
					bedrooms:		$("#utilities_estimateDetails_household_bedrooms").val(),
					propertytype:	$("#utilities_estimateDetails_household_propertyType :selected").text()	
				};
				break;
		};
		
		// Render middle columns
		if( details.hasOwnProperty("household") ) {
			output.push("<div class='item household'><h5>people</h5><p>" + details.household.people + "</p></div>");
			output.push("<div class='item household'><h5>bedrooms</h5><p>" + details.household.bedrooms + "</p></div>");
			output.push("<div class='item household'><h5>property type</h5><p>" + details.household.propertytype + "</p></div>");
		} else if( details.hasOwnProperty("spend") ) {
			if( product == "EG" || product == "E" ) {
				output.push("<div class='item spend'><h5>electricity spend</h5><p>$" + details.spend.electricity.amount + "<span>" + Results.getPeriodString(details.spend.electricity.period) + "</span></p></div>");
			}
			if( product == "EG" || product == "G" ) {
				output.push("<div class='item spend'><h5>gas spend</h5><p>$" + details.spend.gas.amount + "<span>" + Results.getPeriodString(details.spend.gas.period) + "</span></p></div>");
			}
		} else if( details.hasOwnProperty("peak") ) {
			var peak = "", offpeak = "", shoulder = "";
			if( product == "EG" || product == "E" ) {
				peak += "<p>" + details.peak.electricity.amount + " <span>kWh" + Results.getPeriodString(details.peak.electricity.period) + "</span></p>";
				offpeak += "<p>" + details.offpeak.electricity.amount + " <span>kWh" + Results.getPeriodString(details.offpeak.electricity.period) + "</span></p>";
				shoulder += "<p>" + details.shoulder.electricity.amount + " <span>kWh" + Results.getPeriodString(details.shoulder.electricity.period) + "</span></p>";
			}
			if( product == "EG" || product == "G" ) {
				peak += "<p>" + details.peak.gas.amount + " <span>MJ" + Results.getPeriodString(details.peak.gas.period) + "</span></p>";
				offpeak += "<p>" + details.offpeak.gas.amount + " <span>MJ" + Results.getPeriodString(details.offpeak.gas.period) + "</span></p>";
			}
			output.push("<div class='item peakusage'><h5>peak usage</h5>" + peak + "</div>");
			output.push("<div class='item offpeakusage'><h5>offpeak usage</h5>" + offpeak + "</div>");
			// only if postcode starts by '2' (NSW and ACT)
			if( utilitiesChoices._postcode.substring(0,1) == '2' && (product == "EG" || product == "E") ){
				output.push("<div class='item shoulderusage'><h5>shoulder usage</h5>" + shoulder + "</div>");
			}
		}
		
		
		// Finish with cost and best deal
		//output.push("<div class='item estcost'><h5>est. cost p.a.</h5><p>" + details.estcost + "</p></div>");
		output.push("<div class='item bestdeal'><h5>best deal</h5><p>" + details.bestdeal + "</p></div>");
		
		var delimeter = "<div class='item delimeter'><!-- empty --></div>";
		
		$('#results-summary').find(".items").first().empty().append( output.reverse().join(delimeter) + delimeter );
		
		if( utilitiesChoices._has_bill === false && utilitiesChoices.isMovingIn() === false && utilitiesChoices.isEstimateBasedOnStandardTariff() ) {
			<%-- Add the update provider plans form if required --%>
			$('#update_provider_plans').remove();
			var form = $('<div/>',{
				id:'update_provider_plans'
			}).addClass('update_provider_plans')
			.append('For a more detailed comparison, please tell us what plan you are on with your current supplier')
			.append(
				$('<a/>', {
					href:	'javascript:void(0);',
					title:	'Edit Provider/Plans',
					id:'open_update_provider_plans'
				}).addClass('button-common').append('Enter plan details')
			);

			$('#results-summary').append(form);

			update_provider_plans.init();
		} else if ( $('#update_provider_plans') ) {
			$('#update_provider_plans').remove();
		}

		Results.negativeValues(details.bestdeal, $('.bestdeal p'), 'zero' );
	},
	
	negativeValues: function(data, tag, task, size){
	
		var formatNegativeMin = /(\-\\$[0-9,]+) \-/;
		var formatNegativeMax = /- (\-\\$[0-9,]+)/;
		var formatDoubleValues =  /\-?(\\$[0-9,]+) \- \-?(\\$[0-9,]+)/;
		
		var color = false;
		if(task.substring(0,1) == '#' && task.length == 7){
			color = task;
			task = 'color';
			formatDoubleValues =  /(\-?\\$[0-9,]+) \- (\-?\\$[0-9,]+)/;
		}
		
		var negative = false;
		var dataString = String(data);
		
		if( formatDoubleValues.test( data )){
			
			if(formatNegativeMin.test( data ) && !formatNegativeMax.test( data )) {
				$(tag).html( data.replace( formatDoubleValues, "<span class='saveupto'>save up to</span><span>$2</span>" ) );
				negative = false;
			} else if(!formatNegativeMin.test( data ) && formatNegativeMax.test( data )) {
				$(tag).html( data.replace( formatDoubleValues, "<span class='saveupto'>save up to</span><span>$1</span>" ) );
				negative = false;
			} else if( formatNegativeMin.test( data ) || formatNegativeMax.test( data ) ){
			$(tag).html( data.replace( formatDoubleValues, "<span>$1</span> - <span>$2</span>" ) );
				negative = true;
				if(task == 'extra') $(tag).html('<span class="extraCost">extra cost</span> <span>' + $(tag).html() + '</span>' );
			}
			
			if( formatNegativeMin.test( data ) && formatNegativeMax.test( data ) ){
				if(task == 'zero') $(tag).html("$0");
			} else if( formatNegativeMin.test( data ) ) {
				if(task == 'zero') $(tag).find('span:first').html("save up to");
				if(task == 'color') tag = $(tag).find('span:first');
			}
			
		} else {

			if(data < 0){
				negative = true;
				if(task == 'zero') $(tag).html("$0"); 
				if(task == 'extra') $(tag).html('<span class="extraCost">extra cost</span> <span class="extraCost">up to</span> $' + dataString.substring(1, dataString.length) );
			}

		}
		
		if(negative == true){
		
			if(task == 'extra'){
				$(tag).css('color', '#4a4f51');
			} else if(task == 'color'){
				$(tag).css('color', color);
			}
		
			if(typeof size != undefined){
				$(tag).css('font-size', size + 'px');
			}
			
		}
	},
	
	getPeriodString : function( code ) {
		switch( code ) {
			case "2":
				return "/2 Months"
			case "M":
				return "/Month";
			case "Q":
				return "/Quarter";
			case "Y":
				return "/Year";
			default:
				return "";
		};
	},
	
	// SORT PRICES
	sort : function(sortBy, animate){
		
		if( animate == undefined ){
			animate = true;
		}
		if (sortBy == Results._sortBy) {
			Results._sortDir = (Results._sortDir=='asc')?'desc':'asc';
		}
		Results._sortBy = sortBy;
		for (var i =0; i < Results._currentPrices.length; i++){
			Results._calcSortValue(Results._currentPrices[i], Results._sortBy);
		}
		
		// Retrieve the prices
		var prices = Results._currentPrices;			
		
		$("#sortTable").html("");
		
		if( Results._sortBy == "supplier_and_plan" )
		{
			sortedPrices = $(prices).sort(Results._sortSupplierAndPlan);
		}
		else if( Results._sortBy == "green_rating" )
		{
			sortedPrices = $(prices).sort(Results._sortGreenRating);
		}
		else if( Results._sortBy == "contract_period" )
		{
			sortedPrices = $(prices).sort(Results._sortContractLength);
		}
		else if( Results._sortBy == "max_cancellation_fee" )
		{
			sortedPrices = $(prices).sort(Results._sortMaxCancellationFee);
		}
		else if( Results._sortBy == "estimated_saving" )
		{
			sortedPrices = $(prices).sort(Results._sortEstimatedSaving);
		}
		else
		{
			sortedPrices = $(prices).sort(Results._sortPrice);
		}
		var rowHeight = 70+1;
		
		$("#results-table .result-row").removeClass("top-result bottom-result");
		
		var newTop = 0;	
		var i = 0;
		var lastRow = sortedPrices.length-1;
		var delay = 0;
		var qs 	= "rankBy="+sortBy+"-"+Results._sortDir+"&rank_count="+sortedPrices.length+"&";
		
		while (i < sortedPrices.length) {		
			Results._currentPrices[i] = sortedPrices[i];
			var prodId= sortedPrices[i].planId;
			
			qs+="rank_product_id"+i+"="+prodId+"&";
			
			// If the is the first time sorting, send the prm as well 
			if (Results._initialSort == true) {
				qs+="rank_premium"+i+"="+sortedPrices[i].price+"&";
			}
			
			var row=$("#result_"+prodId);	
			if (i == 0){
				row.addClass("top-result");
			} else if (i == lastRow) { 			
				row.addClass("bottom-result");
			}
			
			if(animate){
			
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
				
			} else {
				row.css("top", newTop);
			}
			
			delay+=50; 
			newTop+=rowHeight;
			i++;
		}
		
		Results._updateSortIcons();
		Results._initialSort = false;
		qs += "&transactionId="+referenceNo.getTransactionID();
		$.ajax({url:"ajax/write/utilities_quote_ranking.jsp",data:qs});
		btnInit._show();
		Track.onResultsShown(Results.eventMode());
	},
	
	// Sort the prices
	// We do this by comparing each rank in turn and 
	// Attributing a score value based on the selection made
	_sortPrice : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (isNaN(priceA.price)){
			return 1;
		}
		if (isNaN(priceB.price)){
			return -1;
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = 1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = -1;
			
		// No clear winner by score.. default to sort by Estimated Cost
		} else {
			rtn = (priceA.price - priceB.price);
		}
		
		return Results._sortDir=='asc'?rtn*-1:rtn;
	},
	_sortEstimatedSaving : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (isNaN(priceA.yearlySavings)){
			return 1;
		}
		if (isNaN(priceB.yearlySavings)){
			return -1;
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = 1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = -1;
			
		// No clear winner by score.. default to sort by Estimated Cost
		} else {
			rtn = (priceA.price - priceB.price);
		}
		
		return Results._sortDir=='asc'?rtn*-1:rtn;
	},
	_sortSupplierAndPlan : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (!priceA.provider.length){
			return 1;
		}
		if (!priceB.provider.length){
			return -1;
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = -1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = 1;
			
		// No clear winner by score.. default to sort by Estimated Cost
		} else {
			rtn = (priceA.price - priceB.price);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_sortGreenRating : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (isNaN(priceA.info.GreenPercent)){
			return 1;
		}
		if (isNaN(priceB.info.GreenPercent)){
			return -1;
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = -1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = 1;
			
		// No clear winner by score.. default to sort by Estimated Cost
		} else {
			rtn = (priceA.price.Minimum - priceB.price.Minimum);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_sortContractLength : function(priceA, priceB){
	
		
		// If there is no premium - instant FAIL.
		if (!priceA.contractPeriod){
			return 1;
		}
		if (!priceB.contractPeriod){
			return -1;
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = -1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = 1;
			
		// No clear winner by score.. default to sort by Estimated Cost
		} else {
			rtn = (priceA.price - priceB.price);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_sortMaxCancellationFee : function(priceA, priceB){
	
		
		// If there is no premium - instant FAIL.
		if (!priceA.cancellationFees){
			return 1;
		}
		if (!priceB.cancellationFees){
			return -1;
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = -1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = 1;
			
		// No clear winner by score.. default to sort by Estimated Cost
		} else {
			rtn = (priceA.price - priceB.price);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_calcSortValue : function(price, sortBy){
		if (sortBy=='estimated_saving'){
			price.sortValue=price.yearlySavings;
		} else if (sortBy=='estimated_cost'){
			price.sortValue=price.price;
		} else if(sortBy=='green_rating') {
			price.sortValue=price.info.GreenPercent;
		} else if(sortBy=='supplier_and_plan') {
			price.sortValue = price.retailerName.toLowerCase()+price.planName.toLowerCase();
		}  else if(sortBy=='contract_period') {
			price.sortValue = price.contractPeriod == 'None' ? '0' : price.contractPeriod;
		}  else if(sortBy=='max_cancellation_fee') {
			price.sortValue = price.cancellationFees;
		} else {
			price.sortValue = price.price;
		}
	},
	clear : function(){
		Results._currentPrices = new Object();
		Results._initialSort = true;
	},
	update : function(_Jobj){
		prices=[].concat(_Jobj);		
		Results._currentPrices = prices;
		Results._bestPrice = Results.initBestPrice();
		Results.initEstimatedCost();
		
		
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
				
				this.formatted = {
					cancellationFees:		'$' + Number(this.cancellationFees).toFixed(2),
					currentEstimatedCost:	'$' + Number(this.currentEstimatedCost).toFixed(2),
					previousPrice:			'$' + Number(this.previousPrice).toFixed(2),
					price:					'$' + Number(this.price).toFixed(2),
					yearlySavings:			'$' + Number(this.yearlySavings).toFixed(2)
				}

				var newRow = $(parseTemplate(resultTemplate, this));
				Results._priceCount++;				  					
				
				
									
				if (this.price && !isNaN(this.price)){
					// Populate the price tag
					var tag = $(newRow).find("#price_" + this.planId);
					$(tag).show();
				} else {
					$(newRow).find(".apply").hide();
					$(newRow).find("#price_" + this.planId).hide();
				}
				
				var tag = $(newRow).find("#estimatedSaving_" + this.planId);
				
				if(this.price.Maximum == Math.abs(this.yearlySavings)) {
					tag.empty().append("Existing provider/plan not found for comparison. Please revise these details.");
					tag.css({marginTop:'-6px',fontSize:'10px',color:'#4a4f51'});
				} else {
					Results.negativeValues(this.yearlySavings, tag, 'extra', '12' );
				}
				

				// Position the row. 
				$(newRow).css({position:"absolute", top:topPos});
				topPos+=rowHeight;					
													
				var t = $(newRow).text(); 
				if (t.indexOf("ERROR") == -1 ) {
					<%-- UTL-41: Add Continue Online (now Apply Now - UTL-107) button only if available --%>
						var that = this;
					var link = $('<a/>',{
						id:	'continue_online_btn_' + that.planId
							})
							.addClass('moreinfobtn button')
							.append(
						$('<span/>').append(this.available ==  'Y' ? 'Apply Now' : 'More Info')
						);
					if( this.available ==  'Y' ) {
						link.on('click', function(){
							Results.continueOnline( that.planId );
						});
					} else {
						link.addClass('grey').on('click', function(){
							Results.viewProduct( that.planId );
						});
					}
					$(newRow).find('.link:first').empty().append(link);
					<%-- END UTL-41 --%>
					$("#results-table").append(newRow);
					priceShown=true;
				} else {
					FatalErrorDialog.exec({
						message:		"HTML Template Error: " + t,
						page:			"utilities:results.tag",
						description:	"Results.update(). HTML Template Error: " + t,
						data:			this
					});
				}
				
				// add current estimated cost to prices for convenience
				this.currentEstimatedCost = Results._estimatedCost;
			});
		}
		
		// always show the results table (even when no prices returned)
		var resultRows = $("#results-table .result-row");
		$(resultRows).last().addClass("bottom-result");
		$("#results-table").show();
		
	},
	
	initEstimatedCost: function(){
	
		Results._estimatedCost = Results._bestPrice.price+Results._bestPrice.yearlySavings;
		
	},
	_initSortIcons: function(){
		
		$('#results-header .sortable').each(function(){
			if ($(this).find('.sort-icon').length == 0){
				var icon = $('<span></span>')
								.attr('class','sort-icon')
								.attr('style','margin-left:' + ($(this).width()/2 - 5) + 'px;margin-right:' + ($(this).width()/2 - 5) + 'px;');
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
					var sortBy=Results._sortBy?Results._sortBy:'estimated_saving';
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
	},
	
	reviseDetails : function() 
	{
		Results.hideErrors();
		$('.right-panel').not('.slideScrapesContainer').show();
		Results._sortBy = false;
		//QuoteEngine.prevSlide();
		QuoteEngine.gotoSlide({
			index:	0
		});
	}
}

jQuery.fn.sort = function() {  
	return this.pushStack( [].sort.apply( this, arguments ), []);  
};

</go:script>

<go:script marker="onready">

$(document).on('click','a[data-viewproduct=true]',function(){
	Results.viewProduct($(this).data('id'));
});
	
</go:script>


<%-- HTML --%>
	
<div id="resultsPage" class="clearFix">

	<!-- add the more btn (itemId Id of container want to scroll too + scrollTo position of that item eg: top or bottom) -->
	<agg:moreBtn itemId="footer" scrollTo="top"/>	
	
	<div id="results-container" style="height:auto; position:relative; clear:both;">

		<div id="results-errors"><!-- empty --></div>
		<div id="results-summary">
			<h3>Your estimate is based on: <span><!-- empty --></span></h3>
			<div class="items"><!-- empty --></div>
		</div>
		<div class="clear" style="width:100%"><!-- empty --></div>
		<div id='sort-icon'></div>
		<div id="results-header">
			<div class="supplier_and_plan sortable">Supplier and Plan</div>

			<div class="contract_period sortable">Contract Period</div>
			<div class="max_cancellation_fee sortable">Maximum Cancellation Fee</div>
			<div class="estimated_cost sortable">Estimated Cost<br />(1st Year)</div>
			<div class="estimated_saving sortable">Estimated Savings<br />(1st Year)</div>				
			<div class="link"><!-- empty --></div>					
		</div>
	
		<%-- The results table will be inserted here --%>
		
		<div id="results-table"></div>
		<core:clear/>
		<p class="results-rows-footer">Search results do not include every offer from every retailer. Costs and savings include GST &amp; are effective as at <fmt:formatDate value="${now}" pattern="dd/MM/yyyy" /></p>
		
		
		<%-- TEMPLATE FOR PRICE RESULTS --%>
		<core:js_template id="result-template">
			<div class="result-row" id="result_[#= planId #]" style="display:none;">
				<div class="supplier_and_plan">
					<div class="thumb" title="[#= retailerName #]" style="background-image:url(common/images/logos/utilities/[#= retailerId #]_logo.jpg);"><!-- company logo --></div>
					<div class="label">
						<p class="title">[#= retailerName #]</p>
						<p>[#= planName #]</p>
						<a id="viewdetailsbtn_[#= planId #]" href="javascript:void(0);" data-viewproduct="true" data-id="[#= planId #]" data-retailerid="[#= retailerId #]">View Details</a>
					</div>
				</div>			

				<div class="contract_period">
					<p id="contractLength_[#= planId #]">[#= contractPeriod #]</p>
				</div>
				<div class="max_cancellation_fee">
					<p id="maxCancellationFee_[#= planId #]">[#= formatted.cancellationFees #]</p>
				</div>
				<div class="estimated_cost" id="price_[#= planId #]">
					<p id="price_[#= planId #]">[#= formatted.price #]</p>
				</div>
				<div class="estimated_saving">
					<p id="estimatedSaving_[#= planId #]">[#= formatted.yearlySavings #]</p>
				</div>
				<div class="link"><!-- injected dynamically --></div>
				</div>
		</core:js_template>

	</div>

	<div class="clear"></div>
	
</div>