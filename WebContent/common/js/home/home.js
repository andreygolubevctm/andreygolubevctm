var Home = new Object();
Home = {
	_init : function() {

		QuoteEngine.completed(function(){
			Compare.view.enableRender = true;
			Results.get();
			// Temporary Legal Requirements
			$('.verticalTitleCompare').hide();
			$('.inner-horizontal-bar .darkGreen').html("Click <strong>next</strong> for more <br/>policy information.");
			$('#compareBtn').html("NEXT");
			// End Temporary Code
		});
	}
};
Home._init();

HomeResults = new Object();
HomeResults = {

	init: function(){

		try{

			// Init the main Results object
			Results.init({
				url: "ajax/json/home/results.jsp",
				paths: {
					price: {
						annual: "price.annual.total",
						monthly: "price.monthly.total"
					},
					availability: {
						product: "productAvailable"
					},
					productId: "productId"
				},
				show:{
					savings: false,
					featuresCategories: false
				},
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
					price: "price.annual.total"
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
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'HomeResults.init(); '+e.message, e);
		}

		// add event listeners
		$(Results.settings.elements.resultsContainer).on("topResultSet", function(){
			// Temporary code for legal requirements
			//HomeResults.setResultsActions();
			$('.topResult').css('cursor','default');
		}).on("resultsLoaded", function(){

			HomeResults.showHideExcesses();

			HomeResults.toggleFrequency( $(".update-payment").val() );
			HomeResults.setResultsActions();
			HomeResults.showTermsLinks();
			if(Results.model.resultsLoadedOnce == true){
				Track.resultsShown('Refresh');
			}
			else {
				Track.resultsShown('Load');
			}
			var houseAddress = $("#home_property_address_fullAddress").val();
			Summary.set( houseAddress );

			// Temporary code for legal requirements
			$('.checkboxCustomTxt').html("Select");
			// Hiding the buttons completely
			$('.standardButton').hide();
			//Locking the ticks so that they can't be unselected
			$('.compare').click();
			$('.compareCloseIcon').css('visibility','hidden');
			$('.topResult').unbind();
			$('.compare').unbind();
			$('.compare-on').css('cursor','default');
			$('.topResult').css('cursor','default');
			$('div.result div.des h3 a').removeAttr('data-moredetailshandler');
			// End Temporary Code

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
				HomeResults.toggleCompareCheckboxes();
			}
		}).on("compareAdded", function(event, productId ){
			Compare.view.buildComparison();
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").show();
			HomeResults.toggleCompareCheckboxes();
		}).on("compareClick", function(event, productId ){
			//Temporary code for Legal Requirements
			$('.standardButton').show();
						// End Temporary Code
			if( Compare.view.comparisonOpen ){
				Compare.close();
				//Temporary code for Legal Requirements
				$('#compareBtn').html("DISPLAY");
				$('.inner-horizontal-bar .darkGreen').html("Click <strong>display</strong> for more <br/>policy information.");
				// End Temporary Code
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
			Compare.view.enableRender = false;
			var baseHomeExcess = $('#home_baseHomeExcess').val();
			var baseContentsExcess = $('#home_baseContentsExcess').val();
			$('#home_homeExcess').val(baseHomeExcess);
			$('#home_contentsExcess').val(baseContentsExcess);
			$(Compare.settings.elements.bar).hide();
			// Temporary Legal Requirement
			$('#compareBtn').html("NEXT");
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
			HomeResults.toggleFrequency( frequency );
			Results.setFrequency( frequency );
		});

		$(".update-excess").on("change", function() {
			QuoteEngine.poke();

			var data = new Object();
			data.home_excess = $("#home_homeExcess").val();
			data.contents_excess = $("#home_contentsExcess").val();
			data.action = "change_excess";
			data.transactionId = referenceNo.getTransactionID();
			Results.get( "ajax/json/home/results.jsp", data );
			//Temporary Legal Requirement
			$('#compareBtn').html("NEXT");
		});

		$("#compareCloseButton").on("click", function(){
			Compare.close();
			//Temporary Legal Requirement
			$('#compareBtn').html("DISPLAY");
		});

		$("#quote_existingInsurer_provider").trigger("change");



	},
	showHideExcesses: function(){
		$.each(Results.getReturnedResults(), function( index, product ){
			var productType = $('#home_coverType').val();
			if ((product.HHB && product.HHB.excess.amount == "") ||
					(product.HHC && product.HHC.excess.amount == "") ||
					productType == "Home Cover Only" ||
					productType == "Contents Cover Only") {
				$('.excess_separator').hide(); // We don't need to add any padding since there is only one

				$('.excess').removeClass('doubleExcess');
				if ((product.HHB && product.HHB.excess.amount == "") || productType == "Contents Cover Only") {
					$('.HHBExcess').hide();
				}
				else {
					$('.HHBExcess').show();
				}
				if ((product.HHC && product.HHC.excess.amount == "") || productType == "Home Cover Only") {
					$('.HHCExcess').hide();
				}
				else {
					$('.HHCExcess').show();
				}
			}
			else {
				$('.excess').addClass('doubleExcess');
				$('.HHBExcess').show();
				$('.HHCExcess').show();
			}
		});
	},

	setResultsActions: function(){
		try{
			// Compare checkboxes and top result
			$(".compare, .topResult").unbind().on("click", function(){

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
				};

				if( checkbox.is(":visible") ){
					Compare.remove( productId );
				} else {
					Compare.add( product );
				}

			});
		}catch(e){
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'HomeResults.setResultsActions(); '+e.message, e);
		}

	},

	showTermsLinks: function(){

		$.each(Results.getReturnedResults(), function( index, product ){
			var termsConditions = "";
			var paraStart = "<p class=\"termsLinks\">";
			var terms = false;
			var ageRestriction = false;
			if( typeof( product.headline.terms ) != "undefined" && product.headline.terms != "" ){
				termsConditions += paraStart + "<a href=\"javascript:void(0);\" data-terms-show=\"true\" data-id=\"" + product.productId + "\"><strong>Offer terms</strong></a>";
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
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'HomeResults.toggleFrequency(); '+e.message, e);
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
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'HomeResults.toggleCompareCheckboxes(); '+e.message, e);
		}

	}
}