var ResultsView = new Object();
ResultsView = {

	rowHeight: false,
	rowWidth: false,

	currentlyScrolling: false,
	orientation: 'horizontal',

	shuffleTransitionDuration: false,

	/* Displays the results */
	show: function() {
		//window.location.hash = "/?stage=results";
		$.address.parameter("stage", "results", false );

		// show filters bar if exists
		if( typeof(Filters) != "undefined" && $(Filters.settings.elements.filtersBar).length > 0 ){
			Results.view.toggleFilters('show');
		}

		// show compare bar if exists
		if( $(Compare.settings.elements.bar).length > 0 ){
			Results.view.toggleCompare('show');
			ResultsUtilities.makeElementSticky( "top", $(Compare.settings.elements.bar), "fixed-top",	$(Compare.settings.elements.bar).offset().top );
			ResultsUtilities.makeElementSticky( "top", $(Results.settings.elements.page), 	"fixedThree", 	$(Compare.settings.elements.bar).offset().top );
		}

		// flush potential previous results
		Results.view.flush();


		// parses templates and build the HTML
		Results.view.buildHtml();

		// trigger the reflow into the default display mode
		Results.view.setDisplayMode( Results.settings.displayMode, true );

		// animate all the results one by one
		if( Results.settings.animation.results.individual.active ){
			Results.view.animateIndividualResults();
			var animatedElement = $(Results.settings.elements.rows).last();
		// animate all the results as one element
		} else {
			Results.view.animateAllResults();
			var animatedElement = $(Results.settings.elements.resultsContainer);
		}

		// calculate and show savings if any
		if( Results.settings.show.savings && Results.model.currentProduct && Results.model.currentProduct.product ){

			var currentFrequencyPricePath = Results.settings.paths.price[ Results.settings.frequency ];
			var currentPrice = Object.byString( Results.model.currentProduct.product, currentFrequencyPricePath );

			if( currentPrice && typeof( currentPrice ) != "undefined"){

				var topResult = Results.getTopResult();
				var topResultPrice = Object.byString( topResult , currentFrequencyPricePath );

				var savings = currentPrice - topResultPrice;

				Compare.setSavings( savings );
			}
		}

		// what to do when the last animation is over
		$(animatedElement).queue("fx", function(next) {
			if( Results.settings.animation.shuffle.active ){
				Results.view.shuffle();
			} else {
				// trigger the end of animated custom event
				$(Results.settings.elements.resultsContainer).trigger("resultsAnimated");
				// @todo probably should enable things that needed to wait for the animations to be over (sliders/filter?)
				// Results.view.enableStuff();
			}
			next();
		});

	},

	setDisplayMode: function( mode, forceRefresh ){

		if( mode != Results.settings.displayMode || forceRefresh ){

			// remove previous display mode class and apply the new one
			$( Results.settings.elements.resultsContainer ).removeClass( Results.settings.displayMode + "Mode" );
			$( Results.settings.elements.resultsContainer ).addClass( mode + "Mode" );
			Results.settings.displayMode = mode;

			var target = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );

			if( mode == "features" ) {
				Results.view.orientation = 'vertical';

				// orderBy("weight")

				// show all elements specific to features mode
				$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.features.allElements ).css('display', 'block');

				// set width of the results container to width of all the visible results
				ResultsUtilities.setContainerWidth(
					Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ":not(.filtered)",
					Results.settings.elements.resultsContainer + " " + Results.settings.elements.container
				);

				var fullWidth = target.parent().width();
				var widthAllColumns = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows ).first().outerWidth( true ) * $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ":not(.filtered)" ).length;
				var currentLeftMargin = parseInt( target.css("margin-left") );

				// check there are enough products to have the "Next" button activated, otherwise, disable it
				if( widthAllColumns <= fullWidth ){
					$(Results.settings.elements.rightNav).addClass("inactive");
				} else {
					$(Results.settings.elements.rightNav).removeClass("inactive");
				}

				// reset horizontal scrolling
				var newLeftMargin = 0;
				target.css("margin-left", newLeftMargin);
				Results.view.toggleScrollButtons(newLeftMargin);

			} else {
				// make sure to reset margin-left that might have been changed by the features display scrolling
				target.css( "margin-left", "0px" );
				// reset width to auto
				target.css('width', "auto");
				// hide features elements
				$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.features.allElements ).css('display', 'none');
			}

			if( mode == "price" ) {
				Results.view.orientation = 'horizontal';
				// orderBy("price") // or last orderBy selected by user
			}

			$( Results.settings.elements.resultsContainer ).trigger( mode + "DisplayMode" );
		}

	},

	buildHtml: function(){

		var results;
		var resultRow = "";
		var resultsHtml = "";

		// result template
		var resultTemplate = $(Results.settings.elements.templates.result).html();
		if( resultTemplate == "" ){
			console.log("The result template could not be found: templateSelector=",Results.settings.elements.templates.result,"This template is mandatory, make sure to pass the correct selector to the Results.settings.elements.templates.result user setting when calling Results.init()");
		}

		// unavailable template
		if(Results.settings.elements.templates.unavailable){
			var unavailableTemplate = $(Results.settings.elements.templates.unavailable).html();
			if( unavailableTemplate == "" ){
				console.log("The result template could not be found: templateSelector=",Results.settings.elements.templates.unavailable,"If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.unavailable user setting when calling Results.init()");
			}
		}

		// current product template
		if(Results.settings.elements.templates.currentProduct){
			var currentProductTemplate = $(Results.settings.elements.templates.currentProduct).html();
			if( currentProductTemplate == "" ){
				console.log("The result template could not be found: templateSelector=",Results.settings.elements.templates.currentProduct,"If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.currentProduct user setting when calling Results.init()");
			}
		}

		var topResult = Results.model.sortedProducts[0];
		var topResultRow = false;

		// Which set of results to use
		if( Results.settings.animation.shuffle.active ){
			results = Results.model.returnedProducts;
		} else {
			results = Results.model.sortedProducts;
		}

		// build the HTML results
		$.each(results, function(index, result){

			var productAvailability = null;
			if( Results.settings.paths.availability.product && Results.settings.paths.availability.product != "" ){
				var productAvailability = Object.byString(result, Results.settings.paths.availability.product);
			}

			if( typeof(productAvailability) != "undefined" && productAvailability != "Y" && !unavailableTemplate ){
				resultRow = $( parseTemplate("<div></div>", result) ); // fake parsed non available template
			} else if( typeof(productAvailability) != "undefined" && productAvailability != "Y" ) {
				resultRow = $( parseTemplate(unavailableTemplate, result) ); // parsed non available row
			} else {
				if(
					Results.model.currentProduct && // current product has been set
					Results.model.currentProduct.value == Object.byString(result, Results.model.currentProduct.path) // the user's current product = the currently checked product
				){
					// current product template parsing
					resultRow = $( parseTemplate(currentProductTemplate, result) );
				} else {
					// default row template parsing
					resultRow = $( parseTemplate(resultTemplate, result) );
				}
			}
			// @todo = look for "< # ERROR: xxxx has no properties # >" in the returned resultRow and display it in a popup error if present

			if( $.inArray(result, Results.model.filteredProducts ) == -1 ){
				$(resultRow).addClass("invisible").addClass("filtered");
			}
			$(resultRow).attr("id", "result-row-" + index);

			// if top result, add top result markup
			if( result == topResult ){
				topResultRow = "#result-row-" + index;
			}
			resultsHtml += $(resultRow)[0].outerHTML || new XMLSerializer().serializeToString($(resultRow)[0]); // add row HTML to final HTML (second part is for older browsers not supporting outerHTML)

		});

		// fill the results table with parsed rows and trigger custom event
		$(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container).append(resultsHtml);
		Results.view.setTopResult( $( topResultRow ) );

		$(Results.settings.elements.resultsContainer).trigger("resultsLoaded");
	},

	getRowHeight: function(){

		if( Results.view.orientation == "horizontal" && !Results.view.rowHeight ) {
			Results.view.rowHeight = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows ).not(".filtered").first().outerHeight(true);
		}

		return Results.view.rowHeight;
	},

	getRowWidth: function(){

		if( Results.view.orientation == "vertical" &&  !Results.view.rowWidth ) {
			Results.view.rowWidth = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows ).not(".filtered").first().outerWidth(true);
		}

		return Results.view.rowWidth;
	},

	setTopResult: function( element ){
		if( Results.settings.show.topResult ){
			$(Results.settings.elements.rows).find(".topResult").remove();
			$(element).prepend('<div class="topResult"></div>');
		}
	},

	animateIndividualResults: function(){

		var delay = Results.settings.animation.results.delay;
		var individualDelay = Results.settings.animation.results.options.duration + Results.settings.animation.results.individual.delay;

		$(Results.settings.elements.rows).each(function(){
			delay += individualDelay;
			$(this).delay( delay ).show(
				Results.settings.animation.results.options
			);

			// adding acceleration to the display of results
			if(individualDelay - Results.settings.animation.results.individual.acceleration >= 0) {
				individualDelay -= Results.settings.animation.results.individual.acceleration;
			}
		});

	},

	animateAllResults: function(){

		// show all result rows
		$(Results.settings.elements.rows).show();

		$(Results.settings.elements.resultsContainer).css("opacity", 0).css("left", 0);

		// animate the results table
		$(Results.settings.elements.resultsContainer).delay( Results.settings.animation.results.delay ).animate(
				{ "opacity": 1 },
				Results.settings.animation.results.options
		);

	},

	showNoResults: function(){

		Results.view.toggleFilters('hide');
		Results.view.toggleCompare('hide');
		Results.view.flush();
		$(Results.settings.elements.resultsContainer).css("left", 0).find(".noResults.clone").remove();
		$(Results.settings.elements.resultsContainer).append( $(Results.settings.elements.noResults).clone().addClass("clone").delay(500).fadeIn(800) );

	},

	shuffle: function( previousSortedResults ){

		// position all elements absolutely for the time of the animation
		var allRows = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows );
		ResultsUtilities.position("absolute", allRows, Results.view.orientation);

		// wait for the next tick so that DOM is ready
		setTimeout(function(){

			if( typeof(previousSortedResults) == "undefined" ){
				previousSortedResults = Results.model.returnedProducts.slice();
			}

			var currentTop = 0;
			var currentLeft = 0;
			var topResultIndex = 0;

			var rowHeight = Results.view.getRowHeight();
			var rowWidth = Results.view.getRowWidth();


			$.each(Results.model.sortedProducts, function(sortedIndex, sortedResult){

				// look for current ordered element in previously ordered results
				var previousIndex;
				$.each(previousSortedResults, function(currentPreviousIndex, previousResult){
					if( sortedResult == previousResult ){
						previousIndex = currentPreviousIndex;
						return false;
					}
				});

				// which property to animate
				var currentResult = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + "[data-productId=" + Object.byString( sortedResult, "productId") + "]" );

				// if hardware acceleration enabled, use translate3d
				if( Modernizr.csstransforms3d ){

					if( !currentResult.hasClass("hardwareAcceleration") ){
						currentResult.addClass("hardwareAcceleration");
					}

					var posDifference = sortedIndex - previousIndex;

					var offset = 0;
					if( Results.view.orientation == 'horizontal' ){
						offset =  posDifference * rowHeight;
						currentResult.css( Modernizr.prefixed("transform"), 'translate3d(0,' + offset + 'px,0)');
					} else {
						offset = posDifference * rowWidth;
						currentResult.css( Modernizr.prefixed("transform"), 'translate3d(' + offset + 'px,0,0)');
					}

				// css transitions
				} else if( Modernizr.csstransitions ) {

					if( Results.view.orientation == 'horizontal' ){
						currentResult.addClass("topTransition");
						currentResult.css("top", currentTop);
					} else {
						currentResult.addClass("leftTransition");
						currentResult.css("left", currentLeft);
					}

				// jquery animate
				} else {

					var animatedProperty = new Object();

					if( Results.view.orientation == 'horizontal' ){
						animatedProperty = { top: currentTop };
					} else {
						animatedProperty = { left: currentLeft };
					}

					// setup the rows animations
					currentResult.animate(
						animatedProperty,
						Results.settings.animation.shuffle.options
					)

				}

				// get the CSS transition duration of results elements
				if( !Results.view.shuffleTransitionDuration ){
					Results.view.shuffleTransitionDuration = currentResult.transitionDuration(); // jquery plugin in common/js/results/ResultsUtilities.js
				}

				currentResult.attr("data-sort", sortedIndex);

				// reposition the "top result" badge to the first result
				if( !currentResult.hasClass("filtered") ){

					// update top position for next row to order (only if the current one is not filtered)
					if( sortedIndex == topResultIndex ){
						Results.view.setTopResult( currentResult );
					}

					// update the next position
					currentTop += rowHeight;
					currentLeft += rowWidth;
				} else {
					topResultIndex++;
				}

			});

			// launch the animations
			$(Results.settings.elements.rows).clearQueue( Results.settings.animation.filter.reposition.options.queue ).dequeue( Results.settings.animation.shuffle.options.queue );

			// once animations are finished
			setTimeout(function(){

				// trigger the end of animated custom event
				$(Results.settings.elements.resultsContainer).trigger("resultsAnimated");

				// reposition all elements relatively
				ResultsUtilities.position("relative", allRows);

				// reorder DOM elements in sorted order
				allRows.sort(function (a, b) {
					var sortA = parseInt( $(a).attr('data-sort'));
					var sortB = parseInt( $(b).attr('data-sort'));
					return (sortA < sortB) ? -1 : (sortA > sortB) ? 1 : 0;
				}).each(function(){
					$(this).appendTo( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );
				});

				// remove translate3d if using hardware acceleration
				if( Modernizr.csstransforms3d ){

					allRows.addClass("noTransformTransition");
					allRows.css( Modernizr.prefixed("transform"), 'translate3d(0,0,0)');
					setTimeout(function(){
						allRows.removeClass("noTransformTransition");
					}, 0);

				// remove CSS transitions if using them
				} else if( Modernizr.csstransitions ) {

					allRows.removeClass("leftTransition");
					allRows.removeClass("topTransition");

				}


				// @todo probably should enable things that needed to wait for the animations to be over (sliders/filter?)
				// Results.view.enableStuff();

			}, Results.view.shuffleTransitionDuration != 0 ? Results.view.shuffleTransitionDuration : Results.settings.animation.shuffle.options.duration + 50 );

		}, 0);
	},

	filter: function(){
		// temporary solution until we animate the reposition of non filtered results, see commented code below
		$('body').animate({scrollTop: 0}, 500, "swing", function(){
			$( Results.settings.elements.page + " .resultsOverlay").fadeIn( $.extend( Results.settings.animation.filter.disappear.options, {complete: function(){
				$( Results.settings.elements.rows ).removeClass("filtered");

				$.each(Results.model.sortedProducts, function(index, product){
					var productId = Object.byString( product, Results.settings.paths.productId );
					var currentRow = $( Results.settings.elements.rows + "[data-productId=" + productId + "]" );

					if( $.inArray( product, Results.model.filteredProducts ) == -1 ){
						currentRow.addClass("filtered");
					}
				});

				if( Results.settings.displayMode == "features" ){
					Results.view.setDisplayMode( Results.settings.displayMode, true );
				}
				setTimeout( function(){ $( Results.settings.elements.page + " .resultsOverlay").fadeOut( Results.settings.animation.filter.appear.options ) }, 100);

			}} ) );

		});

		/*
		var firstVisible = false;

		// @todo = line below should go in the future, needs to be replaced with a proper result animation when a result position gets changed
		// another line about 20 lines below which adds the class needs to be removed too
		$( Results.settings.elements.container ).removeClass("resultsTableLeftMarginTransition");

		$.each(Results.model.sortedProducts, function(index, product){

			var currentRow = $("#result-row-" + index);

			if( $.inArray( product, Results.model.filteredProducts ) == -1 ){

				var options = $.extend( Results.settings.animation.filter.disappear.options, { queue: Results.settings.animation.filter.reposition.options.queue } );
				currentRow.fadeOut( options );

			} else {

				// add top result sticker on the first visible row
				if(!firstVisible){
					firstVisible = true;
					Results.view.setTopResult( $( "#result-row-" + index ) );
				}

				// if was not visible before, position first, then display
				if( !currentRow.is(":visible") ){
					currentRow.fadeIn( Results.settings.animation.filter.appear.options );
				}

			}

		});

		// force to reset the display mode here in case we need to resize the results container (i.e. features mode)
		$(Results.settings.elements.rows).last().queue(Results.settings.animation.filter.reposition.options.queue, function(next) {
			Results.view.setDisplayMode( Results.settings.displayMode, true );

			// @todo = 2 lines below should go in the future, needs to be replaced with a proper result animation when a result position gets changed
			// another line about 20 lines above which removes the class needs to be removed too
			var hack = $( Results.settings.elements.container )[ 0 ].offsetHeight; // this forces the browser to repaint and therefore to force the transition removal done about 20 lines above
			$( Results.settings.elements.container ).addClass("resultsTableLeftMarginTransition");

			next();
		});

		$(Results.settings.elements.rows).clearQueue( Results.settings.animation.shuffle.options.queue ).dequeue( Results.settings.animation.filter.reposition.options.queue );
		*/

	},

	/* Displays the results page shell (everything but results themselves) */
	showResultsPage: function(){

		if( !$(Results.settings.elements.page).is(":visible") ){

			$("body, html").animate({scrollTop: 0}, 500);

			Results.view.toggleReferenceNo(); // will hide the reference No

			$(Results.settings.formSelector).find(':input').removeAttr("data-visible");
			$(Results.settings.formSelector).find(':input:visible, .ui-dialog :input, .force-invisible-select :input').attr("data-visible", "true");

			$('#page').slideUp('fast', function() {
				$(Results.settings.elements.page).show();
				Results.view.toggleHeaderSize(); // will narrow the height of the header
				Results.view.toggleProgressBar(); // will hide the progress bar
				Results.view.toggleResultsSummary(); // will show the results summary
			});

			if (typeof btnInit !== 'undefined') {
				btnInit._show(); //the moreBtn tag puts this in, and we should show it.
			}
		}

	},

	/* Hides the results page */
	hideResultsPage: function() {

		if( $(Results.settings.elements.page).is(":visible") ){
			$("body, html").scrollTop(0);

			Results.view.toggleHeaderSize(); // will set the header back to its normal height
			Results.view.toggleProgressBar(); // will show the progress bar
			Results.view.toggleReferenceNo(); // will show the reference No
			Results.view.toggleFilters('hide'); // will hide the filters
			Results.view.toggleCompare('hide'); // will hide the compare bar
			Results.view.toggleResultsSummary(); // will hide the results summary

			$('#page').slideDown(300);
			$(Results.settings.elements.page).hide();

			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container ).css("margin-left", 0);
			$(Results.settings.elements.leftNav).addClass("inactive");
			$(Results.settings.elements.page + " .resultsOverlay").hide(0);
		}

	},

	toggleResultsPage: function(){
		if( $(Results.settings.elements.page).is(":visible") ){
			Results.view.hideResultsPage();
		} else {
			Results.view.showResultsPage();
		}

	},

	toggleProgressBar: function(){
		$('#steps').toggle(0);
	},

	toggleReferenceNo: function(){
		if( referenceNo.showReferenceNumber ){
			$(referenceNo.elements.root).slideToggle(200);
		}
	},

	toggleCompare: function( action ){
		if(action && action == "hide"){
			$(Compare.settings.elements.bar).hide();
		} else if( action && action == "show" ){
			$(Compare.settings.elements.bar).fadeIn(400, function(){
				Compare.topPosition = $(Compare.settings.elements.bar).offset().top;
			});
		} else {
			$(Compare.settings.elements.bar).toggle(0);
			Compare.topPosition = $(Compare.settings.elements.bar).offset().top;
		}
	},

	toggleFilters: function( action ){
		if( typeof(Filters) != "undefined" ){
			if(action && action == "hide"){
				$(Filters.settings.elements.filtersBar).hide();
			} else if( action && action == "show" ){
				$(Filters.settings.elements.filtersBar).fadeIn();
			} else {
				$(Filters.settings.elements.filtersBar).toggle(0);
			}
		}
	},

	toggleHeaderSize: function(){
		if( $('#header').hasClass("normal-header") ){
			$('#header').removeClass("normal-header");
			$('#header').addClass("narrow-header");
		} else {
			$('#header').removeClass("narrow-header");
			$('#header').addClass("normal-header");
		}
	},

	toggleResultsSummary: function(){
		$("#resultsDes").hide();

		if( $('#navContainer #summary-header').length === 0 ) {
			$('#summary-header').prependTo('#navContainer');
			$('#summary-header').show();
		} else {
			$('#summary-header').toggle();
		};
	},

	scrollResults: function( clickedButton ){

		if(clickedButton.hasClass("inactive") == false){
			if( !Results.view.currentlyScrolling ){ //Only run if its not currently sliding

				var target = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );
				var fullWidth = target.parent().width();
				var widthAllColumns = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows ).first().outerWidth( true ) * $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ":not(.filtered)" ).length;
				var scrollWidth = fullWidth * Results.settings.animation.features.scroll.percentage;
				var currentLeftMargin = parseInt( target.css("margin-left") );
				var newLeftMargin;

				var leftStatus = "active";
				var rightStatus = "active";

				$(Results.settings.elements.rightNav).addClass("inactive");
				$(Results.settings.elements.leftNav).addClass("inactive");

				Results.view.currentlyScrolling = true;

				// if clicked left arrow
				if( clickedButton.hasClass( Results.settings.elements.leftNav.replace(/[#\.]/g, '') ) ){

					newLeftMargin = currentLeftMargin + scrollWidth;

					if( widthAllColumns > fullWidth ){
						rightStatus = "active";
					}

					if( newLeftMargin >= 0) {
						newLeftMargin = 0;
						leftStatus = "inactive";
					}

				// if clicked right arrow
				} else {

					newLeftMargin = currentLeftMargin - scrollWidth;
					leftStatus = "active";

					if( widthAllColumns <= fullWidth ){
						newLeftMargin = 0;
						leftStatus = "inactive";
					} else if( Math.abs( newLeftMargin ) >= (widthAllColumns - fullWidth) && ( fullWidth < widthAllColumns ) ) {
						newLeftMargin = widthAllColumns * -1 + fullWidth;
						rightStatus = "inactive";
					}

				}


				target.css( "margin-left", newLeftMargin );

				Results.view.toggleScrollButtons(newLeftMargin, leftStatus, rightStatus);

			}
		}

	},

	toggleScrollButtons: function(expectedHorizontalPosition, leftStatus, rightStatus){


		var container = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );
		var currentHorizontalPosition =  Math.round(Number(container.css('margin-left').replace('px', '')));

		if(expectedHorizontalPosition != currentHorizontalPosition){
			window.setTimeout( function(){ Results.view.toggleScrollButtons(expectedHorizontalPosition,leftStatus, rightStatus) }, 100 );
		}else{

			Results.view.currentlyScrolling = false;

			if(leftStatus == null || rightStatus == null)
			{
				var viewableWidth = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.resultsOverflow ).width();
				var contentWidth = container.width(); // ? has calc yet?


				var rightStatus;
				var leftStatus;

				if( contentWidth <= viewableWidth ){
					rightStatus = "inactive";
				}else{
					if( (0-currentHorizontalPosition) + viewableWidth < contentWidth) {
						rightStatus = "active";
					}else{
						rightStatus = "inactive";
					}

				}

				if( currentHorizontalPosition >= 0) {
					leftStatus = "inactive";
				}else{
					leftStatus = "active";
				}
			}

			if ( rightStatus == "active" ){
				$(Results.settings.elements.rightNav).removeClass("inactive");
			}
			else {
				$(Results.settings.elements.rightNav).addClass("inactive");
			}

			if ( leftStatus == "active" ){
				$(Results.settings.elements.leftNav).removeClass("inactive");
			}
			else {
				$(Results.settings.elements.leftNav).addClass("inactive");
			}
		}

	},

	//Remove all results
	flush: function(){
		$(Results.settings.elements.rows).remove();
	}

};