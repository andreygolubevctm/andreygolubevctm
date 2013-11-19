var CarBrands = new Object();
CarBrands = {
	init : function() {

		QuoteEngine.completed(function(){
			Results.get();

			$('#kampyle').css({ 'margin-bottom': '76px' });
			$('#footer').css({ 'margin-bottom': '46px' });
			$('#call_to_action_bar').show(); //updates element of call_to_action_bar.tag.
		});
	}
};
CarBrands.init();

CarBrandsResults = new Object();
CarBrandsResults = {

	init: function(){

		try{

			// Init the main Results object
			Results.init({
				url: "ajax/json/carlmi_results.jsp",
				paths: {
					results: {
						list: "results.products.product"
					},
					brand: "brandName",
					productId: "policyId",
					features: "features.feature"
				},
				show:{
					savings: false,
					topResult: false,
					nonAvailableProducts: false
				},
				displayMode: "features",
				sort: {
					sortBy: "brand"
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
				},
				dictionary: {
					loadingMessage:"Loading..."
				}
			});

			// Init the Rankings saving
			Rankings.init({
				paths: {
					productId: "fullName"
				}
			});

			// Init the comparison bar
			Compare.init();

		}catch(e){
			Results.onError('Sorry, an error occurred initialising page', 'results.tag', 'CarBrandsResults.init(); '+e.message, e);
		}

		// add event listeners
		$(Results.settings.elements.resultsContainer).on("resultsAnimated", function(){
			CarBrandsResults.setResultsActions();
		});

		$(Results.settings.elements.resultsContainer).on("resultsLoaded", function(){
			CarBrandsResults.setResultsActions();
			Track.resultsShown('Load');
		});

		$(Results.settings.elements.resultsContainer).on("featuresDisplayMode", function(){
			Features.buildHtml();
		});

		$(Compare.settings.elements.bar).on("compareRemoved", function(event, productId){
			if( Compare.view.resultsFiltered && (Compare.model.products.length >= Compare.settings.minimum) ){
				Compare.filterResults();
			}
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").hide();
			CarBrandsResults.toggleCompareCheckboxes();
		});

		$(Compare.settings.elements.bar).on("compareAdded", function(event, productId ){
			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find(".compare-on").show();
			CarBrandsResults.toggleCompareCheckboxes();
		});

		$(Compare.settings.elements.bar).on("compareAvailable", function(event){
			$(Compare.settings.elements.button).on("click", function(){
				Compare.filterResults();
				Track.compareClicked();
			});
		});

		$(Compare.settings.elements.bar).on("compareNonAvailable", function(event){
			if( Compare.view.resultsFiltered ){
				Compare.unfilterResults();
			}
		});

		$(".compareBackButton").on("click", function(){
			QuoteEngine.setOnResults(false);
			Results.reviseDetails();

			$('#kampyle').css({ 'margin-bottom': '0' });
			$('#footer').css({ 'margin-bottom': '0' });
			$('#call_to_action_bar').hide(); //updates element of call_to_action_bar.tag
		});

	},

	setResultsActions: function(){

		try{
			// Compare checkboxes and top result
			$(".compare").unbind();
			$(".compare").on("click", function(){

				var checkbox = $(this).find(".compare-on");
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
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarBrandsResults.setResultsActions(); '+e.message, e);
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
			Results.onError('Sorry, an error occurred processing results', 'results.tag', 'CarBrandsResults.toggleCompareCheckboxes(); '+e.message, e);
		}

	}

}