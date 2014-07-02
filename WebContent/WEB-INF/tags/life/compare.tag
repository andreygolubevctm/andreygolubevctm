<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 	required="true"	 rtexprvalue="true"	 description="Type of quote - life or ip" %>

<%-- VARIABLES --%>
<c:set var="includeThis" value="${true}" />

<c:if test="${includeThis eq true}">

<%-- HTML --%>
<div id="compare-form-wrapper">
	<div class="innertube">
		<div class="col primary">
			<p>Choose products below then select &quot;compare&quot;.</p>
			<table><tbody><tr>
				<td>Selected Product(s):</td>
				<td class="items">
					<div>
						<span class="product"><a href="javascript:void(0);" class="close">Close</a></span>
						<span class="product"><a href="javascript:void(0);" class="close">Close</a></span>
						<span class="product"><a href="javascript:void(0);" class="close">Close</a></span>
					</div>
				</td>
				<td>
					<a id="compare-benefits-primary" href="javascript:void(0);" class="common-button compare-button">Benefits</a>
					<a id="compare-graph-primary" href="javascript:void(0);" class="common-button compare-button">Graph</a>
				</td>
			</tr></tbody></table>
		</div>
		<div class="col partner">
			<p>Choose products below then select &quot;compare&quot;.</p>
			<table><tbody><tr>
				<td>Selected Product(s):</td>
				<td class="items">
					<div>
						<span class="product"><a href="javascript:void(0);" class="close">Close</a></span>
						<span class="product"><a href="javascript:void(0);" class="close">Close</a></span>
						<span class="product"><a href="javascript:void(0);" class="close">Close</a></span>
					</div>
				</td>
				<td>
					<a id="compare-benefits-partner" href="javascript:void(0);" class="common-button compare-button">Benefits</a>
					<a id="compare-graph-partner" href="javascript:void(0);" class="common-button compare-button">Graph</a>
				</td>
			</tr></tbody></table>
		</div>
	</div>
</div>
<life:compare_benefits />
<%-- NOT IN THIS BUILD <life:compare_graph />--%>

<go:script marker="js-head">

jQuery.fn.reverse = [].reverse;

