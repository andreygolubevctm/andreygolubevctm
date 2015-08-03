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
	var isVisible = true;

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

		$(document).ready(function() {
			$target = $(".journeyProgressBar");
		});
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function jeStepInit( step ){
			currentStepNavigationId = step.navigationId;
			$(document).ready(function() {
			render(true);
		});
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

		// override default css width to fill 100%
		$("head").append("<style>.journeyProgressBar>li{ width: " + progressBarElementWidthPercentage + "% }</style>");
	}

	function render(fireEvent){

		var html = "";
		var openTag = "";
		var closeTag = "";
		var lastIndex = _.isArray(progressBarSteps) ? progressBarSteps.length-1 : 0;
		var className = null;
		var tabindex = null;
		var foundCurrent = false;
		var isCurrentStep = false;

		if(isVisible) {
			$target.removeClass('invisible');
		}
		else {
			$target.addClass('invisible');
		}

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
	function showSteps() {
		return progressBarSteps;
	}

	function checkLabel(labelToCheck) {
		_.each( progressBarSteps, function(progressBarStep, index){
			if (progressBarStep.label === labelToCheck){
				return true;
			}
		});
	}
	function addAdditionalStep(labelToCheck, navigationId){
		_.each( progressBarSteps, function(progressBarStep, index){
			if (progressBarStep.label === labelToCheck){
				progressBarStep.matchAdditionalSteps = [navigationId];
			}
		});
	}

	function setComplete(){
		currentStepNavigationId = 'complete';
		$target.addClass('complete');
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

	function show(){
		isVisible = true;
		render();
	}

	function hide(){
		isVisible = false;
		render();
	}

	meerkat.modules.register("journeyProgressBar", {
		init: init,
		render:render,
		events: events,
		configure: configure,
		disable: disable,
		enable: enable,
		show: show,
		hide: hide,
		setComplete: setComplete,
		showSteps: showSteps,
		checkLabel: checkLabel,
		addAdditionalStep: addAdditionalStep
	});

})(jQuery);