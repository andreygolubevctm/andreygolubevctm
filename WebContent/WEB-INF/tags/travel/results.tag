<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="policyType" required="true"  rtexprvalue="true"	 	 description="Single or Annual Policy"%>

	
<%-- CSS --%>
<go:style marker="css-head">

	.wrapper { width: 900px; margin: 0 auto; }
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
	    background: url("common/images/results-shadow-header.png") repeat-x scroll left bottom #F4F4F4
	    height: 60px;
	    line-height: 60px;
	    padding: 0 40px;
	    position: relative;
	    margin-bottom: 30px;
	}
	#results-information > div {
	    margin: 0 auto;
	    width: 900px;
	    padding-top:10px;
	}
	#results-information h2 {
	    display: inline;
	    font-size: 20px;
	    font-weight: bold;
	}
	#summary-header {
		position:relative;
		width:960px;	
		height:44px;
		padding:10px 0;
		margin:0 auto;	
	}
		#summary-header #revise {
			position:absolute;
			right:0px;
			top:24px;
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
	    height: 40px;
	    margin: 0 auto;
	    width: 900px;
		z-index: 9;
    	border-bottom: 1px solid #F4A97F;	    
		background-color: #fff;
	}
	#results-header div {
	    float: left;
	    font-size: 11px;
	    font-weight: bold;
	    height: 30px;
	    margin-right: -1px;
	    padding-left: 0;
	    padding-top: 10px;
	    text-align: center;
		position:relative;
	}
	.results-header { position: relative;}

	.fixed { position:fixed;top: 0; }

	#results-header div.sortable:hover {

	}
	#results-header .link {
    	border-right:none;
    	text-align:center;
    	width:92px;
    }
	.sortable {
		cursor:pointer;
	}
	/* RESULT ROW STYLING */
	.result-row .price {
    	color: #0CB04D;
    	font-weight: bold;
	}
	.result-row .luggage,.result-row .des,.result-row .medical {
	    background-color: #F8F9FB;
	}
	div.provider {
		width: 117px;
	}
	div.des {
		padding-top: 8px;
		width: 160px;
		height:62px;
	}
		div.des .productName {
			padding-left:14px;
			padding-right:14px;
		}
		.result-row div.des .message {
			line-height:30px;
		}
	div.price {
		font-size: 16px;
		padding-top: 13px;
		width: 100px;
		height:57px;
	}
	div.excess {
		padding-top: 16px;
		height:54px;
		width:90px;
	}
	div.medical {
		padding-top: 16px;
		height:54px;
		width: 125px;
	}
	.result-row div.link {
		width: 110px;
		height:70px;
		border-right:none;
		margin-right:-10px;
	}
	div.cxdfee {
		width:100px;
		padding-top: 16px;
		height:54px;
	}
	div.luggage {
		padding-top: 16px;
		width: 105px;
		height:54px;
	}	
	.result-row div.data {
		border-right:none;
	}
	#results-table .link a {
		margin: 4px auto;
	}
	#results-table a.apply-online {
		background: transparent url('common/images/button-apply-online.png') no-repeat;
	}
	#results-table a.apply-online:hover {
		background: transparent url('common/images/button-apply-online-on.png') no-repeat;
	}
		
	#results-table {
		position:relative;
	    margin:0 auto;
    	top:1px;
		width:900px; 
	}
	.result-row {
		width:900px;
		/*padding-top:3px;*/
		margin-left:2px;
		background-color:white;
		height:69px;
		overflow:hidden;
		border-bottom: 1px solid #dae0e4;
	}
	.result-row>div {
		text-align:center;
		border-right: 1px solid #dae0e4;
		height:69px;
		display:inline-block !important;
		vertical-align: top;
		*zoom:1;
		*display:inline;
		-moz-box-sizing: border-box;
	}		
	.result-row div.provider .thumb {
		height: 60px;
		text-align: center;
		background-color: #fff;
		border: 0;
		vertical-align:top;
		margin-top:5px;
	}
	.result-row div.provider .thumb img{
		width:79px;
		height:60px;
	}
	.result-row div.des h5{
		display: inline-block;
		margin-bottom: 4px;
		zoom:1;
		*display:inline;
	}
	.result-row div.des span.productSub{
		font-size:9px;
		color:#666666;
	}		
	.result-row div.des span.productSub a{
		text-decoration:none;
		color:#0554EC;
	}
	.result-row div.des span.productSub a:hover{
		text-decoration:underline;
	}
	
	.result-row div.des p{
		font-size: 11px;
		color: #000000;
		line-height: 120%;	
	}	
	.result-row div.des p a{
		color: #777777;	
		font-size: 9px;
		float:right;
		margin-right:5px;
		margin-bottom:0px;
	}	
	
	.result-row div.productName span {
		font-weight:normal;
	}
	.result-row div.link a {
		position:relative;
	}
	.result-row div {
		margin-left: -4px;
	}	
	.productName {
		color: #0C4DA2;
		cursor: pointer;
		display: block;
		font-family: Helvetica,Arial,sans-serif;
		font-size: 11px;
		font-weight: bold;
		margin-top: 8px;
    }
	.unavailable .thumb {
		opacity:0.5;
		filter:alpha(opacity=50);	
	}
	.unavailable div.des {
		width: 675px;
		padding-right:5px;
	}
	.unavailable div.des p {
		color:#7F7F7F;
		font-size: 13px;
		margin-top:10px;
		font-weight:bold;
		width:auto; 	
	}
    #loading3 {
    	width:60px;
    	height:19px;
    	display:inline-block;
    	background: url("common/images/loading3.gif") no-repeat scroll left top transparent;
    }
    #revise{
    	top:0;
    }
    .sort-icon {
		bottom:2px;
	}

	.subLimits {
		color: #777;
		font-weight: normal;
		font-size: 11px;
    	display:block;
    }
    
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var Results = new Object(); 
Results = {
	_currentPrices : new Object(), 
	_priceCount : 0,
	_initialSort : true, 
	_incrementTransactionId	: false,
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

			offset = $('#results-header').offset();
		}		

