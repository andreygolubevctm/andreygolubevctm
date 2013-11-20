var Car = new Object();
Car = {
	_init : function() {
		QuoteEngine.completed(function(){

			var vehicleDescription = $("#quote_vehicle_year :selected").text()
			+ ' ' + $("#quote_vehicle_make :selected").text()
			+ ' ' + $("#quote_vehicle_model :selected").text();
			Summary.set( vehicleDescription );

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
						active: false
					}
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
		$(Results.settings.elements.resultsContainer).on("resultsAnimated", function(){
			CarResults.setResultsActions();
		});

		$(Results.settings.elements.resultsContainer).on("resultsLoaded", function(){
			CarResults.toggleFrequency( $(".update-payment").val() );
			CarResults.setResultsActions();
			CarResults.showTermsLinks();
			Track.resultsShown('Load');
		});

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		$(Compare.settings.elements.bar).on("compareRemoved", function(event, productId){
			Compare.view.buildComparison();
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").hide();
			CarResults.toggleCompareCheckboxes();
		});

		$(Compare.settings.elements.bar).on("compareAdded", function(event, productId ){
			Compare.view.buildComparison();
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").show();
			CarResults.toggleCompareCheckboxes();
		});

		$(Compare.settings.elements.bar).on("compareClick", function(event, productId ){
			if( Compare.view.comparisonOpen ){
				Compare.close();
			} else {
				Compare.open();
				Track.compareClicked();
			}
			});

		$(Compare.settings.elements.bar).on("compareNonAvailable", function(event, productId ){
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
						.prev()
						.children()
							.css("border-bottom", "none");

				// remove bottom border on cells from the row
					specialOfferCells
						.children()
							.css("border-bottom", "none");

				// round corners of the first cell of the row
					specialOfferCells
				.first()
					.css("-moz-border-radius-topleft", "5px")
					.css("-webkit-border-top-left-radius", "5px")
					.css("border-top-left-radius", "5px")
					.css("-moz-border-radius-bottomleft", "5px")
					.css("-webkit-border-bottom-left-radius", "5px")
					.css("border-bottom-left-radius", "5px")
					.css("margin-left", "-10px");

				// change background color of the row
					specialOfferCells
						.css("background-color", "#B2B2B2");

			// add the Product features & features header in the middle of the comparison table
				$( '[data-featureId="Australian Call Centre"]' + Compare.settings.elements.featuresValues ).each( function(){
					$(this).before('<div class="featuresValues productFeaturesRow">&nbsp;</div>');
				});

				$( Compare.settings.elements.container + " " + Results.settings.elements.features.headers + " .productFeaturesRow" ).html(
					$(".comparisonTableStarsHeader").clone().show()
				);

			// Make sure the right frequency price is displayed
				CarResults.toggleFrequency( $(".update-payment").val() );

		});

		$(".update-payment").on("change", function(){
			var frequency = $(this).val();
			CarResults.toggleFrequency( frequency );
			Results.setFrequency( frequency );
		});

		$(".update-excess").on("change", function() {
			QuoteEngine.poke();
			Compare.reset();
			Results.get();
		});

		$("#compareCloseButton").on("click", function(){
			Compare.close();
				});

		$("#quote_existingInsurer_provider").trigger("change");

	},

	setResultsActions: function(){

		try{
			// Compare checkboxes and top result
			$(".compare, .topResult").unbind();
			$(".compare, .topResult").on("click", function(){

				if( $(this).hasClass("topResult") ){
					var checkbox = $(this).siblings().find(".compare-on");
				} else {
					var checkbox = $(this).find(".compare-on");
				}

				var productId = $(this).parents( Results.settings.elements.rows ).attr("data-productId");
				var productObject = Results.getResult( "productId", productId );

				var product = {
					id: productId,
					object: productObject
				}

				if( checkbox.is(":visible") ){
					Compare.remove( productId );
				} else {
					Compare.add( product );
				}

			});
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarResults.setResultsActions(); '+e.message, e);
		}

	},

	showTermsLinks: function(){

		$.each(Results.getReturnedResults(), function( index, product ){
			if( typeof( product.headline.terms ) != "undefined" && product.headline.terms != "" ){
				$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + product.productId + "]").find(".des").append("<p><a href=\"javascript:Terms.show('" + product.productId + "');\" class=\"termsLinks\">Special conditions and offer terms</a></p>");
			}
		});

	},

	toggleFrequency: function( frequency ){
		try{
			$(Filters.settings.elements.frequency).hide();

			$("."+frequency+".frequency").each(function(index, element){

				var priceAvailable = $(this).parents(".priceAvailable").first();
				var priceNotAvailable = priceAvailable.siblings(".priceNotAvailable").first();

				if( $(this).attr("data-availability") == "Y" ){
					priceAvailable.show();
					priceNotAvailable.hide();
					$(this).show();
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