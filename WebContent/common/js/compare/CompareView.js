CompareView = new Object();
CompareView = {

	resultsFiltered: false,
	comparisonOpen: false,

	add: function( productId ){

		var origin = $( Results.settings.elements.rows + "[data-productId=" + productId + "]" ).find( Compare.settings.elements.companyImage );
		var destination = $(Compare.settings.elements.boxes).eq( Compare.model.products.length - 1 );

		var sizeAndPos = Compare.view.getCompareSizeAndPos(origin, destination);

		origin.clone()
			.css('position', 'absolute')
			.css('top', origin.offset().top)
			.css('left', origin.offset().left)
			.css('width', origin.width() )
			.css('height', origin.height() )
			.css('z-index', '10002')
			.appendTo('body')
			.animate(
				{
					top: destination.offset().top + sizeAndPos.verticalOffset,
					left: destination.offset().left + sizeAndPos.horizontalOffset,
					width: sizeAndPos.cloneFinalWidth,
					height: sizeAndPos.cloneFinalHeight
				},
				Compare.settings.animation.add.speed,
				Compare.settings.animation.add.easing,
				function(){

					Compare.view.render();
					$(this).remove();
					Compare.view.toggleButton();

				}
			);

		$(Compare.settings.elements.bar).trigger("compareAdded", [productId]);

	},

	remove: function( productId ){

		var image = $(Compare.settings.elements.boxes).find("img[data-productId=" + productId + "]");
		var compareBox = image.parent();

		Compare.view.toggleButton();

		compareBox.siblings(".compareCloseIcon").fadeOut('fast', function(){

			image.hide(
				Compare.settings.animation.remove.type,
				Compare.settings.animation.remove.options,
				Compare.settings.animation.remove.speed,
				function(){
					compareBox.hide();
					image.remove();
					Compare.view.render();

					// remove images/close buttons that should be not be displayed
					var emptyCompareBoxes = $(Compare.settings.elements.boxes+":gt("+ Number(Compare.model.products.length - 1) +")");
					var images = emptyCompareBoxes.find("img");
					images.parent().hide();
					images.remove();
					emptyCompareBoxes.find(".compareCloseIcon").hide();
				}
			);

		});

		$(Compare.settings.elements.bar).trigger("compareRemoved", [productId]);

	},

	render: function(){

		$(Compare.settings.elements.bar).find( Compare.settings.elements.companyImage ).parents().show();

		$.each( Compare.model.products, function(index, product){

			var origin = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + product.id + "]" )
								.find( Compare.settings.elements.companyImage );
			var destination = $(Compare.settings.elements.boxes).eq( index );
			var imageContainer = destination.find("span.compareBoxLogo");

			// only render if the position of the element has changed or did not exist yet
			if( imageContainer.find( Compare.settings.elements.companyImage ).attr("data-productId") != product.id ){
				var sizeAndPos = Compare.view.getCompareSizeAndPos( origin, destination);

				var image = origin.clone();

				if( sizeAndPos.cloneFinalWidth > sizeAndPos.cloneFinalHeight ){
					image.css("top", sizeAndPos.verticalOffset).css("left", "inherit");
				} else {
					image.css("top", "inherit").css("left", sizeAndPos.horizontalOffset);
				}

				image.css("position", "relative");
				image.css("width", sizeAndPos.cloneFinalWidth);
				image.css("height", sizeAndPos.cloneFinalHeight);
				image.attr("data-productId", product.id );

				imageContainer.html( image ).show().siblings(".compareCloseIcon").fadeIn();
			}

		});

	},

	getCompareSizeAndPos: function( origin, destination ){

		var destinationWidth = destination.width();
		var destinationHeight = destination.height();
		var destinationOuterWidth = destination.outerWidth();
		var destinationOuterHeight = destination.outerHeight();

		var sizeAndPos = new Object();

		var originRatio = origin.width() / origin.height();
		if( originRatio > 1 ){
			sizeAndPos.cloneFinalWidth  = destinationWidth;
			sizeAndPos.cloneFinalHeight = sizeAndPos.cloneFinalWidth/originRatio;
			sizeAndPos.horizontalOffset = (destinationOuterWidth - destinationWidth) / 2;
			sizeAndPos.verticalOffset = (destinationOuterHeight - sizeAndPos.cloneFinalHeight) / 2;
		} else if(originRatio < 1) {
			sizeAndPos.cloneFinalHeight = destinationHeight;
			sizeAndPos.cloneFinalWidth  = sizeAndPos.cloneFinalHeight/originRatio;
			sizeAndPos.horizontalOffset = (destinationOuterWidth - sizeAndPos.cloneFinalWidth) / 2;
			sizeAndPos.verticalOffset = (destinationOuterHeight - destinationHeight) / 2;
		} else {
			sizeAndPos.cloneFinalWidth  = destinationWidth;
			sizeAndPos.cloneFinalHeight = destinationHeight;
			sizeAndPos.horizontalOffset = 0;
			sizeAndPos.verticalOffset = 0;
		}

		return sizeAndPos;
	},

	toggleButton: function( action ){

		var button = $(Compare.settings.elements.button);
		var compareBar = $( Compare.settings.elements.bar );

		if( action != "disable" && Compare.model.products && Compare.model.products.length >= Compare.settings.minimum ){

			// only trigger compareAvailable event when it just became available, not when toggleButton() is called manually
			if( action != "enable" ){
				compareBar.trigger("compareAvailable");
			}

			button.unbind();

			button.on("click", function(){
				if( !$(this).hasClass("compareInActive") ){
					compareBar.trigger("compareClick");
				}
			});

			button.removeClass("compareInActive");

		} else {
			button.addClass("compareInActive");
			button.unbind();
		}

	},

	open: function(){

		Compare.view.comparisonOpen = true;

		Compare.view.buildComparison();

		$(Compare.settings.elements.button).html("Close"); // @todo the "Open" text should be set by a dictionary setting like done in the Results object

		$(Compare.settings.elements.container).hide();
		$(Compare.settings.elements.container).css("position", "static").css("left", 0);
		$(Compare.settings.elements.container).show(Compare.settings.animation.open.options);

		$('html, body').animate({scrollTop: Compare.topPosition }, 500);

	},

	close: function(){

		Compare.view.comparisonOpen = false;

		$(Compare.settings.elements.button).html("Compare"); // @todo the "Close" text should be set by a dictionary setting like done in the Results object

		$(Compare.settings.elements.container).hide(Compare.settings.animation.close.options);

	},

	filterResults: function(){

		Compare.view.resultsFiltered = true;

		Results.filterBy("productId", "value", {inArray: Compare.getComparedProductIds()}, true);

		$(Compare.settings.elements.button).html("Back to all results");

	},

	unfilterResults: function(){

		Results.unfilterBy("productId", "value", Compare.view.resultsFiltered);

		Compare.view.resultsFiltered = false;

		$(Compare.settings.elements.button).html("Compare"); // @todo the "Compare" text should be set by a dictionary setting like done in the Results object

	},

	buildComparison: function(){

		// product template
		var productTemplate = $(Results.settings.elements.templates.result).html();
		if( productTemplate == "" ){
			console.log("The product template could not be found: templateSelector=",Results.settings.elements.templates.result,"This template is mandatory, check Compare.view.buildComparison()");
		} else {

			$( Compare.settings.elements.compareTable + " " + Results.settings.elements.container ).html("");

			var productsHtml = "";

			// build the HTML results
			$.each(Compare.model.products, function(index, product){
				productRow = $( parseTemplate(productTemplate, product.object) );
				productsHtml += $(productRow)[0].outerHTML || new XMLSerializer().serializeToString($(productRow)[0]); // add row HTML to final HTML
			});

			$( Compare.settings.elements.compareTable + " " + Results.settings.elements.container ).append( productsHtml );

			Features.buildHtml( Compare.getComparedProductObjects(), Compare.settings.elements.compareTable );

			ResultsUtilities.setContainerWidth(
				Compare.settings.elements.compareTable + " " + Results.settings.elements.rows,
				Compare.settings.elements.compareTable + " " + Results.settings.elements.container
			);

			$( Compare.settings.elements.container ).trigger("compareBuilt");

		}

	},

	addRowFromResultData: function( title, path, position ) {

		/*
		@todo = currently, this function will just not work at all, it needs to be refactored so that it works with the current HTML structure
		Or potentially we will never make use of this and it could be deleted
		*/
		var featureRowTemplate = $(Compare.settings.elements.templates.featureRow).html();
		var featureTemplate = $(Compare.settings.elements.templates.feature).html();

		if( featureRowTemplate == "" ){
			console.log("The comparison feature row template could not be found: templateSelector=", Compare.settings.elements.templates.featureRow, "This template is mandatory, make sure to pass the correct selector to the Compare.settings.elements.templates.featureRow user setting when calling Compare.init()");
		} else if( featureTemplate == "" ){
			console.log("The comparison feature template could not be found: templateSelector=", Compare.settings.elements.templates.feature, "This template is mandatory, make sure to pass the correct selector to the Compare.settings.elements.templates.feature user setting when calling Compare.init()");
		} else {

			var html = "";
			var parsedFeatureRow = $( parseTemplate( featureRowTemplate, {desc: title} ) );

			$.each( Compare.model.products, function( index, productId ){
				var product = Results.getResultByIndex( productId );
				var value = Object.byString( product, path);

				var parsedFeature = $( parseTemplate( featureTemplate, $.extend({}, product, {desc: title, value: value}) ) );
				parsedFeatureRow.find( Compare.settings.elements.featureValuesContainer ).append( parsedFeature );
			});

			if( position == "last" ) {
				$( Compare.settings.elements.compareFeatures ).append( parsedFeatureRow );
			} else if( position == "first" ) {
				$( Compare.settings.elements.compareFeatures ).prepend( parsedFeatureRow );
			} else if( !isNaN(position) ) {
				$( Compare.settings.elements.compareFeatures + " > " + Compare.settings.elements.featureRow ).eq( position - 1 ).before( parsedFeatureRow );
			} else {
				console.log("The provided position where to add this additional comparison row should be a number or 'last' or 'first'");
			}

		}

	},

	showSavings: function( value ){

		$(Compare.settings.elements.savingsValue).html( value );
		$(Compare.settings.elements.savings).show();

	},

	hideSavings: function(){
		$(Compare.settings.elements.savings).hide();
	},

	reset: function(){
		Compare.view.resultsFiltered = false;
		Compare.view.unfilterResults();
	}
};