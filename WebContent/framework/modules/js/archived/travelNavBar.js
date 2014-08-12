;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var templates =  {
		navbar :
			'<ul class="nav navbar-nav">'+
				'<li class="slide-feature-back">'+
					'<a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Revise Your Details</span></a>'+
						'</li>'+
						'<li class="navbar-text">'+
						'<div class="resultsSummaryContainer">'+
							'you have <span class="price">30000</span> dollars, in <span class="frequency">awesome</span> travel quotes'+
						'</div>'+
				'</li>'+
			'</ul>'
	};

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		};

	var $component; //Stores the jQuery object for the component group
	var previousBreakpoint;

	function initPage(){

		Features.init();

		eventSubscriptions();

		breakpointTracking();

	}

	function eventSubscriptions(){

		$(document).on("resultsLoaded", onResultsLoaded);
	}

	function breakpointTracking(){

		if( meerkat.modules.deviceMediaState.get() == "xs") {
			startColumnWidthTracking();
		}

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter(){
			if( meerkat.modules.journeyEngine.getCurrentStep().navigationId === "results" ){
				startColumnWidthTracking();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave(){
			stopColumnWidthTracking();
		});

	}

	function startColumnWidthTracking(){
		Results.view.startColumnWidthTracking( $(window), 2, false );
	}

	function stopColumnWidthTracking(){
		Results.view.stopColumnWidthTracking();
	}

	function recordPreviousBreakpoint(){
		previousBreakpoint = meerkat.modules.deviceMediaState.get();
	}


	function onResultsLoaded() {
		createNavbar();
	}

	/*
	 * recreate the Simples tooltips over prices for Simples users
	 * when the results get loaded/reloaded
	 */
	function createNavbar() {
		$('#resultsPage .price').each(function(){

			var $this = $(this);
			var productId = $this.parents( Results.settings.elements.rows ).attr("data-productId");
			var product = Results.getResultByProductId(productId);

			var htmlTemplate = _.template(templates.navbar);

			var text = htmlTemplate({
				product : product,
				frequency : Results.getFrequency()
			});

			meerkat.modules.popovers.create({
				element: $this,
				contentValue: text,
				contentType: 'content',
				showEvent: 'mouseenter click',
				position: {
						my: 'top center',
						at: 'bottom center'
				},
				style: {
					classes: 'priceTooltips'
				}
			});

		});
	}

	function init(){

		$component = $("#resultsPage");

		meerkat.messaging.subscribe(meerkatEvents.healthBenefits.CHANGED, onBenefitsSelectionChange);

	}

	meerkat.modules.register('travelResults', {
		init: init,
		events: moduleEvents,
		initPage: initPage,
		get:get
	});

})(jQuery);