//		if(!$('#retarget').length){
//			$('#resultsPage').append('<img id="retarget" src="https://tags.rtbidder.net/convert?sid=4f70eb188bc06f0bc4b1f562" width="0" height="0" border="0" alt="" style="visibility:hidden" />');
//		}		
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
		this.init();
		
		this._updateSummaryText();
				
		if(this._revising){
			$('#page').slideUp(500);
		}else{
			$('#page').fadeOut(300);
		}
		
		$('#resultsPage').delay(200).fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
		});
		
		var delay = 100;
		var fadeTime = 100;				
		var container_height = 200;
		var i = 0;
		var rowsAdded=0;
		$("#results-table .result-row").each(function(){
			container_height += 70;
			$(this).hide();
			if (rowsAdded < 12){
				delay += fadeTime;
				rowsAdded++;
				$(this).delay(delay).show("slide",{direction:"right",easing:"easeInOutQuart"},400);
			} else {
				$(this).delay(delay).show();
			}
		});
		
		$('#resultsPage').css({'height':container_height+'px'});
		
		var lastRow = $("#results-table .result-row").last();
				
		$(lastRow).queue("fx", function(next) {
			if (Results._priceCount == 0) { 
				NoResult.show();
			} else {
				<%-- Ensure sortBy preference is maintained through subsequent results requests--%>
				var thisSort = Results._sortBy || 'price';
				Results._sortBy = false;
				Results.sort(thisSort);
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
		$("#results-summary").hide();
		// Build the summary text based on the entered information.
		var txt='Your quote is based on: <span>';
		
		var adults = $('#travel_adults').val();
		if (adults==1){
			txt+="1 adult";
		} else {
			txt+=adults +" adults ";
		}
		
		if ($('#travel_children').val() == 1){
			txt+=' and 1 child';
		} else if ($('#travel_children').val() > 0){
			txt+=' and ' + $('#travel_children').val() + ' children'; 
		}
		<c:choose>
			<c:when test="${policyType == 'S'}">
				txt +=' travelling to ';
				var chkCount =$('.destcheckbox:checked').length;
				
				if ($('#travel_destinations_do_do').is(':checked')){
					txt += "any country";
				} else if (chkCount > 1){
					txt += chkCount + " destinations";
				} else {
					var chkId=$('.destcheckbox:checked').first().attr('id');
					txt += $('label[for='+chkId+']').text();
				}
				
		        var x=$('#travel_dates_fromDate').val().split("/");     
		        var y=$('#travel_dates_toDate').val().split("/");
		        var date1=new Date(x[2],(x[1]-1),x[0]);  
		        var date2=new Date(y[2],(y[1]-1),y[0])
		               
		        var DAY=1000*60*60*24;
		        var days=1+Math.ceil((date2.getTime()-date1.getTime())/(DAY)); 
				
				txt += " for "+days+" days";
			</c:when>
			<c:otherwise>
				txt+=" travelling to multiple destinations in one year";
			</c:otherwise>
		</c:choose>
		$("#results-summary").html(txt+'</span>');		
		$("#results-summary").fadeIn();
	},	
	// SORT PRICES
	sort : function(sortBy){

		$("#results-header").attr('data-inprogress', '1');

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
		
		var rowHeight = 70;
		
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

				<%-- If initial sort and is best price result then add best price data --%>
				if(sortedPrices[i].hasOwnProperty('best_price') && sortedPrices[i].best_price === true) {
					data["best_price" + i] = 1;
					data["best_price_productName" + i] = sortedPrices[i].name;
					data["best_price_excess" + i] = sortedPrices[i].info.excess.text;
					data["best_price_medical" + i] = sortedPrices[i].info.medical.text;
					data["best_price_cxdfee" + i] = sortedPrices[i].info.cxdfee.text;
					data["best_price_luggage" + i] = sortedPrices[i].info.luggage.text;
					data["best_price_price" + i] = sortedPrices[i].priceText;
					data["best_price_url" + i] = sortedPrices[i].quoteUrl;
			}
			}
			
			var row=$("#result_"+prodId);	
			$(row).attr('data-index', i);
			if (i == 0){
				row.addClass("top-result");
			} else if (i == lastRow) { 			
				row.addClass("bottom-result");
			}
			
				// Exploder (all versions) just mangles the content when opacity is applied
				// so no nice fades :( 
				if ($.browser.msie || $(row).hasClass("unavailable")) {
				row.delay(delay).animate({ top:newTop }, 400, 'easeInOutQuart', function(){
						var animationCount = $(this).attr('data-index');
						if(animationCount == lastRow-1){
							$("#results-header").attr('data-inprogress', '0');
						}
					}
				);
					
				// Every one else gets gorgeous fading..  
				} else {
					row.delay(delay)
					.fadeTo(50,0.5)
						.animate({ top:newTop }, 400, 'easeInOutQuart')
					.fadeTo(50,1.0, function(){
						var animationCount = $(this).attr('data-index');
						if(animationCount == lastRow-1){
							$("#results-header").attr('data-inprogress', '0');
				}
				
					});
			}

			delay+=10;

			newTop+=rowHeight;
			i++;
		}
		Results._updateSortIcons();
		Results._initialSort = false;
		$.ajax({
			url :		"ajax/write/travel_quote_ranking.jsp",
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
		btnInit._show();
		Track.resultsShown(Results.eventMode());
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
		var rowHeight = 70;  			
		if (prices != undefined) {
			$.each(prices, function() {
				var newRow;
				if (this.available == "Y") {
				
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
			url: "ajax/json/travel_quote_results.jsp",
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
				FatalErrorDialog.display("An error occurred when fetching prices :" + txt, dat);
			},
			timeout:50000	
		});	
	},
	_initSortIcons: function(){
		
		$('#results-header .sortable').each(function(){
			if ($(this).find('.sort-icon').length == 0){
				var icon = $('<span></span>')
								.attr('class','sort-icon');
								//.css({width:$(this).css('width')});
				$(this).append(icon);
				
				$(this).click(function(){

					if($("#results-header").attr('data-inprogress') == '1'){
						// Stop the current sort before continuing.
						$( ".result-row" ).stop(true, true);
					}

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
	$("#qe-wrapper").css({'background':'none', 'margin':'0 0 0 21px', 'width':'900px'});

	// TRV-28: Hide the contact details section
	$("#contactDetails").css({'display':'none'});

	// Layout JS Tweaks
	$(".tip").hide();
	$("#slide-next").remove();
	$("#next-step").remove();
	$(".right-panel").remove();	
	
	$(".scrollable").width(900);
	$(".scrollable").height(800);
	$(".updatebtn").show();
	$(".cancelbtn").show();
	
	$("#slideErrorContainer").addClass("revise");
	$("#results-contacting").addClass("revise");
	$(".qe-window").addClass("revise");
	
	$("#content").addClass("results");	
		
		
	
	// Policy specific tweaks
	<c:choose>
		<c:when test="${policyType == 'A'}">
			$("#qe-wrapper").addClass('resultsform_annual');
			$("#content").height(275);
			$("#enquirerName").css({'display':'none'});
			$("#emailRow").css({'display':'none'});
			$("#marketingRow").css({'display':'none'});
		</c:when>
		<c:otherwise>
			$("#content").height(380);
		</c:otherwise>
	</c:choose>	
}

function view_details(id, url, custInfo){
	ResultsPopup.show(id, url, custInfo);
	////omnitureReporting(2)
}

</go:script>

<go:script marker="onready">
	var headerTop = 282;
	var headerTopRevised = 663;

	var offset = headerTop;

	// Fix the result header
	$(window).bind('scroll', function() {
		if ($(window).scrollTop() > offset) {
			$('#results-header').addClass('fixed');
		}
		else {
			$('#results-header').removeClass('fixed');
		}
	});
		
	// Display form dynamically
	$("#revise").click(function(){
		////omnitureReporting(3)
		$("#revise").fadeOut();
		$("#moreBtn").addClass('ghost');
		$("#moreBtn").fadeOut();		
		format_results_filter();
		
		$('#page').slideDown(500,function(){
			$('#slide0').slideDown(500);
			// Added because IE doesn't take the hint that we want to show the page :/ (and hide the next buttons)
			$('#page').show();

			headerTopRevised = $('#results-header').offset().top;
			offset = headerTopRevised;
	});
	

	});


	$(".updatebtn").click(function(){
		Results.clear();
		Results._incrementTransactionId = true;
		QuoteEngine.poke();
		QuoteEngine.validate(true);
		$("#revise").fadeIn();
		$("#moreBtn").removeClass('ghost');

		offset = headerTop;
	});
	
	$(".cancelbtn").click(function(){
		$("#helpToolTip").hide();
		$('#page').slideUp(400, function(){
			$("#revise").fadeIn().show();
			$("#moreBtn").removeClass('ghost');
		});

		offset = headerTop;
	});
	

	
	// CSS Resets
//	$(".qe-window.content").css({});
//	$(".qe-window h4").css({});
//    $("#qe-wrapper").css({'height':'420px', 'left':'0', 'margin':'0 0 0 61px', 'padding':'17px', 'position':'absolute', 'top':'0'});
	$("#qe-wrapper").addClass('nonresultsform');
	
	
	
	
	
	
	
</go:script>

	





<%-- HTML --%>

	
<div id="resultsPage" class="clearFix">

	<div id="summary-header">
		<h2>Compare Travel Quotes</h2>
		<a href="javascript:void(0)" id="revise">Revise your details</a>
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
		
		<div class="wrapper">
		<div id="left-panel"></div>
		
		<div class="compare-header"></div>
		<div id='sort-icon'></div>
		<div id="results-header" class="results-header">
			<div class="provider">Provider</div>
			<div class="des">Policy Name</div>
			<div class="excess sortable">Excess<br /><br /></div>
			<div class="medical sortable">Overseas<br /> Medical Expenses</div>
			<div class="cxdfee sortable">Cancellation<br />Fee Cover</div>
			<div class="luggage sortable">Luggage &amp; Personal Effects</div>
			<div class="price sortable">Price<br /><br /></div>
			<div class="link">Your Options</div>							
		</div>
	
		<%-- The results table will be inserted here --%>
		
			<div id="results-table"></div>
			<div id="scroll-to-point"></div>
			<core:clear/>
		
		
		<%-- TEMPLATE FOR PRICE RESULTS --%>
		<core:js_template id="result-template">
			<div class="result-row" id="result_[#= productId #]" style="display:none;">
			
				<div class="provider" onclick="javascript:view_details('[#= productId #]', '[#= quoteUrl #]')">
					<div class="thumb"><img src="common/images/logos/travel/[#= productId #].png" /></div>
				</div>
				<div class="des">
					<h5 id="productName_[#= productId #]"><span onclick="javascript:view_details('[#= productId #]', '[#= quoteUrl #]')" class="productName">[#= des #]</span></h5>
					<span id="productSub_[#= productId #]" class="productSub">[#= subTitle #]</span>
				</div>
				<div class="excess" id="excess_[#= productId #]">
					<span>[#= info.excess.text #]</span>
				</div>
				<div class="medical" id="medical_[#= productId #]">
					<span>[#= info.medical.text #]</span>
				</div>
				<div class="cxdfee" id="cxdfee_[#= productId #]">
					<span>[#= info.cxdfee.text #]</span>
				</div>
				<div class="luggage" id="luggage_[#= productId #]">
					<span>[#= info.luggage.text #]</span>
				</div>
				<div class="price" id="price_[#= productId #]">
					<span>[#= priceText #]</span>
				</div>
				<div class="link">
					<a id="buybtn_[#= productId #]" href="javascript:applyOnline('[#= productId #]');" class="buybtn" ><span>Buy Now</span></a>
					<a id="moreinfobtn_[#= productId #]" href="javascript:view_details('[#= productId #]', '[#= quoteUrl #]');" class="moreinfobtn" ><span>More Info</span></a>
				</div>
			</div>
		</core:js_template>
		</div>
	</div>
	
		
	<%-- PRICE UNAVAILABLE TEMPLATE --%>
	<core:js_template id="unavailable-template">
		<div class="result-row unavailable" id="result_[#= productId #]" style="display:none;">
		
			<div class="provider">
				<div class="thumb"><img src="common/images/logos/travel/[#= productId #].png" /></div>
			</div>
			
			<div class="des">
				<p id="productName_[#= productId #]"><span class="productName"></span></p>
				<p id="productDes_[#= productId #]" class="message">[#= message #]</p>
			</div>
			
			<div class="link"></div>
			
			<div class="data"></div>
		</div>
	</core:js_template>
	
	
	
	
	<div class="clear"></div>
	
</div>