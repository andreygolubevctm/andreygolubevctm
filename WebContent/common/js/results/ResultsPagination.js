var ResultsPagination = new Object();
ResultsPagination = {

	NEXT:"next",
	PREVIOUS:"previous",

	$pagesContainer:null,
	$nextButton:null,
	$previousButton:null,

	invalidated:true,
	currentPageNumber:null,
	currentPageMeasurements:null,

	previousScrollPosition:0,

	isLocked:false,

	init:function(){

		$(document).on('click', '[data-results-pagination-control]', function paginationControlClick(event){
			Results.pagination.controlListener( event );
		});

		Results.pagination.$pagesContainer = $('[data-results-pagination-pages-cell]');
		Results.pagination.$nextButton = $('[data-results-pagination-control="next"]');
		Results.pagination.$previousButton = $('[data-results-pagination-control="previous"]');

		if(typeof meerkat !== 'undefined'){
			meerkat.messaging.subscribe(meerkat.modules.events.device.STATE_CHANGE, function paginationBreakPointChange(event){				
				if(event.state !== 'xs'){
					Results.pagination.resync();
				}
			});
		}
	},

	resync:function(){
		Results.pagination.invalidate();
		Results.pagination.gotoPage(Results.pagination.getCurrentPageNumber(), true, true);
		Results.pagination.refresh();
	},

	reposition:function(){
		Results.pagination.gotoPage(Results.pagination.getCurrentPageNumber(), false, true);
	},

	// quick helpers
	isSlideMode:function(){
		return Results.settings.paginationMode === 'slide';
	},

	isPageMode:function(){
		return Results.settings.paginationMode === 'page';
	},

	getCurrentHorizontalPosition:function(){
		return ResultsUtilities.getScroll( 'x', Results.view.$containerElement );
	},

	// Call this on breakpoint change.
	invalidate:function(){
		Results.pagination.isLocked = false;
		Results.pagination.invalidated = true;
		Results.pagination.currentPageMeasurements = null;
	},

	// Reset - called when results are reloaded.
	reset:function(){
		Results.pagination.invalidate();

		Results.pagination.$nextButton.addClass("inactive");
		Results.pagination.$previousButton.addClass("inactive");

		if(Results.pagination.isSlideMode()){

		}else if(Results.pagination.isPageMode()){
			Results.pagination.$pagesContainer.html("");
		}

	},

	// Refresh the active page display and enable/disable the next/prev buttons
	refresh:function(){
		if(Results.pagination.isPageMode()){

			var pageMeasurements = Results.pagination.getPageMeasurements();
			if(pageMeasurements === null) return false;

			if(Results.pagination.invalidated === true){

				// Rebuild pages list.
				Results.pagination.invalidated = false;

				var htmlTemplate = _.template(Results.settings.templates.pagination.pageItem);

				Results.pagination.$pagesContainer.html("");

				if(pageMeasurements.numberOfPages > 1 && pageMeasurements.numberOfPages != Number.POSITIVE_INFINITY){					
					for(var i=0;i<pageMeasurements.numberOfPages;i++){
						var num = i+1;
						var htmlString = htmlTemplate({pageNumber:num,label:num});
						Results.pagination.$pagesContainer.append(htmlString);
					}
				}

			}

			// Update active state on pages list
			var pageNumber = Results.pagination.getCurrentPageNumber();
			$('[data-results-pagination-control].active').removeClass("active");
			$('[data-results-pagination-control="'+pageNumber+'"]').addClass("active");

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

	animateScroll: function( newScroll ){

		if(newScroll === Results.pagination.previousScrollPosition){
			_.defer(function(){
				Results.pagination.refresh();
			});
			return false;			
		}

		if(Results.settings.animation.features.scroll.active === false){
			Results.pagination.scroll(newScroll);
			Results.pagination._afterPaginationMotion();
		}else{
			
			Results.pagination.lock();

			var isIos6 = false;
			if(typeof meerkat != 'undefined'){				
				isIos6= meerkat.modules.performanceProfiling.isIos6(); // Hardware acceleration causes a 'flickering' bug on ios6 and is therefore disabled.
			}

			
			if( Modernizr.csstransforms3d && isIos6 == false){

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
					
						Results.pagination._afterPaginationMotion();

					}, Results.view.$containerElement.transitionDuration()+10);
				
				},25);			

			} else if( Modernizr.csstransitions){

				var duration = Results.view.$containerElement.transitionDuration();

				if( !Results.view.$containerElement.hasClass("resultsTableLeftMarginTransition")){
					Results.view.$containerElement.addClass("resultsTableLeftMarginTransition");
				}
				
				_.defer(function(){
					
					Results.view.$containerElement.css("margin-left", newScroll);
					
					_.delay(function(){
						Results.pagination._afterPaginationMotion();	
					},duration);

				});

			} else {
				var duration = Results.settings.animation.features.scroll.duration;
				Results.view.$containerElement.animate( { "margin-left": newScroll }, duration, function(){
					Results.pagination._afterPaginationMotion();
				});
			}

			ResultsPagination.previousScrollPosition = newScroll;

		}

	},

	_afterPaginationMotion:function(){
		Results.pagination.unlock();
		Results.pagination.refresh();
	},

	scroll:function(scrollPosition){	
		ResultsPagination.previousScrollPosition = scrollPosition;
		Results.view.$containerElement.css("margin-left", scrollPosition);
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
	}
}