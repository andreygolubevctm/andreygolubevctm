Features = new Object();
Features = {

	template: false,
	target: false,
	results: false,
	featuresIds: false,
	emptyAdditionalInfoCategory: true,

	buildHtml: function( results, target ){

		// Which set of results to use
		if( typeof(results) == "undefined" ){
			if( Results.settings.animation.shuffle.active ){
				Features.results = Results.model.returnedProducts;
			} else {
				Features.results = Results.model.sortedProducts;
			}
		} else {
			Features.results = results;
		}

		if( typeof(target) == "undefined" ){
			Features.target = Results.settings.elements.resultsContainer;
		} else {
			Features.target = target;
		}

		// prep of feature template
		Features.template = $(Results.settings.elements.templates.feature).html();

		if( Features.template == "" ) {
			console.log("The comparison feature template could not be found: templateSelector=", Compare.settings.elements.templates.feature, "This template is mandatory, make sure to pass the correct selector to the Compare.settings.elements.templates.feature user setting when calling Compare.init()");
		} else {

			Features.populateHeaders();

			Features.populateFeatures();

			Features.setExpandableRows();

			/**
			 * Had to add a slight delay before calculating heights as it seems the DOM is not
			 * always ready after the previous DOM manipulations (either 0 or incorrect height)
			 * see window.setTimout after this.
			 */
			window.setTimeout( function(){
				Features.sameHeightRows();
			}, 100 );

			Features.hideEmptyRows();

		}

	},

	populateHeaders: function(){

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
								parsedCategory = parseTemplate( Features.template, { value: feature.categoryName, featureId: "category-"+feature.categoryId, extra: "", cellType: "category" } );
									html += parsedCategory;
									currentCategory = feature.categoryId;
								}

								if( !isNaN(feature.desc) ){
									feature.desc = "";
								}

							var parsedFeatureId = parseTemplate( Features.template, {featureId: feature.featureId, value: feature.desc, extra: "&nbsp;", cellType: "feature"} );
								html += parsedFeatureId;

							}

						});

					}

				}

			});

		$( Features.target + " " + Results.settings.elements.features.headers + " " + Results.settings.elements.features.list ).html( html );

		Features.featuresIds = featuresIds;

	},

	populateFeatures: function(){

			// population of features into product columns
		$.each( Features.results, function( index, product ){

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
				var targetContainer = $( Features.target + " " + Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find( Results.settings.elements.features.list );

					// remove the loading spinner
					var html = '';

					// loop through the list of features we found
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

							parsedFeature = parseTemplate( Features.template, $.extend( feature, {cellType: "feature"} ) );

								return false;
							}

						} );

						if( !foundFeature ){
						var parsedFeature = parseTemplate( Features.template, { value: "&nbsp;", featureId: featureId, extra: "", cellType: "feature" } );
						} else {
							if( Results.settings.show.featuresCategories && currentCategory != foundFeature.categoryId ){
							parsedCategory = parseTemplate( Features.template, { value: "&nbsp;", featureId: "category-"+foundFeature.categoryId, extra: "", cellType: "category" } );
								html += parsedCategory;
								currentCategory = foundFeature.categoryId;
							}
						}

						// add html to the feature list DOM element of the product
						html += parsedFeature;

					});

					targetContainer.html( html );

				}

			});

			// this is a custom case/hack for the Additional Info category
			// when none of the displayed products have any additional info
		if( Features.emptyAdditionalInfoCategory ){
			$(Features.target + " [data-featureId=category-9]").next().remove();
			$(Features.target + " [data-featureId=category-9]").remove();
			}

	},

	parseFeatureValue : function (value) {

		var returnVal = '';
		switch (value) {
			case 'AI':
				returnVal = "Additional Information";
				break;
			case 'Y':
				returnVal = "<img src='brand/ctm/images/quote_result/tick_med_blue.png'>";
				break;
			case 'N':
				returnVal = "<img src='brand/ctm/images/quote_result/cross_med_red.png'>";
				break;
			case 'O':
				returnVal = "Optional";
				break;
			case 'R':
				returnVal = "Restricted / Conditional";
				break;
			case 'L':
				returnVal = "Limited";
				break;
			case 'SCH':
				returnVal = "As shown in schedule";
				break;
			case 'NA':
				returnVal = "Non Applicable";
				break;
			case 'E':
				returnVal = "Excluded";
				break;
			case 'NE':
				returnVal = "No Exclusion";
				break;
			case 'OTH':
				returnVal = "";
				break;
			default :
				returnVal = value;
		}
		return returnVal;

	},

	setExpandableRows: function(){

		$( Features.target + " " + Results.settings.elements.rows + ":not(.filtered) " + Results.settings.elements.features.extras )
				.filter( function(){ return $(this).html() != "&nbsp;" && $(this).html() != "" } )
				.each( function( index, featureExtra ){

				var $currentExtra = $(this);
				var $clickableCell = $currentExtra.parent();
				var $valuesCell = $currentExtra.prev( Results.settings.elements.features.values );

				var featureId = $clickableCell.attr("data-featureId");
				var $hoverRow = $( Features.target + ' [data-featureId="' + featureId + '"]' );

				// add expandable arrow icon on value cell
				$valuesCell.addClass( Results.settings.elements.features.expandable.replace(/[#\.]/g, '') );

				// MOUSE ENTER
					$clickableCell.on("mouseenter", function(){
						$hoverRow.addClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
				})
				// MOUSE LEAVE
				.on("mouseleave", function(){
						$hoverRow.removeClass( Results.settings.elements.features.expandableHover.replace(/[#\.]/g, '') );
				})
				// MOUSE CLICK
				.on("click", function(){

					var $clickedThis = $(this);
						var featureIdClicked = $hoverRow.attr("data-featureId");
					var maxHeight = 0;
						var $extras = $hoverRow.children( Results.settings.elements.features.extras );

						if( !( $hoverRow.hasClass("expanded") || $hoverRow.hasClass("collapsed") ) ) {

						//Discover highest cell
						$extras.each(function extrasRowEach_getHeights(){
							var extra = $(this);
							extra.show();
							var currentHeight = extra.height();
							if( currentHeight > maxHeight ) {
								maxHeight = currentHeight;
							}
							extra.hide();
						});

						//Set height on each
						$extras.each(function extrasRowEach_setHeights(){
							$(this).height( maxHeight );
						});

					} //end check on expanded class

						if ( !( $hoverRow.hasClass("expanded") ) ) {
							$hoverRow.removeClass("collapsed").addClass("expanded");
						$extras.slideDown();
					} else {
							$hoverRow.removeClass("expanded").addClass("collapsed");
							$extras.each(function(){
								$(this).slideUp(400, function(){
									$(this).hide(); // fixes the invisible rows which are currently filtered
								});
							});
					}

				});

			});

	},

	sameHeightRows: function(){
		var headersRows = $( Features.target + " " + Results.settings.elements.features.headers + " " + Results.settings.elements.features.list ).children();

				headersRows.each(function headersRowEach(headerValueIndex, headerRow){
					var featureId = $(headerRow).attr("data-featureId");
			var $currentRow = $(Features.target + ' [data-featureId="' + featureId + '"]')
										.filter( function(){ return $(this).parent().parent('.filtered').length === 0; });
					var $valuesRow = $currentRow.find(Results.settings.elements.features.values);
					// HARMONISE VALUES HEIGHTS
					$valuesRow.height( Math.max.apply($valuesRow, $.map( $valuesRow, function mapSetHeight(e){ return $(e).height(); }) ) );
				});

	},

	hideEmptyRows: function(){

			// hides rows without any values (mostly for the "Additional Information" category)
		$.each( Features.featuresIds, function( featureIdIndex, featureId ){
				var found = false;
			$currentRow = $(Features.target + ' [data-featureId="' + featureId + '"]')
					.children( Results.settings.elements.values )
					.each(
						function(){
							var value = $(this).html();
							if( !found && value != '' && value != "&nbsp;" ){
								found = true;
							}
						}
					);
				if(!found){
					$currentRow.hide();
				}
			});

		}

}