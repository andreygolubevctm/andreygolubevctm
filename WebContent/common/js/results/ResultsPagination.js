var ResultsPagination = new Object();
ResultsPagination = {

	NEXT:"next",
	PREVIOUS:"previous",

	$pagesContainer:null,
	$nextButton:null,
	$previousButton:null,
	$pageText: null, //elements to contain text like 'Page 3 of 12'

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

	init: function(){

		$(document).on('click', '[data-results-pagination-control]', function paginationControlClick(event){
			Results.pagination.controlListener( event );
		});

		Results.pagination.$pagesContainer = $('[data-results-pagination-pages-cell]');
		Results.pagination.$nextButton = $('[data-results-pagination-control="next"]');
		Results.pagination.$previousButton = $('[data-results-pagination-control="previous"]');
		Results.pagination.$pageText = $('[data-results-pagination-pagetext="true"]').removeClass('hidden');

		Results.pagination.setScrollMode();

		if (typeof meerkat !== 'undefined') {
			meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function paginationBreakPointChange(event){
				// Don't bother doing pagination if we're on XS breakpoint
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

		Results.pagination.$nextButton.addClass("inactive");
		Results.pagination.$previousButton.addClass("inactive");
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

			var pageMeasurements = Results.pagination.getPageMeasurements();
			if(pageMeasurements === null) return false;


			if(Results.pagination.invalidated === true){

				// Rebuild pages list.
				Results.pagination.invalidated = false;

				var pageItemTemplate = _.template(Results.settings.templates.pagination.pageItem);

				Results.pagination.empty(Results.pagination.$pagesContainer);

				if (pageMeasurements.numberOfPages > 1 && pageMeasurements.numberOfPages != Number.POSITIVE_INFINITY) {
					for (var i=0; i<pageMeasurements.numberOfPages; i++) {
						var num = i+1;
						var htmlString = pageItemTemplate({pageNumber:num, label:num});
						Results.pagination.$pagesContainer.append(htmlString);
					}
				}

			}

			//
			if (Results.pagination.$pageText != null && Results.pagination.$pageText.length > 0) {
				var pageTextTemplate = _.template(Results.settings.templates.pagination.pageText);
				var htmlString = pageTextTemplate({
					currentPage: Results.pagination.getCurrentPageNumber(),
					totalPages: pageMeasurements.numberOfPages
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
				Results.pagination.$previousButton.addClass("inactive");
			}else{
				Results.pagination.$previousButton.removeClass("inactive");
			}

			if(Results.pagination.getCurrentPageNumber() === pageMeasurements.numberOfPages){
				Results.pagination.$nextButton.addClass("inactive");
			}else{
				Results.pagination.$nextButton.removeClass("inactive");
			}

			// Done
			if (typeof Results.settings.pagination.afterPaginationRefreshFunction === 'function') {
				Results.settings.pagination.afterPaginationRefreshFunction(Results.pagination.$pagesContainer);
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
		if(pageNumber !== 1){
			var pageWidth = info.pageWidth;
			if(pageNumber > info.numberOfPages) pageNumber = info.numberOfPages;
			var pageNumberMultiplier = pageNumber-1;
			scrollPosition = 0-pageWidth * pageNumberMultiplier;
		}

		var previousPageNumber = Results.pagination.getCurrentPageNumber();

		if(pageNumber === previousPageNumber && forceReposition == false){
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

		var event = jQuery.Event( "resultPageChange" );
		event.pageData =  {
			pageNumber: pageNumber,
			measurements:info
		};
		$(Results.settings.elements.resultsContainer).trigger(event);

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

		var viewableArea = Results.view.$containerElement.parent().width();
		var $rows = Results.view.$containerElement.find(Results.settings.elements.rows+'.notfiltered');
		if($rows.length == 0 ) return null; // called too early.
		var numberOfColumns = $rows.length;
		var columnWidth =  $rows.outerWidth(true);
		var columnsPerPage = Math.round(viewableArea/columnWidth);
		var pageWidth = columnWidth*columnsPerPage;

		var obj = {
			pageWidth: pageWidth,
			columnsPerPage:columnsPerPage,
			numberOfColumns:numberOfColumns,
			numberOfPages: Math.ceil((numberOfColumns*columnWidth) / (pageWidth))
		}

		Results.pagination.currentPageMeasurements = obj;
		return obj;
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
		} else if( Modernizr.csstransforms3d && isIos6 == false){
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
		}else{

			Results.pagination.lock();

			$(Results.settings.elements.resultsContainer).trigger("pagination.scrolling.start");

			switch(Results.pagination.scrollMode){
				case "scrollto":
					var rowEq = (Results.pagination.getCurrentPageNumber() - 1) * Results.pagination.currentPageMeasurements.columnsPerPage;
					$(Results.settings.elements.resultsOverflow).scrollTo($(Results.settings.elements.rows).not(".filtered").eq(rowEq), 500, {
						onAfter: function () {
							Results.pagination._afterPaginationMotion(true)
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

		}

	},

	_afterPaginationMotion:function(wasAnimated){

		Results.pagination.unlock();
		Results.pagination.refresh();

		if(wasAnimated){
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

		if(clickedButton.hasClass("inactive") == false){
			if( Results.pagination.isLocked === false ){ //Only run if its not currently sliding

				Results.pagination.lock();

				var fullWidth = Results.view.$containerElement.parent().width();
				var widthAllColumns = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows ).first().outerWidth( true ) * $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.rows + ".notfiltered" ).length;
				var scrollWidth = fullWidth * Results.settings.animation.features.scroll.percentage;
				var currentScroll = ResultsUtilities.getScroll( 'x', Results.view.$containerElement );
				var newScroll;

				if( clickedButton.attr('data-results-pagination-control') == 'previous' ){

					newScroll = currentScroll + scrollWidth;

					if( newScroll >= 0) {
						newScroll = 0;
					}

				} else {

					newScroll = currentScroll - scrollWidth;

					if( widthAllColumns <= fullWidth ){
						newScroll = 0;
					} else if( Math.abs( newScroll ) >= (widthAllColumns - fullWidth) && ( fullWidth < widthAllColumns ) ) {
						newScroll = widthAllColumns * -1 + fullWidth;
					}

				}

				Results.pagination.animateScroll( newScroll );

			}
		}

	},

	toggleScrollButtons: function(expectedHorizontalPosition){

		var container = $( Results.settings.elements.resultsContainer + " " + Results.settings.elements.container );
		var currentHorizontalPosition =  ResultsUtilities.getScroll( 'x', Results.view.$containerElement );

		if(expectedHorizontalPosition != currentHorizontalPosition){
			window.setTimeout( function(){ Results.pagination.toggleScrollButtons(expectedHorizontalPosition,leftStatus, rightStatus) }, 100 );
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
				Results.pagination.$nextButton.removeClass("inactive");
			}
			else {
				Results.pagination.$nextButton.addClass("inactive");
			}

			if ( leftStatus == "active" ){
				Results.pagination.$previousButton.removeClass("inactive");
			}
			else {
				Results.pagination.$previousButton.addClass("inactive");
			}

		}

	},

	lock:function(){
		Results.pagination.isLocked = true;
		Results.pagination.$nextButton.addClass("inactive");
		Results.pagination.$previousButton.addClass("inactive");
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
		$(Results.settings.elements.rows+".currentPage").removeClass("currentPage");
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

		// Determine and set the new width of the results-table based on pageWidth * number of pages.
		var numPages = Math.ceil(columnsLength / Results.pagination.currentPageMeasurements.columnsPerPage);
		var newWidth = Results.pagination.currentPageMeasurements.pageWidth * numPages;
		$(Results.settings.elements.container, $featuresModeContainer).width(newWidth);

		// Setup scroll/touch events on the results overflow
		$(Results.settings.elements.resultsOverflow).off('scroll.results').on("scroll.results", Results.pagination.nativePaginationOnScroll);
		if(Modernizr.touch) {
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
		var isMidPage = $(event.target).scrollLeft() % Results.pagination.currentPageMeasurements.pageWidth != 0;
		var isNewPage = Results.pagination.getCurrentPageNumber() != pageNumber;

		// If we're not swiping to the same page, and it's not trying to scroll higher than the number of pages:
		if((isNewPage === true || isMidPage === true) && pageNumber <= Results.pagination.currentPageMeasurements.numberOfPages) {

			Results.pagination.invalidate();
			// Sets it to the object.
			Results.pagination.setCurrentPageNumber(pageNumber);
			// To refresh t/he page count at the top
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