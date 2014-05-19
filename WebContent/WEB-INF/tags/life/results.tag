<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- Load the params into data --%>



<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="false"  rtexprvalue="true"	 description="results page vertical name (life or ip)" %>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>
<c:choose>
	<c:when test="${not empty vertical and (fn:toLowerCase(vertical) eq 'life' or fn:toLowerCase(vertical) eq 'ip') }">
		<c:set var="vertical">${fn:toLowerCase(vertical)}</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="vertical">life</c:set>
	</c:otherwise>
</c:choose>

<%-- CSS --%>
<go:style marker="css-head">

	#results-container {
		width:980px;
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
		width:980px;
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
		width: 491px;
		height: 78px;
		margin: 0 0 0 20px;
		z-index: 0;
	}
	div#results-summary p{
		font-size: 110%;
		margin-bottom:3px;
		margin-right: 0px;
	}
	div#results-summary p.sub{
		font-size: 95%;
	}
	div#results-summary a.button {
		float: right;
		margin-left:10px;
		margin-top: 19px !important;
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
		margin: 0 0 0 20px;
	    position: relative;
		width: 744px;
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
		width:118px;
    }
	.sortable {
		cursor:pointer;
	}		
	.${vertical} #results-header div,
	.${vertical} .result-row > div {
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
	.${vertical} #results-header div {
		color:#4a4f51;
		font-size:13px;
		font-weight:bold;
		height:30px;
		width: 100px;
		font-family:"SunLT Bold",Arial,Helvetica,sans-serif;
		position:relative;
	}
	.${vertical} #results-header div.address,
	.${vertical} #results-header div.price2 {
		border-right:none;
	}
	.${vertical} .result-row > div {
		height:50px;
		border-bottom: 1px solid #DAE0E4;
    	border-left: 1px solid #DAE0E4;		
	}			
	.${vertical} .result-row h5 {
		font-size: 14px;
	}
	#results-table {
		position:relative;
		float: left;
	    margin:0 0 0 20px;;
    	top:0px;
		width:744px;
	}
	
	/* Container Sizes */
	.${vertical} #results-container .provider {
		width:90px;	
	}
		.${vertical} .result-row .provider {
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
	.${vertical} #results-container .name {
		width:145px;
	}	
	.${vertical}.do-compare #results-container .name {
		width:105px;
	}
	.${vertical} #results-container .rating {
		width:85px;	
	}

	.${vertical}  #results-container .price {
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
		.${vertical} .result-row .price {
			background-color:#f8f9fa;
			text-align: center;
		}
	.${vertical} #results-container .des {
		width:210px;
	}
	.${vertical}.do-compare #results-container .des {
		width:170px;
	}
	.${vertical} #results-container .compare {
		display: none;
	}
	.${vertical}.do-compare #results-container .compare {
		width:60px;
		display:block;
	}
		.${vertical} #results-container .result-row.unavailable .des {
			width:799px;
			line-height:50px;
		}
		.${vertical} #results-container .result-row.unavailable .link,
		.${vertical} #results-container .result-row.unavailable .data {
			position:absolute;
			width:0;
			height:0;
			border:none;
			top:0;
			right:0;
		}
	.${vertical} #results-container .link {
		width:118px;
	}		
		.${vertical} .result-row .link {
			padding-top:0;
			padding-bottom:0;
			height:70px;
		}	
		#results-table .link a {
			margin: 4px 5px;
		}

	.${vertical} #results-container .result-row .compare a {
		display:			block;
		width:				19px;
		height:				19px;
		background:			transparent url(common/images/checkbox.png) top left no-repeat;
		margin:				0 auto;
	}

	.${vertical} #results-container .result-row .compare a.selected {
		background-position:bottom left;
	}
		#results-table .link a span {
			width: 90px;
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
#left-panel .box.refine-results .row.mid .filter input,
#left-panel .box.refine-results .row.mid .filter select {
	position:				absolute;
}

#left-panel .box.refine-results .row.mid .filter span.dollar{
	left:					79px;
}

#left-panel .box.refine-results .row.mid .filter span.value{
	display:				block;
	left:					88px;
}
	
#left-panel .box.refine-results .row.mid .filter.frequency span.value,
#left-panel .box.refine-results .row.mid .filter.type span.value{
	left:					78px;
}

#left-panel .box.refine-results .row.mid .filter input,
#left-panel .box.refine-results .row.mid .filter select{
	left:					86px;
	width:					90px;
	display:				none;
}

#left-panel .box.refine-results .row.mid .filter select{
	left:					78px;
	width:					102px;
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

#footer {
	width: 100%;
	background: #CCCCCC;
	<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="2" blurRadius="2" color="0,0,0,0.2" inset="true"  />
	margin: 0px 0 0 0;
	padding: 10px 0 25px 0;
}

