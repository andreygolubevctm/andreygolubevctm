var ResultsView = new Object();
ResultsView = {

	rowHeight: false,
	rowWidth: false,

	orientation: 'horizontal',

	shuffleTransitionDuration: false,
	filterTransitionDuration: false,

	$containerElement: false,

	currentlyColumnWidthTracking:false,

	noResultsMode:false,

	moduleEvents: {
		RESULTS_SORTED: 'RESULTS_SORTED',
		RESULTS_TOGGLE_MODE: 'RESULTS_TOGGLE_MODE'
	},

	/* Displays the results */
	show: function() {

		try{
			// TODO REMOVE
			$.address.parameter("stage", "results", false );
		}catch(e){

		}
		// show filters bar if exists
		if( typeof(Filters) != "undefined" && $(Filters.settings.elements.filtersBar).length > 0 ){
			Results.view.toggleFilters('show');
		}

		// show compare bar if exists
		if( typeof(Compare) != "undefined" ){
			if( $(Compare.settings.elements.bar).length > 0 ){
				Results.view.toggleCompare('show');
				if(Results.settings.render.dockCompareBar === true){
					ResultsUtilities.makeElementSticky( "top", $(Compare.settings.elements.bar), "fixed-top",	$(Compare.settings.elements.bar).offset().top );
					ResultsUtilities.makeElementSticky( "top", $(Results.settings.elements.page), 	"fixedThree", 	$(Compare.settings.elements.bar).offset().top );					
				}
			}
		}

		Results.view.showResults(); // reshow elements in case the previous result had no items

		// flush potential previous results
		Results.view.flush();

		// get rid of the noResults div if it has been displayed previously
		$(Results.settings.elements.resultsContainer).find(".noResults.clone").remove();

		// parses templates and build the HTML
		Results.view.buildHtml();

		// trigger the reflow into the default display mode
		Results.view.setDisplayMode( Results.settings.displayMode, true );
		var animatedElement;
		// animate all the results one by one
		if( Results.settings.animation.results.individual.active ){
			Results.view.animateIndividualResults();
			animatedElement = $(Results.settings.elements.rows).last();
		// animate all the results as one element
		} else {
			Results.view.animateAllResults();
			animatedElement = $(Results.settings.elements.resultsContainer);
		}

		// calculate and show savings if any
		if( Results.settings.show.savings && Results.model.currentProduct && Results.model.currentProduct.product ){

			var currentFrequencyPricePath = Results.settings.paths.price[ Results.settings.frequency ];
			var currentPrice = Object.byString( Results.model.currentProduct.product, currentFrequencyPricePath );

			if( currentPrice && typeof( currentPrice ) != "undefined"){

				var topResult = Results.getTopResult();
				var topResultPrice = Object.byString( topResult , currentFrequencyPricePath );

				var savings = currentPrice - topResultPrice;
				if( typeof(Compare) != "undefined" ) Compare.setSavings( savings );
			}
		}

		// what to do when the last animation is over
		$(animatedElement).queue("fx", function(next) {
			
			// trigger the end of animated custom event
			$(Results.settings.elements.resultsContainer).trigger("resultsAnimated");
			// @todo probably should enable things that needed to wait for the animations to be over (sliders/filter?)
			// Results.view.enableStuff();
			
			next();
		});

	},

	setDisplayMode: function( mode, forceRefresh ){

		if( mode != Results.settings.displayMode || forceRefresh ){

			// remove previous display mode class and apply the new one
			$( Results.settings.elements.resultsContainer ).removeClass( Results.settings.displayMode + "Mode" );
			$( Results.settings.elements.resultsContainer ).addClass( mode + "Mode" );
			Results.settings.displayMode = mode;

			if( mode == "features" ) {
				Results.view.orientation = 'vertical';

				// orderBy("weight")

				// show all elements specific to features mode
				$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.features.allElements ).css('display', 'block');

				// set width of the results container to width of all the visible results
				Results.view.calculateResultsContainerWidth();

				// reset horizontal scrolling
				//Results.pagination.gotoStart(true);


			} else {

				// make sure to reset margin-left that might have been changed by the features display scrolling
				Results.view.$containerElement.css( "margin-left", "0px" );
				// reset width to auto
				Results.view.$containerElement.css('width', "auto");
				// hide features elements
				$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.features.allElements ).css('display', 'none');

			}

			if( mode == "price" ) {
				Results.view.orientation = 'horizontal';
				// orderBy("price") // or last orderBy selected by user
			}

			if (forceRefresh === true) {
				$( Results.settings.elements.resultsContainer ).trigger( mode + "DisplayMode" );
			}

			if(typeof meerkat !== 'undefined') {
				meerkat.messaging.publish(Results.view.moduleEvents.RESULTS_TOGGLE_MODE);
		}
		}

	},

	// set width of the results container to width of all the visible results
	calculateResultsContainerWidth: function(){
		ResultsUtilities.setContainerWidth(
			Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered",
			Results.settings.elements.resultsContainer + " " + Results.settings.elements.container
		);
	},

	setColumnWidth: function( $container, nbColumns, hasOutsideGutters ){

		if( typeof( hasOutsideGutters ) === "undefined" ){
			hasOutsideGutters = true;
		}

		var columnMargin = parseInt( $(Results.settings.elements.rows).first().css("margin-right") );

		var nbMargins = nbColumns * 2;
		if( !hasOutsideGutters ) {
			nbMargins -= 2;
		}

		var width = ( $container.width() - (nbMargins * columnMargin) ) / nbColumns ;

		$(Results.settings.elements.rows).width( width );

		if( typeof(Features) != "undefined" && Features ){
			Features.balanceVisibleRowsHeight();
		}
		// The container width, when we are swiping pagination, is ONLY inclusive of notfiltered rows.
		if(Results.settings.pagination.touchEnabled === true) {
			ResultsUtilities.setContainerWidth( $(Results.settings.elements.rows).not('.filtered'), $(Results.settings.elements.container) );
		} else {
		ResultsUtilities.setContainerWidth( $(Results.settings.elements.rows), $(Results.settings.elements.container) );
		}

		Results.pagination.reposition();

	},

	setOverflowWidthToWindowWidth: function(){
		$(Results.settings.elements.resultsOverflow).width( $(window).width() );
	},

	startColumnWidthTracking: function( $container, nbColumns, hasOutsideGutters ){

		// unbind before applying, just in case it's already been applied
		if(Results.view.currentlyColumnWidthTracking === true){
			$(window).off("resize.ResultsView.columnWidthTracking");
		}

		Results.view.currentlyColumnWidthTracking = true;

		// init the first column width calculation
		Results.view.setColumnWidth( $container, nbColumns, hasOutsideGutters );
		Results.view.setOverflowWidthToWindowWidth();

		// recalculate row heights
		if( typeof Features !== "undefined") {
			Features.balanceVisibleRowsHeight();
		}

		// start tracking the window resize and resize column accordingly
		$(window).on("resize.ResultsView.columnWidthTracking", _.debounce(function debounceColumnWidthTracking(){
			Results.view.setColumnWidth( $container, nbColumns, hasOutsideGutters );
			Results.view.setOverflowWidthToWindowWidth();
		}) );

	},

	stopColumnWidthTracking: function(){

		Results.view.currentlyColumnWidthTracking = false;

		$(window).off("resize.ResultsView.columnWidthTracking");

		_.defer( function(){
			$(Results.settings.elements.rows).width("");
			$(Results.settings.elements.resultsOverflow).width("");
			if (typeof Features !== "undefined" && Results.getDisplayMode() === 'features') {
				Features.balanceVisibleRowsHeight();
			}
			Results.pagination.resync();
		});
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
				console.log("The unavailable template could not be found: templateSelector=",Results.settings.elements.templates.unavailable,"If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.unavailable user setting when calling Results.init()");
			}
		}

		// unavailable combined template
		if (Results.settings.elements.templates.unavailableCombined) {
			var unavailableCombinedTemplate = $(Results.settings.elements.templates.unavailableCombined).html();
			if (unavailableCombinedTemplate == "") {
				console.log("The unavailable combined template could not be found: templateSelector=",Results.settings.elements.templates.unavailableCombinedTemplate, "If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.unavailableCombinedTemplate user setting when calling Results.init()");
			}
		}

		// error template
		if(Results.settings.elements.templates.error){
			var errorTemplate = $(Results.settings.elements.templates.error).html();
			if( errorTemplate == "" ){
				console.log("The error template could not be found: templateSelector=",Results.settings.elements.templates.error,"If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.error user setting when calling Results.init()");
			}
		}

		// current product template
		if(Results.settings.elements.templates.currentProduct){
			var currentProductTemplate = $(Results.settings.elements.templates.currentProduct).html();
			if( currentProductTemplate == "" ){
				console.log("The current Product template could not be found: templateSelector=",Results.settings.elements.templates.currentProduct,"If you don't want to use this template, pass 'false' to the Results.settings.elements.templates.currentProduct user setting when calling Results.init()");
			}
		}

		var topResult = Results.model.sortedProducts[0];
		var topResultRow = false;
		var countVisible = 0;
		var countUnavailable = 0;

		results = Results.model.sortedProducts;
		
		// build the HTML results
		$.each(results, function(index, result){

			var productAvailability = null;
			if( Results.settings.paths.availability.product && Results.settings.paths.availability.product != "" ){
				var productAvailability = Object.byString(result, Results.settings.paths.availability.product);
			}

			if( typeof productAvailability !== "undefined" && productAvailability !== "Y" && !unavailableTemplate ){
				countUnavailable++;
				resultRow = $( Results.view.parseTemplate("<div></div>", result) ); // fake parsed non available template
			} else if( typeof productAvailability !== "undefined" && productAvailability === "E" ) {
				countUnavailable++;
				resultRow = $( Results.view.parseTemplate(errorTemplate, result) ); // parsed error row
			} else if( typeof productAvailability !== "undefined" && productAvailability !== "Y" ) {
				countUnavailable++;
				resultRow = $( Results.view.parseTemplate(unavailableTemplate, result) ); // parsed non available row
			}else {
				if(
					Results.model.currentProduct && // current product has been set
					Results.model.currentProduct.value == Object.byString(result, Results.model.currentProduct.path) // the user's current product = the currently checked product
				){
					// current product template parsing
					resultRow = $( Results.view.parseTemplate(currentProductTemplate, result) );
				} else {
					// default row template parsing
					resultRow = $( Results.view.parseTemplate(resultTemplate, result) );
				}
			}
			// @todo = look for "< # ERROR: xxxx has no properties # >" in the returned resultRow and display it in a popup error if present

			// If the product is filtered, mark it as such.
			if( $.inArray(result, Results.model.filteredProducts ) == -1 ){
				$row = $(resultRow);
				$row.addClass("filtered");
				$row.hide();
				$row.attr("data-position", "undefined");
			} else {
				$(resultRow).addClass("notfiltered").attr("data-position", countVisible);
				countVisible++;
			}
			$(resultRow).attr("id", "result-row-" + index).attr("data-sort", index);

			// if top result, add top result markup
			if( result == topResult ){
				topResultRow = "#result-row-" + index;
			}
			resultsHtml += $(resultRow)[0].outerHTML || new XMLSerializer().serializeToString($(resultRow)[0]); // add row HTML to final HTML (second part is for older browsers not supporting outerHTML)

		});

		if (Results.settings.show.hasOwnProperty('unavailableCombined') && Results.settings.show.unavailableCombined === true && countUnavailable > 0) {
			resultRow = $( Results.view.parseTemplate(unavailableCombinedTemplate, results) );
			resultsHtml += $(resultRow)[0].outerHTML;
		}

		// fill the results table with parsed rows and trigger custom event
		$(Results.settings.elements.resultsContainer + " " + Results.settings.elements.container).append(resultsHtml);
		Results.view.setTopResult( $( topResultRow ) );

		Results.view.toggleFrequency( Results.settings.frequency );

		$(Results.settings.elements.resultsContainer).trigger("resultsLoaded");

		Results.pagination.refresh();
	},

	parseTemplate:function(template, data){
		if( Results.settings.render.templateEngine == 'microTemplate'){
			htmlString = parseTemplate(template, data);
		}else{
			htmlTemplate = _.template(template);
			htmlString = htmlTemplate(data);
		}

		return htmlString;
	},

	getRowHeight: function(){

		if( Results.view.orientation == "horizontal" && !Results.view.rowHeight ) {
			Results.view.rowHeight = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered").first().outerHeight(true);
		}

		return Results.view.rowHeight;
	},

	getRowWidth: function(){

		if( Results.view.orientation == "vertical" &&  !Results.view.rowWidth ) {
			Results.view.rowWidth = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered").first().outerWidth(true);
		}

		return Results.view.rowWidth;
	},

	setTopResult: function( element ){
		if( Results.settings.show.topResult ){
			$(Results.settings.elements.rows).find(".topResult").remove();
			$(element).prepend('<div class="topResult"></div>');
			$(Results.settings.elements.resultsContainer).trigger("topResultSet");
		}
	},

	animateIndividualResults: function(){

		var delay = Results.settings.animation.results.delay;
		var individualDelay = Results.settings.animation.results.options.duration + Results.settings.animation.results.individual.delay;

		$(Results.settings.elements.rows).each(function(){
			delay += individualDelay;
			$(this).stop(true, true).delay( delay ).show(
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
		$(Results.settings.elements.rows+'.notFiltered').show();

		$(Results.settings.elements.resultsContainer).css("opacity", 0);

		// animate the results table
		$(Results.settings.elements.resultsContainer).stop(true, true).delay( Results.settings.animation.results.delay ).animate(
				{ "opacity": 1 },
				Results.settings.animation.results.options
		);

	},

	// Reshow the results after all being filtered out.
	showResults:function(){

		if(Results.view.noResultsMode === true){
			Results.view.noResultsMode = false;
			Results.view.toggleFilters('show');
			Results.view.toggleCompare('show');
			$(Results.settings.elements.features.headers + ', ' + Results.settings.elements.resultsOverflow).show();
			$(Results.settings.elements.resultsContainer).find(".noResults.clone").remove();
		}
	},

	// Hide page elements when all results are filtered out
	showNoFilteredResults:function(){
		Results.view.noResultsMode = true;
		Results.view.toggleFilters('hide');
		Results.view.toggleCompare('hide');
		$(Results.settings.elements.features.headers + ', ' + Results.settings.elements.resultsOverflow).hide();
		$(Results.settings.elements.resultsContainer).find(".noResults.clone").remove().end()
		.append( $(Results.settings.elements.noResults).clone().addClass("clone").stop(true, true).delay(500).fadeIn(800) );
		Results.pagination.reset();
	},

	// Hide elements when no items returned by the server.
	showNoResults: function(){
		Results.view.noResultsMode = true;
		Results.view.toggleFilters('hide');
		Results.view.toggleCompare('hide');
		Results.view.flush();
		$(Results.settings.elements.features.headers).hide();
		$(Results.settings.elements.resultsOverflow).hide();
		//$(Results.settings.elements.features.list).html(''); // broke health vertical.
		$(Results.settings.elements.resultsContainer).find(".noResults.clone").remove();
		$(Results.settings.elements.resultsContainer).append( $(Results.settings.elements.noResults).clone().addClass("clone").stop(true, true).delay(500).fadeIn(800) );
		Results.pagination.reset();
	},

	shuffle: function( previousSortedResults ){
		
		// position all elements absolutely for the time of the animation
		var allRows = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows );
		if(Results.settings.animation.shuffle.active === true) {
		ResultsUtilities.position("absolute", allRows, Results.view.orientation);
		}

		// wait for the next tick so that DOM is ready
		setTimeout(function shuffleSetTimeout(){

			if( typeof(previousSortedResults) == "undefined" ){
				previousSortedResults = Results.model.returnedProducts.slice();
			}

			var currentTop = 0;
			var currentLeft = 0;
			var topResultIndex = 0;

			var rowHeight = Results.view.getRowHeight();
			var rowWidth = Results.view.getRowWidth();

			$(Results.settings.elements.resultsContainer).trigger("results.view.animation.start");
			
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

				var posDifference = sortedIndex - previousIndex;

				var shuffleOptions = false;
				if(Results.settings.animation.shuffle.active === true){
					shuffleOptions = Results.settings.animation.shuffle.options;
				}

				Results.view.moveResult( currentResult, sortedIndex, posDifference, currentTop, currentLeft, shuffleOptions );

				// get the CSS transition duration of results elements
				if( !Results.view.shuffleTransitionDuration ){
					Results.view.shuffleTransitionDuration = currentResult.transitionDuration(); // jquery plugin in common/js/results/ResultsUtilities.js
				}

				
				currentResult.attr("data-sort", sortedIndex);

				// reposition the "top result" badge to the first result
				if( currentResult.hasClass("notfiltered") ){

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
			
			var animationDuration = Results.view.shuffleTransitionDuration != 0 ? Results.view.shuffleTransitionDuration : Results.settings.animation.shuffle.options.duration + 50;

			// launch the animations (this is for jQuery animations)
			$(Results.settings.elements.rows).clearQueue( Results.settings.animation.filter.queue ).dequeue( Results.settings.animation.shuffle.options.queue );

			Results.view.afterAnimation(animationDuration , function(){
				// trigger the end of animated custom event
				$(Results.settings.elements.resultsContainer).trigger("resultsSorted");

				if (typeof meerkat !== 'undefined') {
					meerkat.messaging.publish(Results.view.moduleEvents.RESULTS_SORTED);
				}

				Results.pagination.invalidate();
				Results.pagination.refresh();

				$(Results.settings.elements.resultsContainer).trigger("results.view.animation.end");
			});


		}, 0);
	},

	filter: function(){

		Results.view.showResults(); // re-show elements just in case previous filter filtered everything out and hid all the elements.

		if(Results.settings.animation.filter.active === true) {
		Results.view.beforeAnimation();
		}

		var firstVisible = false;
		var countVisible = 0;

		var currentTop = 0;
		var currentLeft = 0;

		var countMoved = 0;
		var countFadedIn = 0;
		var countFadedOut = 0;

		var repositionAnimationOptions = false;

		if(Results.settings.animation.filter.active === true){
			repositionAnimationOptions = $.extend( Results.settings.animation.filter.reposition.options, { queue: Results.settings.animation.filter.queue } );
		}


		if(typeof Features !== 'undefined' && Features.target !== false) {

			var items = [];
			for(var i=0;i< Results.model.filteredProducts.length;i++){
				var product = Results.model.filteredProducts[i];
				var productId = Object.byString( product, Results.settings.paths.productId );
				items.push(Results.settings.elements.rows +"[data-productId=" + productId + "].filtered");
			}
			if(items.length > 0){
				$items = $( items.join(','));
				if($items.length > 0){
					$items.show();
					Features.balanceVisibleRowsHeight();
					$( Results.settings.elements.rows +'.filtered').hide();
				}
			}
		}
		$.each(Results.model.sortedProducts, function iterateSortedProducts(sortedIndex, product){

			var productId = Object.byString( product, Results.settings.paths.productId );
			var currentResult = $( Results.settings.elements.rows + "[data-productId=" + productId + "]" );
			// result has been filtered, so fades out
			if( $.inArray( product, Results.model.filteredProducts ) == -1 ){

				Results.view.fadeResultOut( currentResult, Results.settings.animation.filter.active );
				countFadedOut++;

			} else {

				// add top result sticker on the first visible row
				if(!firstVisible){
					firstVisible = true;
					Results.view.setTopResult( currentResult );
				}

				// if was not visible before, position first, then fade it in
				if( currentResult.hasClass('filtered') ) { //previously !currentResult.is(":visible")

					Results.view.fadeResultIn( currentResult, countVisible, Results.settings.animation.filter.active );
					countFadedIn++;

				// was already displayed so potentially needs to move to new position
				} else {

					var prevPosition = currentResult.attr("data-position");

					// only animate if position has changed
					if( countVisible != prevPosition){
						var posDifference = countVisible - prevPosition;
						Results.view.moveResult( currentResult, countVisible, posDifference, currentTop, currentLeft, repositionAnimationOptions );
						countMoved++;
					}

				}

				countVisible++;
				currentTop += Results.view.getRowHeight();
				currentLeft += Results.view.getRowWidth();

			}

			// get the longest CSS transition duration of results elements (between fadeIn, fadeOut and translation)
			if(Results.settings.animation.filter.active === true) {
			if( !Results.view.filterTransitionDuration || currentResult.transitionDuration() > Results.view.filterTransitionDuration ){
				Results.view.filterTransitionDuration = currentResult.transitionDuration(); // jquery plugin in common/js/results/ResultsUtilities.js
			}
			}

		});

		setTimeout(function(){
			Results.view.setDisplayMode( Results.settings.displayMode, "partial" );
		}, 0);

		if(Results.settings.animation.filter.active === true){

			// launch the animations (jquery)
			$(Results.settings.elements.rows).clearQueue( Results.settings.animation.shuffle.options.queue ).dequeue( Results.settings.animation.filter.queue );

			// determine when to trigger the end of the animations
			var animationDuration = 0;
			// no need to wait if nothing is animated
			if( countMoved == 0 && countFadedIn == 0 && countFadedOut == 0 ){
				animationDuration = 1;
			// if css transition are handled by the browsers, use the determined longest animation duration
			} else if( Results.view.filterTransitionDuration != 0 ){
				animationDuration = Results.view.filterTransitionDuration;
				animationDuration += 200;
			// if no css transitions, determine longest duration out of jquery animate option objects
			} else {

				var durations = new Array();

				if( countMoved != 0 ) 		durations.push( Results.settings.animation.filter.reposition.options.duration );
				if( countFadedIn != 0 ) 	durations.push( Results.settings.animation.filter.appear.options.duration );
				if( countFadedOut != 0 ) 	durations.push( Results.settings.animation.filter.disappear.options.duration );

				$.each( durations, function(index, duration) {
					if( duration > animationDuration ){
						animationDuration = duration;
					}
				});

				animationDuration += 50; // add 50ms security otherwise the afterAnimation() sometimes runs before animation is finished

			}
		}else{
			animationDuration = 0;
		}

		// end of animations
		Results.view.afterAnimation( animationDuration, function(){

			// trigger the end of animated custom event
			$(Results.settings.elements.resultsContainer).trigger("resultsFiltered");

			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".filtered").css("display", "none");

			Results.view.setDisplayMode( Results.settings.displayMode, "partial" );

			_.defer(function(){
				Results.pagination.invalidate();
				Results.pagination.refresh();
				$(Results.settings.elements.resultsContainer).trigger("results.view.animation.end");
			});

		});

	},

	beforeAnimation: function(){

		var allRows = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows );
		ResultsUtilities.position("absolute", allRows, Results.view.orientation);
		$(Results.settings.elements.resultsContainer).trigger("results.view.animation.start");

		Results.view.disableDuringAnimation();

	},

	afterAnimation: function( animationDuration, callback ){

		var allRows = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows );

		// once animations are finished
		setTimeout(function(){

			// reposition all elements relatively
			ResultsUtilities.position("relative", allRows);

			// reorder DOM elements in sorted order (only useful for Result.view.shuffle() but needs to happen in this order so cannot use callback)
			allRows.sort(function (a, b) {
				var sortA = parseInt( $(a).attr('data-sort'));
				var sortB = parseInt( $(b).attr('data-sort'));
				return (sortA < sortB) ? -1 : (sortA > sortB) ? 1 : 0;
			}).each(function(){
				$(this).appendTo( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );
			});

			if(animationDuration !== 0){

				// remove translate3d if using hardware acceleration
				if( Modernizr.csstransforms3d ){

					allRows
						.removeClass("transformTransition")
						.removeClass("opacityTransition")
						.addClass("noTransformTransition")
						.css( Modernizr.prefixed("transform"), '');

					setTimeout(function(){
						allRows.removeClass("noTransformTransition");
					}, 0);

				// remove CSS transitions if using them
				} else if( Modernizr.csstransitions ) {

					allRows
						.removeClass("leftTransition")
						.removeClass("topTransition")
						.removeClass("opacityTransition");

				}
			}

			Results.view.enableAfterAnimation();

			if( typeof(callback) == "function" ){
				callback();
			}

		}, animationDuration );

	},

	disableDuringAnimation: function(){

		if( typeof(Compare) != "undefined" ){
			Compare.view.toggleButton("disable");
		}

		// add any other actions that should be disabled during animation here

	},

	enableAfterAnimation: function(){

		if( typeof(Compare) != "undefined" ){
			Compare.view.toggleButton("enable");
		}

		// add any other actions that should be enabled after animation here

	},

	moveResult: function( resultElement, position, posDifference, top, left, animationOptions ){

		var currentPosition = resultElement.attr('data-position');

		if(currentPosition == position){
			// don't do anything if no move is required.
			return true;
		}

		resultElement.attr("data-position", position);
		
		
		if(animationOptions !== false){

			// if hardware acceleration enabled, use translate3d
			if( Modernizr.csstransitions ) {
				resultElement.addClass("hardwareAcceleration");

				_.defer(function(){

					if( Results.view.orientation == 'horizontal' ){
						resultElement.addClass("topTransition");
						resultElement.css("top", top);
					} else {
						resultElement.addClass("leftTransition");
						resultElement.css("left", left);
					}


				});

					_.delay(function(){
						resultElement.removeClass("hardwareAcceleration");
				},animationOptions.duration+100);

			// jquery animate
			} else {
				var animatedProperty = new Object();

				if( Results.view.orientation == 'horizontal' ){
					animatedProperty = { top: top };
				} else {
					animatedProperty = { left: left };
				}

				// setup the rows animations
				resultElement.animate(
					animatedProperty,
					animationOptions
				);

			}

			


		}else{
			if( Results.view.orientation == 'horizontal' ){
				resultElement.css("top", top);
			} else {
				resultElement.css("left", left);
			}
		}



	},

	fadeResultIn: function( resultElement, position, animate ){

		// put result in it appropriate spot before fading it in
		if( Results.view.orientation == "vertical" ){
			resultElement.css("left", position * Results.view.getRowWidth() );
		} else {
			resultElement.css("top", position * Results.view.getRowHeight() );
		}

		if(animate === true){
			
			if( Modernizr.csstransitions ){
				resultElement.addClass("hardwareAcceleration");
				resultElement.addClass("opacityTransition").css("display", "block");

				// stupid hack delay because the opacity transition does not kick in if triggered straight after the display property is changed to block
				setTimeout(function(){
					resultElement.removeClass("filtered").addClass("notfiltered");
				}, 0);

				_.delay(function(){
					resultElement.removeClass("hardwareAcceleration");
				},1000); // TODO SET TIME OUT

			} else {

				resultElement.removeClass("filtered").addClass("notfiltered");

				var options = $.extend( Results.settings.animation.filter.appear.options, { queue: Results.settings.animation.filter.queue } );
				resultElement.fadeIn( options );

			}


			

		}else{
			resultElement.removeClass("filtered").addClass("notfiltered");
			resultElement.css("display", "block");
		}

		resultElement.attr("data-position", position );
	},

	fadeResultOut: function( resultElement, animate ){

		if(animate === true){

			if( Modernizr.csstransitions ) {
				resultElement.addClass("hardwareAcceleration");
				resultElement
					.addClass("opacityTransition")
					.addClass("filtered")
					.removeClass("notfiltered");

				_.delay(function(){
					resultElement.removeClass("hardwareAcceleration");

				},1000);

			} else {
				var options = $.extend(
									Results.settings.animation.filter.disappear.options,
									{
										queue: Results.settings.animation.filter.queue,
										complete: function(){
											$(this).addClass("filtered").removeClass("notfiltered");
										}
									}
							);
				resultElement.fadeOut( options );
			}

		}else{
			resultElement.addClass("filtered").removeClass("notfiltered");
		}

		resultElement.attr("data-position", "undefined");

	},

	/* Displays the results page shell (everything but results themselves) */
	showResultsPage: function(){

		if (Results.settings.runShowResultsPage === false) {
			return;
		}

		if( !$(Results.settings.elements.page).is(":visible") ){

			$("body, html").animate({scrollTop: 0}, 500);

			Results.view.toggleReferenceNo(); // will hide the reference No

			$(Results.settings.formSelector).find(':input').removeAttr("data-visible");
			$(Results.settings.formSelector).find(':input:visible, .ui-dialog :input, .force-invisible-select :input').attr("data-visible", "true");

			if( $('#page').length > 0 ){
				$('#page').slideUp('fast', function() {
					$(Results.settings.elements.page).show();
					Results.view.toggleHeaderSize(); // will narrow the height of the header
					Results.view.toggleProgressBar(); // will hide the progress bar
					Results.view.toggleResultsSummary(); // will show the results summary
				});
			}

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

			if( $('#page').length > 0 ){
				$('#page').slideDown(300);
				$(Results.settings.elements.page).hide();
			}

			$( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container ).css("margin-left", 0);

			Results.pagination.reset();

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
		if( typeof referenceNo != 'undefined' && referenceNo.showReferenceNumber ){
			$(referenceNo.elements.root).slideToggle(200);
		}
	},

	toggleCompare: function( action ){
		if( typeof(Compare) != "undefined" ){
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



	toggleFrequency: function( frequency ){

		try{
			// hide all frenquency based info
			$(Results.settings.elements.frequency).hide();
			// show info only about newly selected frequency
			$("." +frequency + Results.settings.elements.frequency).show();
		}catch(e){
			Results.onError('Sorry, an error occurred toggling frequencies', 'ResultsView.js', 'Results.view.toggleFrequency(); '+e.message, e);
		}

	},

	//Remove all results
	flush: function(){
		$(Results.settings.elements.rows).remove();		
	}

};