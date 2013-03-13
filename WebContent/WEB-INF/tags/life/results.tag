<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<%-- Load the params into data --%>



<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

	
<%-- CSS --%>
<go:style marker="css-head">

	#results-container {
		width:920px;
		min-height:420px;
		margin:0 auto;
		padding-top: 20px;
	}
	
	#results-container .moreinfobtn, #results-container .buybtn {
		width:80px;
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
	#summary-header {
		position:relative;
		width:920px;	
		height:44px;
		margin:0 auto;	
	}
		#summary-header #revise {
			position:absolute;
			right:0px;
			top:0px;
			color:				#0C4DA2;
			font-size:			16px;
			text-decoration:	none;
		}
		#summary-header h2 {
			color: #4A4F51;
		    font-family: "SunLT Light",Arial,Helvetica,sans-serif;
		    font-size: 22px;
		    font-weight: normal;	
		    line-height:44px;
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
	div#results-errors {
		display: none;
		float: left;
		position: relative;
		width: 391px;
		padding: 20px;
		margin: 0 0 0 20px;
		background: #F8F9FA;
		border:	1px solid #E54200; 
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-khtml-border-radius: 5px;
		border-radius: 5px;
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
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-khtml-border-radius: 5px;
		border-radius: 5px;
	}
	div#results-summary {
		float: left;
		position: relative;
		width: 684px;
		height: 88px;
		margin: 0 0 0 20px;
		z-index: 0;
	}
	div#results-summary p{
		font-size: 110%;
		margin-bottom:3px;
		margin-right: 224px;
	}
	div#results-summary p.sub{
		font-size: 95%;
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
		float: left;
		height: 50px;
	    left: 0px;
	    margin: 15px 0 0 20px;
	    position: relative;
	    width: 684px;
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
	.life #results-header div,
	.life .result-row > div {
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
	.life #results-header div {
		color:#4a4f51;
		font-size:13px;
		font-weight:bold;
		height:30px;
		width: 100px;
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		position:relative;
	}
	.life #results-header div.address,
	.life #results-header div.price2 {
		border-right:none;
	}
	.life .result-row > div {
		height:50px;
		border-bottom: 1px solid #DAE0E4;
    	border-left: 1px solid #DAE0E4;		
	}			
	.life .result-row h5 {
		font-size: 14px;
	}
	#results-table {
		position:relative;
		float: left;
	    margin:0 0 0 20px;;
    	top:0px;
		width:684px; 
	}
	
	/* Container Sizes */
	.life #results-container .provider {
		width:90px;	
	}
		.life .result-row .provider {
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
		max-width:80px;
		max-height:60px;
	}	
	.result-row div.provider p {
		width: 90px;
		text-align: center;
		position: absolute;
		bottom: 5px;
	}
	.life #results-container .name {
		width:90px;	
	}	
	.life #results-container .rating {
		width:85px;	
	}

	.life  #results-container .price {
		width:75px;
	}
		#results-container .result-row .price span {
			font-weight:bold;
			color:#0DB14B;
			font-size:15px;
			display:inline-block;			
			margin-top:2px;
			width:100%;
		}	
		.life .result-row .price {
			background-color:#f8f9fa;
			text-align: center;
		}
	.life #results-container .des {
		width:134px;
	}
		.life #results-container .result-row.unavailable .des {
			width:799px;
			line-height:50px;
		}
		.life #results-container .result-row.unavailable .link,
		.life #results-container .result-row.unavailable .data {
			position:absolute;
			width:0;
			height:0;
			border:none;
			top:0;
			right:0;
		}
	.life #results-container .link {
		width:80px;
	}		
		.life .result-row .link {
			padding-top:0;
			padding-bottom:0;
			height:70px;
		}	
		#results-table .link a {
			margin: 4px auto;
		}

#left-panel .box {
	width:					216px;
	padding:				0;
	margin:					0 0 150px 0;
}

#left-panel .box h4 {
	font-size: 				15pt;
	padding:				10px 0 5px 0;
}

#left-panel h5, #current-results .result-row h5  {
	font-size: 				14px;
}

