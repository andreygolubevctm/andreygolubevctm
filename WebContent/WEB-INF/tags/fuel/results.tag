<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- CSS --%>
<go:style marker="css-head">

	/* MORE BTN OVERIDE */
	.fuel #moreBtn {
		background:url("common/images/more_btn/more-button-prices.png") center bottom no-repeat;
	}
	
	.fuel .css3-button {
		float: 					right;
		color: 					#FFF;
		font-size:				9pt;
		font-weight:			bold;
		text-decoration:		none;
		padding:				6px 25px 5px 25px;
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
		-moz-border-radius: 	6px;
		-webkit-border-radius:	6px;
		-o-border-radius: 		6px;
		-ms-border-radius: 		6px;
		-khtml-border-radius:	6px;
		border-radius: 			6px;
	}

	.fuel .css3-button:hover {
		cursor: 				pointer;
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

	#results-container {
		min-height:420px;
		margin:0 auto;
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
		min-height: 620px;
	}
	#results-information {
		padding:0;
		padding-top:20px;
		background: url('common/images/results-shadow.png') repeat-x top left;
		height: 60px;
		line-height: 60px;
		position:relative;
		top:-7px;
		margin-left:0;
	}
	#results-information>div {
		margin:0 auto;
		width:780px;
		position:relative;
		padding-left:230px;
	}
	.regional #results-information>div {width:730px;}
	#results-information h2 {
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		color:#0db14b;
		font-weight: normal;
		font-size: 20px;
	}
		#results-information h2 em {
			font-style:normal;
			color:#4a4f51;
		}
		#results-information h2 span {
			color:#4a4f51;
			display:block;
			font-weight:normal;
			font-size:12px;
			line-height:110%;
			margin-top:-15px;
			margin-bottom:20px;
		} 
		#results-information h2 span.error {
			color:#0C4DA2;
		}
		#results-information h2 a {
			font-size:100%;
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
					top:6px;
					padding: 6px 23px;
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
		left: auto;
		width: 780px;
		height: 35px;
		z-index: 0;
		background-position: 0pt -36px;		
		padding-left: 230px;
	}
	.regional div.compare-header{width:730px;}
	/* Results table */
	#results-header {
		height: 40px;
		left: 0px;
		top:-1px;
		margin: 24px auto 0 auto;
		position: relative;
		width: 780px;
		z-index: 0;
		background-color:#FFF;
    	padding-left:230px;    	    
	}
	.regional #results-header {width:730px;}
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

	.fuel .result-row {
		width:775px;
	}
	.fuel .regional .result-row{width:725px;}

	.fuel #results-header div div,
	.fuel .result-row div {
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
	.fuel #results-header div div {
		color:#4a4f51;
		font-size:14px;
		font-weight:bold;
		height:20px;
		line-height:20px;
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		position:relative;
		border-bottom: 1px solid #F4A97F;
	}
	.fuel #results-header div div.address,
	.fuel #results-header div div.price2 {
		border-right:none;
	}
	.fuel .result-row div {
		height:17px;
		border-bottom: 1px solid #DAE0E4;
    	border-left: 1px solid #DAE0E4;		
	}	
	#results-table .link a {
		margin: 4px auto;
	}		
	#results-table {
		position:relative;
		margin:0 auto;
		top:0px;
		width:780px;
		padding-left:230px;
	}
	.regional #results-table{width:730px;}

	/* Container Sizes */
	.fuel #results-container .provider {
		width:150px;
	}
		.fuel .result-row .provider {
			border-left:none;
			font-weight:bold;
			color:#0C4DA2;
		}
	.fuel  #results-container .price1,
	.fuel  #results-container .price2,
	.fuel  #results-container .last_update {
		width:144px;
		text-align:center;
	}	
	.fuel  #results-container .last_update {
		width:124px;
	}
	.fuel  #results-container .price {
		width:60px;
		text-align:center;
	}
		#results-container .result-row .price span,
		#results-container .result-row .price1 span,
		#results-container .result-row .price2 span {
			font-weight:bold;
			color:#0DB14B;
			font-size:14px;
			display:inline-block;
			text-align: center;
			margin-top:2px;
		}	
		.fuel .result-row .price {
			background-color:#f8f9fa;
		}
	.fuel  #results-container .fuel {
		width:78px;
	}
	.fuel  #results-container .address {
		width:208px;
	}
	.fuel  #results-container .mapcol {
		position: relative;
		width:32px;
		padding-left: 6px;
		padding-right: 6px;
	}
	.fuel  #results-header .mapcol {
		padding-left: 10px;
		padding-right: 2px;
	}
	.fuel  #results-container .map {
		width:32px;
		height: 32px;
		border-left: none;
		padding: 3px 0;
		position: absolute;
		right: 6px;
		top: 0;
	}
		.result-row .address .street {
	    	font-weight:normal;
	    	display:block;
	    	margin-bottom:2px;
	    	margin-top:-3px;
	    	font-size:11px;
	    }
	    .result-row .address .suburb, .result-row .address .postcode {
	    	font-weight:bold;
	    }		
		.fuel .result-row .provider, .fuel .result-row .fuel {
			padding-top:0;
			padding-bottom:0;
			height:37px;
		}
		.result-row .provider span, .result-row .fuel span {
			margin-top:1px;
			height:37px;
			display:table-cell;
			vertical-align:middle;
			line-height:110%;
		}
		.fuel .resultsform #fuelTypes .fuel-trigger{
			width: 80px;
		}

	/* Messages */

		.result-row div.message {
			clear:left;
			display:none;
			height:auto;
			padding:10px;
			width:797px;
			border-right:none;
			border-left:none;
		}
		.error-limit .limit.message, .metro .metro.message, .regional .regional.message {
			display:block;
		}	
		.error-limit .metro.message, .error-limit .regional.message {
			display:none;
		}
		.regional .metro, .metro .regional {
			display:none;
		}


	 #times {
	 	position:absolute;
	 	bottom:0px;
	 	left:0px;
	 	width:100%;
	}
		#times .container {	
			text-align:right;
			width:815px;
			margin:0 auto;
			font-size:11px;	
		}
		#times div {
			margin-bottom:.5em;
		}	
		#times #updateTime {
			color:#4E9733;
		}	
		#times #supplier {
			font-size:10px;
			color:#808080;
			margin-top:10px;
		}

	#mapDialog{
		display: none;
	}
	.mapDialogContainer .ui-dialog-titlebar{
		height: 15px;
	}
	.infowindowContainer {
		width: auto;
		height: auto;
		overflow: hidden;
	}
	.infowindowContainer h1{
		margin-bottom: 5px;
	}
  
	.fuel .resultsform #fuelTypes h4,
	.fuel .resultsform #fuelTypes .footer {
		width: 431px;
		margin-left: 1px;
	}

	.fuel .resultsform .fuelForm-cancelbtn {
		margin-right: 130px;
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
	_errorCode : false,
	_source : false,
	
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
				
		if(this._revising){
			$('#aside').animate({ "top": "-=305px" }, {queue: false} );
			$('#page').slideUp(500);
		}else{
			$('#page').fadeOut(300);
		}
		
		$('#resultsPage').delay(200).fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
		});
		
		var delay = 1000;
		var fadeTime = 50;				
		var container_height = 200;
		$("#results-table .result-row").each(function(){
			container_height += 37+1;
			delay += fadeTime;
			$(this).hide();			
			$(this).delay(delay).fadeIn(100);
			
		});
		
		$('#resultsPage').css({'height':container_height+'px'});
		
		var lastRow = $("#results-table .result-row").last();
				
		$(lastRow).queue("fx", function(next) {
			if (Results._priceCount == 0) {
				//omnitureReporting(5);//No results ~ normally a pop-up
			} else {
				Results._sortBy="";
				Results.sort('price');				
			}
			next();		

			fuel_price_history.init();
		});
		
		$('#aside').fadeIn();
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
		$("#results-summary").hide();
		// Build the summary text based on the entered information.
		
		if( $('#results-container').hasClass('regional') ) {
			var txt='Regional price average';
		} else {
			var txt='<em>Your fuel prices in and around';

			var location = $('#fuel_location').val();
			if( isNaN(location.substring(1,5)) ) {
				txt+= ':</em> ' + location;
			} else {
				txt+= ' the postcode: </em>' + location;
			}
		};
		
			

		//There's been a technical delay in getting prices to the DB. Not enough room for both error message and text
		if(Results.errorCode) {
			txt += '<span class="error">We have been experiencing technical problems in getting the latest prices to you.</span>';
		} else if( $('#results-container').hasClass('regional') ) {
			txt = "Regional price average <span>We do not have prices for individual service stations for your area. The prices displayed are yesterday's average fuel prices for some regional cities in your state.</span>";		
		}			
		
		$("#results-summary").html(txt);				
							
		$("#results-summary").fadeIn();		
			
	},	
	// SORT PRICES
	sort : function(sortBy){
		if (sortBy == this._sortBy) {
			this._sortDir = (this._sortDir=='asc')?'desc':'asc';
		}
		this._sortBy = sortBy; 
		
		for (var i =0; i < this._currentPrices.length; i++){
			this._calcSortValue(this._currentPrices[i], this._sortBy);
		}
		
		// Retrieve the prices
		var prices = this._currentPrices;			
		 
		$("#sortTable").html("");
		sortedPrices = $(prices).sort(this._sortPrices);
		
		var rowHeight = 37+1;
		
		$("#results-table .result-row").removeClass("top-result bottom-result");
		
		var newTop = 0;	
		var i = 0;
		var lastRow = sortedPrices.length-1;
		var delay = 0;
		var qs 	= "rankBy="+sortBy+"-"+this._sortDir+"&rank_count="+sortedPrices.length+"&";
		
		while (i < sortedPrices.length) {		
			this._currentPrices[i] = sortedPrices[i];
			var prodId= sortedPrices[i].productId;
			
			qs+="rank_productId"+i+"="+prodId+"&";
			
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
		$.ajax({url:"ajax/write/fuel_quote_ranking.jsp",data:qs});
		//omnitureReporting(1);//Quote Results
		btnInit._show();
		
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
	
		fuel_price_history.hideButton();

		//ADD the error message to the gallery
		if(prices.error != undefined){
			Results.errorCode = prices.error;
		} else {
			Results.errorCode = false;
		}
	
		Results._source = prices.source;
	
		//NEW feature to toggle between price templates
		if(prices.source == 'metro') {
			$('#results-container').addClass('metro');
			$('#results-container').removeClass('regional');
		} else if(prices.source == 'regional') {
			$('#results-container').addClass('regional');
			$('#results-container').removeClass('metro');
				$('#results-header').find('.price1').text(prices.fuel1Text);
				$('#results-header').find('.price2').text(prices.fuel2Text);
		};

		
		if(prices.error == 'limit') {
			$('#results-container').addClass('error-limit');
		} else {
			$('#results-container').removeClass('error-limit');
		}
		
			if(prices.timeDiff != undefined){
				$('#time').html('Prices updated <strong>' + prices.timeDiff + '</strong> ago');
			} else {
				$('#time').html('');
			}
			if(prices.update != undefined){
				$('#updateTime').html('Next update in <strong>' + prices.update + '</strong>');
			} else {
				$('#updateTime').html('');
			}									

		//Swing back to only prices as part of the data
		prices = prices.price;
		
		prices=[].concat(prices);
		
		this._currentPrices = prices;
		
		var resultTemplate		= $("#result-template").html();
		var unavailableTemplate	= $("#unavailable-template").html();
		var regionalTemplate	= $("#regional-template").html();

		var priceShown = false;
		$("#results-table").hide();
		$("#results-table").html("");
		
		Results._priceCount = 0;
		var topPos = 0; 
		var rowHeight = 39+1;  			
		if (prices != undefined) {						
		
			$.each(prices, function() {
				var newRow;

				if (this.available == "Y") {
					
					//Main template switch is here
					if( $('#results-container').hasClass('metro') ){
						if( this.created ) {
							this.created = this.created.replace(/:\d\d\s/, "");
						} else {
							this.created = '';
						}
						newRow = $(parseTemplate(resultTemplate, this));
					} else {
						newRow = $(parseTemplate(regionalTemplate, this));
					}
														
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

		resultRows.find(".mapIcons").on("click", function(){

			var lat = $(this).attr("data-lat");
			var long = $(this).attr("data-long");
			var name = $(this).attr("data-name");
			var address = $(this).attr("data-address");
			var suburb = $(this).attr("data-suburb");
			var postcode = $(this).attr("data-postcode");

			<%-- Replace dialog title with fuel station name --%>
			$("#ui-dialog-title-mapDialog").html( name );

			<%-- reset the show complete callback to the default settings --%>
			var options = $("#mapDialog").dialog("option", "show");
			options.complete = function(){ $("#mapDialog").dialog("option", "position", "center") };
			$('#mapDialog').dialog( 'option', 'show', options );

			<%-- when dialog is open, init/refresh map and its elements --%>
			mapDialog.actionCallback(function(){

			<%-- set up map --%>
				dialogMapHandler.init( lat, long, 16 );

			<%-- delete previous markers --%>
			dialogMapHandler.deleteMarkers();

			<%-- add fuel station marker --%>
			var fuelMarker = dialogMapHandler.addMarker( lat, long, name, "brand/ctm/images/icons/gas_bubble.png" );

			<%-- add info window on click of the marker --%>
			var contentString = '<h1>' + name + '</h1>'+
								'<div>' +
								'<p>' + address + '</p>' +
								'<p>' + suburb + ', ' + postcode + '</p>' +
								'</div>';
			dialogMapHandler.addBubbleToMarker(fuelMarker, contentString);

			<%-- add a button to enable the user to locate himself --%>
			dialogMapHandler.addCurrentLocationMarker(false);

				<%-- add Supertag call to track map opened --%>
				Track.mapOpened();

			}, 'show');

			<%-- open dialog --%>
			mapDialog.open();

		});

		//$(resultRows).first().addClass("top-result");
		$(resultRows).last().addClass("bottom-result");
		$("#results-table").show();
	},
	
	reload : function() {
		
		initialClick = true;
	
		Loading.show("Updating Quotes &nbsp; &nbsp; Back in a tick...");
		Results.clear();
		
		var dat = $("#mainform").serialize();
		$.ajax({
			url: "ajax/json/fuel_price_results.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
			
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
	$("#slide-next").remove();
	$("#next-step").remove();
	$(".right-panel").remove();
	
	$(".scrollable").width(900);
	$(".scrollable").height(340);
	$(".fuelForm-updatebtn").show();
	$(".fuelForm-cancelbtn").show();
	
	$("#slideErrorContainer").addClass("revise");
	$("#results-contacting").addClass("revise");
	
	$("#content").addClass("results");	
		

}

</go:script>

<go:script marker="jquery-ui">
	
	$("#revise").click(function(){
	
		fuel.reduceSelectedToLimit();
		
		//omnitureReporting(3); //revise
		$("#revise").fadeOut();
		$("#moreBtn").addClass('ghost');
		format_results_filter();
		
		$('#aside').animate({ "top": "+=305px" }, {queue: false} );
		
		$('#page').slideDown(500,function(){
			$('#slide0').slideDown(500);			
			// Added because IE doesn't take the hint that we want to show the page :/ (and hide the next buttons)
			$('#page').show();
		});
	});
	
</go:script>


<go:script marker="onready">

	$(".fuelForm-updatebtn").click(function(){
		QuoteEngine.poke();
		QuoteEngine.validate(true);
		$("#revise").fadeIn();
		$("#moreBtn").removeClass('ghost');
	});
	
	$(".fuelForm-cancelbtn").click(function(){
		$("#helpPanel").hide();
		$('#aside').animate({ "top": "-=305px" }, {queue: false} );
		$('#page').slideUp(400, function(){
			$("#revise").fadeIn().show();
			$("#moreBtn").removeClass('ghost');
		});
	});	
	
</go:script>

	





<%-- HTML --%>

	
<div id="resultsPage" class="clearFix">

	<div id="summary-header">
		<h2>Compare Fuel Prices</h2>
		<a href="javascript:void(0)" id="revise" class="css3-button">Revise your details</a>
	</div>

	<div class="clear"></div>
	<!-- add the more btn (itemId Id of container want to scroll too + scrollTo position of that item eg: top or bottom) -->
	<agg:moreBtn itemId="footer" scrollTo="top"/>
	
	<div id="results-container" style="height:auto; position:relative; clear:both;">				
		
		<div id="results-information">
			<div>
				<h2 id="results-summary"></h2>
			</div>
		</div>
		
		<div id="left-panel"></div>
		
		<div class="compare-header"></div>
		<div id='sort-icon'></div>
		<div id="results-header">
			<div class="metro">
				<div class="provider">Provider</div>
				<div class="price sortable">Price</div>
				<div class="fuel">Type</div>
				<div class="address">Address</div>
				<div class="mapcol">Map</div>
				<div class="last_update">Collected</div>
			</div>
			<div class="regional">
				<div class="provider">City</div>
				<div class="price1 sortable">Type</div>
				<div class="price2 sortable"></div>
				<div class="last_update">Collected</div>
			</div>
		</div>

		<%-- The results table will be inserted here --%>
		
			<div id="results-table"></div>
			<fuel:history />
			<div id="scroll-to-point"></div>
			<core:clear/>
		
		
		<%-- TEMPLATE FOR PRICE RESULTS --%>
		<core:js_template id="result-template">
			<div class="result-row" id="result_[#= productId #]" style="display:none;">
				<div class="provider">
					<span>[#= name #]</span>
				</div>
				<div class="price" id="price_[#= productId #]">
					<span>[#= priceText #]</span>
				</div>
				<div class="fuel" id="fuel_[#= productId #]">
					<span>[#= fuelText #]</span>
				</div>
				<div class="address" id="address_[#= productId #]">
					<span class="street">[#= address #]</span>
					<span class="suburb">[#= suburb #]</span>
					<span class="postcode">[#= postcode #]</span>
				</div>
				<div class="mapcol">
					<div class="map">
						<a href="javascript:void(0)" class="mapIcons" title="Locate [#= name #]" data-lat="[#= lat #]" data-long="[#= long #]" data-address="[#= address #]" data-suburb="[#= suburb #]" data-postcode="[#= postcode #]" data-name="[#= name #]">
							<img src="brand/ctm/images/icons/map.png" />
						</a>
					</div>
				</div>
				<div class="last_update" id="last_update_[#= productId #]">
					<span>[#= created #]</span>
				</div>
			</div>
		</core:js_template>
		
		<%-- TEMPLATE FOR REGIONAL RESULTS --%>
		<core:js_template id="regional-template">
			<div class="result-row" id="result_[#= productId #]" style="display:none;">
				<div class="provider">
					<span>[#= city #]</span>
				</div>
				<div class="price1" id="price1_[#= productId #]">
					<span>[#= priceText #]</span>
				</div>
				<div class="price2" id="price2_[#= productId #]">
					<span>[#= price2Text #]</span>
				</div>
				<div class="last_update" id="last_update_[#= productId #]">
					<span>[#= created #]</span>
				</div>
			</div>
		</core:js_template>		

	</div>
	
		
	<%-- PRICE UNAVAILABLE TEMPLATE --%>
	<core:js_template id="unavailable-template">		
		<div class="result-row unavailable" id="result" style="display:none;">
			<div class="limit message">
				<p><strong>Sorry, you have reached your daily limit for searches.</strong></p>
				<p>Please come back tomorrow.</p>
			</div>		
			<div class="metro message">
				<p><strong>Sorry, there is currently no data available for your search.</strong></p>
				<p>Please try again.</p>
			</div>
			<div class="regional message">
				<p><strong>Sorry, there is currently no data available for your fuel type.</strong></p>
				<p>Please try again.</p>
			</div>			
		</div>
	</core:js_template>
	
	<div class="clear"></div>
	
	<%-- Additional Times and Information --%>
	<div id="times">
		<div class="container">
			<div id="time"></div>	
			<div id="updateTime"></div>
			<div id="supplier">Data supplied by Motormouth</div>
		</div>	
	</div>

</div>

<ui:dialog id="map" width="800" height="800" title="Location" titleDisplay="true">
	<ui:google_map id="dialogMap" sensor="true" />
</ui:dialog>