#copyright {
	background: #CCCCCC;
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
	_selectedProduct : {
		primary : false,
		partner : false
	},
	_eventMode : false,
	_partnerQuote : false,
	_renderingProducts : false,
	_resultsRowsHeight : 0,
	_queuedCallbacks : [],
	_animQueue : $({}),
	_animQueueLabel : "showresultitems",
	
	// INITIALISATION
	
	
	init : function(){
	
		if( $("#navContainer").not("#summary-header") )
		{
			$('#summary-header').appendTo('#navContainer');
		}
		
		if($('#${vertical}_primary_insurance_partner_Y').is(':checked')) {
			Results._partnerQuote = true;
			$('#resultsPage').removeClass('single');
		} else {
			Results._partnerQuote = false;
			$('#resultsPage').addClass('single');
		}

		Results.resetForm();

		$('#steps:visible').hide();
		$('#summary-header:hidden').show();
			
		Results.hideErrors();
		Results._initSortIcons();		
		
		InsuranceHandler.updateResultsPage();
	},	
	
	setSelectedProduct : function( type, product_obj )
	{
		Results._selectedProduct[type] = product_obj;
	},
	
	setPrimarySelectedProduct : function( product_obj )
	{
		Results.setSelectedProduct('primary', product_obj);
	},
	
	setPartnerSelectedProduct : function( product_obj )
	{
		Results.setSelectedProduct('partner', product_obj);
	},

	getSelectedProduct : function( type )
		{
		return Results._selectedProduct[type];
	},

	getPrimarySelectedProduct : function()
			{
		return Results._selectedProduct.primary;
	},

	getPartnerSelectedProduct : function()
	{
		return Results._selectedProduct.partner;
	},

	getProductByID : function( type, product_id )
	{
		for(var i=0; i < Results._currentPrices[type].length; i++)
		{
			if( product_id == Results._currentPrices[type][i].product_id )
			{
				return Results._currentPrices[type][i];
			}
		}
		
		return false;
	},
	
	getPrimaryProductByID : function( product_id )
	{
		return Results.getProductByID('primary', product_id);
	},
	
	getPartnerProductByID : function( product_id )
	{
		return Results.getProductByID('partner', product_id);
	},
		
	flushSelectedProducts : function(callback) {
		for(var i in Results._selectedProduct) {
			if( Results._selectedProduct != false ) {
				Results._selectedProduct[i] = false;
			}
		}
		
		Results.showHideProceedPanel( true );
		$('#results-rows-primary').empty();
		$('#results-rows-partner').empty();

		if( typeof callback == "function" ) {
			callback();
		}
	},
		
	forceShowAllProducts : function( callback ) {		if( Results._renderingProducts || $('#resultsPage').hasClass('proceed') ) {
		
			Results._animQueue.clearQueue( Results._animQueueLabel );
			Results._animQueue.stop();

			Results.addCallbackToQueue( callback);

			$('#results-rows-wrapper .results-row').each(function(){
				$(this).show();
			});

			Results.updateRankingAndSupertag();

			Results.resizeResultsWrappers();

			Results.processQueuedCallbacks();
		}
	},

	addProductToCart : function( type, product_id) {
		var product = Results.getProductByID(type, product_id);

		if( product !== false ) {

			var callback = function() {

				// Exit if already in cart
				if(
					typeof Results._selectedProduct[type] == "object" &&
					Results._selectedProduct[type].hasOwnProperty("product_id") &&
					Results._selectedProduct[type].product_id == product_id) {
					// don't do anything as item already in the cart
				} else {

					$("#results-mast-wrapper ." + type).find('.client').first().addClass("adding");
					$("#addtocart_" + type + "_" + product_id).addClass("adding");

					LifeQuote.selectProduct(type, product, function(){

						// Remove loading animation
						$("#addtocart_" + type + "_" + product_id).removeClass("adding");

						// Remove any existing logo image
						$("#results-mast-wrapper ." + type).find('.logo').first().css({backgroundImage:'none'});

						// Remove any existing animation
						if( $('#animated_logo_' + type) ) {
							$('#animated_logo_' + type).stop().remove();
						}
						// Unselect any previous selected products
						$("#results-rows-wrapper ." + type).find(".add-to-cart-button").removeClass('active')

						Results.setSelectedProduct(type, product);

						$("#results-mast-wrapper .client." + (type=='partner'?'right':'left')).find(".select").first().fadeOut(50, function(){
							$("#results-mast-wrapper .client." + (type=='partner'?'right':'left')).find(".selected").first().fadeIn(50, function(){

								$("#addtocart_" + type + "_" + product_id).addClass("active");

								var elements = {
										start : 	$("#results-rows-" + type + " #result_" + type + "_" + product_id).find(".logo").first(),
										finish :	$("#results-mast-wrapper .client." + (type=='partner'?'right':'left')).find(".logo").first(),
										min : 		$("#results-rows-" + type).find(".results-row").first()
								};

								var completeLogoMove = function() {
									var size = "83x53";//"44x25";
									elements.finish.css({backgroundImage:"url(common/images/logos/life/" + size + "/" + product.thumb + ")"});
									$("#results-mast-wrapper ." + type).find('.client').first().removeClass("adding");
									$("#results-rows-" + type).find(".results-row.selected").removeClass('selected');
									$('#result_' + type + '_' + product_id).addClass('selected');
									elements.finish.find('.drop-selected-product').first().unbind('click').on('click', function(){
										Results.dropProductFromCart(type, product_id);
									});

									<%-- Don't proceed until the last animation has finished --%>
									if( $("#results-rows-" + type + " .results-row").find(".adding").length == 0 ) {
									Results.showHideProceedPanel();
								}
								}

								<%-- Bypass animation if IE and less than IE8 --%>
								if( $.browser.msie && parseInt($.browser.version, 10) < 8 ) {
									completeLogoMove();
								} else {
								var start_pos = elements.start.offset();
								var end_pos = elements.finish.offset();
								var min_pos = elements.min.offset();
								var speed = 250;
								var travel_distance = Number(250);

								<%-- Calculate the top/left position on the line that is the travel_distance on the line between the start and finish --%>
								var x1 = start_pos.left;
								var y1 = start_pos.top;
								var x2 = end_pos.left;
								var y2 = end_pos.top;
								var vx = Number(x2 - x1);
								var vy = Number(y2 - y1);
								var mag = Number(Math.sqrt(vx*vx + vy*vy));
								vx = vx / mag;
								vy = vy / mag;
								var px = parseInt( Number(x1 + (vx * (travel_distance))), 10);
								var py = parseInt( Number(y1 + (vy * (travel_distance))), 10);

								var copy = elements.start.clone();
									copy.attr('id', 'animated_logo_' + type).css({position:'absolute', width:83, height:53, top:start_pos.top, left:start_pos.left, border:'1px solid #b6b6b6'}).appendTo('body');
								copy.animate({top:py, left:px, opacity:0.2}, {duration:speed, complete:function(){
									copy.remove();
										completeLogoMove();
								}});
								}
							});
						});
					});
				}
			};

			if( Results._renderingProducts ) {
				Results.forceShowAllProducts( callback );
			} else {
				callback();
			}
		}
	},

	dropProductFromCart : function(type, product_id) {
		// Firstly let's remove the product from the list
		Results._selectedProduct[type] = false;

		// Then deselect the
		$("#addtocart_" + type + "_" + product_id).removeClass('active');

		var completeLogoMove = function() {
			$("#results-mast-wrapper .client." + (type=='partner'?'right':'left')).find(".selected").first().fadeOut(50, function(){
				$("#results-mast-wrapper .client." + (type=='partner'?'right':'left')).find(".select").first().fadeIn(50, function(){
					Results.showHideProceedPanel();
				});
			});
		};

		<%-- Bypass animation if IE and less than IE8 --%>
		if( $.browser.msie && parseInt($.browser.version, 10) < 8 ) {
			completeLogoMove();
		} else {

		// Do a pretty animation
		var start = $("#results-mast-wrapper ." + (type == 'primary' ? "left" : "right")).find(".logo").first();

		$('#result_' + type + '_' + product_id).removeClass('selected');

		var start_pos = start.offset();
		var speed = 250;
		var travel_distance = Number(100);

		<%-- Calculate the top/left position on the line that is the travel_distance on the line between the start and finish --%>
		var x1 = start_pos.left;
		var y1 = start_pos.top;
		var x2 = start_pos.left;
		var y2 = start_pos.top + travel_distance;

		var copy = start.clone();
			copy.attr('id', 'animated_logo_' + type).css({position:'absolute', width:83, height:53, top:start_pos.top, left:start_pos.left, border:'1px solid #9d9d9d'}).appendTo('body');
		start.css({backgroundImage:'none'});
		copy.animate({top:y2, left:x2, opacity:0.2}, speed, function(){
			copy.remove();
				completeLogoMove();
				});
		}
	},

	showHideProceedPanel : function( dont_animate ) {

		dont_animate = dont_animate || false;

		var callback = function() {

			var cart_full = true;

			if( Results._selectedProduct.primary == false ) {
				cart_full = false;
			}

			if( cart_full != false && Results._partnerQuote && Results._selectedProduct.partner == false ) {
				cart_full = false;
			}

			if( cart_full ) {
				// Shift progress bar to Apply stage
				QuoteEngine.gotoSlide({noAnimation:true, index:2});

				$('#resultsPage').addClass('proceed');
				$('#results-mast-wrapper .premium-summary').find('.prim').first().text('$' + Results._selectedProduct.primary.price);
				if( Results._partnerQuote ) {
					$('#results-mast-wrapper .premium-summary').find('.part').first().text('$' + Results._selectedProduct.partner.price);
				}
				$('#results-mast-wrapper .call-info').find('.reference_no').first().text(Results._selectedProduct.primary.transaction_id);

				switch( $('#${vertical}_primary_insurance_frequency').val() ) {
					case 'Y':
						$('#results-mast-wrapper .premium-summary').find('.text:first').empty().append("Estimated Annual Premium");
						break;
					case 'H':
						$('#results-mast-wrapper .premium-summary').find('.text:first').empty().append("Estimated Half-Yearly Premium");
						break;
					case 'M':
					default:
						$('#results-mast-wrapper .premium-summary').find('.text:first').empty().append("Estimated Monthly Premium");
						break;
				}

				$('html, body').animate({ scrollTop: 0 }, {duration:'fast', complete:function(){
					compare.hide(function(){
						$('#results-mast-wrapper').animate({height:280}, 500, function(){
							if($.browser.msie && parseInt($.browser.version, 10) < 8) {
								// ignore
							} else {
							highlightMeTextObj.animate($('#what-happens-next-text'));
							}
						});
						$('#we-call-you').unbind('click').on('click', function(){
							LifeQuote.submitApplication(Results._selectedProduct);
						});
						Results.toggleShowOnlySelectedProducts(true);
					});
				}});
			} else {
				// Shift progress back to Results stage
				QuoteEngine.gotoSlide({noAnimation:true, index:1});

				if( dont_animate === true ) {
					$('#results-mast-wrapper').animate({height:90}, 500, function(){
						$('#resultsPage').removeClass('proceed');
						compare.show();
					});
				} else {
					$('#results-mast-wrapper').css({height:90});
					$('#resultsPage').removeClass('proceed');
					compare.show();
				}

				Results.toggleShowOnlySelectedProducts(false);

				highlightMeTextObj.stop();
			}
		}

		if( Results._renderingProducts ) {
			Results.addCallbackToQueue( callback );
		} else {
			callback();
		}
	},

	toggleMoreDetails : function( type, product_id )
		{
		if( !$('#result_' + type + '_' + product_id).hasClass('pending') ) {

			$('#result_' + type + '_' + product_id).addClass('pending');

			var callback = function() {
				if( $('#more-info-' + type + '_' + product_id).is(":visible") ) {
					var cur_height = $('#more-info-' + type + '_' + product_id).height();
					var margin = -10;
					$('#more-info-' + type + '_' + product_id).slideUp({duration:500,step:function(){
						Results.recalculateRowPositions();
						Results.resizeResultsWrappers( $('#resultsPage').hasClass('proceed') );
					},complete : function(){
						$('#result_' + type + '_' + product_id).removeClass('expanded');
						$('#result_' + type + '_' + product_id).removeClass('pending');
						$('#moreinfobtn_' + type + '_' + product_id).text("More Details");
						Results.recalculateRowPositions();
						Results.resizeResultsWrappers( $('#resultsPage').hasClass('proceed') );
					}});
				} else {
					var product = Results.getProductByID(type, product_id);
					LifeQuote.fetchProductDetails(product, function(){
						/* Build and inject details into more-info-slider */

						Results.populateMoreDetails( product );

						var ignore = true;
						var cur_height = 0;
						var margin = 10;
						$('#result_' + type + '_' + product_id).addClass('expanded');
						$('#more-info-' + type + '_' + product_id).slideDown({duration:500,step:function(){
							Results.recalculateRowPositions();
							Results.resizeResultsWrappers( $('#resultsPage').hasClass('proceed') );
						},complete : function(){
							$('#result_' + type + '_' + product_id).removeClass('pending');
							$('#moreinfobtn_' + type + '_' + product_id).text("Less Details");
							Track.onMoreInfoClick( product_id );
						}});
					});
		}
		}
		
			if( Results._renderingProducts ) {
				Results.forceShowAllProducts( callback );
			} else {
				callback();
			}
		} else {
			// Ignore because animating;
		}
	},
		
	populateMoreDetails : function( product ) {
		var parent = $('#more-info-' + product.client_type + '_' + product.product_id);
		var elements = {
			inc		: parent.find('.inclusions').first().empty(),
			exc		: parent.find('.exclusions').first().empty(),
			ext		: parent.find('.extras').first().empty(),
			pds		: parent.find('.pds a').first(),
			term	: $('#life_insurance_term'),
			tpd		: $('#life_insurance_tpd'),
			trauma	: $('#life_insurance_trauma')
		};

		var getLI = function( content ) {
			return "<li>" + content + "</li>";
		}

		var limit = 5;
		var count = 0;

		var policy_benefits = {
			term	: false,
			trauma	: false,
			tpd		: false,
			income	: false
		};

		if( '${vertical}' == 'income' ) {
			policy_benefits.term = true;
			policy_benefits.trauma = true;
			policy_benefits.tpd = true;
		} else {
			policy_benefits.income = true;

			if( elements.term.val() != '' && elements.term.val() > 0 ) {
				policy_benefits.term = true;
			}

			if( elements.trauma.val() != '' && elements.trauma.val() > 0 ) {
				policy_benefits.trauma = true;
			}

			if( elements.tpd.val() != '' && elements.tpd.val() > 0 ) {
				policy_benefits.tpd = true;
			}
		}

		for(var i in policy_benefits) {
			if( policy_benefits[i] ) {
				parent.find('.' + i).show();
			} else {
				parent.find('.' + i).hide();
			}
		}

		if(typeof(product.features.available) == 'undefined') {
			//console.log("product " , product);
		}

		for(var i in product.features.available) {
			if( count++ < 5 ) {
				elements.inc.append( getLI(product.features.available[i]) );
			}
		}

		count = 0;

		for(var i in product.features.unavailable) {
			if( count++ < 5 ) {
				elements.exc.append( getLI(product.features.unavailable[i]) );
			}
		}

		for(var i in product.features.extras) {
			elements.ext.append( getLI(product.features.extras[i]) );
		}

		elements.pds.on('click', function(){
			ui_popup_window.open('pds', product.pds, '_blank', {location:0,status:0});
		});
	},	
	
	addCallbackToQueue : function( callback ) {
		Results._queuedCallbacks.push( callback );
	},
	
	processQueuedCallbacks : function() {

		Results._renderingProducts = false;

		for(var i in Results._queuedCallbacks) {
			if( !isNaN(i) && typeof Results._queuedCallbacks[i] == 'function' ){
				Results._queuedCallbacks[i]();
			}
		}

		delete Results._queuedCallbacks;

		Results._queuedCallbacks = [];
	},

	showErrors : function( msgs, transaction_id )
	{
		transaction_id = transaction_id || false;

		Results.init();
		Results.resetForm();
		Results.renderRefineResultsDOM();

		Results._sortBy = false;

		compare.flushCompareList();

		$('#summary-header h2 strong').first().text("ZERO quotes");

		$('#page').hide();
		$('#resultsPage').fadeIn(300, function(){
			$('#results-rows-wrapper').slideUp(400, function(){
				$('#results-mast-wrapper').slideUp(200, function(){
					compare.hide(function(){
						$('#refine-form-wrapper').slideDown(100, function(){
							$("#results-errors-wrapper .innertube:first").empty();

							for(var i=0; i < msgs.length; i++) {
								$("#results-errors-wrapper .innertube:first").append("<p>" + msgs[i] + "</p>")
							}

							$("#results-errors-wrapper").slideDown('slow');
		});
					});
				});
			});
		});
	},
	
	hideErrors : function(callback) {

		$("#results-errors-wrapper").slideUp("fast", callback);
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
	
		Results._renderingProducts = true;

		Results.init();		
		Results._updateQuoteCount();
		Results._updateClientSummary();
				
		var business = function() {

			var delay = 200;
			var fadeTime = 150;
			var heightDelay = 50;
			var slideDelay = 100;

			var row_height = 124;
			var max_height = 0;

			Results._animQueue.delay(delay, Results._animQueueLabel);

			<%-- If partner quote lets do some tricky stuff so that both columns animate in nicely --%>
			if( Results._partnerQuote ) {
				var temp = {primary:[],partner:[]};
				$("#results-rows-primary .results-row").each(function(){
					temp.primary.push($(this));
		});
				$("#results-rows-partner .results-row").each(function(){
					temp.partner.push($(this));
				});
		
				var alternating = $.map(temp.primary, function(v, i) { return [v, temp.partner[i]]; });
				for(var i = 0; i < alternating.length; i++) {
					if( i % 2 == 0 ) {
						max_height += row_height;
			
						<%-- Don't underestimate how important this wrapping is --%>
						(function(mh){
							Results._animQueue.queue(Results._animQueueLabel, function(next){
								$('#results-rows-wrapper .primary').find('.innertube').first().animate({height:mh}, heightDelay);
								$('#results-rows-wrapper .partner').find('.innertube').first().animate({height:mh}, heightDelay);
								$('#resultsPage').css({minHeight:mh});
								next();
		});
						})(max_height);
		
						Results._animQueue.delay(heightDelay, Results._animQueueLabel);
					}
		
					<%-- Don't underestimate how important this wrapping is --%>
					(function(j){
						Results._animQueue.queue(Results._animQueueLabel, function(next){
							$(alternating[j]).show("slide",{direction:(j % 2 ? "left" : "right"),easing:"easeInOutQuart"}, slideDelay);
							next();
		});
					})(i);
		
					if( i % 2 == 0 ) {
						Results._animQueue.delay(slideDelay * 2, Results._animQueueLabel);
					}
				}
			} else {
			<%-- Otherwise just do it as normal --%>
				$("#results-rows-primary .results-row").each(function(){
					max_height += row_height;
		
					<%-- Don't underestimate how important this wrapping is --%>
					(function(mh){
						Results._animQueue.queue(Results._animQueueLabel, function(next){
							$('#results-rows-wrapper .primary').find('.innertube').first().animate({height:mh}, heightDelay);
							$('#results-rows-wrapper .partner').find('.innertube').first().animate({height:mh}, heightDelay);
							$('#resultsPage').css({minHeight:mh});
							next();
						});
					})(max_height);
		
					Results._animQueue.delay(heightDelay, Results._animQueueLabel);
				
					<%-- Don't underestimate how important this wrapping is --%>
					(function(that){
						Results._animQueue.queue(Results._animQueueLabel, function(next){
							$(that).show("slide",{direction:"right",easing:"easeInOutQuart"},fadeTime * 2);
							next();
						});
					})(this);
			
					Results._animQueue.delay(delay, Results._animQueueLabel);
				});
			}

			Results._animQueue.queue(Results._animQueueLabel, function(next) {

			if (Results._priceCount == 0) { 
				NoResult.show();
			} else {
					Results.updateRankingAndSupertag();
			}

				Results.processQueuedCallbacks()
		});

			Results._animQueue.delay( delay, Results._animQueueLabel );

			Results._animQueue.dequeue( Results._animQueueLabel );
		}

		$('#page').hide();
		$('#resultsPage').fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
			$('#refine-form-wrapper').slideDown(200, function(){
				compare.show(function(){
					$('#results-mast-wrapper').slideDown(300, function(){
						$('#results-rows-wrapper').slideDown(400, function() {
							if( $.browser.msie && parseInt($.browser.version, 10) < 8 ) {
								Results.forceShowAllProducts();
							} else {
								business();
							}
					});
				});
		});
		});
		});