var Compare = function( _config ) {

	var that				= this,
		list				= {
			primary:	{},
			partner:	{}
		},
		oldest_product		= {
			primary:	{},
			partner:	{}
		},
		comparison_shown	= false,
		maxCompare			= 3,
		selectedClass		= "active",
		elements			= {},
		benefits_obj 		= null,
		graph_obj 			= null,
		cache_data			= {},
		cache_age_limit		= (60 * 1000 * 10), // 10 minutes
		absolutised			= false,
		config				= {
			testingMode :		true,
			graph 		:		{
					show	:		false,
					text	:		"Show Graph"
			},
			benefits 	:		{
					show	:		true,
					text	:		"Compare"
			}
		};

	if( typeof _config == "object" ) {
		config = $.extend(config, _config);
	};

	$(document).ready(function() {

		elements = {
			primary	: {
				client_ref		: $("#${quoteType}_client_reference"),
				premium_type	: $("#${quoteType}_insurance_type")
			},
			partner	: {
				client_ref		: $("#${quoteType}_client_reference"),
				premium_type	: $("#${quoteType}_insurance_type")
			}
		};

		if( typeof CompareBenefits == "function" ) {
			for( var i in list ) {
				elements[i].benefits_btn = $('#compare-benefits-' + i);
				elements[i].benefits_btn.text(config.benefits.text).show();
			}
			benefits_obj = new CompareBenefits();
		}

		if( typeof CompareGraph == "function" ) {
			for( var i in list ) {
				elements[i].graph_btn = $('#compare-benefits-' + i);
				elements[i].graph_btn.text(config.benefits.text).show();
			}
			graph_obj = new CompareGraph();
		}
	});

	this.show = function( callback ) {
		$('#compare-form-wrapper').slideDown({duration: 'fast', complete: function(){
			if( !absolutised ) {
				setPlaceholdersAbsolute();
			}

			if( typeof callback == "function" ) {
				callback();
			}
		}});
	};

	this.hide = function( callback ) {
		$('#compare-form-wrapper').slideUp('fast', function(){
			if( typeof callback == "function" ) {
				callback();
			}
		});
	};

	<%--Empties the list of items to be compared --%>
	this.flushCompareList = function() {
		for(var i in list) {
			for(var j in list[i]) {
				dropFromCompareList(i, j);
			}
		}

		cache_data = {};
		<%-- Because IE, that's why. --%>
		$('#compare-benefits-wrapper').hide().find('.innertube').html('');
	};

	<%-- Add/Remove a product in a clients compare list --%>
	this.toggleInCompareList = function( type, product_id ) {
		var callback = function() {
			<%-- Exists so let's remove it --%>
			if( $('#toggle-compare-' + type + '-' + product_id).hasClass( selectedClass ) ) {
				if( list[type].hasOwnProperty( product_id ) ) {
					dropFromCompareList(type, product_id);
				}
			<%-- Doesn't exist so let's add it --%>
			} else {
				var callback = null;
				<%-- Drop oldest entry before adding if list at capacity--%>
				if( selectedCount( type ) >= maxCompare ) {
					dropFromCompareList(type, oldest_product[type], function(){
						$('#toggle-compare-' + type + '-' + product_id).addClass( selectedClass );
						if( !list[type].hasOwnProperty( product_id ) ) {
							appendCompareList(type, product_id);
						}
					});
				} else {
					if( !list[type].hasOwnProperty( product_id ) ) {
						appendCompareList(type, product_id);
					}
				}
			}
		}

		if( Results._renderingProducts ) {
			Results.forceShowAllProducts( callback );
		} else {
			callback();
		}
	};

	<%-- Drop item from compare list with a pretty animation --%>
	var dropFromCompareList = function(type, product_id, callback) {
		// Firstly let's remove the product from the compare list
		delete list[type][product_id];

		// update the oldest product object
		oldest_product[type] = getOldestProductAdded(type);

		$('#toggle-compare-' + type + '-' + product_id).removeClass( selectedClass );

		var commonFinish = function() {
			$('#comparebox-' + type + '-' + product_id).find('a').first().unbind('click').prop('id', null);
			if( typeof callback == "function" ) {
				callback();
			}

			benefits_obj.dropColumn(type, product_id);

			<%-- Show/Hide the compare button --%>
			toggleCompareButton(type);
		};

		<%-- Bypass animation if IE and less than IE8 --%>
		if( $.browser.msie && parseInt($.browser.version, 10) < 8 ) {
			$('#comparebox-' + type + '-' + product_id).removeClass('active').css({backgroundImage:'none'});
			commonFinish();
		} else {

			// Next we do a pretty animation
			var start = $("#comparebox-" + type + "-" + product_id);

			var start_pos = start.offset();
			var speed = 250;
			var travel_distance = Number(100);

			<%-- Calculate the top/left position on the line that is the travel_distance on the line between the start and finish --%>
			var x1 = start_pos.left;
			var y1 = start_pos.top;
			var x2 = start_pos.left;
			var y2 = start_pos.top + travel_distance;

			var copy = start.clone();
			copy.attr('id', 'compare_animated_logo_' + type + '_' + product_id).css({position:'absolute', width:44, height:25, top:start_pos.top, left:start_pos.left, border:'1px solid #06883e'}).appendTo('body');
			$('#comparebox-' + type + '-' + product_id).removeClass('active').css({backgroundImage:'none'});
			copy.animate({top:y2, left:x2, opacity:0.2}, speed, function(){
				copy.remove();
				commonFinish();
			});
		}
	};

	<%-- Add item to compare list with a pretty animation --%>
	var appendCompareList = function(type, product_id) {
		// Firstly, lets add the product to the compare list
		list[type][product_id] = Results.getProductByID( type, product_id );

		// update the oldest product object
		oldest_product[type] = getOldestProductAdded(type);

		$('#toggle-compare-' + type + '-' + product_id).addClass( selectedClass );

		// Next we do a pretty animation
		var elements = {
				start : 	$("#results-rows-" + type + " #result_" + type + "_" + product_id).find(".logo").first(),
				finish :	getNextAvailableCompareBox(type)
		};

		var completeLogoMove = function() {
			elements.finish.addClass('active');
			elements.finish.css({backgroundImage:"url(common/images/logos/life/44x25/" + list[type][product_id].thumb + ")"});
			elements.finish.prop("id", "comparebox-" + type + "-" + product_id);

			<%--Add event to the product close button --%>
			elements.finish.find('a').first().unbind('click').on('click', function() {
				that.toggleInCompareList(type, product_id);
			});

			<%-- Show/Hide the compare button --%>
			toggleCompareButton(type);
		};

		<%-- Bypass animation if IE and less than IE8 --%>
		if( $.browser.msie && parseInt($.browser.version, 10) < 8 ) {
			completeLogoMove();
		} else {
			var start_pos = elements.start.offset();
			var end_pos = elements.finish.offset();
			var speed = 250;
			var travel_distance = 250;

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
			copy.attr('id', 'compare_animated_logo_' + type + '_' + product_id).css({position:'absolute', width:83, height:53, top:start_pos.top, left:start_pos.left, border:'1px solid #b6b6b6'}).appendTo('body');
			copy.animate({top:py, left:px, opacity:0.2}, speed, function(){
				copy.remove();
				completeLogoMove();
			});
		}
	};

	<%-- Switches the button between being inactive/active compare button and a close button --%>
	var toggleCompareButton = function(type) {

		elements[type].benefits_btn.removeClass('active').removeClass('close')
		.text(config.benefits.text).unbind();

		if( selectedCount(type) >= 2 ) {
			if( comparison_shown ) {
				elements[type].benefits_btn.on('click', function(){
					benefits_obj.hide(function(){
						onComparisonHidden(type);
					});
				})
				.addClass('close')
				.text('close');
			} else {
				elements[type].benefits_btn.on('click', function(){
					that.benefits( type );
				})
				.text(config.benefits.text)
				.removeClass('close')
				.addClass('active');
			}
		} else {
			if( comparison_shown ) {
				benefits_obj.hide(function(){
					onComparisonHidden(type);
				});
			}
		}

		reSortPlaceholders();
	};

	<%-- Returns the next available compare panel (or false if none) --%>
	var getNextAvailableCompareBox = function( type ) {
		var compare_box = false;
		$($('#compare-form-wrapper .' + type).find('.product').reverse()).each(function(){
			if(!$(this).hasClass('active')) {
				compare_box = $(this);
			}
		});

		return compare_box;
	};

	<%-- Public method for rendering the comparison graph --%>
	this.graph = function( type ) {

		if( graph_obj != null ) {
			if( selectedCount(type) < 2 ) {
				throwMinSelectionError();
			} else {

				var data = {
						type :				type,
						client_reference : 	elements.client_ref.val(),
						premium_type :		elements.premium_type.val(),
						products :			getSelectedProductsFlatList(type),
						transactionId:		referenceNo.getTransactionID()
				};

				graphCall( data );
			}
		}
	};

	<%-- Private call to API to retrieve and render the graph content --%>
	var graphCall = function( data ) {

		Loading.show();

		$.ajax({
			url: "ajax/json/lifebroker_graph.jsp",
			data: data,
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

				if(
					json.hasOwnProperty("results") &&
					json.results.hasOwnProperty("graph") &&
					typeof json.results.graph.json == "string" &&
					json.results.graph.json.length
				) {
					var sanitised = json.results.graph.json.replace(/,]/g, "]").replace(/'/g, "\"");
					json.results.graph.json = jQuery.parseJSON( sanitised );
					compareGraph.launch( json.results.graph.json );
				} else {
					FatalErrorDialog.exec({
						message:		"An invalid response was received when fetching the graph data.",
						page:			"compare.tag",
						description:	"Compare.compareCall().  Invalid response object received.",
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
					page:			"compare.tag",
					description:	"Compare.graphCall().  AJAX Request failed: " + txt,
					data:			data
				});
			}
		});
	};

	<%-- Public method for rendering the benefits comparison --%>
	this.benefits = function( type ) {

		if(benefits_obj != null ) {
			if( selectedCount( type ) < 2 ) {
				throwMinSelectionError();
			} else {
				var data = {
						type : type,
						products : getSelectedProductsFlatList( type )
				};

				benefitsCall( data );
			}
		}
	};

	<%-- Private call to API to retrieve and render the benefits comparison content --%>
	var benefitsCall = function( data ) {

		var cache = cacheDataExists(data);

		if( cache !== false ) {
			benefits_obj.show( cache, function(){
				onComparisonShown(data.type);
			} );
		} else {

			Loading.show("Loading Products...");
			data.transactionId = referenceNo.getTransactionID();

			$.ajax({
				url: "ajax/json/lifebroker_benefits.jsp",
				data: data,
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
				success: function(json){
					Loading.hide();

					if( json.results.success ) {
						if(
							json.hasOwnProperty("results") &&
							json.results.hasOwnProperty("features") &&
							typeof json.results.features.product == "object" &&
							json.results.features.product.constructor == Array &&
							json.results.features.product.length
						) {
							// Do cleanup here to remove age related multiples
							for(var i in json.results.features.product) {
								json.results.features.product[i].feature = sanitiseFeatures(json.results.features.product[i].feature);
							}

							var output = sanitiseCompareData(json.results.features.product, data.type);
							addDataToCache(output);
							benefits_obj.show( output, function(){
								onComparisonShown(data.type);
							} );
						} else {
							FatalErrorDialog.exec({
								message:		"An invalid response was received when fetching the benefits data.",
								page:			"compare.tag",
								description:	"Compare.benefitsCall().  Invalid response object received.",
								data:			{
										sent:		data,
										received:	json
								}
							});
						}
					} else {
						var msg = "This service is temporarily unavailable. Please try again later.";
						FatalErrorDialog.exec({
							message:		msg,
							page:			"compare.tag",
							description:	"Compare.benefitsCall().  Service is currently unavailable.",
							data:			{
									sent:		data,
									received:	json,
									errors:		json.results.error
							}
						});
					}
					return false;
				},
				error: function(obj,txt, errorText){
					Loading.hide();
					FatalErrorDialog.exec({
						message:		"An error occurred when fetching the comparison data: " + txt,
						page:			"compare.tag",
						description:	"Compare.compareCall().  AJAX Request failed: " + txt,
						data:			data
					});
				}
			});
		}
	};

	var setPlaceholdersAbsolute = function() {
		for(var type in list) {
			var spots = $('#compare-form-wrapper .' + type).find('.product');
			var bgs = [$(spots[0]).css('background-image'),$(spots[1]).css('background-image'),$(spots[2]).css('background-image')];
			$(spots[0]).removeAttr('style').attr("style", "position:absolute;top:3px;left:15px;background-image:" + bgs[0] + ";");
			$(spots[1]).removeAttr('style').attr("style", "position:absolute;top:3px;left:76px;background-image:" + bgs[1] + ";");
			$(spots[2]).removeAttr('style').attr("style", "position:absolute;top:3px;left:137px;background-image:" + bgs[2] + ";");
			$('#compare-form-wrapper .' + type).find('td.items:first').sortable('disable');
		}

		absolutised = true;
	};

	var reSortPlaceholders = function() {

		var speed = 100;

		for(var type in list) {

			var callback = function( type, index ) {

				var spots = $('#compare-form-wrapper .' + type).find('.product');

				var next_i = index + 1;
				if( index < 2 && !$(spots[index]).hasClass('active') && $(spots[next_i]).hasClass('active') ) {
					var pos1 = $(spots[index]).position().left;
					var pos2 = $(spots[next_i]).position().left;
					$(spots[next_i]).insertBefore($(spots[index]));
					$(spots[index]).animate({left:pos2}, speed);
					$(spots[next_i]).animate({left:pos1}, speed);
					setTimeout(function(){
						callback(type, next_i);
					},speed + 5);
				} else if(index < 2) {
					callback(type, next_i);
				}
			}

			callback(type, 0);
		};

	};

	var onComparisonShown = function(type) {
		comparison_shown = true;
		for(var i in list) {
			if( i == type ) {
				$('#compare-form-wrapper').find('.' + i).first().fadeIn('fast');
			} else {
				$('#compare-form-wrapper').find('.' + i).first().fadeOut('fast');
			}
		}
		toggleCompareButton(type);
	};

	var onComparisonHidden = function(type) {
		comparison_shown = false;
		for(var i in list) {
			if( i == 'primary' || (i == 'partner' && Results._partnerQuote)) {
				$('#compare-form-wrapper').find('.' + i).first().fadeIn('fast');
			}
		}
		toggleCompareButton(type);
	};

	var sanitiseCompareData = function( data, type ) {

		var sanitised = {
				type :		type,
				columns :	data.length,
				features :	[],
				products :	{}
		};

		/* Retain this code as there is a high likelihood that provider specific ordering will be implemented soon.
		var official_order = LifeQuote.getFeaturesOrder();
		*/

		// Add flat list of features (for creating rows later)
		for( var i = 0; i < data[0].feature.length; i++ ) {
			sanitised.features.push( data[0].feature[i].name );
		}

		// Add list of products inc features
		for( var j = 0; j < data.length; j++ ) {

			// Build flat features list for product
			var features = [];
			for( var k = 0; k < data[j].feature.length; k++ ) {
				var f = data[j].feature[k];
				features.push(f.available);
			}

			// Add product info
			var prod = Results.getProductByID( type, data[j].id );

			var info = {
				id :	data[j].id,
				type :	prod.client_type,
				logo :	"common/images/logos/life/83x53/" + prod.thumb,
				price :	prod.priceHTML,
				freq :	prod.priceFrequency,
				pds :	prod.pds,
				info :	prod.info,
				name :	prod.name,
				desc :	prod.description
			};

			// Copy product and insert features then append to sanitised products list
			sanitised.products[data[j].id] = $.extend(
				true,
				list[data[j].id], {
					features : features,
					info : info
				}
			);
		}

		return sanitised;
	};

	var sanitiseFeatures = function(features)
	{
		/* Retain this code as there is a high likelihood that provider specific ordering will be implemented soon.
		var official_order = LifeQuote.getFeaturesOrder();
		*/

		// List of feature code groups applicable to age
		var feature_groups = LifeQuote.getFeatureGroups();

		// Get selected features
		var selected_waiting_period = LifeQuote.getSelectedWaitingPeriodCode();
		var selected_benefit_period = LifeQuote.getSelectedBenefitPeriodCode();

		var output = [];

		if( typeof features == "object" && features.constructor == Array )
		{
			for(var i = 0; i < features.length; i++)
			{
				// Test if feature is age related
				var feature_grp = false;
				var feature_pos = false;
				for(var j in feature_groups)
				{
					var pos = arrayIndex(feature_groups[j], features[i].id);

					if( pos !== false && pos >= 0 )
					{
						feature_grp = j;
						feature_pos = pos;
						break;
					}
				}

				// Just add if not age related
				if(	!feature_grp )
				{
					output[features[i].id] = features[i];
				}
				// Otherwise only add if age is the highest in its group and
				// delete any lesser ones added previously
				else
				{
					var feature_highest = true;
					for(var k = 0; k < feature_groups[feature_grp].length; k++)
					{
						if( output.hasOwnProperty(feature_groups[feature_grp][k]) )
						{
							if( feature_grp == 'waiting_period' ) {
								if( feature_groups[feature_grp][k] < selected_waiting_period || feature_groups[feature_grp][k] > selected_waiting_period )
								{
									delete output[feature_groups[feature_grp][k]];
								}
								else
								{
									feature_highest = false;
								}
							} else if( feature_grp == 'benefit_period' ) {
								if( feature_groups[feature_grp][k] < selected_benefit_period || feature_groups[feature_grp][k] < selected_benefit_period )
								{
									delete output[feature_groups[feature_grp][k]];
								}
								else
								{
									feature_highest = false;
								}
							} else {
								// Delete the old and keep the highest
								if( k < feature_pos )
								{
									delete output[feature_groups[feature_grp][k]];
								}
								else
								{
									feature_highest = false;
								}
							}
						}
					}

					if( feature_highest )
					{
						output[features[i].id] = features[i];
					}
				}
			}
		}

		var final_output = [];

		/* Retain this code as there is a high likelihood that provider specific ordering will be implemented soon.
		for(var i = 0; i < official_order.length; i++) {
			if( output[official_order[String(i)]] && output.hasOwnProperty(official_order[String(i)]) ) {
				final_output.push(output[official_order[String(i)]]);
			}
		}*/

		for( var i in output) {
			final_output.push(output[i]);
		}

		return final_output;
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

	var getSelectedProductsFlatList = function( type ) {

		var flat = "";

		for(var i in list[type]) {
			if( flat.length ) {
				flat += "," + i
			} else {
				flat = i;
			}
		}

		return flat;
	};

	var selectedCount = function( type ) {

		var count = 0;

		for(var i in list[type]) {
			count++;
		}

		return count;
	};

	var getOldestProductAdded = function(type) {

		for(var i in list[type]) {
			return i;
		}

		return false;
	};

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
};

var compare = new Compare();

$(document).on('click','a[data-toggleincomparelist=true]',function(){
		compare.toggleInCompareList($(this).data('client_type'),$(this).data('id'));
	});
</go:script>

<go:style marker="css-head">

	#compare-form-wrapper {
		display:				none;
		height:					59px;
		background:				url("brand/ctm/images/results_Life_IP/bkg_comparerow.png") top left repeat-x;
	}

	#compare-form-wrapper .innertube {
		width:					980px;
		margin:					0 auto;
	}

	#compare-form-wrapper p {
		color:					#035024;
		font-size:				8pt;
		padding:				10px 0px 0px 0px;
	}

	#compare-form-wrapper .col {
		float:					left;
		width:					489px;
	}

	#compare-form-wrapper .col.primary {
		border-right:			1px solid #00c461;
	}
	#resultsPage.single #compare-form-wrapper .col.primary {border:none;}

	#compare-form-wrapper .col.partner {
		float:					right;
		width:					469px;
		padding-left:			20px;
		border-left:			1px solid #009533;
	}
	#resultsPage.single #compare-form-wrapper .col.partner {display:none;}

	#compare-form-wrapper table {
		height:					33px;
		margin-bottom:			4px;
	}

	#compare-form-wrapper td {
		position:				relative;
		vertical-align:			middle;
		color:					#ffffff;
		font-weight:			bold;
		font-size:				13.5pt !important;
	}

	#compare-form-wrapper td.items {
		width:					183px;
	}

	#compare-form-wrapper td.items div {
		position:				relative;
		height:					33px;
	}

	#compare-form-wrapper .product {
		display:				inline-block;
		vertical-align:			top;
		padding:				0;
		margin:					0;
		width:					44px;
		height:					25px;
		border:					1px solid #2e6632;
		background:				#009e45;
		background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #009e45), color-stop(100%, #00ad43));
		background-image: 		-webkit-linear-gradient(#009e45, #00ad43);
		background-image: 		-moz-linear-gradient(#009e45, #00ad43);
		background-image: 		-o-linear-gradient(#009e45, #00ad43);
		background-image: 		linear-gradient(#009e45, #00ad43);
		-pie-background: 		linear-gradient(#009e45, #00ad43);
	}

	#compare-form-wrapper .product.active {
		border-color:			#06883e;
		background:				#ffffff;
		background-position:	50% 50%;
		background-repeat:		no-repeat;
	}

	#compare-form-wrapper .product .close {
		position:				relative;
		display:				none;
		width:					14px;
		height:					14px;
		top:					-7px;
		right:					-37px;
		background:				url('brand/ctm/images/results_Life_IP/closeIcon.png') 50% 50% no-repeat;
		overflow:				hidden;
		text-indent:			-10000px;
	}
	#compare-form-wrapper .product.active .close {display:block;}

	#compare-form-wrapper .common-button {
		position: 				relative;
		float: 					left;
		color:					#009633;
		font-size:				8pt;
		font-weight:			bold;
		text-decoration:		none;
		padding:				6px 10px 5px 10px;
		margin: 				0 0 0 15px;
		-moz-border-radius: 	6px;
		-webkit-border-radius:	6px;
		-o-border-radius: 		6px;
		-ms-border-radius: 		6px;
		-khtml-border-radius:	6px;
		border-radius: 			6px;
	}

	#compare-form-wrapper a.compare-button {
		display:				none;
		background:				#00a642;
		background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #00ac49), color-stop(100%, #00a642));
		background-image: 		-webkit-linear-gradient(#00ac49, #00a642);
		background-image: 		-moz-linear-gradient(#00ac49, #00a642);
		background-image: 		-o-linear-gradient(#00ac49, #00a642);
		background-image: 		linear-gradient(#00ac49, #00a642);
		-pie-background: 		linear-gradient(#00ac49, #00a642);
		border: 				1px solid #00a13e;
		-moz-box-shadow: 		inset 0 1px 0 0 #00b450;
		-webkit-box-shadow: 	inset 0 1px 0 0 #00b450;
		-o-box-shadow: 			inset 0 1px 0 0 #00b450;
		box-shadow: 			inset 0 1px 0 0 #00b450;
	}

	#compare-form-wrapper a.compare-button:hover {
		cursor:					default;
	}

	#compare-form-wrapper a.compare-button.active {
		color: 					#FFF;
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

	#compare-form-wrapper a.compare-button.active:hover {
		cursor:					pointer;
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

	#compare-form-wrapper a.compare-button.close {
		color: 					#FFF;
		background:				#ff8400;
		background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #ffa200), color-stop(100%, #ff8400));
		background-image: 		-webkit-linear-gradient(#ffa200, #ff8400);
		background-image: 		-moz-linear-gradient(#ffa200, #ff8400);
		background-image: 		-o-linear-gradient(#ffa200, #ff8400);
		background-image: 		linear-gradient(#ffa200, #ff8400);
		-pie-background: 		linear-gradient(#ffa200, #ff8400);
		border: 				1px solid #df6f00;
		-moz-box-shadow: 		inset 0 1px 0 0 #fbe1b4;
		-webkit-box-shadow: 	inset 0 1px 0 0 #fbe1b4;
		-o-box-shadow: 			inset 0 1px 0 0 #fbe1b4;
		box-shadow: 			inset 0 1px 0 0 #fbe1b4;
	}

	#compare-form-wrapper a.compare-button.close:hover {
		cursor:					pointer;
		background:				#ffa200;
		background-image: 		-webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #ff8400), color-stop(100%, #ffa200));
		background-image: 		-webkit-linear-gradient(#ff8400, #ffa200);
		background-image: 		-moz-linear-gradient(#ff8400, #ffa200);
		background-image: 		-o-linear-gradient(#ff8400, #ffa200);
		-pie-background: 		linear-gradient(#ff8400, #ffa200);
		-moz-box-shadow: 		inset 0 1px 0 0 #fbe1b4;
		-webkit-box-shadow: 	inset 0 1px 0 0 #fbe1b4;
		-o-box-shadow: 			inset 0 1px 0 0 #fbe1b4;
		box-shadow: 			inset 0 1px 0 0 #fbe1b4;
	}

	#compare-error {
		display:				none;
	}

	#compare-error h5 {
		height:					53px !important;
		padding-top:			20px !important;
	}

	#compare-error #compare-error-text {
		padding-left:			15px !important;
		padding-right:			15px !important;
		line-height:			16px;
	}
</go:style>

</c:if>