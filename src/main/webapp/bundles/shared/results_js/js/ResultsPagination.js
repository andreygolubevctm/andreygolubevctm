var ResultsPagination = {

	NEXT:"next",
	PREVIOUS:"previous",
    hasPinnedProduct: false,
	$pagesContainer:null,
	$nextButton:null,
	$previousButton:null,
	$pageText: null, //elements to contain text like 'Page 3 of 12'
    $summary: null,

    $floatedNextButton: null,
    $floatedPreviousButton: null,

	invalidated:true,
	currentPageNumber:null,
	currentPageMeasurements:null,

	scrollMode:null,
	previousScrollPosition:0,

	isLocked: false,
	isHidden: false,
	isTouching: false,
	isScrolling: false,

	touchendSnapTimeout: false,
	scrollCheckTimeout: false,

	paginationSummaryTemplate: null,
	showPaginationSummary: false,

	init: function(){

		$(document).on('click', '[data-results-pagination-control]', function paginationControlClick(event){
			Results.pagination.controlListener( event );
		});

		Results.pagination.$pagesContainer = $('[data-results-pagination-pages-cell]');
		Results.pagination.$nextButton = $('[data-results-pagination-control="next"]');
		Results.pagination.$previousButton = $('[data-results-pagination-control="previous"]');
		Results.pagination.$pageText = $('[data-results-pagination-pagetext="true"]').removeClass('hidden');
        Results.pagination.$floatedNextButton = $('.results-pagination.floated-next-arrow');
        Results.pagination.$floatedPreviousButton = $('.results-pagination.floated-previous-arrow');

		Results.pagination.setScrollMode();

		if (typeof meerkat !== 'undefined') {
			meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function paginationBreakPointChange(event){
				// Don't bother doing pagination if we're on XS breakpoint
				// @todo this could work if we fixed the css top calculations
				if (event.state === 'xs') return;

				Results.pagination.resync();
			});
		}
	},

	resync: function(){
		// Don't continue if the pagination is hidden
		if (Results.pagination.isHidden === true) return false;

		Results.pagination.invalidate();
		Results.pagination.gotoPage(Results.pagination.getCurrentPageNumber(), true, true);
		Results.pagination.refresh();
	},

	reposition:function(){
		Results.pagination.gotoPage(Results.pagination.getCurrentPageNumber(), false, true);
	},

	// quick helpers
	isSlideMode:function(){
		return Results.settings.pagination.mode === 'slide';
	},

	isPageMode:function(){
		return Results.settings.pagination.mode === 'page';
	},

	getCurrentHorizontalPosition:function(){
		return ResultsUtilities.getScroll( 'x', Results.view.$containerElement );
	},

	// Call this on breakpoint change.
	invalidate:function(){
		Results.pagination.isLocked = false;
		Results.pagination.invalidated = true;
		Results.pagination.currentPageMeasurements = null;
		Results.pagination.isHidden = false;
	},

	// Reset - called when results are reloaded.
	reset:function(){
		Results.pagination.invalidate();

		Results.pagination.deactivateButton(this.$nextButton);
		Results.pagination.deactivateButton(this.$previousButton);
		Results.pagination.$pageText.empty();

		if(Results.pagination.isSlideMode()){

		}else if(Results.pagination.isPageMode()){
			Results.pagination.empty(Results.pagination.$pagesContainer);
		}

	},

	// Refresh the active page display and enable/disable the next/prev buttons
	refresh:function(){
		// Don't continue if the pagination is hidden
		if (Results.pagination.isHidden === true) return;

		if(Results.pagination.isPageMode()){

			var pageMeasurements = Results.pagination.getPageMeasurements(),
			htmlString;
			if(pageMeasurements === null) return false;


			if(Results.pagination.invalidated === true){

				// Rebuild pages list.
				Results.pagination.invalidated = false;

				var pageItemTemplate = _.template(Results.settings.templates.pagination.pageItem);
				var pageUpDownTemplate = _.template(Results.settings.templates.pagination.page);

                paginationSummaryTemplate = null;
                showPaginationSummary = false;

                if((!_.isEmpty(Results.settings.templates.pagination.summary)) && Results.settings.templates.pagination.summary)  {
                    paginationSummaryTemplate = _.template(Results.settings.templates.pagination.summary);
                    showPaginationSummary = true;
                }

				Results.pagination.empty(Results.pagination.$pagesContainer);

                Results.pagination.$floatedNextButton.addClass('hidden');
                Results.pagination.$floatedPreviousButton.addClass('hidden');

				if (pageMeasurements.numberOfPages > 1 && pageMeasurements.numberOfPages != Number.POSITIVE_INFINITY) {
                    Results.pagination.$floatedNextButton.removeClass('hidden');
                    Results.pagination.$floatedPreviousButton.removeClass('hidden');

					for (var i=0; i<pageMeasurements.numberOfPages; i++) {
						// Previous Button
						if(i === 0) {
							htmlString = pageUpDownTemplate({type:'previous', icon:'left'});
							Results.pagination.$pagesContainer.append(htmlString);
						}
						// Page Numbers
						var num = i+1;
						htmlString = pageItemTemplate({pageNumber: num, label: num});
						Results.pagination.$pagesContainer.append(htmlString);
						
                        if(showPaginationSummary) {
                            htmlString = $(htmlString).addClass('hidden-xs hidden-sm');
                        }

						// Next Button
						if(num >= pageMeasurements.numberOfPages) {
							htmlString = pageUpDownTemplate({type:'next', icon:'right'});
							Results.pagination.$pagesContainer.append(htmlString);
						}
					}
					// We need update this list so that buttons not a load time are included
					Results.pagination.$nextButton = $('[data-results-pagination-control="next"]');
					Results.pagination.$previousButton = $('[data-results-pagination-control="previous"]');
				}

			}

			/* fix issue where clearing the products on the last page doesn't automatically scroll left */
            _.defer(function(){
                if ((pageMeasurements.numberOfPages * pageMeasurements.columnsPerPage) === pageMeasurements.numberOfColumns && Results.pagination.$pagesContainer.find('a.active').length === 0) {
                    Results.pagination.$previousButton.trigger('click');
                }
            });

			//
			if (Results.pagination.$pageText !== null && Results.pagination.$pageText.length > 0) {
				var pageTextTemplate = _.template(Results.settings.templates.pagination.pageText);
				htmlString = pageTextTemplate({
					currentPage: Results.pagination.getCurrentPageNumber(),
					totalPages: pageMeasurements.numberOfPages,
					availableCounts: Results.model.availableCounts
				});
				Results.pagination.$pageText.html(htmlString);
			}

			// Update active state on pages list
			var pageNumber = Results.pagination.getCurrentPageNumber();
			$('[data-results-pagination-control].active').removeClass("active");
			$('[data-results-pagination-control="'+pageNumber+'"]').addClass("active");

			Results.pagination.addCurrentPageClasses(pageNumber, pageMeasurements);

			// Update state on prev/next buttons
			if(Results.pagination.getCurrentPageNumber() == 1){
				Results.pagination.deactivateButton(this.$previousButton);
			}else{
				Results.pagination.activateButton(this.$previousButton);
			}

			if(Results.pagination.getCurrentPageNumber() === pageMeasurements.numberOfPages){
				Results.pagination.deactivateButton(this.$nextButton);
			}else{
				Results.pagination.activateButton(this.$nextButton);
			}

			if(showPaginationSummary) {
				var summaryData = Results.pagination.getPaginationSummary();
				htmlString = paginationSummaryTemplate(summaryData);
				_.defer(function(){
                    Results.pagination.$pagesContainer.find('.summary').remove();
					$(htmlString).insertAfter(Results.pagination.$pagesContainer.find('[data-results-pagination-control="previous"]').closest("li"));
				});
			}

			// Done
			if (typeof Results.settings.pagination.afterPaginationRefreshFunction === 'function') {
				Results.settings.pagination.afterPaginationRefreshFunction(Results.pagination.$pagesContainer);
			}

			if (Results.settings.balanceCurrentPageRowsHeightOnly.mobile && meerkat.modules.deviceMediaState.get() === 'xs') {
				_.defer(function() {
					Features.clearAndBalanceRowsHeight();
				});
			}

		}else{
			Results.pagination.toggleScrollButtons(Results.pagination.previousScrollPosition);
		}

	},

	controlListener:function(event){

		if(Results.pagination.isSlideMode()){
			Results.pagination.scrollResults( $(event.currentTarget) );
		}else if(Results.pagination.isPageMode()){
			Results.pagination.gotoPage($(event.currentTarget).attr('data-results-pagination-control') );
		}

	},

	empty: function($container) {
		if (typeof Results.settings.pagination.emptyContainerFunction === 'function') {
			Results.settings.pagination.emptyContainerFunction($container);
		}
		else {
			$container.empty();
		}
	},

	gotoPage:function(pageNumber, reset, forceReposition){
		if(Results.pagination.isLocked) return false;

		if(reset !== true) reset = false;
		if(forceReposition !== true) forceReposition = false;

		if(pageNumber === ResultsPagination.NEXT){
			pageNumber = Results.pagination.getCurrentPageNumber()+1;
		}else if(pageNumber === ResultsPagination.PREVIOUS){
			pageNumber = ResultsPagination.getCurrentPageNumber() -1;
		}

		if(isNaN(pageNumber) === true) return false;

		if(pageNumber < 1) pageNumber = 1;

		pageNumber = Number(pageNumber);

		var info = Results.pagination.getPageMeasurements();
		var scrollPosition = 0;
		if(pageNumber !== 1 && info !== null){
			var pageWidth = info.pageWidth;
			if(pageNumber > info.numberOfPages) pageNumber = info.numberOfPages;
			var pageNumberMultiplier = pageNumber-1;
			scrollPosition = 0-pageWidth * pageNumberMultiplier;
		}

		var previousPageNumber = Results.pagination.getCurrentPageNumber();

		if(pageNumber === previousPageNumber && forceReposition === false){
			// do nothing...
			return false;
		}

		Results.pagination.setCurrentPageNumber(pageNumber);
		Results.pagination.removeCurrentPageClasses();

		if(reset || forceReposition){
			Results.pagination.scroll(scrollPosition);
		}else{
			Results.pagination.animateScroll(scrollPosition);
		}
		// sometimes it inits too soon and doesn't have this.
        var currentStep = meerkat.modules.journeyEngine.getCurrentStep();
		if(currentStep && currentStep.navigationId === 'results'
		&& pageNumber !== previousPageNumber) {
			var event = jQuery.Event("resultPageChange");
			event.pageData = {
				pageNumber: pageNumber,
				measurements: info
			};
			$(Results.settings.elements.resultsContainer).trigger(event);
		}

	},

	gotoPosition:function(positionNumber, reset, forceReposition){
		if(Results.pagination.isLocked) return false;
		var info = Results.pagination.getPageMeasurements();
		var pageNumber = Math.ceil(positionNumber / info.columnsPerPage);
		Results.pagination.gotoPage(pageNumber, reset, forceReposition);
	},

	getCurrentPageNumber:function(){
		if(Results.pagination.currentPageNumber === null ){
			// Either the cached object doesn't exist of column width tracking is enabled. => Recalculate the measurements each time.
			return Results.pagination.calculateCurrentPageNumber();
		}
		return Results.pagination.currentPageNumber;
	},

	setCurrentPageNumber:function(pageNumber){
		Results.pagination.currentPageNumber = pageNumber;
	},

	// Calculates current page number based on current positions of elements
	calculateCurrentPageNumber:function(){
		var pageMeasurements = Results.pagination.getPageMeasurements();
		if(pageMeasurements === null) return false;
		var pageWidth = pageMeasurements.pageWidth;
		var currentHorizontalPosition = 0-Results.pagination.getCurrentHorizontalPosition();
		var pageNumber = Math.round(currentHorizontalPosition / pageWidth) + 1;
		return pageNumber;
	},

	getPageMeasurements:function(){

		if(Results.pagination.currentPageMeasurements === null || Results.view.currentlyColumnWidthTracking === true){
			// Either the cached object doesn't exist of column width tracking is enabled. => Recalculate the measurements each time.
			return Results.pagination.calculatePageMeasurements();
		}

		return Results.pagination.currentPageMeasurements;
	},

	// These values can not be cached as they change when the breakpoint changes.
	calculatePageMeasurements:function(){
		var $container = Results.view.$containerElement;
		var viewableArea = $container.parent().width();
		var $rows = $container.find(Results.settings.elements.rows+'.notfiltered');
		if($rows.length === 0) {
			return null; // called too early.
		}
		var numberOfColumns = $rows.length;
		// As the column widths are defined in the LESS let's save time interrogating the DOM
		// objects and simply check the applicable class defined in the .resultsContainer
		var columnWidth = 0;
		var columnsPerPage = 0;
		var mediaState = typeof meerkat != 'undefined' ? meerkat.modules.deviceMediaState.get().toLowerCase() : false;
		if (mediaState !== false && mediaState !== "xs" && Results.pagination.hasLessDrivenColumns(mediaState)) {

			columnsPerPage = Results.pagination.getColumnCountFromContainer(mediaState);
			columnWidth = Math.round((viewableArea / columnsPerPage) * 100) / 100;
		} else {
            /**
			 * Only used on XS.
			 * Pagination deteremines how wide a column is, separately to its actual width in ResultsView on XS.
			 * Why is this?
			 * Because it needs to account for the margin and padding, whereas the .result-row css width property
			 * sets the innerWidth and thus excludes those properties from its width.
             */
			columnWidth = Results.settings.pagination.useSubPixelWidths ? Results.pagination.getSubPixelWidth($rows) : $rows.outerWidth(true);
			viewableArea += Results.settings.pagination.margin;
			columnsPerPage = Math.round(viewableArea/columnWidth);
		}

		var pageWidth = columnWidth * columnsPerPage;

		// we reduce the number of columns per page JUST here, after other calculations
        if(Results.pagination.hasPinnedProduct) {
            columnsPerPage -= 1;
		}
		var obj = {
			pageWidth: pageWidth,
			columnWidth: columnWidth,
			columnsPerPage:columnsPerPage,
			numberOfColumns:numberOfColumns,
			numberOfPages: Math.ceil(numberOfColumns/columnsPerPage)
		};

		Results.pagination.currentPageMeasurements = obj;
		return obj;
	},
	/**
	 * jQuery outerWidth/width/.css('width') doesn't support subpixel widths.
	 * @param $el
	 * @returns {*}
     */
	getSubPixelWidth: function($el) {
		if($el[0] && _.isFunction($el[0].getBoundingClientRect)) {
			var rects = $el[0].getBoundingClientRect();
			if(rects.width) {
				// @IMPORTANT: Make sure this is set in verticalResults.js files to whatever is specified in the stylesheet!
				return rects.width + Results.settings.pagination.margin;
			}
		}
		// fallback
		return $el.outerWidth(true);
	},
	hasLessDrivenColumns: function(mediaState) {
		return $('.resultsContainer[class*="results-columns-' + mediaState + '-"]').length > 0;
	},

	getColumnCountFromContainer: function(mediaState) {
		var noColumns = 0;
		var $container = $('.resultsContainer');
		if($container.length) {
			var classes = $container[0].className.split(" ");
			for(var i=0; i<classes.length; i++) {
				if(!_.isEmpty(classes[i]) && classes[i].indexOf("results-columns-" + mediaState + "-") === 0) {
					noColumns = Number(classes[i].replace( /^\D+/g, ''));
				}
			}
		}
		return noColumns;
	},

	getPaginationSummary: function(){
		var pageMeasurements = Results.pagination.getPageMeasurements();
		var totalProducts = Results.model.availableCounts;
		var rangeStart = (pageMeasurements.columnsPerPage * Results.pagination.getCurrentPageNumber()) - (pageMeasurements.columnsPerPage - 1);
		var rangeEnd = pageMeasurements.columnsPerPage * Results.pagination.getCurrentPageNumber();
		if(rangeEnd > totalProducts) {
			rangeEnd = totalProducts;
		}
		return {rangeStart: rangeStart, rangeEnd: rangeEnd, totalProducts:totalProducts};
	},

	gotoStart: function(invalidate){

		if(invalidate){
			Results.pagination.invalidate();
		}

		if(Results.pagination.isSlideMode()){

			var newScroll = 0;
			Results.pagination.animateScroll( newScroll );


		}else if(Results.pagination.isPageMode()){
			Results.pagination.gotoPage(1);
			if(invalidate){
				Results.pagination.refresh();
			}

		}
	},

	setScrollMode: function(){

		var isIos6 = false;
		if(typeof meerkat != 'undefined'){
			isIos6= meerkat.modules.performanceProfiling.isIos6(); // Hardware acceleration causes a 'flickering' bug on ios6 and is therefore disabled.
		}

		//isIos6 = true; // helps with testing.
		// If we have enabled native scrolling pagination
		if (Results.settings.pagination.touchEnabled === true) {
			Results.pagination.scrollMode = "scrollto";
		} else if( Modernizr.csstransforms3d && isIos6 === false){
			Results.pagination.scrollMode = "csstransforms3d";
		} else if(Modernizr.csstransitions) {
			Results.pagination.scrollMode = "csstransitions";
		} else {
			Results.pagination.scrollMode = "jquery";
		}

	},

	animateScroll: function( newScroll ){

		if(newScroll === Results.pagination.previousScrollPosition){
			_.defer(function(){
				Results.pagination.refresh();
			});
			return false;
		}

		if(Results.settings.animation.features.scroll.active === false){
			Results.pagination.scroll(newScroll);
			Results.pagination._afterPaginationMotion(false);
			return;
		}

		Results.pagination.lock();

		$(Results.settings.elements.resultsContainer).trigger("pagination.scrolling.start");
		$(Results.settings.elements.resultsOverflow).removeClass('notScrolling').addClass('isScrolling');

		switch(Results.pagination.scrollMode){
			case "scrollto":
				var rowEq = (Results.pagination.getCurrentPageNumber() - 1) * Results.pagination.currentPageMeasurements.columnsPerPage;
				$(Results.settings.elements.resultsOverflow).scrollTo($(Results.settings.elements.rows).not(".filtered").eq(rowEq), 500, {
					onAfter: function () {
						Results.pagination._afterPaginationMotion(true);
					}
				});
			break;
			/* CSS TRANSLATE/TRANSFORM3D */
			case "csstransforms3d":
				var css = {
					marginLeft:0
				};
				css[Modernizr.prefixed("transform")] = 'translate3d(' +ResultsPagination.previousScrollPosition + 'px,0,0)';

				Results.view.$containerElement.css(css);

				_.delay(function(){

					Results.view.$containerElement.addClass("resultsTransformTransition");
					Results.view.$containerElement.css( Modernizr.prefixed("transform"), 'translate3d(' + newScroll + 'px,0,0)');

					_.delay(function(){
						Results.view.$containerElement.removeClass("resultsTransformTransition");
						var css = {
							marginLeft:newScroll+'px'
						};
						css[Modernizr.prefixed("transform")] = '';
						Results.view.$containerElement.css(css);

						Results.pagination._afterPaginationMotion(true);

					}, Results.view.$containerElement.transitionDuration()+10);

				},25);
				break;


			/* CSS TRANSITIONS */
			case "csstransitions":
				if( !Results.view.$containerElement.hasClass("resultsTableLeftMarginTransition")){
					Results.view.$containerElement.addClass("resultsTableLeftMarginTransition");
				}

				_.defer(function(){

					var duration = Results.view.$containerElement.transitionDuration();
					Results.view.$containerElement.css("margin-left", newScroll);

					_.delay(function(){
						Results.pagination._afterPaginationMotion(true);
						Results.view.$containerElement.removeClass("resultsTableLeftMarginTransition");
					},duration);

				});
				break;


			/* JQUERY */
			default:
				var duration = Results.settings.animation.features.scroll.duration;
				Results.view.$containerElement.animate( { "margin-left": newScroll }, duration, function(){
					Results.pagination._afterPaginationMotion(true);
				});
				break;

		}

		ResultsPagination.previousScrollPosition = newScroll;


	},

	_afterPaginationMotion:function(wasAnimated){

		Results.pagination.unlock();
		Results.pagination.refresh();

		if(wasAnimated){
			$(Results.settings.elements.resultsOverflow).addClass('notScrolling').removeClass('isScrolling');
			$(Results.settings.elements.resultsContainer).trigger("pagination.scrolling.end");
		}
	},

	scroll:function(scrollPosition){

		ResultsPagination.previousScrollPosition = scrollPosition;

		var recalc = function(){
			Results.pagination.currentPageMeasurements = Results.pagination.calculatePageMeasurements();
			$(Results.settings.elements.resultsContainer).trigger(" pagination.instantScroll");
		};

		if(
			Results.settings.pagination.touchEnabled === true &&
			!_.isNull(Results.pagination.currentPageMeasurements) &&
			Results.pagination.currentPageMeasurements.hasOwnProperty('pageWidth')
		) {
			// Calculate the animation speed
			var baseDuration = 150;
			var width = Results.pagination.currentPageMeasurements.pageWidth;
			var start = $(Results.settings.elements.resultsOverflow).scrollLeft();
			var finish = Math.abs(scrollPosition);
			var gap = Math.abs(start - finish);
			var duration = Math.floor((gap/width) * baseDuration);
			var maxScroll = width * (Results.pagination.currentPageMeasurements.numberOfColumns - 1);
			if(start > 0 || start < maxScroll) {
				$(Results.settings.elements.resultsOverflow).stop(true, true).animate({scrollLeft: Math.abs(scrollPosition)}, {
					duration: duration,
					step: function() {
						// Allow the animation to stop itself
						if(Results.pagination.isTouching === true || Results.pagination.isScrolling === true) {
							$(Results.settings.elements.resultsOverflow).stop(true, true);
						}
					},
					complete: function() {
						_.defer(recalc);
					}
				});
		} else {
				_.defer(recalc);
			}
		} else {
			Results.view.$containerElement.css("margin-left", scrollPosition);
			recalc();
		}
	},

	scrollResults: function( clickedButton ){

		if (clickedButton.hasClass("inactive") || Results.pagination.isLocked !== false) {
			return;
		}
		//Only run if its not currently sliding

		Results.pagination.lock();

		var fullWidth = Results.view.$containerElement.parent().width();
		var $row = $(Results.settings.elements.resultsOverflow + " " + Results.settings.elements.rows).first();
		var widthAllColumns = (Results.settings.pagination.useSubPixelWidths ? Results.pagination.getSubPixelWidth($row) : $row.outerWidth(true)) * $(Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered").length;
		var scrollWidth = fullWidth * Results.settings.animation.features.scroll.percentage;
		var currentScroll = ResultsUtilities.getScroll('x', Results.view.$containerElement);
		var newScroll;
		if (clickedButton.attr('data-results-pagination-control') == 'previous') {

			newScroll = currentScroll + scrollWidth;

			if (newScroll >= 0) {
				newScroll = 0;
			}

		} else {

			newScroll = currentScroll - scrollWidth;

			if (widthAllColumns <= fullWidth) {
				newScroll = 0;
			} else if (Math.abs(newScroll) >= (widthAllColumns - fullWidth) && ( fullWidth < widthAllColumns )) {
				newScroll = widthAllColumns * -1 + fullWidth;
			}

		}

		Results.pagination.animateScroll(newScroll);


	},

	toggleScrollButtons: function(expectedHorizontalPosition){

		var container = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );
		var currentHorizontalPosition =  ResultsUtilities.getScroll( 'x', Results.view.$containerElement );

		if(expectedHorizontalPosition != currentHorizontalPosition){
			window.setTimeout( function(){
				Results.pagination.toggleScrollButtons(expectedHorizontalPosition,leftStatus, rightStatus);
			}, 100 );
		}else{

			var viewableWidth = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.resultsOverflow ).width();
			var contentWidth = container.width();

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


			if ( rightStatus == "active" ){
				Results.pagination.activateButton(this.$nextButton);
			}
			else {
				Results.pagination.deactivateButton(this.$nextButton);
			}

			if ( leftStatus == "active" ){
				Results.pagination.activateButton(this.$previousButton);
			}
			else {
				Results.pagination.deactivateButton(this.$previousButton);
			}

		}

	},

	deactivateButton: function($button) {
		$button.addClass('inactive').parent().addClass('inactive');
	},
	activateButton: function($button) {
		$button.removeClass('inactive').parent().removeClass('inactive');
	},
	lock:function(){
		Results.pagination.isLocked = true;
		Results.pagination.deactivateButton(this.$nextButton);
		Results.pagination.deactivateButton(this.$previousButton);
		Results.pagination.$pagesContainer.find("a").addClass("inactive");
	},

	unlock:function(){
		Results.pagination.isLocked = false;
		Results.pagination.$pagesContainer.find("a").removeClass("inactive");
	},

	// Hide the pagination and make it inactive
	hide: function() {
		Results.pagination.isHidden = true;
		Results.pagination.$pagesContainer.addClass('hidden');
		Results.pagination.$nextButton.addClass('hidden');
		Results.pagination.$previousButton.addClass('hidden');
		Results.pagination.$pageText.addClass('hidden');
	},

	// Show the pagination and make it active
	// @param performResync Boolean
	show: function(performResync) {
		Results.pagination.isHidden = false;
		Results.pagination.$pagesContainer.removeClass('hidden');
		Results.pagination.$nextButton.removeClass('hidden');
		Results.pagination.$previousButton.removeClass('hidden');
		Results.pagination.$pageText.removeClass('hidden');

		if (performResync === true) {
			Results.pagination.resync();
		}
	},

	addCurrentPageClasses:function(pageNumber, pageMeasurements){

		Results.pagination.removeCurrentPageClasses();

		// Something is broken (probably on price mode); don't run the function
		if (isNaN(pageMeasurements.columnsPerPage)) return;

		var startVar = (pageNumber-1)*pageMeasurements.columnsPerPage;
		var endVar = pageNumber*pageMeasurements.columnsPerPage;

		var looking = true;
		var i = startVar;
		var columnsFound = 0;
		while(looking){

			var columnNumber = i;
			if($("[data-position='"+columnNumber+"']").hasClass('notfiltered')){
				$("[data-position='"+columnNumber+"']").addClass("currentPage");
				columnsFound++;
			}
			i++;

			if(columnsFound === pageMeasurements.columnsPerPage || i === Results.getReturnedResults().length || i > 1000){
				looking = false;
			}
		}

	},

	removeCurrentPageClasses:function(){
		$(Results.settings.elements.resultsOverflow + ' ' + Results.settings.elements.rows+".currentPage").removeClass("currentPage");
	},

	setupNativeScroll: function() {
		// Only if this setting is true.
		if(Results.settings.pagination.touchEnabled !== true) {
			return;
		}

		var $featuresModeContainer = $(Results.settings.elements.resultsContainer + '.featuresMode');

		// Get the length of the visible rows ('filtered' means its display: none, needs to be excluded from count)
		var columnsLength = Results.getFilteredResults().length;

		// If there are any "result_unavailable_combined" rows (there will only be 1) add it to the length
		if($featuresModeContainer.find('.result-row.result_unavailable_combined').length) {
			columnsLength++;
		}

        var pageMeasurements = Results.pagination.getPageMeasurements();
        if(pageMeasurements === null) return false;
		// Determine and set the new width of the results-table based on pageWidth * number of pages.
		var numPages = Math.ceil(columnsLength / pageMeasurements.columnsPerPage);
		var newWidth = pageMeasurements.pageWidth * numPages;
		$(Results.settings.elements.container, $featuresModeContainer).width(newWidth);

		// Setup scroll/touch events on the results overflow
		$(Results.settings.elements.resultsOverflow).off('scroll.results').on("scroll.results", Results.pagination.nativePaginationOnScroll);
		if(Results.settings.pagination.touchEnabled) {
			$(Results.settings.elements.resultsOverflow, $featuresModeContainer).off('touchstart.results').on('touchstart.results', function() {
				Results.pagination.isTouching = true;
				Results.pagination.cancelExistingSnapTo();
			}).off('touchend.results').on('touchend.results', function() {
				Results.pagination.isTouching = false;
				Results.pagination.isScrolling = false;
				Results.pagination.cancelExistingSnapTo();
				setTimeout(function() {
					if(Results.pagination.isScrolling === false){
						Results.pagination.nativeScrollSnapTo();
					}
				}, 250);
			});
		}

	},

	nativePaginationOnScroll: _.debounce(function(event) {

		// If it's currently locked, do nothing
		if(Results.pagination.isLocked) {
			return;
		}

		Results.pagination.isScrolling = true;

		// Get the scrollLeft position, plus 1/3 of the width of the first visible row
		var divisor = 3;
		var widthToDivide = Results.pagination.currentPageMeasurements.pageWidth;
		var experiencePadding = Math.floor(widthToDivide / divisor);
		var pxFromLeft = $(event.target).scrollLeft() + experiencePadding;

		// The page number we've swiped into is:
		var pageNumber = Math.floor(pxFromLeft / Results.pagination.currentPageMeasurements.pageWidth) + 1;
		var isMidPage = $(event.target).scrollLeft() % Results.pagination.currentPageMeasurements.pageWidth !== 0;
		var isNewPage = Results.pagination.getCurrentPageNumber() != pageNumber;

		// If we're not swiping to the same page, and it's not trying to scroll higher than the number of pages:
		if((isNewPage === true || isMidPage === true) && pageNumber <= Results.pagination.currentPageMeasurements.numberOfPages) {

			Results.pagination.invalidate();
			// Sets it to the object.
			Results.pagination.setCurrentPageNumber(pageNumber);
			// To refresh the page count at the top
			Results.pagination.refresh();
			// This is used to snap to the nearest page.
			if(meerkat.modules.deviceMediaState.get() == 'xs' && Results.pagination.isTouching === false && isNewPage === true) {
				Results.pagination.isScrolling = false;
				Results.pagination.nativeScrollSnapTo();
			}

			// Trigger the event that would happen with a page change? @todo: Is this necessary?
			var eventData = $.Event( "resultPageChange" );
			eventData.pageData =  {
				pageNumber: pageNumber,
				measurements:Results.pagination.getPageMeasurements()
			};
			$(Results.settings.elements.resultsContainer).trigger(eventData);

		}
	}, 25),

	nativeScrollSnapTo : function(){
		Results.pagination.cancelExistingSnapTo();
		Results.pagination.touchendSnapTimeout = setTimeout(function() {
			if(Results.pagination.isTouching === false && Results.pagination.isScrolling === false) {
				var pNum = Results.pagination.currentPageNumber;
				var pWidth = Results.pagination.currentPageMeasurements.pageWidth;
				Results.pagination.scroll(pWidth * (pNum-1));
			}
		}, 750);
	},

	cancelExistingSnapTo : function(){
		$(Results.settings.elements.resultsOverflow).stop(true, true);
		clearTimeout(Results.pagination.touchendSnapTimeout);
	}
};