#left-panel .box h4  {
	position:				relative;
	padding:				7px 0;
}

#left-panel .box h6 {
	position:				relative;
}

#left-panel .box .row {
	width:					auto;
}

#left-panel .box .row.top {
	height:					5px;
}

#left-panel .box .row.mid {
	width:					216px;
	padding:				14px 0px 10px 0px;
}

#left-panel .box.refine-results .row.mid {
	width:					186px;
	padding:				14px 15px 10px 15px;
}

#left-panel .box .row.bot {
	height:					5px;
}

#left-panel .box.refine-results .row.mid .filter {
	position:				relative;
	height:					26px;
	border:					1px solid #E3E8EC;
	padding:				5px 10px;
	margin:					5px 0;
	/*display:				none;*/
}

#left-panel .box.refine-results .row.mid .content{
	margin-top:				10px;
}

#left-panel .box.refine-results .row.mid .filter span{
	line-height:			25px;
}

#left-panel .box.refine-results .row.mid .filter span.title,
#left-panel .box.refine-results .row.mid .filter span.dollar,
#left-panel .box.refine-results .row.mid .filter span.value,
#left-panel .box.refine-results .row.mid .filter input {
	position:				absolute;
}

#left-panel .box.refine-results .row.mid .filter span.dollar{
	left:					64px;
}

#left-panel .box.refine-results .row.mid .filter span.value{
	
	display:				block;
	left:					73px;
}

#left-panel .box.refine-results .row.mid .filter input{
	left:					71px;
	width:					100px;
	display:				none;
}

#left-panel .edit-selection .row.mid {
	width:					206px;
    padding: 				10px 5px 5px 5px;
}

#left-panel .edit-selection a {
    float:					left;
    width:					98px;
    height:					33px;
    cursor:					pointer;
	margin:					2px 2px 2px 55px;
	padding:				0;
    text-decoration: 		none;
}

