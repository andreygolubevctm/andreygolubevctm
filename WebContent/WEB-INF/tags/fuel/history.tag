<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="includeThis" value="${true}" />
<c:set var="popup_width" value="900" />
<c:set var="popup_height" value="300" />

<c:if test="${includeThis eq true}">

<%-- HTML --%>
<div id="price-history-button-row"><!-- empty --></div>
<script type="text/javascript">google.load("visualization", "1", {packages:["corechart"]});</script>

<%-- Load Google Chart API --%>
<go:script marker="js-href" href="https://www.google.com/jsapi" />

<go:script marker="js-head">

var FuelPriceHistory = function() {

	var that				= this,
		initialised			= false,
		elements			= {},
		benefits_obj 		= null,
		graph_obj 			= null,
		cache_data			= {},
		cache_age_limit		= (60 * 1000 * 10); // 10 minutes

	this.init = function() {

		if( initialised === false ) {

			elements.btn_wrap = $("#price-history-button-row").hide();

			elements.btn = $("<a/>",{
				text: "View Price History"
			})
			.on("click", showHistory);

			elements.btn_wrap.append( elements.btn );

			elements.close = $("<div/>",{
				id: "price-history-chart-close"
			}).on("click", hideHistory);

			elements.content = $("<div/>",{
				id: "price-history-chart-content"
			});

			elements.popup = $("<div/>",{
				id: "price-history-chart"
			})
			.append( elements.close )
			.append( elements.content )
			.hide();

			elements.mask = $("<div/>",{
				id: "price-history-chart-mask"
			}).on("click", hideHistory)
			.hide();

			$("body").append(elements.popup)
			.append(elements.mask);

			initialised = true;
		}

		toggleButton();
	};

	var isMetro = function() {
		return Results._source !== false && Results._source == "metro";
	};

	this.hideButton = function() {
		toggleButton(true);
	};

	var toggleButton = function( force_hide ) {

		force_hide = force_hide || false;

		if( force_hide === false && isMetro() && Results._priceCount ) {
			elements.btn_wrap.fadeIn("slow");
		} else {
			elements.btn_wrap.fadeOut("fast");
		}
	};

	var showHistory = function() {

		if( isMetro() ) {
			var callback = function( data ) {
				updateDimensionsNPosition();
				elements.mask.show();
				elements.popup.fadeIn("fast", function(){
					renderChart( data );
				});
			};

			getData( callback );
		}
	};

	var hideHistory = function() {
		elements.popup.fadeOut("fast", function(){
			elements.mask.hide();
		});
	};

	var updateDimensionsNPosition = function() {
		var width = ${popup_width};
		var height = ${popup_height};
		var viewportWidth = jQuery(window).width(),
			viewportHeight = jQuery(window).height(),
			scrolltop = $(window).scrollTop();
		elements.popup.css({
			top :	scrolltop + (viewportHeight/2) - (height/2),
			left :	(viewportWidth/2) - (width/2)
		});
		elements.mask.css({height:$(document).height()});
	};

	var getChartTitle = function() {
		var title = "Average monthly prices for selected fuel types in and around ";
		var location = $('#fuel_location').val();
		if( isNaN(location.substring(1,5)) ) {
			title += location;
		} else {
			title += "the postcode: " + location;
		}

		return title;
	};

	var renderChart = function( json ) {

		var data = google.visualization.arrayToDataTable( json );
		//Set up currency format for all lines
		var formatter = new google.visualization.NumberFormat({fractionDigits:1});
		for (i = 1; i < data.getNumberOfColumns(); i++) {
			formatter.format(data, i);
		}
		var options = {
				title: 				getChartTitle(),
				titleTextStyle:		{
					fontSize: $.browser.msie ? 14 : 16,
					bold: true,
					color: '#1C3F94'
				},
				legend:				{
					position:	'right'
				},
				hAxis:				{
					title:		'Month/Year'
				},
				vAxis:				{
					title:		'Price',
					format:		'0.0'
				},
				axisTitlesPosition:	'out',
				pointSize:		3,
				series: [{color:'#0C4DA2'},{color:'#0CB24E'},{color:'#333333'}]
		};
		var chart = new	google.visualization.LineChart(document.getElementById(elements.content.attr("id")));
		chart.draw(data, options);
	};

	var getData = function( callback ) {

		Loading.show("Retrieving Price History");

		var data = $("#mainform").serialize();
		data+="&transactionId="+referenceNo.getTransactionID();

		$.ajax({
			url: "ajax/json/fuel_price_monthly_averages.jsp",
			data: meerkat.modules.form.getSerializedData($('#mainform')),
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(json) {

				Loading.hide();

				if( json.hasOwnProperty("results") && json.results.success ) {
					var sanitised = sanitiseData( String(json.results.fuels).split(","), json.results.prices );
					callback( sanitised );
				} else {
					FatalErrorDialog.exec({
						message:		"Sorry, this service is temporarily unavailable. Please try again later.",
						page:			"history.tag",
						description:	"FuelPriceHistory.getData(). " + json.results.error,
						data:			{
								sent:		data,
								received:	json
						}
					});
				}

				return false;
			},
			error: function(obj,txt, errorText){

				Loading.hide();

				FatalErrorDialog.exec({
					message:		"An error occurred when fetching the graph data:" + txt,
					page:			"history.tag",
					description:	"FuelPriceHistory.getData().  AJAX Request failed: " + txt,
					data:			data
				});
			}
		});
	};

	var sanitiseData = function( fuels, prices ) {

		<%-- FOR TESTING FULL YEAR
		return [
			["Month", "Premium Unleaded 95", "Premium Unleaded 98"],
			["Sep'13", 162.01, 162.02],
			["Aug'13", 152.01, 152.02],
			["Jul'13", 142.01, 142.02],
			["Jun'13", 132.01, 132.02],
			["May'13", 122.01, 122.02],
			["Apr'13", 112.01, 112.02],
			["Mar'13", 102.01, 102.02],
			["Feb'13", 142.01, 142.02],
			["Jan'13", 162.01, 162.02],
			["Dec'13", 182.01, 182.02],
			["Nov'13", 112.01, 112.02],
			["Oct'13", 80.01, 80.02]
		]; --%>

		var output = [];

		<%-- Create temp object to store the fuel type prices in month order --%>
		var temp = {};
		for(var j = 0; j < prices.length; j++) {
			var amount = Number(Number(prices[j].amount/10).toFixed(1));
			var type = getFuelLabel(prices[j].type);
			var period = getMonthString(prices[j].period.substr(5)) + "'" + prices[j].period.substr(2, 2);

			if( !temp.hasOwnProperty(period) ) {
				temp[period] = [period];
				for(var k = 0; k < fuels.length; k++) {
					temp[period].push(0);
				}
			}

			temp[period][arrayIndex(fuels, prices[j].type) + 1] = amount;//{v:amount,f:'$' + String(amount)};
		}

		<%-- Inject month ordered results back in output --%>
		for(var l in temp) {
			output.unshift(temp[l]);
		}

		<%-- Add Fuel Type labels to the graph labels section --%>
		output.unshift(["month"]);
		for(var i = 0; i < fuels.length; i++) {
			var label = getFuelLabel(fuels[i]);
			if( $.inArray(label, output[0]) === -1 ) {
				output[0].push(label);
			}
		}

		return output;
	};

	var getMonthString = function( index ) {
		var months = {
			'01' : "Jan",
			'02' : "Feb",
			'03' : "Mar",
			'04' : "Apr",
			'05' : "May",
			'06' : "Jun",
			'07' : "Jul",
			'08' : "Aug",
			'09' : "Sep",
			'10' : "Oct",
			'11' : "Nov",
			'12' : "Dec"
		};

		return months[index];
	}

	var getFuelLabel = function( fuelid ) {
		var labels = ['Unknown', 'Unknown', 'Unleaded', 'Diesel', 'LPG', 'Premium Unleaded 95', 'E10', 'Premium Unleaded 98', 'Bio-Diesel 20', 'Premium Diesel'];
		return labels[fuelid];
	}

	var cacheDataExists = function(data) {
		cleanCache();

		var requested_products = data.products.split(",");
		for(var i in cache_data) {
			var o = cache_data[i].products;
			<%-- If cache entry is same size as request then we're one step closer --%>
			if( getObjPropertiesCount(o) == requested_products.length ) {
				<%-- If we have the same product IDs then we have a match --%>
				var match = true;
				for(var j in requested_products) {
					if( !o.hasOwnProperty(requested_products[j]) ) {
						match = false;
					}
				}
				if(match !== false) {
					return cache_data[i];
				}
			}
		}

		return false;
	};

	var addDataToCache = function(data) {
		cleanCache();
		cache_data[new Date().getTime()] = data;
	};

	var cleanCache = function() {
		var age_limit = (new Date().getTime()) - cache_age_limit;
		for(var i in cache_data) {
			if( i < age_limit ) {
				delete cache_data[i];
			}
		}
	};

	var getObjPropertiesCount = function(obj) {
		var count = 0;
		for (k in obj) if (obj.hasOwnProperty(k)) count++;
		return count;
	};

	var arrayIndex = function(arr, token)
	{
		if( typeof arr == "object" && arr.constructor == Array )
		{
			for(var i = 0; i < arr.length; i++)
			{
				if( arr[i] == token )
				{
					return i;
				}
			}
		}

		return false;
	};

	var throwMinSelectionError = function() {

		error(
			"Mimumum of 2 products can be compared.",
			"A minimum of 2 products need to be selected to do a comparison. Please select more products before continuing."
		);
	};

	var throwMaxSelectionError = function() {

		error(
			"Maximum of 4 products can be compared.",
			"A maximum of 4 products can be compared at one time. Please deselect a product before attempting to add a new product to be compared."
		);
	};

	var throwNoFeaturesError = function() {

		error(
			"Sorry, cannot complete your request.",
			"We were unable to retrieve the list of features for the selected products. Please try again later."
		);
	};

	var error = function (title, message) {

		$("#compare-error h5").text(title);
		$("#compare-error-text").text(message);
		Popup.show("#compare-error", "#loading-overlay");
	};

	/*var getDummyGraphData = function() {
		return {
			graph : {
				json : "[['Age', 'Asteron Life - Complete - Life Cover w Linked Trauma','AIA Australia - Life Cover Plan w Crisis Recovery'],['30',53.86,52.59,],['34',57.28,57.03,],['38',68.36,69.72,],['42',95.43,95.31,],['46',143.98,148.61,],['50',242.64,235.75,],['54',413.38,397.12,],['58',665.81,638.23,],['62',1108.91,1039.66,],['66',null,null,],]"
			}
		};
	};*/

	$(document).ready(that.init);
};