<c:if test="${vertical eq 'ip'}">
		Results.income = $('#${vertical}_primary_insurance_income').val();
		Results.amount = $('#${vertical}_primary_insurance_amount').val();
</c:if>
	},
		
	updateRankingAndSupertag : function() {
		Results._sortBy="price";
		Results._sortDir="asc";
		var qs = "rootPath=${vertical}&rankBy=" + Results._sortBy + "-" + Results._sortDir + "&rank_count=" + Results._currentPrices.primary.length;
		for(var i in Results._currentPrices.primary) {
			var prodId= Results._currentPrices.primary[i].product_id;
			qs+="&rank_productId"+i+"="+prodId;
		}
		qs+="&transactionId="+referenceNo.getTransactionID();
		$.ajax({
			url:"ajax/write/quote_ranking.jsp",
			data:qs,
			type:'POST'
		});
		btnInit._show();
		Track.onResultsShown(Results.eventMode());
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
		
	_updateQuoteCount : function() {
		$('#summary-header h2 strong').first().text(Results._currentPrices.length + " quotes");
	},

	_updateClientSummary : function() {

		// Build the dataset for populating client elements

		var getName = function( type ) {
			var firstname = $("#${vertical}_" + type + "_firstName").val();
			var lastname = $("#${vertical}_" + type + "_lastname").val()
			var name = firstname + ' ' + (Results._partnerQuote ? lastname.charAt(0) : lastname);
			return $.trim(name);
		}

		var details = {
				aggregate : {
					count:		Results._currentPrices.primary.length + Results._currentPrices.partner.length
				},
				primary : {
					count:		Results._currentPrices.primary.length,
					age:		Results._getAge( $("#${vertical}_primary_dob").val() ),
					name:		getName( 'primary' ),
					gender:		$("#${vertical}_primary_gender input[name='${vertical}_primary_gender']:checked").val() == "F" ? "female" : "male",
					smoker:		$("#${vertical}_primary_smoker input[name='${vertical}_primary_smoker']:checked").val() == "Y" ? "smoker" : "non-smoker",
					classname:	'left'
				},
				partner : null
		};
		
		if(Results._partnerQuote) {
			details.partner = {
				count:		Results._currentPrices.partner.length,
				age:		Results._getAge( $("#${vertical}_partner_dob").val() ),
				name:		getName( 'partner' ),
				gender:		$("#${vertical}_partner_gender input[name='${vertical}_partner_gender']:checked").val() == "F" ? "female" : "male",
				smoker:		$("#${vertical}_partner_smoker input[name='${vertical}_partner_smoker']:checked").val() == "Y" ? "smoker" : "non-smoker",
				classname:	'right'
			}
		};
				
		// First update the primary results summary in the header
		$('#summary-header h2').find("strong").first().text( details.aggregate.count + " quotes" );

		// Update the individual client details
		var client_container = $('#client-column-headers');
		var clientTemplate = $("#client-template").html();
		var client = $(parseTemplate(clientTemplate, details.primary));

		client_container.empty();

		var applyContent = function( content ) {
			var test = $(content).text();
			if (test.indexOf("ERROR") == -1) {
				client_container.append(content);
			} else {
				FatalErrorDialog.exec({
					message:		"HTML Template Error: " + t,
					page:			"${vertical}:results.tag",
					description:	"Results.update().  Price template error occured: " + t,
					data:			this
				});
			}
		}

		applyContent( client );

		if( details.partner ) {
			clientTemplate = $("#client-template").html();
			client = $(parseTemplate(clientTemplate, details.partner));
			applyContent( client );
		}
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
		
		if( Results._sortBy == "provider" ) {
			sortedPrices = $(prices).sort(Results._sortProviders);
		} else if( Results._sortBy == "rating" ) {
			sortedPrices = $(prices).sort(Results._sortRatings);
		} else {
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
		
		prices['primary'] = [].concat(prices.primary);
		prices['partner'] = [].concat(prices.partner);
		
		Results._currentPrices = prices;
		
		Results._updateQuoteCount();
		
		Results._updateClientSummary();

		var resultTemplate		= $("#result-template").html();
		var unavailableTemplate	= $("#unavailable-template").html();

		var priceShown = false;
		
		$("#results-rows-primary").empty();
		$("#results-rows-partner").empty();

		Results._priceCount = 0;
		if (prices != undefined) {
			//var maxHeight = 0;
				
			for( var i in prices ) {
				var topPos = 0;
				var rowHeight = 124;

				$.each(prices[i], function() {

					this["client_type"] = i;

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
						//$(newRow).css({top:topPos});

						<%-- Store the TOP position in the element for later use --%>
						$(newRow).data('top', topPos);

					topPos+=rowHeight;					
														
						/*if( topPos > maxHeight ) {
							maxHeight = topPos;
						}*/

					var t = $(newRow).text(); 
					if (t.indexOf("ERROR") == -1 ) {
							$("#results-rows-" + i).append(newRow);
						priceShown=true;
					} else {
						FatalErrorDialog.exec({
							message:		"HTML Template Error: " + t,
								page:			"${vertical}:results.tag",
							description:	"Results.update().  Price template error occured: " + t,
							data:			this
						});
					}
				}
			});
		}
		}
		
		Results.recalculateRowPositions();

		// always show the results table (even when no prices returned)
		var resultRows = $("#results-table .result-row");
		$(resultRows).last().addClass("bottom-result");
		$("#results-table").show();
	},
		
	recalculateRowPositions : function() {
		var margin = 10;
		var row_height = 124;
		var rows_height = 0;
		var types = ['primary','partner'];
		for(var i in types) {
			var top = 0;
			$('#results-rows-' + types[i]).find('.results-row').each(function(){
				if( $('#resultsPage').hasClass('proceed') && $(this).hasClass('selected') ) {
					$(this).css({top:0});
				} else {
					$(this).css({top:top});
				}
				var more_info_height = 0;
				if( $(this).hasClass('expanded') ) {
					more_info_height = $(this).find('.more-info-slider:first').height() - margin;
				}
				top += row_height + more_info_height;
			});

			if( top > rows_height ) {
				rows_height = top;
			}
		}

		Results._resultsRowsHeight = rows_height;
	},

	resizeResultsWrappers : function( ignore_invisible ){

		var ignore_invisible = ignore_invisible || false;

		var height_to_use = Results._resultsRowsHeight;

		if( ignore_invisible ) {
			var margin = 10;
			var row_height = 124;
			var rows_height = 0;
			var types = ['primary','partner'];
			for(var i in types) {
				var top = 0;
				$('#results-rows-' + types[i]).find('.results-row').each(function(){
					if( $(this).is(':visible') ) {
						var more_info_height = 0;
						if( $(this).hasClass('expanded') ) {
							more_info_height = $(this).find('.more-info-slider:first').height() - margin;
						}
						top += row_height + more_info_height;
					}
				});

				if( top > rows_height ) {
					rows_height = top;
				}
			}

			height_to_use = rows_height;
		}

		<%-- Let's resize the content wrappers --%>
		$('#results-rows-wrapper .primary').find('.innertube').first().css({height:height_to_use});
		$('#results-rows-wrapper .partner').find('.innertube').first().css({height:height_to_use});

		$('#resultsPage').css({minHeight:height_to_use});
	},

	toggleShowOnlySelectedProducts: function(hide){
		hide = hide || false;

		if( hide ) {
			$($('#results-rows-wrapper .results-row').reverse()).each(function(){
				if( !$(this).hasClass("selected") ) {
					if( hide ) {
						$(this).hide();
					} else {
						$(this).show();
					}
				} else if( hide ) {
					$(this).css({top:0});
				}
			});
		} else {
			$($('#results-rows-wrapper .results-row').reverse()).show();
			Results.recalculateRowPositions();
		}

		Results.resizeResultsWrappers( true );
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
	
	resetForm : function( callback ) {
		Results._selectedProduct = {
			primary : false,
			partner : false
		};

		$('#results-mast-wrapper').animate({
			height : 90
		}, 'fast', function(){
			$('#resultsPage').removeClass('proceed');
		});
	},

	reviseDetails : function() {
		if( Results._renderingProducts ) {
			Results.forceShowAllProducts();
		}

		Results.resetForm();
		Results.hideErrors();
		Results.renderRefineResultsDOM();
		
		Results._sortBy = false;
		
		compare.flushCompareList();

		$('#results-rows-wrapper').slideUp(400, function(){
			$('#results-mast-wrapper').slideUp(200, function(){
				compare.hide(function(){
					$('#refine-form-wrapper').slideUp(100, function(){
						$('#summary-header').slideUp(50, function(){
							$('#steps').slideDown(50, function(){
						QuoteEngine.gotoSlide({
							index:	0
						});
				$('#resultsPage').hide("fast", function(){
					$('#page').fadeIn("fast", function(){
										$('.accordion-toggle.edit-button').first().trigger('click');
						$("#next-step").show();
					})
				});
			})
		});
					});
				});
			});
		});
	},
	
	hideResults : function() {
		if( Results._renderingProducts ) {
			Results.forceShowAllProducts();
		}

		Results.resetForm();
		Results.hideErrors();
		Results.renderRefineResultsDOM();

		Results._sortBy = false;

		compare.flushCompareList();

		$('#results-rows-wrapper').slideUp(400, function(){
			$('#results-mast-wrapper').slideUp(200, function(){
				compare.hide(function(){
					$('#refine-form-wrapper').slideUp(100, function(){
						$('#summary-header').slideUp(50, function(){
							$('#steps').slideDown(50, function(){
								$('#resultsPage').hide("fast", function(){
									$('#page').fadeIn("fast", function(){
									})
								});
							})
						});
					});
				});
			});
		});
	},

	getFieldLabelsList : function() {
<c:choose>
	<c:when test="${vertical eq 'ip'}">
		return ['income','amount'];
	</c:when>
	<c:otherwise>
		return ['term','tpd','trauma'];
	</c:otherwise>
</c:choose>
	},

	refineResultItemClicked: function(event) {
		$("#${vertical}_refine_primary_insurance_" + event.data.type).toNumber();
		$("#${vertical}_refine_primary_insurance_" + event.data.type).show().select();
	},
	
	_refine_client_type : 'primary',

	renderRefineResultsDOM: function() {
		
		var list = Results.getFieldLabelsList();

		for(var i = 0; i < list.length; i++)
		{
			var type = list[i];

			$("#${vertical}_refine_primary_insurance_" + type).hide();
				
			$("#refine-form-wrapper").find(".${vertical}_refine_primary_insurance_" + type + "_value").first().empty()
			.append( $("#${vertical}_" + Results._refine_client_type + "_insurance_" + type).val() )
			.on("click", {type:type}, Results.refineResultItemClicked);
				
			$("#${vertical}_refine_primary_insurance_" + type).val( $("#${vertical}_" + Results._refine_client_type + "_insurance_" + type).val())
<c:choose>
	<c:when test="${vertical eq 'ip'}">
			.on("blur", {type:type}, Results.showHideUpdateResultsButton)
			.on("keyup", {type:type}, Results.ipCustomShowHideUpdateResultsButton)
	</c:when>
	<c:otherwise>
			.on("keyup", {type:type}, Results.showHideUpdateResultsButton)
	</c:otherwise>
</c:choose>
			.on("blur", {type:type}, Results.toggleRefineInputVisibility)
			.formatCurrency('.${vertical}_refine_primary_insurance_' + type + '_value', {symbol:'',roundToDecimalPlace:-2});
			}

		$("#refine-quotes").removeClass('active');
<c:choose>
	<c:when test="${vertical eq 'life'}">
		if( $('input[name=life_primary_insurance_partner]:checked').val() == 'Y' && $('input[name=life_primary_insurance_samecover]:checked').val() == 'N' ) {
			$("#${vertical}_refine_insurance_type").on('change', Results.toggleRefineClientType);
			$("#${vertical}_refine_insurance_type").show();
		} else {
			$("#${vertical}_refine_insurance_type").unbind().hide();
		}
	</c:when>
	<c:otherwise>
		$("#${vertical}_refine_insurance_type").unbind().hide();
	</c:otherwise>
</c:choose>
	},
	
	toggleRefineClientType: function() {
		Results._refine_client_type = $("#${vertical}_refine_insurance_type").val();
		Results.renderRefineResultsDOM();
	},

	submitRefineResults: function() {
		
		var list = Results.getFieldLabelsList();

		for(var i = 0; i < list.length; i++) {

			var type = list[i];
					
			if( !isNaN($("#${vertical}_refine_primary_insurance_" + type).val()) ) {
					
				$("#${vertical}_" + Results._refine_client_type + "_insurance_" + type + "entry").val( $("#${vertical}_refine_primary_insurance_" + type).val() ).trigger("blur");
<c:if test="${vertical eq 'ip'}">
				$("#${vertical}_primary_insurance_" + type).trigger("keyup");
</c:if>
				$("#${vertical}_refine_primary_insurance_" + type).hide();

				$("#refine-form-wrapper").find(".${vertical}_refine_primary_insurance_" + type + "_value").first().empty().append(
					$("#${vertical}_refine_primary_insurance_" + type).val()
					).show();
					
				$("#${vertical}_refine_primary_insurance_" + type).formatCurrency('.${vertical}_refine_primary_insurance_' + type + '_value', {symbol:'',roundToDecimalPlace:-2});
				}
			}
		
		Results._sortBy = false;
		
		LifeQuote.fetchPrices();
	},
	
	toggleRefineInputVisibility : function(event) {
	
		var hide = true
			type = event.data.type,
			value = $("#${vertical}_refine_primary_insurance_" + type).val();

		var clean_val = parseInt(value, 10);
		$("#${vertical}_refine_primary_insurance_" + type + "_value").text( clean_val );
		$("#${vertical}_refine_primary_insurance_" + type).val( clean_val )
		.formatCurrency('.${vertical}_refine_primary_insurance_' + type + '_value', {symbol:'',roundToDecimalPlace:-2});
			
		$("#${vertical}_refine_primary_insurance_" + type).hide();
	},
			
	showHideUpdateResultsButton : function(event) {

		var	hide = true,
			type = event.data.type;
<c:choose>
	<c:when test="${vertical eq 'ip'}">

		var new_income = $("#${vertical}_refine_primary_insurance_income").val();
		var new_amount = $("#${vertical}_refine_primary_insurance_amount").val();

		if( type == 'income' && Results.income != new_income )
				{
			var calc_amount = InsuranceHandler.getMaxBenefitAmount(new_income);
			$("#${vertical}_refine_primary_insurance_amount").val( calc_amount );
			$("#${vertical}_refine_primary_insurance_amount").formatCurrency('.${vertical}_refine_primary_insurance_amount_value:first', {symbol:'',roundToDecimalPlace:-2});
			hide = false;
					}
		else if( type == 'amount' && Results.amount != new_amount )
					{
			var calc_amount = InsuranceHandler.getMaxBenefitAmount(new_income);
			if( new_amount <= calc_amount ) {
				$(".${vertical}_refine_primary_insurance_amount:first").empty().append( new_amount );
				$("#${vertical}_refine_primary_insurance_amount").formatCurrency('.${vertical}_refine_primary_insurance_amount_value:first', {symbol:'',roundToDecimalPlace:-2});
			} else {
				$("#${vertical}_refine_primary_insurance_amount").val( calc_amount );
				$("#${vertical}_refine_primary_insurance_amount").formatCurrency('.${vertical}_refine_primary_insurance_amount_value:first', {symbol:'',roundToDecimalPlace:-2});
		}
						hide = false;
					}

		// Restore the original values until refine actually submitted
		$("#${vertical}_primary_insurance_incomeentry").val(Results.income).trigger("blur");
		$("#${vertical}_primary_insurance_amountentry").val(Results.amount).trigger("blur");

	</c:when>
	<c:otherwise>

		var list = Results.getFieldLabelsList();;

		var one_valid = false;
		for(var i = 0; i < list.length; i++) {
			if( Number($("#${vertical}_refine_primary_insurance_" + list[i]).val()) > 0 ) {
				one_valid = true;
				}
					}

		if( one_valid ) {
			for(var j = 0; j < list.length; j++) {
				var t = list[j];

				if( $("#${vertical}_" + Results._refine_client_type + "_insurance_" + t).val() != $("#${vertical}_refine_primary_insurance_" + t).val() ) {
						hide = false;
					}
				}
			}

	</c:otherwise>
</c:choose>

		if( hide ) {
			$("#refine-quotes").removeClass("active");
		} else {
			$("#refine-quotes").addClass("active");
			}
	},
			
	ipCustomShowHideUpdateResultsButton : function(event) {

		var	hide = true,
			type = event.data.type;

		var value = $("#${vertical}_refine_primary_insurance_" + type).val();

		if( String(value).length && !isNaN(value) && value > 0 ) {

			var new_income = $("#${vertical}_refine_primary_insurance_income").val(),
				new_amount = $("#${vertical}_refine_primary_insurance_amount").val();

			if( Results.income != new_income || Results.amount != new_amount ) {
				hide = false;
			};
			}

		if( hide ) {
			$("#refine-quotes").removeClass("active");
		} else {
			$("#refine-quotes").addClass("active");
			}
		}
	}

jQuery.fn.sort = function() {  
    return this.pushStack( [].sort.apply( this, arguments ), []);  
};


var HighlightMeText = function() {
	var that 			= this,
		element 		= null,
		char_list		= [],
		char_elements	= [],
		char_count		= 0,
		anim_info		= {
			animating :		false,
			speed :			25,
			delay :			1500,
			timer : 		null,
			pos :			0,
			loops :			2,
			loop_count :	0
		};

	var init = function( el ) {
		element = el;
		char_list = $(element).text().split('');
		char_count = char_list.length;
		char_elements = [];
		$(element).empty();
		for(var i = 1; i <= char_count; i++) {
			var el = $('<span/>', {
				'class'	: 'hlmt-' + i
			}).append((char_list[i - 1] == ' ' ? '&nbsp;' : char_list[i - 1]));
			$(element).append( el );
			char_elements.push( el );
}
	};

	var getTrailPos = function(cur) {
		var temp = cur - 1 < 0 ? char_list.length : cur - 1;
		if( char_list[temp - 1] == String.fromCharCode(160) ) {
			temp--;
}

		return temp;
	};

	var getFlatRGB = function( rgb ) {
		return String(rgb).replace(/[^0-9]/g, '');
	};

	var animationCallback = function() {
		if( anim_info.pos > 0 ) {
			// Loop through all char and degrade progressively to rgb(102, 102, 102)
			for(var i = 1; i <= char_count; i++) {
				var rgb = getFlatRGB( char_elements[i - 1].css('color') );
				switch(rgb) {
					case "255255255":
						char_elements[i - 1].css({color:'rgb(192, 192, 192)'});
						break;
					case "192192192":
						char_elements[i - 1].css({color:'rgb(153, 153, 153)'});
						break;
					case "153153153":
						char_elements[i - 1].css({color:'rgb(102, 102, 102)'});
						break;
			}
		}
		}

		anim_info.pos++;

		if( anim_info.pos > char_count + 2 ) {
			anim_info.pos = 0;
			anim_info.loop_count++;
			if(anim_info.loop_count >= anim_info.loops) {
				anim_info.loop_count = 0;
				pauseAnimation();
			}
		} else {
			if( char_list[anim_info.pos - 1] == String.fromCharCode(160) ) {
				anim_info.pos++;
		}

			$(element).find('.hlmt-' + anim_info.pos).css({color:'rgb(255, 255, 255)'});
			}
	};

	var pauseAnimation = function() {
		clearInterval( anim_info.timer );
		anim_info.timer = null;
		setTimeout(start, 2000);
	};

	this.animate = function( el ) {
		if( !anim_info.animating ) {
			init(el);
			start();
		}
	};

	var start = function() {
		anim_info.animating = true;
		anim_info.timer = setInterval(animationCallback, anim_info.speed);
	};

	this.stop = function() {
		$(element).empty();
		clearInterval( anim_info.timer );
		anim_info.timer = null;
		anim_info.animating = false;
		for(var i = 0; i < char_count; i++) {
			$(element).append(char_list[i]);
		}
	};
};

var highlightMeTextObj = new HighlightMeText();

</go:script>

<go:script marker="onready">

	$("#refine-quotes").on("click", function(){
		if( $(this).hasClass('active') ){
			compare.flushCompareList();
			Results.flushSelectedProducts(function(){
				QuoteEngine.poke();
				Results.submitRefineResults();
	});	
		}
		});
	
	$(document.body).on('click','a[data-toggleMoreDetails=true]',function(){
		Results.toggleMoreDetails($(this).data('client_type'),$(this).data('id'));
	});

	$(document.body).on('click','a[data-addProductToCart=true]',function(){
		Results.addProductToCart($(this).data('client_type'),$(this).data('id'));
	});


	$(document.body).on('click','a[data-revisedetails=true]',function(){
		Results.reviseDetails();
	});



</go:script>


<%-- HTML --%>
<div id="resultsPage" class="clearFix">

	<!-- add the more btn (itemId Id of container want to scroll too + scrollTo position of that item eg: top or bottom) -->
	<agg:moreBtn itemId="footer" scrollTo="top"/>	
	
		<div id="summary-header">
			<div>
			<h2>We have found <strong><!-- empty --></strong><span>These quotes have been provided by Lifebroker, a trusted partner of Comparethemarket.com.au.</span></h2>
			<a href="javascript:void(0);" data-savequote="true" id="save-my-quote" class="button-common" title="Save you quote"><span><!-- icon --></span>Save Quote</a>
			<a href="javascript:void(0);" data-revisedetails="true" id="revise-quote" class="button-common" title="Revise your details"><span><!-- icon --></span>Edit Details</a>
			</div>
		</div>
		
	<div id="refine-form-wrapper">
		<div class="innertube">
			<span class="text title">Refine results</span>
			<span class="arrow"><!-- arrow --></span>

<c:choose>
	<c:when test="${vertical eq 'ip'}">

<%-- REFINE CONTENT FOR IP --%>

			<span class="text">Gross annual income:</span>
			<span class="dollar"><!-- dollar --></span>
			<span class="input">
				<span class="left"><!-- empty --></span>
				<span class="body">
					<span class="value ${vertical}_refine_primary_insurance_income_value"><!-- empty --></span>
					<input type="text" name="${vertical}_refine_primary_insurance_income" id="${vertical}_refine_primary_insurance_income" maxlength="10" value=""  />
				</span>
				<span class="right"><!-- empty --></span>
			</span>
			<span class="delimeter"><!-- delimeter --></span>
			<span class="text">Benefit amount:</span>
			<span class="dollar"><!-- dollar --></span>
			<span class="input">
				<span class="left"><!-- empty --></span>
				<span class="body">
					<span class="value ${vertical}_refine_primary_insurance_amount_value"><!-- empty --></span>
					<input type="text" name="${vertical}_refine_primary_insurance_amount" id="${vertical}_refine_primary_insurance_amount" maxlength="10" value=""  />
				</span>
				<span class="right"><!-- empty --></span>
			</span>

<%-- END REFINE CONTENT FOR IP --%>

	</c:when>
	<c:otherwise>

<%-- REFINE CONTENT FOR LIFE --%>
			<select class="refine-type" id="${vertical}_refine_insurance_type" name="${vertical}_refine_insurance_type">
				<option value="primary" selected>Your Cover</option>
				<option value="partner">Partner Cover</option>
			</select>
			<span class="delimeter"><!-- delimeter --></span>
			<span class="text">Life insurance:</span>
			<span class="dollar"><!-- dollar --></span>
			<span class="input">
				<span class="left"><!-- empty --></span>
				<span class="body">
					<span class="value ${vertical}_refine_primary_insurance_term_value"><!-- empty --></span>
					<input type="text" name="${vertical}_refine_primary_insurance_term" id="${vertical}_refine_primary_insurance_term" maxlength="10" value=""  />
				</span>
				<span class="right"><!-- empty --></span>
			</span>
			<span class="delimeter"><!-- delimeter --></span>
			<span class="text">TPD:</span>
			<span class="dollar"><!-- dollar --></span>
			<span class="input">
				<span class="left"><!-- empty --></span>
				<span class="body">
					<span class="value ${vertical}_refine_primary_insurance_tpd_value"><!-- empty --></span>
					<input type="text" name="${vertical}_refine_primary_insurance_tpd" id="${vertical}_refine_primary_insurance_tpd" maxlength="10" value=""  />
				</span>
				<span class="right"><!-- empty --></span>
			</span>
			<span class="delimeter"><!-- delimeter --></span>
			<span class="text">Trauma:</span>
			<span class="dollar"><!-- dollar --></span>
			<span class="input">
				<span class="left"><!-- empty --></span>
				<span class="body">
					<span class="value ${vertical}_refine_primary_insurance_trauma_value"><!-- empty --></span>
					<input type="text" name="${vertical}_refine_primary_insurance_trauma" id="${vertical}_refine_primary_insurance_trauma" maxlength="10" value=""  />
				</span>
				<span class="right"><!-- empty --></span>
			</span>

<%-- END REFINE CONTENT FOR LIFE --%>

	</c:otherwise>
</c:choose>

			<a href='javascript:void(0);' id="refine-quotes" class="button-common" title="Get Quotes">Update Quotes</a>
						</div>
						</div>

	<div id="results-errors-wrapper">
		<div class="innertube"><!-- empty  --></div>
						</div>

	<life:compare quoteType="${vertical}" />

	<div id="results-mast-wrapper">
		<div class="partner"><!-- empty --></div>
		<div class="primary">
			<table class='results-mast'>
				<tr>
					<td class="col left"><!-- empty --></td>
					<td class="col mid">
						<div id="client-column-headers"><!-- populated by template --></div>
						<div class="clear"><!-- empty --></div>
						<div class="premium-summary">
							<span class="text">Estimated Monthly Premium</span>
							<span class="prim"><!-- populated with javascript --></span>
							<span class="part"><!-- populated with javascript --></span>
						</div>
						<div class="what-next">
							<span id="what-happens-next-text" class="col text dk">What&nbsp;happens&nbsp;next?</span>
							<a href='javascript:void(0);' id="we-call-you" class="button-common we-call-you" title="We Call You"><span><!-- icon --></span>We Call You</a>
							<span class="col text last">OR</span>
							<span class="col call-info">
								<%--<span class="col left"><!-- empty --></span>
								<span class="col mid">--%>
									<table><tbody><tr>
										<td class="text small">You call us</td>
										<td class="text">1800 204 124</td>
										<td class="delimeter"><!-- delimeter --></td>
										<td class="text small block">Remember to quote your reference no.</td>
										<td id="" class="text reference_no"><!-- populated by javascript --></td>
									</tr></tbody></table>
								<%--</span>
								<span class="col right"><!-- empty --></span>--%>
							</span>
							<div>A Lifebroker consultant can call you or you can call Lifebroker to discuss this option and process your insurance policy.</div>
						</div>
						<p class="legal">Comparethemarket.com.au is an online comparison website aimed at delivering our clients competitively priced yet comprehensive policies. Information and quotes are provided by our trusted partner, Lifebroker Pty Ltd.</p>
					</td>
					<td class="col right"><!-- empty --></td>
				</tr>
			</table>
					</div>
				</div>

	<div id="results-rows-wrapper">
		<div class="primary">
			<div id="results-rows-primary" class="innertube"><!-- empty --></div>
			<div class="clear"><!-- empty --></div>
			</div>
		<div class="partner">
			<div id="results-rows-partner" class="innertube"><!-- empty --></div>
			<div class="clear"><!-- empty --></div>
		</div>
		<div class="clear"><!-- empty --></div>
		</div>
	
	<%-- TEMPALTE FOR CLIENT HEADING --%>
	<core:js_template id="client-template">
		<span class="client [#= classname #]">
			<span class='col icon [#= gender #]'><!-- empty --></span>
			<span class='col age-smoker [#= smoker #]'>
				<p>Age <span class="age">[#= age #]</span></p>
				<div><!-- empty --></div>
			</span>
			<span class='col quotes-name'>
				<p>We have <span class="quotes">[#= count #]</span> quotes for</p>
				<p class="name">[#= name #]</p>
			</span>
			<span class='col select'><!-- empty --></span>
			<span class='col selected'><div class="logo"><a href="javascript:void(0);" class="drop-selected-product">drop selected product</a></div></span>
		</span>
	</core:js_template>
		
	<%-- TEMPLATE FOR RESULT ROW --%>
		<core:js_template id="result-template">
		<div class="results-row" id="result_[#= client_type #]_[#= product_id #]">
			<div id="more-info-[#= client_type #]_[#= product_id #]" class="more-info-slider">
				<table><tbody><tr>
					<td class="lft"><!-- empty --></td>
					<td class="mid"><div class="innertube">
						<span class="panel">
							<h4 >What's Included</h4>
							<ul class="inclusions"><!-- empty --></ul>
						</span>
						<span class="panel">
							<h4>Exclusions</h4>
							<ul class="exclusions"><!-- empty --></ul>
						</span>
						<span class="panel">
							<h4>Optional Extras</h4>
							<ul class="extras"><!-- empty --></ul>
						</span>
						<span class="panel">
							<h4>Product disclosure statement</h4>
							<p class="pds"><a href="javascript:void(0);" title="view the PDS">Product Disclosure Statement</a></p>
						</span>
						<span class="panel">
							<h4>Financial Services Guide</h4>
							<p class="pds"><a href="javascript:void(0);" class="showDoc" data-url="legal/Life_FSG.pdf" data-title="Financial Services Guide">Financial Services Guide (Life Insurance Products)</a></p>
						</span>
						<div class="clear"><!-- empty --></div>
					</div></td>
					<td class="rht"><!-- empty --></td>
				</tr></tbody></table>
				</div>			
			<a href="javascript:void(0);" data-addProductToCart="true" data-client_type="[#= client_type #]" data-id="[#= product_id #]" id="addtocart_[#= client_type #]_[#= product_id #]" class="add-to-cart-button box selector"><div class="loading"><!-- empty --></div></a>
			<div class="box detail">
				<div class="col left"><!-- empty --></div>
				<div class="col mid">
					<div class="product company">
						<div class="logo" title="[#= company #]" style="background-image:url('common/images/logos/life/83x53/[#= thumb #]');"><!-- logo --></div>
						<div class="seltocompare">
							<div class="col left"><!-- empty --></div>
							<div class="col mid">
								<a id="toggle-compare-[#= client_type #]-[#= product_id #]" href="javascript:void(0);" data-toggleInCompareList="true" data-client_type="[#= client_type #]" data-id="[#= product_id #]" class="selector"><!-- empty --></a>
				</div>
							<div class="col text"><!-- empty --></div>
							<div class="col right"><!-- empty --></div>
				</div>
				</div>
					<div class="product details">
						<p class="title">[#= name #]</p>
						<p>[#= description #]</p>
				</div>
					<div class="product price">
						<div class="amt">
							<h4>[#= priceHTML #]</h4>
							<p>[#= priceFrequency #]</p>
			</div>
						<div class="rowbtn">
							<a href="javascript:void(0);" data-toggleMoreDetails="true" data-client_type="[#= client_type #]" data-id="[#= product_id #]" id="moreinfobtn_[#= client_type #]_[#= product_id #]" class="button-common product-more-info" title="More Details">More Details</a>
							<div class="loading"><!-- empty --></div>
	</div>
			</div>
			</div>			
				<div class="col right"><!-- empty --></div>
		</div>
		</div>
	</core:js_template>
	
</div>