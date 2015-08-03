Features = new Object();
Features = {

	template: false,
	target: false,
	results: false,
	featuresIds: false,
	emptyAdditionalInfoCategory: true,
	moduleEvents: {
		FEATURE_TOGGLED: 'FEATURE_TOGGLED'
	},

	init: function(target){

		if (typeof target === "undefined") {
			Features.target = Results.settings.elements.resultsContainer;
		} else {
			Features.target = target;
		}

		if (typeof meerkat !== "undefined") {
			meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function deviceMediaStateChange(state){

				// Check that we're in features mode
				if (Results.getDisplayMode() !== 'features') return;

				// Perform tasks required after breakpoint change
				if ($(Results.settings.elements.resultsContainer+" :visible").length > 0) {
					Results.view.calculateResultsContainerWidth();
					Features.clearSetHeights();
					Features.balanceVisibleRowsHeight();
				}

			});
		}

		Features.applyExpandableEvents();
	},

	buildHtml: function( results){

		// Which set of results to use
		if (typeof results === "undefined") {
			Features.results = Results.model.sortedProducts;
		} else {
			Features.results = results;
		}

		// prep of feature template
		Features.template = $(Results.settings.elements.templates.feature).html();
		//var htmlTemplate = _.template(Features.template);
		//Features.template = htmlTemplate({});

		if (Features.template == "") {
			console.log("The comparison feature template could not be found: templateSelector=", Compare.settings.elements.templates.feature, "This template is mandatory, make sure to pass the correct selector to the Compare.settings.elements.templates.feature user setting when calling Compare.init()");
		} else {
			$(Results.settings.elements.resultsContainer).trigger("populateFeaturesStart");
			Features.populateHeaders();
			Features.populateFeatures();
			Features.setExpandableRows();

			_.defer(function(){
				Features.clearSetHeights();
				Features.balanceVisibleRowsHeight();
				$(Results.settings.elements.resultsContainer).trigger("populateFeaturesEnd");
			});

			Features.hideEmptyRows();

			$(Features.target).trigger("FeaturesRendered");
		}

	},

	populateHeaders: function(){

		// Option to render the headers, set to false if the headers are static or have been rendered server side.
		if(Results.settings.render.features.headers === true){

			Features.emptyAdditionalInfoCategory = true;

			// gather all the feature types we are going to compare
			var featuresIds = new Array();
			var html = '';

			$.each(Features.results, function(index, result){

				var productAvailability = null;
				if( Results.settings.paths.availability.product && Results.settings.paths.availability.product != "" ){

					var productAvailability = Object.byString(result, Results.settings.paths.availability.product);
				}

				// only for available products
				if( productAvailability == "Y" || typeof(productAvailability) == "undefined" ) {

					var features = Object.byString( result, Results.settings.paths.features );
					if( typeof(features) != "undefined" && features.length > 0 ){

						var currentCategory = "";
						$.each( features, function( index, feature ){

							if( Features.emptyAdditionalInfoCategory && feature.categoryId == 9 && feature.extra != ""){
								Features.emptyAdditionalInfoCategory = false;
							}

							if( $.inArray( feature.featureId, featuresIds ) == -1 ){

								featuresIds.push(feature.featureId);
								if( Results.settings.show.featuresCategories && currentCategory != feature.categoryId ){
									parsedCategory = Results.view.parseTemplate( Features.template, { value: feature.categoryName, featureId: "category-"+feature.categoryId, extra: "", cellType: "category" } );
									html += parsedCategory;
									currentCategory = feature.categoryId;
								}

								if( !isNaN(feature.desc) ){
									feature.desc = "";
								}

								var parsedFeatureId = Results.view.parseTemplate( Features.template, {featureId: feature.featureId, value: feature.desc, extra: "&nbsp;", cellType: "feature"} );
								html += parsedFeatureId;

							}

						});

					}
				}

			});

			$( Features.target + " " + Results.settings.elements.features.headers + " " + Results.settings.elements.features.list ).html( html );

			Features.featuresIds = featuresIds;
		}

	},

	populateFeatures: function() {
		
		// population of features into product columns
		$.each( Features.results, function(index, product) {

			var productAvailability = null;
			if( Results.settings.paths.availability.product && Results.settings.paths.availability.product != "" ){
				var productAvailability = Object.byString(product, Results.settings.paths.availability.product);
			}

			// only for available products and not the user's current insurer
			if(
				( productAvailability == "Y" || typeof(productAvailability) == "undefined" ) &&
				( !Results.model.currentProduct  || Results.model.currentProduct.value != Object.byString(product, Results.model.currentProduct.path) )
			){

				var productId = Object.byString( product, Results.settings.paths.productId );
				var $targetContainer = $( Features.target + " " + Results.settings.elements.rows + "[data-productId='" + productId + "']" ).find( Results.settings.elements.features.list );

				// remove the loading spinner
				var html = '';

				if(Results.settings.render.features.mode == 'populate'){

					html = Features.populateTemplate(product);

				}else{

					html = Features.buildAndPopulateTemplate(product);

				}

				$targetContainer.html( html );

			}

		});

		// this is a custom case/hack for the Additional Info category
		// when none of the displayed products have any additional info
		if( Features.emptyAdditionalInfoCategory ){
			$(Features.target + " [data-featureId=category-9]").next().remove().end().remove();
		}



	},

	populateTemplate: function(product){

		// The server has rendered a 'flat' template for a single product, therefore just populate this flat template with product values.

		var currentProductTemplate = $(Results.settings.elements.templates.feature).html();
		return Results.view.parseTemplate(currentProductTemplate, product);

	},

	buildAndPopulateTemplate: function(product){

		// Build the features dynamically based on the data model.

		var html = '';
		var currentCategory = "";

		$.each( Features.featuresIds, function( featureIdIndex, featureId ){

			// get the current product features
			var features = Object.byString( product, Results.settings.paths.features );

			var foundFeature = false;
			var parsedFeature = "";

			// look for the current feature we want to display in the list of features of the current product
			$.each( features, function( featureIndex, feature ){

				// if we found it
				if( feature.featureId == featureId ){

					foundFeature = feature;

					feature.value = Features.parseFeatureValue( feature.value );
					if( feature.extra == "" ){
						feature.extra = "&nbsp;";
					}
					if (feature.value == "" && feature.extra != "") {
						feature.value = feature.extra;
						feature.extra = "&nbsp;";
					}

					parsedFeature = Results.view.parseTemplate( Features.template, $.extend( feature, {cellType: "feature"} ) );

					return false;
				}

			} );

			if( !foundFeature ){
				var parsedFeature = Results.view.parseTemplate( Features.template, { value: "&nbsp;", featureId: featureId, extra: "", cellType: "feature" } );
			} else {
				if( Results.settings.show.featuresCategories && currentCategory != foundFeature.categoryId ){
					parsedCategory = Results.view.parseTemplate( Features.template, { value: "&nbsp;", featureId: "category-"+foundFeature.categoryId, extra: "", cellType: "category" } );
					html += parsedCategory;
					currentCategory = foundFeature.categoryId;
				}
			}

			// add html to the feature list DOM element of the product
			html += parsedFeature;

		});

		return html;
	},

	parseFeatureValue: function(value, decode) {

		decode = decode || false;

		if (typeof value === 'undefined' || value === '') {
			value = "&nbsp;";
		} else {
			var obj = _.findWhere(Results.settings.dictionary.valueMap, {key:value});
			if (typeof obj !== 'undefined') {
				value = obj.value;
			}
		}

		return decode === true ? Features.simpleDecodeHTML(value) : value;
	},

	simpleDecodeHTML: function(input) {
		if(typeof input === "string") {
			input = input.replace(/&lt;/gi, "<");
			input = input.replace(/&gt;/gi, ">");
		}
		return input;
	},

	setExpandableRows: function(){

		if( $(Features.target + " .expandable").length == 0 ){

			$( Features.target + " " + Results.settings.elements.rows + ".notfiltered " + Results.settings.elements.features.extras + " " + Results.settings.elements.features.values )
				.filter( function(){ return $(this).html() != "&nbsp;" && $(this).html() != "" } )
				.parent().parent().addClass( Results.settings.elements.features.expandable.replace(/[#\.]/g, '') );
		}

	},

	applyExpandableEvents: function(){
		var selector = Features.target + " .expandable > " + Results.settings.elements.features.values;
		$(document.body).off('click', selector).on('click', selector ,function(e){

			var featureId = $(this).attr("data-featureId");

			var $extras = $(Features.target+' .children[data-fid="' + featureId + '"]');
			var $parents = $extras.parent(),
				opening;
			if ( $parents.hasClass("expanded") === false ) {
				Features.toggleOpen($extras, $parents);
				opening = true;
			} else {
				Features.toggleClose($parents);
				opening = false;
			}

			if(typeof meerkat !== "undefined") {
				meerkat.messaging.publish(Results.moduleEvents.FEATURE_TOGGLED, {
					element: $extras.eq(0),
					isOpening: opening
				});
			}

		}).on('click', '.expandAllFeatures, .collapseAllFeatures', function(e) {
			e.preventDefault();
			$(this).parent().find('.active').removeClass('active');
			$(this).addClass('active');
			var $extras = $(Features.target+' .children[data-fid]'),
			$parents = $extras.parent();
			if($(this).hasClass('expandAllFeatures')) {
				Features.toggleOpen($extras, $parents);
			} else {
				Features.toggleClose($parents);
			}
		});

	},
	toggleClose: function($parents) {
		$parents.removeClass("expanded").addClass("collapsed");
	},
	toggleOpen: function($extras, $parents) {

		_.defer(function(){

			$parents.removeClass("collapsed").addClass("expanding");

			_.defer(function(){

				Features.sameHeightRows( $extras.find(Results.settings.elements.features.values ) ); // Removed .filter(":visible") because IE couldn't handle it.
				$parents.removeClass("expanding").addClass("expanded");
			});

		});
	},
	clearSetHeights:function(){
		$( Features.target + " " + Results.settings.elements.features.values ).removeClass (function (index, css) {
			return (css.match (/\height\S+/g) || []).join(' ');
		});
		$( Features.target + " " + Results.settings.elements.features.values ).css("height", '');
	},

	balanceVisibleRowsHeight: function(){
		// Never needs to run on price mode.
		if(Features.target === false || (typeof Results.getDisplayMode === 'function' && Results.getDisplayMode() == 'price')) {
			return;
		}
		var visibleMultirowElements = $( Features.target + " " + Results.settings.elements.features.values+":visible"  ); // Removed .filter(":visible") because IE couldn't handle it.
		Features.sameHeightRows( visibleMultirowElements );
	},

	sameHeightRows: function( elements ){

		var featureRowCache = [];

		elements.each(function elementsEach(elementIndex, element){

			var $e = $(element);

			var featureId = $e.attr("data-featureId");

			var item = _.findWhere(featureRowCache, {featureId: featureId});

			if(typeof item != 'undefined'){
				item.height = Math.max(getHeight($e), item.height);
				item.elements.push($e);
			}else{
				var obj = {};
				obj.featureId = featureId;
				obj.height = getHeight($e);
				obj.elements = [];
				obj.elements.push($e);
				featureRowCache.push(obj);
			}

		});

		for(var i =0;i<featureRowCache.length;i++){

			var item2 = featureRowCache[i];

			for(var j =0;j<item2.elements.length;j++){

				var $ee = item2.elements[j];

				// use css classes to set heights between 20 and 270 pixels (classes are in 20 pixel increments)
				// This is for performance reasons - esp. on tablet where is seems it is faster to set height via css class than directly.

				var roundedHeight = Math.ceil( item2.height / 10 ) * 10;

				// Smaller rows for Car and Home
				if(typeof meerkat !== "undefined") {
					if (meerkat.site.vertical == 'car' || meerkat.site.vertical == 'home') {
						roundedHeight = roundedHeight - 5;
					}
				}

				if(roundedHeight <= 270){
					$ee.addClass('height'+roundedHeight);
				}else{
					$ee.height(item2.height);
				}

			}
		}


		function getHeight($h){
			// the h class means its a header cell which is always recalculated
			if($h.hasClass('isMultiRow') || $h.hasClass('h')){
				return $h.innerHeight();
			}else{
				return 0;
			}
		}
	},

	hideEmptyRows: function() {
		var $container = $(Features.target);
		// hides rows without any values (mostly for the "Additional Information" category)
		$.each( Features.featuresIds, function( featureIdIndex, featureId ){
			var found = false;
			var $currentRow = $('[data-featureId="' + featureId + '"]', $container);
			$currentRow.each(function(){
					var value = $.trim($(this).text());
					if( !found && value != '' && value != "&nbsp;" ){
						found = true;
						return false; //break out
					}
			});
			if(!found){
				$currentRow.parent().hide();
			}
		});

	},

	removeEmptyDropdowns: function() {
		var $container = $(Features.target);
		// hides rows without any values (mostly for the "Additional Information" category)
		$.each( Features.featuresIds, function( featureIdIndex, featureId ){
			var found = false;
			var $currentRow = $('.children[data-fid="' + featureId + '"]', $container);
			$currentRow.each(function(){
					var value = $.trim($(this).text());
					if( !found && value != '' && value != "&nbsp;" ){
						found = true;
						return false; //break out
					}
			});
			if(!found) {
				$currentRow.closest('.cell').off('mousenter mousemove').removeClass('expandable').end().remove();
			}
		});

	},

	flush: function(){
		$( Features.target ).find( Results.settings.elements.features.list ).html('');
	}

}