var LifeQuote = {

	ajaxPending : false,

	premiumFrequency : false,

	_vertical : 'life',

	_new_quote : quoteCheck._new_quote,

	_testingMode : false,
	_tempFields : {},

	cache_active : true,

	cache_age_limit : (60 * 1000 * 10), // 10 minutes

	cache_type : {
		details : 'product_details',
		results : 'results'
	},

	cache_data : {
		product_details : {},
		results : {}
	},

	_init : function()
	{
		slide_callbacks.register({
			mode:		"before",
			direction:	"reverse",
			slide_id:	-1,
			callback: 	function() {
				if( QuoteEngine._options.prevSlide == 1 ) {
					referenceNo.generateNewTransactionID(3);
				}
			}
		});
	},

	generateNewQuote: function()
	{
		referenceNo.getTransactionID( ReferenceNo._FLAG_INCREMENT );
	},

	fetchPrices: function(){
		if (LifeQuote.ajaxPending){
			// we're still waiting for the results.
			return;
		}
		Loading.show("Loading premiums...");

		LifeQuote.cleanCache( LifeQuote.cache_type.details, true );

		LifeQuote.applyTestingData();

		var data = $("#mainform").serialize() + "&vertical=" + LifeQuote._vertical;
		LifeQuote.ajaxPending = true;
		$.ajax({
			url: "ajax/json/life_quote_results.jsp",
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
			success: function(jsonResult){
				LifeQuote.ajaxPending = false;
				Loading.hide();
				if( jsonResult.results.success ) {
					if( LifeQuote.isValidResultsResponse(jsonResult) )
					{
						if( LifeQuote.responseContainsProducts(jsonResult) )
						{
							// Update form with client/product data
							LifebrokerRef.updateClientFormFields( jsonResult.results.client.reference, null );
							var clean_data = LifeQuote.sanitiseResults(jsonResult.results.products.premium, jsonResult.results.client.reference, jsonResult.results.transactionId);
							Results.update(clean_data, jsonResult.results.transactionId);
							Results.show();
							Results._revising = true;

							LifeQuote.removeTestingData();

							// Form updated with client reference now so update databucket again
							LifebrokerRef.updateDataBucket();
						}
						else
						{
							Results.showErrors(["No results found, please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>."]);
						}
					}
					else
					{
						var msg = "Invalid response received. Please try again later.";
						try {
							if( typeof jsonResult.results.products.error == "string" && jsonResult.results.products.error.constructor == String )
							{
								msg = jsonResult.results.products.error + " Please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>.";
							}
						} catch(e) { /* IGNORE */ }

						Results.showErrors([msg]);
					}
				} else {
					var msg = "This service is temporarily unavailable. Please try again later.";
					Results.showErrors([msg]);
				}

				LifeQuote.removeTestingData();

				return false;
			},
			error: function(obj,txt){
				LifeQuote.ajaxPending = false;
				Loading.hide();

				LifeQuote.removeTestingData();
				FatalErrorDialog.register({
					message:		"An error occurred when fetching prices: " + txt,
					page:			"common/life.js:fetchPrices",
					description:	LifeQuote._vertical + " Quote Results. An error occurred when trying to successfully call or parse the results.",
					data:			data
				});
				Results.showErrors(["An error occurred when fetching premiums: " + txt]);
			}
		});
	},

	isValidResultsResponse : function( json )
	{
		return typeof json.results == 'object' && (typeof json.results.products == 'object' || json.results.products == "") && typeof json.results.client == 'object';
	},

	responseContainsProducts : function( json )
	{
		var is_valid = false;

		// First test the response contains ANY products
		if( typeof json.results.products == "object" && json.results.products.hasOwnProperty("premium") && typeof json.results.products.premium == "object" && json.results.products.premium instanceof Array && json.results.products.premium.length ) {
			// Now check that at least one product is now 'below_min'
			for(var i=0; i < json.results.products.premium.length; i++)
			{
				if(
					(json.results.products.premium[i].hasOwnProperty("below_min") &&
					json.results.products.premium[i].below_min == "N") &&
					(
						!json.results.products.premium[i].hasOwnProperty("partner_below_min") ||
						(json.results.products.premium[i].hasOwnProperty("partner_below_min") &&
						json.results.products.premium[i].partner_below_min == "N")
					)
				) {
					is_valid = true;
					break;
				}
			}
		}

		return is_valid;
	},

	/**
	 * sanitiseResults is needed to remove results that may not contain all required fields.
	 * Occasionally a result will only contain the product id and value.
	 *
	 * We're also going to add the client ref to each product for ease of later use.
	 */
	sanitiseResults: function(results, client_ref, transaction_id)
	{
		var output = {
				primary : [],
				partner : []
		};

		for(var i=0; i < results.length; i++)
		{
			if(
				(
					(results[i].hasOwnProperty("below_min") && results[i].below_min == "N") ||
					(results[i].hasOwnProperty("partner_below_min") && results[i].partner_below_min == "N")
				) &&
				results[i].hasOwnProperty("company") &&
				results[i].hasOwnProperty("description") &&
				results[i].hasOwnProperty("name") &&
				results[i].hasOwnProperty("product_id") &&
				results[i].hasOwnProperty("stars") &&
				results[i].hasOwnProperty("value") &&
				LifeQuote.productInWhiteList( results[i] )
			)
			{
				results[i].client_ref = client_ref;
				results[i].transaction_id = transaction_id;
				results[i].price = LifeQuote.getPrettyNumber( LifeQuote.getAdjustedPremium(results[i].value) );
				results[i].priceHTML = LifeQuote.getPriceHTML( results[i].price );
				results[i].priceFrequency = LifeQuote.getPremiumFrequencyTerm();
				results[i].thumb = results[i].company.toLowerCase().replace(" ", "_") + ".png";
				results[i].pds = "pds/life/" + decodeURI(results[i].pds.split("/").pop()).replace(/ /g, "_");
				if(results[i].hasOwnProperty("below_min") && results[i].below_min == "N") {
					output.primary.push(results[i]);
				}

				if(results[i].hasOwnProperty("partner_below_min") && results[i].partner_below_min == "N") {
					var pval = results[i].partner_value;
					var pprice = LifeQuote.getPrettyNumber( LifeQuote.getAdjustedPremium(pval) );
					var ppHTML = LifeQuote.getPriceHTML( pprice );
					var temp = $.extend(true, {}, results[i]); // make a safe copy of results[i]
					temp = $.extend(true, temp,{
						value : 	pval,
						price :		pprice,
						priceHTML :	ppHTML
					});

					output.partner.push(temp);
				}
			}
		}

		return output;
	},

	getAdjustedPremium : function( premium )
	{
		/* The correct premiums as per frequency appears to be in results by default */
		switch( LifeQuote.premiumFrequency )
		{
			/*case "H":
				return premium * 6;
				break;
			case "Y":
				return premium * 12;
				break;*/
			case "M":
			default:
				return premium;
				break;
		}
	},

	getPremiumFrequencyTerm : function()
	{
		switch( LifeQuote.premiumFrequency )
		{
			case "H":
				return "per half year";
				break;
			case "Y":
				return "per year";
				break;
			case "M":
			default:
				return "per month";
				break;
		}
	},

	getPrettyNumber : function( num )
	{
		if( isNaN(num) ) {
			num = "0.00";
		}
		else if( String(num).indexOf(".") == -1 ) {
			num = num + ".00";
		} else {
			var left = String(String(num).split(".")[0]);
			var right = String(String(num).split(".")[1]);

			if( right.length < 2 )
			{
				for(var i=2; i > right.length; i--)
				{
					right += "0";
				}

				num = left + "." + right;
			}
			else if( right.length > 2 ) {
				num = left + "." + right.substring(0,2);
			}
			else
			{
				num = String(num);
			}
		}

		return num;
	},

	getPriceHTML : function( price ) {
		var pieces = price.split('.');

		return "<span>$</span>" + String(pieces[0]) + ".<span>" + String(pieces[1]) + "</span>";
	},

	fetchProductDetails: function( product, callback )
	{
		var data = {
			product_id:		product.product_id,
			client_type:	product.client_type,
			vertical:		LifeQuote._vertical
		};

		var cache = LifeQuote.cacheDataExists(LifeQuote.cache_type.details, data);

		if( cache !== false ) {
			// Update form with client/product data
			LifebrokerRef.updateClientFormFields( product.client_ref, product.product_id );

			// Form updated with product id now so update databucket again
			LifebrokerRef.updateDataBucket();

			if( typeof callback == 'function' )
			{
				callback();
			}
		} else {
		$.ajax({
				url: "ajax/json/life_product_details.jsp",
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
				success: function(jsonResult){
					if( jsonResult.results.success ) {
						product.transaction_id = jsonResult.results.transactionId;
						product.features = LifeQuote.sanitiseFeatures(jsonResult.results.features.product.feature);

						// Update form with client/product data
						LifebrokerRef.updateClientFormFields( product.client_ref, product.product_id );

						// Form updated with product id now so update databucket again
						LifebrokerRef.updateDataBucket();

						LifeQuote.addDataToCache( LifeQuote.cache_type.details, data );

						if( typeof callback == 'function' )
						{
							callback();
						}
					} else {
						// Remove the loading icon on error
						$('#result_' + data.client_type + '_' + data.product_id).removeClass('pending');

						var msg = "This service is temporarily unavailable. Please try again later.";
						FatalErrorDialog.exec({
							message:		msg,
							page:			"life.js",
							description:	"LifeQuote.fetchProductDetails().  Service is currently unavailable.",
							data:			{
									sent:		data,
									received:	jsonResult,
									errors:		jsonResult.results.error
							}
						});
					}
					return false;
				},
				error: function(obj, txt, errorThrown) {
					// Remove the loading icon on error
					$('#result_' + data.client_type + '_' + data.product_id).removeClass('pending');

					FatalErrorDialog.exec({
						message:		"An error occurred when fetching the product:" + txt,
						page:			"life.js",
						description:	"LifeQuote.fetchProductDetails().  AJAX Request failed: " + txt + ' ' + errorThrown,
						data:			data
				});
			}
		});
		}
	},

	cacheDataExists : function(type, data) {
		LifeQuote.cleanCache(type);

		if( type == LifeQuote.cache_type.details ) {
			for(var i in LifeQuote.cache_data[type]) {
				if( LifeQuote.cache_data[type][i].product_id == data.product_id && LifeQuote.cache_data[type][i].client_type == data.client_type ) {
					return true;
				}
			}
		} else {
			var requested_products = data.products.split(",");
			for(var i in LifeQuote.cache_data[type]) {
				var o = LifeQuote.cache_data[type][i].products;
				if( LifeQuote.getObjPropertiesCount(o) == requested_products.length ) {
					var match = true;
					for(var j in requested_products) {
						if( !o.hasOwnProperty(requested_products[j]) ) {
							match = false;
						}
					}
					if(match !== false) {
						return cache_data[type][i];
					}
				}
			}
		}

		return false;
	},

	addDataToCache : function(type, data) {
		LifeQuote.cleanCache(type);
		LifeQuote.cache_data[type][new Date().getTime()] = data;
	},

	cleanCache : function( type, destroy ) {
		destroy = destroy || false;
		var age_limit = (new Date().getTime()) - LifeQuote.cache_age_limit;
		for(var i in LifeQuote.cache_data[type]) {
			if( destroy === true || i < age_limit ) {
				delete LifeQuote.cache_data[type][i];
			}
		}
	},

	getObjPropertiesCount : function(obj) {
		var count = 0;
		for (k in obj) if (obj.hasOwnProperty(k)) count++;
		return count;
	},

	sanitiseFeatures : function(features)
	{
		/* Retain this code as there is a high likelihood that provider specific ordering will be implemented soon.
		var official_order = LifeQuote.getFeaturesOrder();
		*/

		// List of feature code groups applicable to age
		var feature_groups = LifeQuote.getFeatureGroups();

		// Get selected features
		var selected_waiting_period = LifeQuote.getSelectedWaitingPeriodCode();
		var selected_benefit_period = LifeQuote.getSelectedBenefitPeriodCode();

		// List of allowed feature codes
		var whitelist = {
				available : 	[],
				unavailable :	[]
		};

		var output = {
				available:{},
				unavailable:{},
				extras:		{
					ip:		"Income Protection Insurance",
					term:	"Term Life Cover",
					tpd:	"Total and Permanent Disablement Cover",
					trauma:	"Trauma Cover"
				}
		};

		var covers = ["ip","term","tpd","trauma"];
		for(var c = 0; c < covers.length; c++) {
			if(
				(c == 0 && LifeQuote._vertical == 'ip') ||
				(c > 0 && LifeQuote._vertical != 'ip' && Number($("#" + LifeQuote._vertical + "_primary_insurance_" + covers[c]).val()) > 0)
			) {
				delete output.extras[covers[c]];
			}
		}

		if( typeof features == "object" && features.constructor == Array )
		{
			for(var i = 0; i < features.length; i++)
			{
				var type = features[i].available ? "available" : "unavailable";

				// Only proceed if in whitelist
				if( LifeQuote.arrayIndex(whitelist[type], features[i].id) === false )
				{
					// Test if feature is age related
					var feature_group = false;
					var feature_pos = false;
					for(var j in feature_groups)
					{
						var pos = LifeQuote.arrayIndex(feature_groups[j], features[i].id);
						if( pos !== false && pos >= 0 )
						{
							feature_group = j;
							feature_pos = pos;
							break;
						}
					}

					// Just add if not age related
					if(	!feature_group )
					{
						output[type][features[i].id] = features[i].name;
					}
					// Otherwise only add if age is the highest in its group and
					// delete any lesser ones added previously
					else
					{
						var feature_highest = true;
						for(var k = 0; k < feature_groups[feature_group].length; k++)
						{
							if( output[type].hasOwnProperty(feature_groups[feature_group][k]) )
							{
								if( feature_group == 'waiting_period' ) {
									if( feature_groups[feature_group][k] < selected_waiting_period || feature_groups[feature_group][k] > selected_waiting_period )
									{
										delete output[type][feature_groups[feature_group][k]];
									}
									else
									{
										feature_highest = false;
									}
								} else if( feature_group == 'benefit_period' ) {
									if( feature_groups[feature_group][k] < selected_benefit_period || feature_groups[feature_group][k] < selected_benefit_period )
									{
										delete output[type][feature_groups[feature_group][k]];
									}
									else
									{
										feature_highest = false;
									}
								} else {
									if( k < feature_pos )
									{
										delete output[type][feature_groups[feature_group][k]];
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
							output[type][features[i].id] = features[i].name;
						}
					}
				}
			}
		}

		/* Retain this code as there is a high likelihood that provider specific ordering will be implemented soon.
		var final_output = {available:[],unavailable:[]};
		for(var i = 0; i < official_order.length; i++) {
			if( output.available[official_order[String(i)]] && output.available.hasOwnProperty(official_order[String(i)]) ) {
				final_output.available.push(output.available[official_order[String(i)]]);
			}
			if( output.unavailable[official_order[String(i)]] && output.unavailable.hasOwnProperty(official_order[String(i)]) ) {
				final_output.unavailable.push(output.unavailable[official_order[String(i)]]);
			}
		}

		output.available = final_output.available;
		output.unavailable = final_output.unavailable;*/

		return output;
	},

	getFeaturesOrder : function() {
		return [10101,10106,10201,20401,34501,10301,10302,10501,20601,34701,52901,10604,20704,34804,53307,10701,10702,10703,11201,21501,35501,11301,21601,35601,11401,21701,11701,22001,36001,11801,22101,12201,22401,55301,12301,12401,22501,34401,12801,22901,36201,54301,20108,20801,20802,21001,21002,22801,30106,30107,30108,30109,30110,30117,30118,30123,30201,30301,30401,30502,30503,30605,30701,30801,30901,31201,31301,31401,31501,31601,31701,31801,31901,31902,32001,32101,32201,32301,32401,32501,32601,32701,32801,32901,33001,33101,33201,33301,33401,33501,33601,33701,33801,33901,34201,34202,34203,35705,54107,50102,50103,50206,50304,50406,50407,50408,50601,50602,50701,50702,50802,50803,51001,51002,51105,51107,51108,51109,51114,51116,51201,51301,51801,51901,52102,52201,52401,52601,52602,52603,52702,52703,52704,52705,52706,53001,53002,53004,53005,53110,53111,53112,53113,53114,53115,53116,53205,53206,53207,53208,53209,53210,53211,53212,53213,53309,53402,53901,54001,54402,54403,54801,54802,54803,55201,55202];
	},

	getFeatureGroups : function() {

		return {
				cover_continues : 		[10701,10702,10703],
				//cover_continues_def :	[20801,20802], // Both of these values required to be shown
				benefit_period : 		[53205,53206,53207,53208,53209,53210,53211,53212],
				waiting_period :		[53110,53111,53112,53113,53114,53115,53116],
				no_claim_discount :		[53004,53005]
		};
	},

	getSelectedWaitingPeriodCode : function() {
		var codes = [53110,53111,53112,53113,53114,53115,53116];
		var wp = Number($('#' + LifeQuote._vertical + '_primary_insurance_waiting').val());

		switch(wp) {
			case 14:
				return codes[0];
			case 30:
				return codes[1];
			case 60:
				return codes[2];
			case 90:
				return codes[3];
			case 180:
				return codes[4];
			case 1:
				return codes[5];
			case 2:
			default:
				return codes[6];
		}
	},

	getSelectedBenefitPeriodCode : function() {
		var codes = [53205,53206,53207,53208,53209,53210,53211,53212];
		var wp = Number($('#' + LifeQuote._vertical + '_primary_insurance_benefit').val());

		switch(wp) {
			case 1:
				return codes[0];
			case 2:
				return codes[1];
			case 5:
				return codes[2];
			case 10:
				return codes[3];
			case 55:
				return codes[4];
			case 60:
				return codes[5];
			case 65:
				return codes[6];
			case 70:
			default:
				return codes[7];
		}
	},

	arrayIndex : function(arr, token)
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
	},

	groupFeatures : function(features)
	{
		var output = {};

		for(var i = 0; i < features.length; i++)
		{
			var f = features[i];
			var code = f.name;

			if( !output.hasOwnProperty(code) )
			{
				output[code] = {};
			}

			output[code][f.id] = f.name;
		}
	},

	/**
	 * Method is to check the product against a valid product list once available
	 */
	productInWhiteList : function( product )
	{
		return true;
	},

	selectProduct: function( type, product, callback )
	{
		var data = {
			request_type:			'REQUEST-INFO',
			client_ref:				product.client_ref,
			vertical:				LifeQuote._vertical,
			partner_quote:			Results._partnerQuote ? 'Y' : 'N'
		};

		if( type == 'partner' ) {
			data.partner_product_id = product.product_id;
			data.client_product_id = Results._selectedProduct.primary ? Results._selectedProduct.primary.product_id : '';
		} else {
			data.client_product_id = product.product_id;
			data.partner_product_id = Results._selectedProduct.partner ? Results._selectedProduct.partner.product_id : '';
		}

		$.ajax({
			url: "ajax/json/life_product_select.jsp",
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
			success: function(jsonResult){

				if( jsonResult.results.success ) {

					product.transaction_id = jsonResult.results.transactionId;

					// Update form with client/product data
					LifebrokerRef.updateClientFormFields( product.client_ref, type, product.product_id );

					// Form updated with product id now so update databucket again
					LifebrokerRef.updateDataBucket();

					if( typeof callback == 'function' )
					{
						callback();
					}
				} else {
					// Remove the loading icon on error
					$('#addtocart_' + type + '_' + product.product_id).removeClass('adding');

					var msg = "This service is temporarily unavailable. Please try again later.";
					FatalErrorDialog.exec({
						message:		msg,
						page:			"life.js",
						description:	"LifeQuote.selectProduct().  Service is currently unavailable.",
						data:			{
								sent:		data,
								received:	jsonResult,
								errors:		jsonResult.results.error
						}
					});
				}

				return false;
			},
			error: function(obj, txt, errorThrown) {
				// Remove the loading icon on error
				$('#addtocart_' + type + '_' + product.product_id).removeClass('adding');

				FatalErrorDialog.exec({
					message:		"An error occurred when fetching the product:" + txt,
					page:			"life.js",
					description:	"LifeQuote.fetchProductDetails().  AJAX Request failed: " + txt + ' ' + errorThrown,
					data:			data
				});
			}
		});
	},

	submitApplication: function(products, callback ){

		// Update form with client/product data
		for(var i in products) {
			LifebrokerRef.updateClientFormFields( products[i].client_ref, i, products[i].product_id );
		}

		var submit = function() {
				Loading.show("Submitting application...");
			var data = {
					request_type:	"REQUEST-CALL",
				client_product_id:		products.hasOwnProperty('primary') ? products.primary.product_id : null,
				partner_product_id:		products.hasOwnProperty('partner') ? products.partner.product_id : null,
				client_ref:				products.primary.client_ref,
				vertical:				LifeQuote._vertical,
				partner_quote:			Results._partnerQuote ? 'Y' : 'N'
				};

			$.ajax({
				url: "ajax/json/life_submit_application.jsp",
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
				success: function(jsonResult){
					Loading.hide();
					if( jsonResult.results.success ) {
						LifeConfirmationPage.show();
					} else {
						var msg = "This service is temporarily unavailable. Please try again later.";
						FatalErrorDialog.exec({
							message:		msg,
							page:			"life.js",
							description:	"LifeQuote.submitApplication().  Service is currently unavailable.",
							data:			{
								sent:		data,
								received:	jsonResult,
								errors:		jsonResult.results.error
							}
						});
					}
					return false;
				},
				error: function(obj, txt, errorThrown) {
					Loading.hide();
					Write.touchQuote("E", function() {
						FatalErrorDialog.exec({
							message:		"An error occurred when submitting the application: " + txt + ' ' + errorThrown,
							page:			"life.js",
							description:	"LifeQuote.submitApplication().  AJAX Request failed: " + txt + ' ' + errorThrown,
							data:			data
						});
					});
				}
			});
		};

		if( $("#" + LifeQuote._vertical + "_contactDetails_call").val() == "N" ) {
			CallbackConfirmDialog.launch( function() {
				LifeQuote.updateLifebroker( products, submit );
			} );
		} else {
			submit();
		}
	},

	updateLifebroker : function( products, callback ) {
		if (LifeQuote.ajaxPending){
			// we're still waiting for the results.
			return;
		}
		Loading.show("Loading...");

		LifeQuote.applyTestingData();

		var data = $("#mainform").serialize() + "&vertical=" + LifeQuote._vertical;

		// Force this field to be updated - actual change would have occured after
		// this function was added to the callback
		data = data.replace(LifeQuote._vertical + '_contactDetails_call=N', LifeQuote._vertical + '_contactDetails_call=Y');

		LifeQuote.ajaxPending = true;
		$.ajax({
			url: "ajax/json/life_quote_results.jsp",
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
			success: function(jsonResult){
				LifeQuote.ajaxPending = false;
				Loading.hide();

				if( jsonResult.results.success ) {
					if( LifeQuote.isValidResultsResponse(jsonResult) )
					{
						for(var i in products) {
							products[i].client_ref = jsonResult.results.client.reference;
							products[i].transaction_id - jsonResult.results.transactionId;

							// Update form with client/product data
							LifebrokerRef.updateClientFormFields( products[i], i, null );
						}

						if( typeof callback == "function" ) {
							LifeQuote.removeTestingData();
							callback();
						}
					}
					else
					{
						var msg = "Invalid response received. Please try again later.";
						try {
							if( typeof jsonResult.results.products.error == "string" && jsonResult.results.products.error.constructor == String )
							{
								msg = jsonResult.results.products.error + " Please <a href='javascript:Results.reviseDetails()' title='Revise your details'>revise your details</a>.";
							}
						} catch(e) { /* IGNORE */ }

						Results.showErrors([msg]);
					}
				} else {
					var msg = "This service is temporarily unavailable. Please try again later.";
					Results.showErrors([msg]);
				}

				LifeQuote.removeTestingData();

				return false;
			},
			error: function(obj,txt){
				LifeQuote.ajaxPending = false;
				Loading.hide();
				FatalErrorDialog.register({
					message:		"An error occurred when fetching prices: " + txt,
					page:			"common/life.js:updateLifeBroker",
					description:	LifeQuote._vertical + " Quote Results. An error occurred when trying to successfully call or parse the life results.",
					data:			data
				});
				Results.showErrors(["An error occurred contacting Lifebroker: " + txt]);
			}
		});
	},

	checkQuoteOwnership: function( callback ) {
		var data = {quoteType:LifeQuote._vertical};
		$.ajax({
			url: "ajax/json/access_check.jsp",
			data: data,
			dataType: "json",
			type: "POST",
			async: true,
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				if( !Number(jsonResult.result.success) )
				{
					FatalErrorDialog.exec({
						message:		jsonResult.result.message,
						page:			"life.js",
						description:	"LifeQuote.checkQuoteOwnership().  jsonResult contains error message: " + jsonResult.result.message,
						data:			{sent:data,received:jsonResult}
					});
				}
				else
				{
					if( typeof callback == "function" )
					{
						callback();
					}
				}

				return false;
			},
			error: function(obj, txt, errorThrown) {
				FatalErrorDialog.exec({
					message:		"An undefined error has occured - please try again later.",
					page:			"life.js",
					description:	"LifeQuote.checkQuoteOwnership().  AJAX Request failed: " + txt + ' ' + errorThrown,
					data:			data
				});
				return false;
			}
		});

		return true;
	},

	touchQuote: function(touchtype, callback, comment, allData)
	{
		comment = comment || null;
		allData = allData || false;

		var data = {touchtype:touchtype,quoteType:LifeQuote._vertical};

		//Send form data unless recording a Fail
		if (allData === true) {
			data = $.param(data) + '&' + serialiseWithoutEmptyFields('#mainform');
		}

		$.ajax({
			url: "ajax/json/access_touch.jsp",
			data: data,
			dataType: "json",
			type: "POST",
			async: true,
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				if( !Number(jsonResult.result.success) )
				{
					FatalErrorDialog.exec({
						message:		jsonResult.result.message,
						page:			"life.js",
						description:	"LifeQuote.touchQuote().  jsonResult contains error message: " + jsonResult.result.message,
						data:			{sent:data,received:jsonResult}
					});
				}
				else
				{
					if( typeof callback == "function" )
					{
						callback();
					}
				}

				return false;
			},
			error: function(obj, txt, errorThrown) {
				FatalErrorDialog.exec({
					message:		"An undefined error has occured - please try again later.",
					page:			"life.js",
					description:	"LifeQuote.checkQuoteOwnership().  AJAX request failed: " + txt + ' ' + errorThrown,
					data:			data
				});
				return false;
			}
		});
	},

	restartQuote: function() {
		Loading.show("Start New Quote...");
		var data = {quoteType:LifeQuote._vertical};
		$.ajax({
			url: "ajax/json/restart_quote.jsp",
			data: data,
			type: "POST",
			async: false,
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

				if(json && json.result.destUrl)
				{
					window.location.href = json.result.destUrl;
				}
				else
				{
					FatalErrorDialog.exec({
						message:		"Sorry, an error occurred trying to start a new quote.",
						page:			"life.js",
						description:	"LifeQuote.restartQuote().  No destUrl contained in response.",
						data:			json
					});
				};

				return false;
			},
			error: function(obj, txt, errorThrown) {
				Loading.hide();
				FatalErrorDialog.exec({
					message:		"Sorry, an error occurred trying to start a new quote.",
					page:			"life.js",
					description:	"LifeQuote.restartQuote().  AJAX request failed: " + txt + ' ' + errorThrown,
					data:			data
				});
			}
		});
	},

	onRequestCallback: function() {
		if( $("#" + LifeQuote._vertical + "_contactDetails_call").val() == "Y" )
		{
			LifeQuote.requestCallback();
		}
		else
		{
			CallbackConfirmDialog.launch( LifeQuote.doRequestCallback );
		}
	},

	doRequestCallback : function() {
		LifeQuote.requestCallback();
	},

	requestCallback: function() {

		Loading.show("Requesting Callback...");

		LifeQuote.applyTestingData();

		var data = $("#mainform").serialize() + "&vertical=" + LifeQuote._vertical;

		// Force this field to be updated - actual change would have occured after
		// this function was added to the callback
		data = data.replace(LifeQuote._vertical + '_contactDetails_call=N', LifeQuote._vertical + '_contactDetails_call=Y');

		$.ajax({
			url: "ajax/json/life_request_call.jsp",
			data: data,
			type: "POST",
			async: false,
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
			success: function(jsonResult){
				Loading.hide();
				if( jsonResult.results.success ) {
					if( $('#callbackconfirm-dialog').is(":visible") ) {
						CallbackConfirmDialog.close(LifeConfirmationPage.show);
					} else {
						LifeConfirmationPage.show();
					}

					LifeQuote.removeTestingData();
				} else {
					var msg = "This service is temporarily unavailable. Please try again later.";
					FatalErrorDialog.exec({
						message:		msg,
						page:			"life.js",
						description:	"LifeQuote.requestCallback().  Service is currently unavailable.",
						data:			{
							sent:		data,
							received:	jsonResult,
							errors:		jsonResult.results.error
						}
					});
				}

				return false;
			},
			error: function(obj, txt, errorThrown) {
				Loading.hide();

				LifeQuote.removeTestingData();

				FatalErrorDialog.exec({
					message:		"An error occurred when submitting your request:" + txt,
					page:			"life.js",
					description:	"LifeQuote.requestCallBack().  AJAX request failed: " + txt + ' ' + errorThrown,
					data:			data
				});
			}
		});
	},

	applyTestingData : function() {

		if( LifeQuote._testingMode ) {

			LifeQuote._tempFields = {
				firstname:	$('#' + LifeQuote._vertical + '_primary_firstName').val(),
				lastname:	$('#' + LifeQuote._vertical + '_primary_lastname').val(),
				email:		$('#' + LifeQuote._vertical + '_contactDetails_email').val(),
				client_ref:	$('#' + LifeQuote._vertical + '_client_reference').val()
			};

			$('#' + LifeQuote._vertical + '_primary_firstName').val( 'Gomez' );
			$('#' + LifeQuote._vertical + '_primary_lastName').val( 'Testing' );
			$('#' + LifeQuote._vertical + '_contactDetails_email').val( 'Gomez.Testing@aihco.com.au' );
		}
	},

	removeTestingData : function() {

		if( LifeQuote._testingMode ) {
			$('#' + LifeQuote._vertical + '_primary_firstName').val( LifeQuote._tempFields.firstname );
			$('#' + LifeQuote._vertical + '_primary_lastName').val( LifeQuote._tempFields.lastname );
			$('#' + LifeQuote._vertical + '_contactDetails_email').val( LifeQuote._tempFields.email );
		}
	}
};

LifeQuote._init();