#left-panel .edit-selection a span {
    display: 				block;
	font-size:				9.5pt;
	font-weight:			bold;
	height: 				100%;
    width: 					100%;
    line-height: 			33px;
    margin:					0;
    padding:				0;
    text-align: 			center;
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
	_selectedProduct : false,
	_eventMode : false,
	
	// INITIALISATION
	
	
	init : function(){
	
		if( $("#navContainer").not("#summary-header") )
		{
			$('#summary-header').appendTo('#navContainer');
		}
		
		$('#steps:visible').hide();
		$('#summary-header:hidden').show();
			
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
			if( product_id == Results._currentPrices[i].product_id )
			{
				return Results._currentPrices[i];
			}
		}
		
		return false;
	},
	
	viewProduct : function( product_id )
	{
		Results._selectedProduct = Results.getProductByID( product_id );
		Track.onMoreInfoClick( product_id );
		LifeQuote.fetchProductSelection("REQUEST-INFO", Results._selectedProduct, LifeProductDialog.launch);
	},
	
	showErrors : function( msgs, transaction_id )
	{
		transaction_id = transaction_id || false;
		
		$("#results-errors").empty();
		
		for(var i=0; i < msgs.length; i++)
		{
			$("#results-errors").append("<p>" + msgs[i] + "</p>")
		}
		
		$('#page').hide();	
		Results.renderRefineResultsDOM();
		
		if( $("#navContainer").not("#summary-header") )
		{
			$('#summary-header').appendTo('#navContainer');
		}
		
		$('#steps:visible').hide();
		$('#summary-header:hidden').show();
		
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
	
		Results.init();		
		Results._updateSummaryText();
				
		$('#page').hide();
		$('#resultsPage').fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
		});
		
		var delay = 1000;
		var fadeTime = 350;				
		var container_height = 180;
		$("#results-table .result-row").each(function(){
			container_height += 71;
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
		while (i < Results._currentPrices.length) {
			if (Results._currentPrices[i].product_id == id ){
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
			if (Results._currentPrices[i].product_id == id ){
				return i;
			}
			i++;
		}
		return -1;
	},
	
	// GET TOP POSITION	
	getTopPosition : function(){		
		return Results._currentPrices[0].product_id;
	},	
	
	// GET THE REFERENCE NUMBER
	getLeadNo : function(id, destDiv){
		var r=Results.getResult(id);
		if (r){
			if (r.leadNo != ""){
				return r.leadNo;
			} else if (r.refnoUrl != ""){
				Results._loadLeadNo(r, destDiv);
			}
		}
		return "";	
	},
	
	_getAge : function( dob ) {	
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
		{
			age--;
		}
		
		return age;
	},
	_updateSummaryText : function(){
		// Build the summary text based on the entered information.
		
		var details = {
			count:		Results._currentPrices.length,
			age:		Results._getAge( $("#life_details_primary_dob").val() ),
			gender:		$("#life_details_primary_gender input[name='life_details_primary_gender']:checked").val() == "F" ? "female" : "male",
			smoker:		$("#life_details_primary_smoker input[name='life_details_primary_smoker']:checked").val() == "Y" ? "smoker" : "non-smoker"
		};
		
		var text = "We have found " + details.count + " quotes for a " + details.age + " year old " + details.gender + ", " + details.smoker + ".";
				
		$('#results-summary').find("p").first().empty().append( text );
	},	
	// SORT PRICES
	sort : function(sortBy){
		
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
		
		if( Results._sortBy == "provider" )
		{
			sortedPrices = $(prices).sort(Results._sortProviders);
		}
		else if( Results._sortBy == "rating" )
		{
			sortedPrices = $(prices).sort(Results._sortRatings);
		}
		else
		{
			sortedPrices = $(prices).sort(Results._sortPrices);
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
			var prodId= sortedPrices[i].product_id;
			
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
		$.ajax({url:"ajax/write/sar_quote_ranking.jsp",data:qs});
		btnInit._show();
		Track.onResultsShown(Results.eventMode());
		
		$('html, body').animate({ scrollTop: 0 }, 'fast');
	},
	
	// Sort the prices
	// We do this by comparing each rank in turn and 
	// Attributing a score value based on the selection made
	_sortPrices : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (isNaN(priceA.value)){
			if (priceB.below_min != "Y"){
				return 1;
			} else {
				return -1;
			}
		}
		if (isNaN(priceB.value)){
			if (priceA.below_min != "Y"){
				return -1;
			} else {
				return 1;
			} 
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = 1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = -1;
			
		// No clear winner by score.. default to sort by price
		} else {
			rtn = (priceA.value - priceB.value);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_sortProviders : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (!priceA.company.length){
			if (priceB.below_min != "Y"){
				return 1;
			} else {
				return -1;
			}
		}
		if (!priceB.company.length){
			if (priceA.below_min != "Y"){
				return -1;
			} else {
				return 1;
			} 
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = -1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = 1;
			
		// No clear winner by score.. default to sort by price
		} else {
			rtn = (priceA.value - priceB.value);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_sortRatings : function(priceA, priceB){
	
		// If there is no premium - instant FAIL.
		if (isNaN(priceA.stars)){
			if (priceB.below_min != "Y"){
				return 1;
			} else {
				return -1;
			}
		}
		if (isNaN(priceB.stars)){
			if (priceA.below_min != "Y"){
				return -1;
			} else {
				return 1;
			} 
		}		
		if (priceA.sortValue < priceB.sortValue){
			rtn = -1;
			
		} else if (priceA.sortValue > priceB.sortValue){
			rtn = 1;
			
		// No clear winner by score.. default to sort by price
		} else {
			rtn = (priceA.value - priceB.value);
		}
		
		return Results._sortDir=='asc'?rtn:rtn*-1;
	},
	_calcSortValue : function(price, sortBy){
		if (sortBy=='price'){
			price.sortValue=0;
		}
		else if(sortBy=='rating') {
			price.sortValue=price.stars;
		}
		else if(sortBy=='provider') {
			price.sortValue = price.company.toLowerCase();
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
		Results._currentPrices = new Object();
		Results._initialSort = true;
	},
	update : function(prices, reference_no){
	
		Results.renderRefineResultsDOM();
		
		prices=[].concat(prices);
		
		Results._currentPrices = prices;
		
		Results._updateSummaryText();
		
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
				
				if (this.below_min == "Y") {
					// Ignore this entry as quote invalid;
					
				} else {
					var newRow = $(parseTemplate(resultTemplate, this));
					Results._priceCount++;				  										
					if (this.value && !isNaN(this.value)){
						// Populate the price tag
						var tag = $(newRow).find("#price_" + this.product_id);
						$(tag).show();						
						
					} else {
						$(newRow).find(".apply").hide();
						$(newRow).find("#price_" + this.product_id).hide();
					}
					
					// Position the row. 
					$(newRow).css({position:"absolute", top:topPos});
					topPos+=rowHeight;					
														
					var t = $(newRow).text(); 
					if (t.indexOf("ERROR") == -1 ) {
						$("#results-table").append(newRow);
						priceShown=true;
					} else {
						FatalErrorDialog.exec({
							message:		"HTML Template Error: " + t,
							page:			"life:results.tag",
							description:	"Results.update().  Price template error occured: " + t,
							data:			this
						});
					}
				}
			});
			
			$("#results-table .rating .stars").each(function(){
				var rating = Number($(this).html());
				StarRating.render($(this), rating);
			});
		}
		
		// always show the results table (even when no prices returned)
		var resultRows = $("#results-table .result-row");
		$(resultRows).last().addClass("bottom-result");
		$("#results-table").show();
		
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
	},
	
	reviseDetails : function() 
	{
		Results.hideErrors();
		Results.renderRefineResultsDOM();
		
		Results._sortBy = false;
		
		$('#summary-header').slideUp("fast", function(){
			$('#steps').slideDown("fast", function(){
				$('#resultsPage').hide("fast", function(){
					/*$(".scrollable").width(639);
					$(".scrollable").height(300);*/
					$('#page').fadeIn("fast", function(){
						QuoteEngine.gotoSlide({
							index:	1
						});
						$("#next-step").show();
					})
				});
			})
		});
	},
	
	refineResultItemClicked: function(event) {
		$(this).hide();
		$("#life_refine_details_primary_insurance_" + event.data.type).toNumber();
		$("#life_refine_details_primary_insurance_" + event.data.type).show();
		$("#life_refine_details_primary_insurance_" + event.data.type).on("change keyup", {type:event.data.type}, Results.showHideUpdateResultsButton);
	},
	
	renderRefineResultsDOM: function() {
		var list = ['term','tpd','trauma'];
		
		for(var i = 0; i < list.length; i++)
		{
			var type = list[i];
			if( $("#life_cover_" + type).is(":checked") )
			{
				$("#life_refine_details_primary_insurance_" + type).hide();
				
				$("#life_details_primary_insurance_" + type + "_refine_row").find(".value").first().empty()
				.append( $("#life_details_primary_insurance_" + type).val() )
				.on("click", {type:type}, Results.refineResultItemClicked)
				.show();
				
				$("#life_refine_details_primary_insurance_" + type).val( $("#life_details_primary_insurance_" + type).val());
				
				$("#life_refine_details_primary_insurance_" + type).formatCurrency('.life_refine_details_primary_insurance_' + type + '_value', {symbol:'',roundToDecimalPlace:-2});
				
				$("#life_details_primary_insurance_" + type + "_refine_row").show();
			}
			else
			{
				$("#life_details_primary_insurance_" + type + "_refine_row").hide();
			}
		}
		
		$("#submit_update_results").hide();
	},
	
	submitRefineResults: function() {
		var list = ['term','tpd','trauma'];
		
		for(var i = 0; i < list.length; i++)
		{
			var type = list[i];
			if( $("#life_cover_" + type).is(":checked") )
			{
				if( !isNaN($("#life_refine_details_primary_insurance_" + type).val()) && $("#life_refine_details_primary_insurance_" + type).val() > 0)
				{
					$("#life_details_primary_insurance_" + type + "entry").val( $("#life_refine_details_primary_insurance_" + type).val() ).trigger("blur");
					
					$("#life_refine_details_primary_insurance_" + type).hide();
					
					$("#life_details_primary_insurance_" + type + "_refine_row").find(".value").first().empty().append(
						$("#life_refine_details_primary_insurance_" + type).val()
					).show();
					
					$("#life_refine_details_primary_insurance_" + type).formatCurrency('.life_refine_details_primary_insurance_' + type + '_value', {symbol:'',roundToDecimalPlace:-2});					
					
				}
			}
		}
		
		Results._sortBy = false;
		
		LifeQuote.fetchPrices();
	},
	
	showHideUpdateResultsButton : function(event) {
	
		var value = $("#life_refine_details_primary_insurance_" + event.data.type).val();
		if( String(value).length && !isNaN(value) && value > 0 )
		{
			$("#life_refine_details_primary_insurance_" + event.data.type).val( parseInt(value) );
			
			var list = ['term','tpd','trauma'];
			
			var hide = true;
			
			for(var i = 0; i < list.length; i++)
			{
				var type = list[i];
				if( $("#life_cover_" + type).is(":checked") )
				{
					if( $("#life_details_primary_insurance_" + type).val() != $("#life_refine_details_primary_insurance_" + type).val() )
					{
						hide = false;
					}
				}
			}
			
			if( hide )
			{
				$("#submit_update_results").slideUp("fast");
			}
			else
			{
				$("#submit_update_results").slideDown("fast");
			}
		}
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
	$("#next-step").hide();
	$(".right-panel").remove();	
	$(".scrollable").width(900);
	$(".scrollable").height(360);
	$(".updatebtn").show();
	$(".cancelbtn").show();
	$("").addClass('.invisible');		
	$("#slideErrorContainer").addClass("revise");
	$("#results-contacting").addClass("revise");
	
	$("#content").addClass("results");	
}

function view_details(id, url){
	ResultsPopup.show(id, url);
	//omnitureReporting(2);
}

$.validator.addMethod("isTermCoverANumber",
	function(value, element) {	
		if(  value && value.length > 0 )
		{
			value = Number(value)
			if( !isNaN(value) && value > 0 )
			{
				return true;
			}
		}
		return false;		
	},
	"Term life cover must be number greater than zero."
);

$.validator.addMethod("isTPDCoverANumber",
	function(value, element) {	
		if(  value && value.length > 0 )
		{
			value = Number(value)
			if( !isNaN(value) && value > 0 )
			{
				return true;
			}
		}
		return false;		
	},
	"TPD cover must be number greater than zero."
);

$.validator.addMethod("isTraumaCoverANumber",
	function(value, element) {	
		if(  value && value.length > 0 )
		{
			value = Number(value)
			if( !isNaN(value) && value > 0 )
			{
				return true;
			}
		}
		return false;		
	},
	"Trauma cover must be number greater than zero."
);

</go:script>

<go:script marker="onready">

	$(".updatebtn").click(function(){
		QuoteEngine.validate(true);
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
	
	$("#submit_update_results").on("click", Results.submitRefineResults);
	
</go:script>


<%-- HTML --%>
	
<div id="resultsPage" class="clearFix">

	<!-- add the more btn (itemId Id of container want to scroll too + scrollTo position of that item eg: top or bottom) -->
	<agg:moreBtn itemId="footer" scrollTo="top"/>	
	
	<div id="results-container" style="height:auto; position:relative; clear:both;">

		<div id="summary-header">
			<div>
				<h2>Compare results and premium estimates <a href='javascript:Results.reviseDetails()' id="revise" title="Revise your details">Revise your details</a></h2>
			</div>
		</div>
		
		<div id="left-panel">
			<div class="box refine-results">
				<div class="row top"><!-- empty --></div>
				<div class="row mid">
					<div class="content">
						<h3>Refine your results</h3>
						<div id="life_details_primary_insurance_term_refine_row" class="filter term">
							<span class="title">Term life:</span>
							<span class="dollar">$</span>
							<span class="value life_refine_details_primary_insurance_term_value"><!-- empty --></span>
							<input type="text" name="life_refine_details_primary_insurance_term" id="life_refine_details_primary_insurance_term" value="" />
						</div>
						<div id="life_details_primary_insurance_tpd_refine_row" class="filter tpd">
							<span class="title">TPD:</span>
							<span class="dollar">$</span>
							<span class="value life_refine_details_primary_insurance_tpd_value"><!-- empty --></span>
							<input type="text" name="life_refine_details_primary_insurance_tpd" id="life_refine_details_primary_insurance_tpd" value="" />
						</div>
						<div id="life_details_primary_insurance_trauma_refine_row" class="filter trauma">
							<span class="title">Trauma:</span>
							<span class="dollar">$</span>
							<span class="value life_refine_details_primary_insurance_trauma_value"><!-- empty --></span>
							<input type="text" name="life_refine_details_primary_insurance_trauma" id="life_refine_details_primary_insurance_trauma" value="" />
						</div>
						<a href="javascript:void(0);" id="submit_update_results" class="button"><span>Update Results</span></a>
					</div>
				</div>
				<div class="row bot"><!-- empty --></div>
			</div>
		</div>
		<div id="results-errors"><!-- empty --></div>
		<div id="results-summary">
			<%--<form:reference_number id="results_reference_number" preserveTranId="${true}"/>--%>
			<p><!-- empty --></p>
			<p class="sub">These quotes have been provided by Lifebroker, a trusted partner of <strong>Compare</strong>the<strong>market</strong>.com.au.</p>
		</div>
		<div id='sort-icon'></div>
		<div id="results-header">
			<div class="provider sortable">Insurer</div>
			<div class="rating sortable">Rating</div>
			<div class="name">Product Name</div>
			<div class="des">Description</div>
			<div class="price sortable">Premium<br />(<span id="results_premium_frequency">Monthly</span>)</div>				
			<div class="link"><!-- empty --></div>					
		</div>
	
		<%-- The results table will be inserted here --%>
		
			<div id="results-table"></div>
			<core:clear/>
		
		
		
		<%-- TEMPLATE FOR PRICE RESULTS --%>
		<core:js_template id="result-template">
			<div class="result-row" id="result_[#= product_id #]" style="display:none;">			
				<div class="provider">
					<div class="thumb" title="[#= company #]"><img src="common/images/logos/life/80x60/[#= thumb #]" /></div>
				</div>			
				<div class="rating">
					<div class="stars">[#= stars #]</div>
				</div>
				<div class="name">
					<p id="productName_[#= product_id #]">[#= name #]</p>
				</div>
				<div class="des">
					<p id="productName_[#= product_id #]">[#= description #]</p>
				</div>
				<div class="price" id="price_[#= product_id #]">
					<span>$[#= price #]</span>
				</div>
				<div class="link">
					<a id="moreinfobtn_[#= product_id #]" href="javascript:Results.viewProduct('[#= product_id #]');" class="moreinfobtn button" ><span>More Info</span></a>
				</div>
			</div>
		</core:js_template>

	</div>


	<%-- PRICE UNAVAILABLE TEMPLATE --%>
	<core:js_template id="unavailable-template">
		<div class="result-row unavailable" id="result_[#= product_id #]" style="display:none;">
		
			<div class="provider">
				<div class="thumb"><img src="common/images/logos/roadside/[#= product_id #].png" /></div>
			</div>
			
			<div class="des">
				<p id="productName_[#= product_id #]"><span class="productName"></span></p>
				<p id="productDes_[#= product_id #]">[#= message #]</p>
			</div>			
			<div class="link"></div>			
			<div class="data"></div>
		</div>
	</core:js_template>
	
	<div class="clear"></div>
	
	<life:star_rated />
	<life:popup_product />
	<life:popup_callbackconfirm />
	
</div>

<%-- VALIDATION --%>
<go:validate selector="life_refine_details_primary_insurance_term" rule="isTermCoverANumber" parm="true" message="Term life cover must a number greater than zero." />
<go:validate selector="life_refine_details_primary_insurance_tpd" rule="isTPDCoverANumber" parm="true" message="TPD cover must a number greater than zero." />
<go:validate selector="life_refine_details_primary_insurance_trauma" rule="isTraumaCoverANumber" parm="true" message="Trauma cover must a number greater than zero." />