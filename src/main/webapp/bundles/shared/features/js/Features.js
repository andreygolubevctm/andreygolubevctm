Features = {

	template: false,
	target: false,
	results: false,
	featuresIds: false,
	pageStructure: [],
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
					Features.clearAndBalanceRowsHeight();
				}

			});
		}

		Features.applyExpandableEvents();
	},

	/**
	 *
	 * @param featuresStructureIndexToUse - If you want to render different sections in different divs, set Results.settings.elements.features.renderTemplatesBasedOnFeatureIndex to true and add data-feature-index="#" to the markup.
	 * @returns Array - Must return an array
     */
	getPageStructure: function(featuresStructureIndexToUse) {
		if(_.isUndefined(featuresStructureIndexToUse) || _.isNull(featuresStructureIndexToUse)) {
			return Features.pageStructure || [];
		} else {
			return _.isObject(Features.pageStructure[featuresStructureIndexToUse]) ? [Features.pageStructure[featuresStructureIndexToUse]] : [];
		}
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

		if (Features.template === "") {
			console.log("The feature template could not be found: templateSelector=", Results.settings.elements.templates.feature, "This template is mandatory, make sure to pass the correct selector to the Results.settings.elements.templates.feature user setting when calling Results.init()");
			return;
		}

		$(Results.settings.elements.resultsContainer).trigger("populateFeaturesStart");

		Features.populateFeatures();
		Features.populateFeaturesHeaders();
		Features.setExpandableRows();

		_.defer(function(){
			Features.clearAndBalanceRowsHeight();
			$(Results.settings.elements.resultsContainer).trigger("populateFeaturesEnd");
		});

		Features.hideEmptyRows();

		$(Features.target).trigger("FeaturesRendered");


	},
	populateFeaturesHeaders: function() {
		if($( ".featuresHeaders" ).length) {
			var $targetContainer = $(".featuresHeaders").find(Results.settings.elements.features.list);
			$targetContainer.html(Results.view.parseTemplate("#feature-template-labels", {}));
		}
	},
	populateFeatures: function() {

		// If specified, use data-feature-index on the div you want to render the template inside.
		var renderBasedOnFeatureIndex = Results.settings.elements.features.renderTemplatesBasedOnFeatureIndex,
			structure = Features.getPageStructure(),
			defaultTemplate = Results.settings.elements.templates.feature;

		// population of features into product columns
		$.each( Features.results, function(index, product) {

			var productAvailability = null, availabilityObj =  Results.settings.paths.availability.product;
			if( availabilityObj && availabilityObj !== "" ){
				productAvailability = Object.byString(product, availabilityObj);
			}

			// only for available products and not the user's current insurer
			if(
				( productAvailability == "Y" || typeof(productAvailability) == "undefined" ) &&
				( !Results.model.currentProduct  || Results.model.currentProduct.value != Object.byString(product, Results.model.currentProduct.path) )
			){

				var productId = Object.byString( product, Results.settings.paths.productId );
				var featuresContainerTarget = Features.target + " " + Results.settings.elements.rows + "[data-productId='" + productId + "']";
				var $targetContainer = $( featuresContainerTarget ).find( Results.settings.elements.features.list );

				// Only use this mode if not
				if(renderBasedOnFeatureIndex === true) {
					if(!$targetContainer.find('[data-feature-index]').length) {
						console.log("Error: Did not find any feature containers for this product");
						return;
					}
					$targetContainer.find('[data-feature-index]').each(function() {
						var $el = $(this),
							dataIndex = $el.attr('data-feature-index'),
							differentTemplateSelector = $el.attr('data-feature-template'),
							featureType = $el.attr('data-feature-type');
						if(!_.isUndefined(structure) && _.isObject(structure[dataIndex])) {
							product.featuresStructureIndexToUse = dataIndex;
							if(featureType) {
                                product.featureType = featureType;
                            }
							product.featuresTemplate = differentTemplateSelector && $(differentTemplateSelector).length ? differentTemplateSelector : defaultTemplate;
							$el.html( Features.populateTemplate(product.featuresTemplate, product) );
						}
					});
				} else {
					product.featuresStructureIndexToUse = null;
					product.featuresTemplate = defaultTemplate;
					$targetContainer.html( Features.populateTemplate(product.featuresTemplate, product) );
				}

			}

		});

		// this is a custom case/hack for the Additional Info category
		// when none of the displayed products have any additional info
		if( Features.emptyAdditionalInfoCategory ) {
			$(Features.target + " [data-featureId=category-9]").next().remove().end().remove();
		}
	},
	populateTemplate: function(templateSelector, product){
		// The server has rendered a 'flat' template for a single product, therefore just populate this flat template with product values.
		return Results.view.parseTemplate(templateSelector, product);
	},

	parseFeatureValue: function(value, decode) {

		decode = decode || false;

		if (typeof value == 'undefined' || value === '') {
			value = false;
		} else {
			var obj = _.findWhere(Results.settings.dictionary.valueMap, {key:value});
			if (typeof obj != 'undefined') {
				value = obj.value;
			}
		}

		return decode === true ? Features.simpleDecodeHTML(value) : value;
	},

	simpleDecodeHTML: function(input) {
		if(typeof input == "string") {
			input = input.replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
		}
		return input;
	},

	setExpandableRows: function(){

		if( $(Features.target + " .expandable").length === 0 ){

			$( Features.target + " " + Results.settings.elements.rows + ".notfiltered " + Results.settings.elements.features.extras + " " + Results.settings.elements.features.values )
				.filter( function(){ return $(this).html() != "&nbsp;" && $(this).html() !== ""; } )
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

				Features.sameHeightRows( $extras.find(Results.settings.elements.features.values +":visible" ) ); // Removed .filter(":visible") because IE couldn't handle it.
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
		var currentPageElements = (meerkat.modules.deviceMediaState.get() === 'xs' &&
			Results.settings.balanceCurrentPageRowsHeightOnly.mobile) ? ' .result-row.currentPage ' : ' ';
		var visibleMultiRowElements = $( Features.target + currentPageElements + Results.settings.elements.features.values+":visible"  ); // Removed .filter(":visible") because IE couldn't handle it.
		Features.sameHeightRows( visibleMultiRowElements );
	},

	sameHeightRows: function( elements ){

		var featureRowCache = [];

		elements.each(function elementsEach(elementIndex, element){

			var $e = $(element);

			var featureId = $e.attr("data-featureId");
			var item = _.findWhere(featureRowCache, {featureId: featureId});

			if(typeof item != 'undefined'){
				item.height = Math.max(Features.getHeight($e), item.height);
				item.elements.push($e);
			}else{
				var obj = {};
				obj.featureId = featureId;
				obj.height = Features.getHeight($e);
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
					if(roundedHeight !== 0)
						$ee.addClass('height'+roundedHeight);
				}else{
					$ee.height(item2.height);
				}

			}
		}



	},
	getHeight: function($h){
		// the h class means its a header cell which is always recalculated
		if($h.hasClass('isMultiRow') || $h.hasClass('h')){
			return $h.innerHeight();
		}else{
			return 0;
		}
	},
	hideEmptyRows: function() {
		if(!Features.featuresIds) {
			return;
		}
		var $container = $(Features.target);

		// hides rows without any values (mostly for the "Additional Information" category)
		$.each( Features.featuresIds, function( featureIdIndex, featureId ){
			var found = false;
			var $currentRow = $('[data-featureId="' + featureId + '"]', $container);
			$currentRow.each(function(){
					var value = $.trim($(this).text());
					if( !found && value !== '' && value != "&nbsp;" ){
						found = true;
						return false; //break out
					}
			});
			if(!found){
				$currentRow.parent().hide();
			}
		});

	},

	/**
	 * This is used in Car/Home LMI. Not sure how to get Features.featureIds in other verticals.
	 * Removes
	 */
	removeEmptyDropdowns: function() {
		if(!Features.featuresIds) {
			return;
		}
		var $container = $(Features.target);
		// hides rows without any values (mostly for the "Additional Information" category)
		$.each( Features.featuresIds, function( featureIdIndex, featureId ){
			var found = false;
			var $currentRow = $('.children[data-fid="' + featureId + '"]', $container);
			$currentRow.each(function(){
					var value = $.trim($(this).text());
					if( !found && value !== '' && value != "&nbsp;" ){
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
	},

	clearAndBalanceRowsHeight: function() {
		Features.clearSetHeights();
		Features.balanceVisibleRowsHeight();
	}
};