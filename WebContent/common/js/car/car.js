var Car = new Object();
Car = {
	_init : function() {

		$(document).on('car.vehicleSelect.complete', function(){
			var vehicleDescription = $("#quote_vehicle_year :selected").text()
			+ ' ' + $("#quote_vehicle_make :selected").text()
			+ ' ' + $("#quote_vehicle_model :selected").text();
			Summary.set( vehicleDescription );
		});

		QuoteEngine.completed(function(){
			Results.get();
		});
	}
};
Car._init();

CarResults = new Object();
CarResults = {

	init: function(){

		try{

			// Init the main Results object
			Results.init({
				url: "ajax/json/car_quote_results.jsp",
				paths: {
					price: {
						annually: "headline.lumpSumTotal",
						/* The annual property is here as a hack because Payment Type (#quote_paymentType) is configured incorrectly.
						When upgrading Car, someone should reconfigure the sort to be 'annually'. We haven't done so due to potential impact on reporting etc.
						*/
						annual: "headline.lumpSumTotal",
						monthly: "headline.instalmentTotal"
					},
					availability: {
						product: "available"
					},
					productId: "productId"
				},
				show:{
					savings: false,
					featuresCategories: false
				},
				//frequency: "annually",
				/* See comment above */
				frequency: "annual",
				animation: {
					results: {
						individual: {
							active: false
						},
						delay: 500,
						options: {
							easing: "easeInOutQuart", // animation easing type
							duration: 1000
			}
					},
					shuffle: {
						active: true,
						options: {
							duration: 1000
						}
					}
				},
				dictionary: {
					valueMap:[
						{
							key:'Y',
							value: "<img src='brand/ctm/images/quote_result/tick_med_blue.png'>"
						},
						{
							key:'N',
							value: "<img src='brand/ctm/images/quote_result/cross_med_red.png'>"
						},
						{
							key:'R',
							value: "Restricted / Conditional"
						},
						{
							key:'AI',
							value: "Additional Information"
						},
						{
							key:'O',
							value: "Optional"
						},
						{
							key:'L',
							value: "Limited"
						},
						{
							key:'SCH',
							value: "As shown in schedule"
						},
						{
							key:'NA',
							value: "Non Applicable"
						},
						{
							key:'E',
							value: "Excluded"
						},
						{
							key:'NE',
							value: "No Exclusion"
						},
						{
							key:'NS',
							value: "No Sub Limit"
						},
						{
							key:'OTH',
							value: ""
						}
					]
				}
			});

			// Init the Rankings saving
			Rankings.init({
				paths: {
					productId: "productId",
					price: "headline.lumpSumTotal"
		}
		});


			// Init the comparison bar
			Compare.init({
				paths:{
					features: "compareFeatures"
				}
			});

			// Init the Filter bar
			Filters.init();

		}catch(e){
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'CarResults.init(); '+e.message, e);
		}

		// add event listeners
		$(Results.settings.elements.resultsContainer).on("topResultSet", function(){
			CarResults.setResultsActions();
		}).on("resultsLoaded", function(){
			CarResults.toggleFrequency( $(".update-payment").val() );
			CarResults.setResultsActions();
			CarResults.showTermsLinks();
			if(Results.model.resultsLoadedOnce == true){
				Track.resultsShown('Refresh');
			}
			else {
			Track.resultsShown('Load');
			}
		});

		Features.init(Compare.settings.elements.compareTable);

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		$(document).on("FeaturesRendered", function(){
			$(Features.target + " .expandable ").on("mouseenter", function(){
				var featureId = $(this).find( Results.settings.elements.features.values ).first().attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				$hoverRow.parent().addClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
			})
			.on("mouseleave", function(){
				var featureId = $(this).find( Results.settings.elements.features.values ).first().attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				$hoverRow.parent().removeClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
			});
		});

		$(Compare.settings.elements.bar).on("compareRemoved", function(event, productId){
			if( QuoteEngine.getOnResults() ){
				Compare.view.buildComparison();
				$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").hide();
				CarResults.toggleCompareCheckboxes();
			}
		}).on("compareAdded", function(event, productId ){
			Compare.view.buildComparison();
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").show();
			CarResults.toggleCompareCheckboxes();
		}).on("compareClick", function(event, productId ){
			if( Compare.view.comparisonOpen ){
				Compare.close();
			} else {
				Compare.open();
				Track.compareClicked();
			}
		}).on("compareNonAvailable", function(event, productId ){
			if( $(Compare.settings.elements.container).is(":visible") ){
				Compare.close();
			}
		});

		$(Results.settings.elements.resultsContainer).on("resultsReset", function(){
			// @todo = reset filters
		});

		$( Compare.settings.elements.container ).on("compareBuilt", function(){

			// Special Offer
				var specialOfferCells = $('[data-featureId="Special Feature / Offer"]');

				// remove bottom border on cells of previous row
					specialOfferCells
						.parent()
						.prev()
							.css("border-bottom", "none");

				// remove bottom border on cells from the row
					specialOfferCells
						.parent()
						.css("border-bottom", "none");

				// round corners of the first cell of the row
					specialOfferCells
						.first()
						.parent()
							.css("-moz-border-radius-topleft", "5px")
							.css("-webkit-border-top-left-radius", "5px")
							.css("border-top-left-radius", "5px")
							.css("-moz-border-radius-bottomleft", "5px")
							.css("-webkit-border-bottom-left-radius", "5px")
							.css("border-bottom-left-radius", "5px")
							.css("margin-left", "-10px");

				// change background color of the row
					specialOfferCells
						.parent()
						.css("background-color", "#B2B2B2");

			// add the Product features & features header in the middle of the comparison table
//				$( '[data-featureId="Australian Call Centre"]' + Compare.settings.elements.featuresValues ).each( function(){
//					$(this).parent().before('<div class="featuresValues productFeaturesRow">&nbsp;</div>');
//				});
//
//				$( Compare.settings.elements.container + " " + Results.settings.elements.features.headers + " .productFeaturesRow" ).html(
//					$(".comparisonTableStarsHeader").clone().show()
//				);

		});

		$(".update-payment").on("change", function(){
			var frequency = $(this).val();
			Results.setFrequency( frequency );
			CarResults.toggleFrequency( frequency );
		});

		$(".update-excess").on("change", function() {
			QuoteEngine.poke();
			
			var data = new Object();
			data.quote_excess = $("#quote_excess").val();
			data.action = "change_excess";
			data.transactionId = referenceNo.getTransactionID();
			Results.get( "ajax/json/car_quote_results.jsp", data );
		});

		$("#compareCloseButton").on("click", function(){
			Compare.close();
				});

		$("#quote_existingInsurer_provider").trigger("change");

	},

	setResultsActions: function(){

		try{
			// Compare checkboxes and top result
			$(".compare, .topResult").unbind().on("click", function(){
				var el = $(this), checkbox;
				if( el.hasClass("topResult") ){
					checkbox = el.siblings().find(".compare-on");
				} else {
					checkbox = el.find(".compare-on");
				}

				if(!checkbox.length) {
					return;
				}

				var productId = el.parents( Results.settings.elements.rows ).attr("data-productId");
				var productObject = Results.getResult( "productId", productId );

				var product = {
					id: productId,
					object: productObject
				};


				if( checkbox.is(":visible") ){
					Compare.remove( productId );
				} else {
					Compare.add( product );
				}

			});
		} catch(e) {
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarResults.setResultsActions(); '+e.message, e);
		}

	},

	showTermsLinks: function(){

		$.each(Results.getReturnedResults(), function( index, product ){
			var termsConditions = "";
			var paraStart = "<p class=\"termsLinks\">";
			var terms = false;
			var ageRestriction = false;
			if( typeof( product.headline.terms ) != "undefined" && product.headline.terms != "" ){
				termsConditions += paraStart + "<a href=\"javascript:Terms.show('" + product.productId + "');\" data-terms-show=\"true\" data-id=\"" + product.productId + "\"><strong>Offer terms</strong></a>";
				terms = true;
			}
			if (typeof( product.conditions) != "undefined" && typeof( product.conditions.ageRestriction) != "undefined" && product.conditions.ageRestriction != "" ){
				if (terms == false ) {
					termsConditions += paraStart;
				}
					termsConditions += " <span class=\"conditions\"><strong>Special Conditions:</strong> "+product.conditions.ageRestriction+"</span>";
				ageRestriction = true;
			}
			if (terms == true || ageRestriction == true){
				termsConditions += "</p>";
			}
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + product.productId + "]").find(".des").append(termsConditions);
		});

	},

	toggleFrequency: function( frequency ){

		try{

			$("."+frequency+".frequency").each(function(index, element){

				var priceAvailable = $(this).parents(".priceAvailable").first();
				var priceNotAvailable = priceAvailable.siblings(".priceNotAvailable").first();

				if( $(this).attr("data-availability") == "Y" ){
					priceAvailable.show();
					priceNotAvailable.hide();
				} else {
					priceNotAvailable.find(".frequencyName").html( frequency.charAt(0).toUpperCase() + frequency.substr(1) );
					priceAvailable.hide();
					priceNotAvailable.show();
				}
			});
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarResults.toggleFrequency(); '+e.message, e);
		}

	},

	toggleCompareCheckboxes: function(){
		try{
			if( Compare.getComparedQuantity() == Compare.settings.maximum - 1 ){
				$(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows).find(".compare").removeClass("compareInactive");
			} else if( Compare.getComparedQuantity() == Compare.settings.maximum ){

				$(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows).not(
					function(){
						return $.inArray( $(this).attr("data-productId"), Compare.getComparedProductIds() ) != -1;
					}
				).find(".compare").addClass("compareInactive");

			}
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarResults.toggleCompareCheckboxes(); '+e.message, e);
		}

	},

	addCurrentProduct: function( insurerId, insurerName, frequency, price ){

		try{
			var premiumAmount = parseInt(price, 10);

			if (frequency == "M"){
				var annualAmount = parseFloat(premiumAmount * 12).toFixed(0);
				var monthlyAmount = parseFloat(premiumAmount).toFixed(2);
			}
			else {
				var annualAmount = parseFloat(premiumAmount).toFixed(0);
				var monthlyAmount = parseFloat(premiumAmount / 12).toFixed(2);
			}

			Results.addCurrentProduct("productId", {
														available: "Y",
														current: {
															frequency: frequency,
															provider: insurerId
														},
														headline: {
															name: insurerName,
															lumpSumTotal: annualAmount,
															instalmentCount: 11,
															instalmentFirst: monthlyAmount,
															instalmentPayment: monthlyAmount,
															instalmentTotal:  annualAmount
														},
														productId: "CURR"
													}
			);
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarResults.addCurrentProduct(); '+e.message, e);
		}

	},

	removeCurrentProduct: function(){ Results.removeCurrentProduct(); }

}