var fuel_price_history = new FuelPriceHistory();
</go:script>

<go:style marker="css-head">

	#price-history-button-row {
		position:				relative;
		display:				none;
		width:					980px;
		height:					25px;
		margin:					10px auto;
		top:					-120px;
	}

	#price-history-button-row a {
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

	#price-history-button-row a:hover {
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

	#price-history-button-row a span {
		position: 				absolute;
		left: 					10px;
		top: 					6px;
		width: 					20px;
		height: 				20px;
	}

	#price-history-chart,
	#price-history-chart-content {
		display:				none;
		position:				absolute;
		width:					${popup_width}px;
		height:					${popup_height}px;
		background:				#ffffff;
		z-index:				26000 !important;
		-webkit-border-radius:	5px;
		-moz-border-radius: 	5px;
		border-radius: 			5px;
	}

	#price-history-chart {
		-webkit-box-shadow: 	0px 0px 30px rgba(0, 0, 0, 0.75);
		-moz-box-shadow:		0px 0px 30px rgba(0, 0, 0, 0.75);
		box-shadow:				0px 0px 30px rgba(0, 0, 0, 0.75);
	}

	#price-history-chart-content {
		display:				block;
		position:				relative;
	}

	#price-history-chart-close {
		display:				block;
		position:				absolute;
		width:					36px;
		height:					36px;
		top:					-30px;
		right:					-30px;
		background:				url(common/images/dialog/close.png) 50% 50% no-repeat;
		text-indent:			-10000px;
	}

	#price-history-chart-mask {
		position: 				absolute;
		left: 					0;
		right: 					0;
		bottom: 				0;
		top: 					0;
		z-index: 				1000;
		background:				#000000;
		zoom: 					1;
		filter: 				alpha(opacity=20);
		opacity: 				0.2;
		visibility: 			visible;
		display:				none;
	}

	#price-history-chart #price-history-chart-content svg g:nth-child(1) text:nth-child(2) {
		color:red !important;
	}
</go:style>

</c:if>