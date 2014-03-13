;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var events = {
			journeyProgressBar: {
				INIT: 'PROGRESS_BAR_INITED'
			}
		},
		moduleEvents = events.journeyProgressBar;



	var $target = null;
	var progressBarSteps = null;
	var currentStepNavigationId = null;
	var isDisabled = false;

	/* example object
	progressBarSteps: [
		{
			label:'Your Details',
			navigationId:'start',
			matchAdditionalSteps:['details']
		},
		{
			label:'Your Cover',
			navigationId:'benefits'
		}
	]
	*/

	function init() {

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function jeStepInit( step ){
			currentStepNavigationId = step.navigationId;
			render(true);
		});

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange( step ){
			currentStepNavigationId = step.navigationId;
			render(false);
		});

	}

	function configure( progressBarStepsArgument){

		progressBarSteps = progressBarStepsArgument;

		// 99% width divided by number of steps (last li.end element takes 1% width)
		var progressBarElementWidthPercentage = 99 / progressBarSteps.length;

		$target = $(".journeyProgressBar");

		// override default css width to fill 100%
		$("head").append("<style>.journeyProgressBar>li{ width: " + progressBarElementWidthPercentage + "% }</style>");

			

	}

	function render(fireEvent){

		var html = "";
		var openTag = "";
		var closeTag = "";
		var lastIndex = progressBarSteps.length-1;
		var className = null;
		var tabindex = null;
		var foundCurrent = false;
		var isCurrentStep = false;

		_.each( progressBarSteps, function(progressBarStep, index){
			className = "";
			tabindex = "";

			isCurrentStep = currentStepNavigationId === progressBarStep.navigationId || _.indexOf( progressBarStep.matchAdditionalSteps, currentStepNavigationId ) != -1;

			// if current step
			if( isCurrentStep ) {
				className = ' class="current"';
				foundCurrent = true;
			} else {
				// if later step
				if(foundCurrent){
					tabindex = ' tabindex="-1"';
				// if complete step
				}else{
					className = ' class="complete"';
				}
			}

			if( isDisabled || isCurrentStep || foundCurrent ){
				openTag = closeTag = 'div';
			} else {
				openTag = 'a href="javascript:;"' + tabindex + ' data-slide-control="' + progressBarStep.navigationId + '"';
				closeTag = 'a';
			}

			html += '<li' + className + '><' + openTag + '>' + progressBarStep.label + '</' + closeTag + '></li>';

			if( index == lastIndex ){
				className = "";
				if( currentStepNavigationId == "complete"){
					className = ' complete';
				}
				html += '<li class="end' + className + '"><div></div></li>';
			}
		});

		$target.html( html );

		if(fireEvent){
			meerkat.messaging.publish(moduleEvents.INIT);	
		}

	}

	function setComplete(){
		currentStepNavigationId = 'complete';
		$target.addClass('complete');
		render();
	}

	function setCurrentStepNavigationId( stepNavigationId ){
		currentStepNavigationId = stepNavigationId;
		render();
	}

	function enable(){
		isDisabled = false;
		render();
	}

	function disable(){
		isDisabled = true;
		render();
	}

	meerkat.modules.register("journeyProgressBar", {
		init: init,
		render:render,
		events: events,
		configure: configure,
		disable: disable,
		setComplete: setComplete,
		setCurrentStepNavigationId: setCurrentStepNavigationId
	});

})(jQuery);