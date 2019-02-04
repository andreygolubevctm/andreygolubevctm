;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            journeyEngine: {
                BEFORE_STEP_CHANGED: 'BEFORE_STEP_CHANGED',
                STEP_CHANGED: 'STEP_CHANGED',
                STEP_INIT: 'STEP_INIT',
                READY: 'JOURNEY_READY',
                STEP_VALIDATION_ERROR: 'STEP_VALIDATION_ERROR',
                EXTERNAL: 'TRACKING_EXTERNAL'
            }
        },
        moduleEvents = events.journeyEngine;

	/* Variables */
    var currentStep = null,
        webappLock = false,
        furtherestStep = null;
	/* Constants */
    var DIRECTION_FORWARD = "DIRECTION_FORWARD",
        DIRECTION_BACKWARD = "DIRECTION_BACKWARD";

	/* Default settings for journey engine */
    var settings = {
        startStepId: null,
        steps: [],
        progressBarSteps: [],
        slideContainer: '#journeyEngineContainer',
        slideClassName: 'journeyEngineSlide',
        transition: null  // TODO - build. this
    };

	/* Default settings for journey step */
    var defaultStepSettings = {
        title: null,
        navigationId : null,
        slideId: null,
        initialised: false,
        onInitialise: null,
        onBeforeEnter: null,
        onAfterEnter: null,
        onBeforeLeave: null,
        onAfterLeave: null,
		/*
		 * Set this as a method which returns additional hash information to include
		 * in the URL. e.g.:
		 *
		 * function() {
		 *     return "one/two/three";
		 * }
		 *
		 * These values can be set based on form values (see fuel.js for the results step).
		 * Entering that step will cause the URL to not only include the step, but the additional
		 * information e.g:
		 *
		 * #results/Toowong+4066+QLD/5,2
		 *
		 * To access this information on page load, you can use meerkat.modules.address.getHashAsArray() right before
		 * the journey engine initialises.
		 *
		 * For an example, Fuel implements this using the prefill module. It's pretty neat.
		 */
        additionalHashInfo: null,
        validation: {
            validate: true,
            customValidation: null
        },
        slideScrollTo: 'html, body',
        tracking: null,
        externalTracking: null
    };

	/* example objects

	 validation:{
	 validate:true,
	 customValidation:function(callback){
	 callback(true);
	 }
	 }

	 tracking:{
	 touchType:'H',
	 touchComment: 'HLT detail',
	 }

	 externalTracking:{
	 method:'trackQuoteForms',
	 object:meerkat.modules.health.getTrackingFieldsObject
	 }

	 */

	/* Configure and start the journey engine */
    function configure(instanceSettings){

        if(instanceSettings === null){
            hideInitialLoader();
            return false;
        }

        $.extend(settings, instanceSettings);

        //$(settings.slideContainer+' .'+settings.slideClassName).hide();
        $(settings.slideContainer+' .'+settings.slideClassName).removeClass('active').addClass('hiddenSlide');

        // Configure the steps and apply default settings.
        for(var i=0;i<settings.steps.length;i++){
            settings.steps[i] = $.extend({}, defaultStepSettings, settings.steps[i]);
        }

        // Sort the steps array based on the slideIndex property of each step rather than
        // assuming the array provided matches that order (eg arose in split-testing)
        settings.steps.sort(function(a,b){
            if(a.slideIndex < b.slideIndex) {
                return -1;
            } else if(a.slideIndex > b.slideIndex) {
                return 1;
            } else {
                return 0;
            }
        });

        // Show the initial step (either the first step, or the one defined in the settings, or the one identified in the hash)

        if(settings.startStepId === null && meerkat.modules.address.getWindowHash() === ''){
            settings.startStepId = settings.steps[0].navigationId;

            meerkat.modules.address.setStartHash(settings.startStepId); // so the address module knows what the hash should be
            onNavigationChange({navigationId:settings.startStepId});

        }else{
            if(settings.startStepId === null){
                // Use the browser hash as the start step.
                var hashValue = meerkat.modules.address.getWindowHashAt(0);
                // Check to see if value is valid.
                var requestedStep = getStep(hashValue);
                if(requestedStep === null){
                    settings.startStepId = settings.steps[0].navigationId;
                }else{
                    settings.startStepId = hashValue;
                }
            }

            // need to run through all steps before...
            var eventObject = {};
            eventObject.direction = DIRECTION_FORWARD;
            eventObject.isForward = true;
            eventObject.isBackward = false;
            eventObject.isStartMode = true;

            var stepToShow = settings.steps[0]; // default...
            processStep(0, function(step, validated){
                if(step == null) {
                    step = stepToShow;
                }
                settings.startStepId = step.navigationId;

                if(validated){
                    currentStep = null;
                    furtherestStep = null;
                }else{
                    showSlide(currentStep, false, null);
                    onShowNextStep(eventObject, null, false);
                }

                var startStepId = settings.startStepId;
                if(typeof step !== "undefined" && typeof step.additionalHashInfo === "function")
                    startStepId += "/" + step.additionalHashInfo();

                // Trigger initial navigation change event, either directly or by changing the hash to the correct value.
                if(meerkat.modules.address.getWindowHash() !== "" && meerkat.modules.address.getWindowHash() !== startStepId){
                    meerkat.modules.address.setHash(startStepId);
                }else{
                    meerkat.modules.address.setStartHash(startStepId); // so the address module knows what the hash should be
                    onNavigationChange({ navigationId: settings.startStepId });
                }

            });

        }

        meerkat.messaging.publish(moduleEvents.READY, this);

        function processStep(index, callback){

            if(index >= settings.steps.length) callback(null); // shouldn't happen, here for safety
            var step = settings.steps[index];

            if(step.navigationId === settings.startStepId){

                // found the step, show it.
                callback(step, true);

            }else{

                // progress to next step, check if current step is valid before continuing...

                try{

                    onStepEnter(step, eventObject);
                    if(step.onAfterEnter !== null) step.onAfterEnter(eventObject);

                    currentStep = step;

                    setFurtherestStep();

                    validateStep(step, function successCallback(){

                        if(currentStep.onBeforeLeave !== null) currentStep.onBeforeLeave(eventObject);
                        if(currentStep.onAfterLeave !== null) currentStep.onAfterLeave(eventObject);

                        // continue to next step...
                        _.delay(function () {
                            processStep(index + 1, callback);
                        }, 300);

                    });
                }catch(e){
                    // validation failed.
                    meerkat.logging.info('[journeyEngine]',e);
                    callback(step, false);
                }
            }
        }

    }

    // tries to run onInitialise() of the step being accessed if not done already, and runs the onBeforeEnter()
    function onStepEnter(step, eventObject){
        if(step.initialised === false && step.onInitialise != null) step.onInitialise(eventObject);
        step.initialised = true;
        updateCurrentStepHiddenField(step);
        if(step.onBeforeEnter != null) step.onBeforeEnter(eventObject);
    }

	/* Navigation change - do not call directly, update window hash to trigger this event */
    function onNavigationChange(eventObject){
        try{
            eventObject.isStartMode = false;

            if(eventObject.navigationId === "") eventObject.navigationId = settings.startStepId; // assume it is the start step if blank
            var step = getStep(eventObject.navigationId);
            if(step === null) {
                step = getStep(0);
            }
            step.stepIndex = getStepIndex(step.navigationId); //Also return the index on the event.

            if(currentStep === null){

                // Current step is not set, therefore must be on first run.
                eventObject.direction = DIRECTION_FORWARD;
                eventObject.isForward = true;
                eventObject.isBackward = false;

                _goToStep(step,eventObject);

            }else{

                eventObject.previousNavigationId = currentStep.navigationId;

                if(eventObject.navigationId == currentStep.navigationId){
                    return false;
                }

                if(getStepIndex(step.navigationId) < getStepIndex(currentStep.navigationId) ){

                    eventObject.direction = DIRECTION_BACKWARD;
                    eventObject.isForward = false;
                    eventObject.isBackward = true;

                    _goToStep(step, eventObject);

                }else if(getStepIndex(step.navigationId) == getStepIndex(currentStep.navigationId)+1 ){

                    eventObject.direction = DIRECTION_FORWARD;
                    eventObject.isForward = true;
                    eventObject.isBackward = false;

                    if($(settings.slideContainer).attr('data-prevalidation-completed') == "1"){
                        // Validation was performed prior to the hash being updated and triggering this event, no need to validate again.
                        $(settings.slideContainer).removeAttr('data-prevalidation-completed');
                        _goToStep(step, eventObject);

                    }else{
                        // Most likely this event was triggered directly by a hash change, validation must be performed now.
                        validateStep(currentStep, function afterValidation(){
                            _goToStep(step, eventObject);
                        });
                    }


                }else{
                    // because now the new step is more than one step ahead of the current step.
                    throw "Moving forward too many steps. "+currentStep.navigationId +" to "+eventObject.navigationId;
                }


            }


        }catch(e){
            unlock();
            meerkat.logging.info('[journeyEngine]',e);
            if(currentStep) {
                meerkat.modules.address.setHash(currentStep.navigationId);
            }
            return false;
        }

        return true;

    }

    function _goToStep(step, eventObject){
        // added new publish call. This is for renderingMode.js to be able to update the hidden field as verticals like
        // home loans update the transaction details before the STEP_CHANGED event is fired.
        meerkat.messaging.publish(moduleEvents.BEFORE_STEP_CHANGED, step);

        if(currentStep !== null && currentStep.onBeforeLeave !== null) currentStep.onBeforeLeave(eventObject);

        onStepEnter(step, eventObject);

        _goToSlide(step, eventObject); // animates transition if required
    }

	/* Update HTML to show the correct slide for the specified step */
    function _goToSlide(step, eventObject){

        var previousStep = currentStep;
        if(currentStep === null || step.slideIndex == currentStep.slideIndex){

            // No change in slide, no transitions required, therefore call the step after/before callbacks directly.
            onHidePreviousStep();

            if(currentStep === null) showSlide(step, false, null); // Force show the first step on the initial call of the journey engine.

            currentStep = step;

            setFurtherestStep();

            onShowNextStep(eventObject, previousStep, true);

        }else{

            // The slide has changed, therefore call the step after/before call backs after the transitions have completed.
            var $slide = $(settings.slideContainer+' .'+settings.slideClassName+':eq('+currentStep.slideIndex+')');


            $slide.fadeOut(250,function afterHide(){
                $slide.removeClass('active').addClass('hiddenSlide');

                onHidePreviousStep();

                currentStep = step;
                setFurtherestStep();

                showSlide(step, true, function onShown() {
                    // place the following inside call back
                    onShowNextStep(eventObject, previousStep, true);
                    sessionCamRecorder(currentStep);
                });
            });

        }

        function onHidePreviousStep(){
            if(currentStep !== null && currentStep.onAfterLeave !== null) currentStep.onAfterLeave(eventObject);
        }
    }

    function sessionCamRecorder(step) {
        meerkat.modules.sessionCamHelper.updateVirtualPageFromJourneyEngine(step);
    }

    function onShowNextStep(eventObject, previousStep, triggerEnterMethod){

        $("body").attr("data-step", currentStep.navigationId);

        // Change the browser title
        var title = meerkat.site.title;
        if(currentStep.title != null) title = currentStep.title+' - '+title;
        window.document.title = title;

        // If defined, scroll to an element
        if (currentStep.slideScrollTo && currentStep.slideScrollTo !== null) {
            meerkat.modules.utils.scrollPageTo(currentStep.slideScrollTo);
        }

        // Run callbacks
        if(triggerEnterMethod === true){
            if(currentStep.onAfterEnter != null) currentStep.onAfterEnter(eventObject);
        }

        unlock();

        var eventType = moduleEvents.STEP_INIT;
        if(previousStep !== null){
            eventType = moduleEvents.STEP_CHANGED;
        }

        if (eventType === moduleEvents.STEP_INIT) {
            hideInitialLoader();
        }

        eventObject.step = currentStep;
        eventObject.navigationId = currentStep.navigationId;

        meerkat.messaging.publish(eventType, eventObject);

        if(currentStep.tracking != null){
            meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, currentStep.tracking);
            $('.journeyNavButton').removeClass('poke');
        } else {
            $('.journeyNavButton').addClass('poke');
        }

        if(currentStep.externalTracking != null){
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, currentStep.externalTracking);
        }

        //meerkat.logging.info('[journeyEngine] '+eventType,currentStep);

    }

    function showSlide(step, animate, callback){
        // make this a bit more fault tolerant
        var stepToAnimate = (step && step.slideIndex) || 0;
        var $slide = $(settings.slideContainer+' .'+settings.slideClassName+':eq('+stepToAnimate+')');

        if(animate === true){

            $slide.fadeIn(250,function onShow(){
                _onShow($slide, callback);
            });

        }else{
            _onShow($slide, callback);
        }
    }

    function _onShow($slide, callback) {
        $slide.removeClass('hiddenSlide').addClass('active');
        if(callback !== null) {
            callback();
        }
    }

    function hideInitialLoader(){
        $(document.body).removeClass('jeinit');
    }


	/* Iterate over array and return index for step */
    function getStepIndex(navigationId){
        for(var i=0; i<settings.steps.length; i++){
            var step = settings.steps[i];
            if(step.navigationId == navigationId){
                return i;
            }
        }
        return null;
    }

	/* Return length of the step array */
    function getStepsTotalNum(){
        return settings.steps.length;
    }

	/* Iterate over array and return step item */
    function getStep(navigationId){
        var index = getStepIndex(navigationId);
        if(index === null) {
            return null;
        }
        return settings.steps[index];
    }

	/* The following is used for a supertag method... remove if possible */
    function getCurrentStepIndex(){
        var navId = 0;
        if(currentStep !== null) {
            navId = currentStep.navigationId;
        }
        return getStepIndex(navId);
    }

	/* The furtherestStep is used for a supertag method... remove if possible */
    function setFurtherestStep() {
        if( _.isNull(furtherestStep) || getStepIndex(furtherestStep.navigationId) < getStepIndex(currentStep.navigationId) ) {
            furtherestStep = currentStep;
        }
    }
    function getFurtherestStepIndex(){
        return getStepIndex(furtherestStep.navigationId);
    }

    function getCurrentStep(){
        return currentStep;
    }

    function getPreviousStepId() {
        var previousIndex = 0;
        var currentIndex = getCurrentStepIndex();
        if(currentIndex > 0) {
            previousIndex = --currentIndex;
        }

        return settings.steps[previousIndex].navigationId;
    }

	/* Validate current step */
    /**
     * @param {POJO} step
     * @param {function} successCallback - What to do when validation succeeds
     * @param {function} failureCallback - What to do when validation fails
     */
    function validateStep(step, successCallback, failureCallback){

        var waitForCallback = false;

        if(!_.isNull(step.validation) && !_.isUndefined(step.validation)) {

            if(step.validation.validate === true){


                var isAlreadyVisible = false;
                if($('.'+settings.slideClassName+':eq('+step.slideIndex+'):visible').length > 0){
                    isAlreadyVisible = true;
                }

                var $slide = $('.'+settings.slideClassName+':eq('+step.slideIndex+')');

                $slide.removeClass("hiddenSlide").addClass("active");

                // Mark fields as visible
                meerkat.modules.form.markFieldsAsVisible($slide);

                var isValid = true,
                    errorList = [];
                $slide.find( "form" ).each(function( index, element ) {
                    var $element = $(element);
                    var formValid = $element.valid();
                    if(formValid === false) isValid = false;
                    errorList = $.merge(errorList, $element.validate(meerkat.modules.jqueryValidate.getDefaultValidationObj()).errorList);
                });

                if(isAlreadyVisible === false) $slide.removeClass("active").addClass('hiddenSlide');
                if(isValid === false) {
                    if(typeof failureCallback === 'function') {
                        failureCallback();
                    }
                    throw "Validation failed on "+step.navigationId;
                }
            }

            if(!_.isNull(step.validation.customValidation) && !_.isUndefined(step.validation.customValidation) && _.isFunction(step.validation.customValidation)) {
                waitForCallback = true;
                step.validation.customValidation(function(valid){
                    if(valid){
                        successCallback(true);
                    }else{
                        if(typeof failureCallback === 'function') {
                            failureCallback();
                        }
                        throw "Custom validation failed on "+step.navigationId;
                    }
                });
            }
        }

        if(waitForCallback === false) successCallback(true);

        return true;

    }

    // Public function to check if the current step is valid.
    function isCurrentStepValid(){
        return $(settings.slideContainer+' .'+settings.slideClassName+':eq('+currentStep.slideIndex+') form').valid();
    }

	/* Lock/Unlock journey engine - designed to prevent users from 'double clicking' the next/previous step buttons */

    function lock(){
        $(settings.slideContainer).attr('data-locked','1');
    }

    function unlock(){
        $(settings.slideContainer).removeAttr('data-locked');
    }

    function isLocked(){
        return $(settings.slideContainer).attr('data-locked') == '1';
    }

    function onSlideControlClick(eventObject) {

        var $target = $(eventObject.currentTarget);

        // If button is disabled do not action it
        if ($target.is('.disabled, :disabled')) return false;

        eventObject.preventDefault();
        // Commented out as they prevent other event listeners being applied
        // to the slide control elements.
        // eventObject.stopPropagation();

        gotoPath($target.attr('data-slide-control'), $target);

    }

    // Goto either a navigation id or 'next' or 'previous'. Target is optional and will add loading statuses to the object.
    function gotoPath(path, $target){
        if (typeof $target !== 'undefined' && $target.hasClass('show-loading')) {
            var spinnerPos = $target.attr("data-loadinganimation"),
                spinnerShowAtEnd = !_.isUndefined($target.attr("data-loadinganimation-showAtEnd"));

            if(!_.isUndefined(spinnerPos) && !_.isEmpty(spinnerPos)) {
                if(spinnerPos === "inside") {
                    meerkat.modules.loadingAnimation.showInside($target, spinnerShowAtEnd);
                } else {
                    meerkat.modules.loadingAnimation.showAfter($target);
                }
            } else {
                meerkat.modules.loadingAnimation.showAfter($target);
            }
        }

        // Validate current slide before updating hash.
        try{

            if(isLocked()){
                throw "Journey engine action in progress (isLocked)";
            }else{
                lock(); // Lock the journey engine to prevent multiple clicks.
            }

            var navigationId = path;

            if(currentStep !== null && currentStep.navigationId !== navigationId) {
                var direction;

                // handle dynamically name
                if(navigationId == 'next' || navigationId == 'previous'){

                    meerkat.modules.navMenu.close();

                    var currentStepIndex = getStepIndex(currentStep.navigationId);

                    var newStepIndex = null;
                    if(navigationId == 'next'){
                        direction = 'forward';
                        newStepIndex = currentStepIndex+1;
                        if(newStepIndex >= settings.steps.length){
                            throw "No next steps";
                        }
                    }else{
                        direction = 'backward';
                        newStepIndex = currentStepIndex-1;
                        if(newStepIndex < 0){
                            throw "No previous steps";
                        }
                    }

                    // Get the actual navigation id.
                    navigationId = settings.steps[newStepIndex].navigationId;

                    if(typeof settings.steps[newStepIndex].additionalHashInfo === "function") {
                        navigationId += "/" + settings.steps[newStepIndex].additionalHashInfo();
                    }

                }

                // validate current step
                if(getStepIndex(navigationId) == getStepIndex(currentStep.navigationId)+1 && direction == 'forward'){
                    validateStep(currentStep, function(){
                        $(settings.slideContainer).attr('data-prevalidation-completed','1');

                        meerkat.modules.address.setHash(navigationId);
                        if(typeof $target !== 'undefined') meerkat.modules.loadingAnimation.hide($target);
                    }, logValidationErrors);
                }else{
                    meerkat.modules.address.setHash(navigationId);
                    if(typeof $target !== 'undefined') meerkat.modules.loadingAnimation.hide($target);
                }

            }

        }catch(e){
            unlock();
            meerkat.logging.info('[journeyEngineListener]',e);
            if(typeof $target !== 'undefined') meerkat.modules.loadingAnimation.hide($target);
        }
    }

    function getValue($el) {
        if($el.attr('type') == 'radio' || $el.attr('type') == 'checkbox') {
            return $('input[name='+$el.attr('name')+']:checked').val() || "";
        }
        return $el.val();
    }

    /**
     * Logs validation errors to the database
     */
    function logValidationErrors() {

        var data = [], i = 0, errorList = [];

        data.push({
            name: 'stepId',
            value: meerkat.modules.journeyEngine.getCurrentStep().navigationId
        });

        data.push({
            name: 'hasPrivacyOptin',
            value: meerkat.modules.optIn.isPrivacyOptedIn()
        });

        $(".journeyEngineSlide.active form" ).each(function( index, element ) {
            var $element = $(element);
            errorList = $.merge(errorList, $element.validate(meerkat.modules.jqueryValidate.getDefaultValidationObj()).errorList);
        });


        if (errorList.length > 0) {
            var filteredErrorList = errorList.filter(function(errorObj) {
                var $element = $(errorObj.element);

                return !$element.hasClass('dontSubmit') ? true : false;
            });

            if (filteredErrorList.length > 0) {
                filteredErrorList.forEach(function (errorObj, index) {
                    var xpath = errorObj.element.id,
                        validationMessage = errorObj.message;

                    if (index < 5) {
                        meerkat.messaging.publish(moduleEvents.EXTERNAL, {
                            method: 'errorTracking',
                            object: {
                                error: {
                                    name: xpath,
                                    validationMessage: validationMessage
                                }
                            }
                        });
                    }

                    data.push({
                        name: xpath,
                        value: errorObj.element.value + "::" + validationMessage
                    });

                    i++;
                });
            }
        }

        if(i === 0) {
            return false;
        }

        return meerkat.modules.comms.post({
            url: "logging/validation.json",
            data: data,
            dataType: 'json',
            cache: true,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        });
    }

    function initJourneyEngine() {
        //
        // Hash change listener
        //
        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function hashChange(event) {
            if (webappLock === true) {
                meerkat.modules.address.setHash(currentStep.navigationId);
                return;
            }

            // only the first hash value should relate to journey engine steps, the rest are dialog related.
            onNavigationChange({navigationId:event.hashArray[0]});
        }, window);

        //
        // Slide control link listener
        //
        $(document.body).on("click", 'a[data-slide-control]', onSlideControlClick);

        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function jeAppLock(event) {
            webappLock = true;

            // Disable journey navigation elements
            $('a[data-slide-control]').each(function() {
                $(this).addClass('disabled').addClass('inactive');
            });
        });

        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function jeAppUnlock(event) {
            webappLock = false;

            $('a[data-slide-control]').each(function() {
                $(this).removeClass('disabled').removeClass('inactive');
            });
        });

        $(document).on("keydown", function(e) {
            if (e.ctrlKey && e.keyCode==39) {
                gotoPath("next");
            }
            if (e.ctrlKey && e.keyCode==37){
                gotoPath("previous");
            }
        });

        $('#journeyEngineLoading .loading-logo').after(meerkat.modules.loadingAnimation.getTemplate());
    }

    function getFormData(){
        return meerkat.modules.form.getData( $("#mainform") );
    }

    function getSerializedFormData(){
        return meerkat.modules.form.getSerializedData( $("#mainform") );
    }

    function loadingShow(message, showInstantly, footerMessage) {
        var messageText = message || 'Please wait...';
        var $ele = $('#journeyEngineLoading');
        $('body,html').css('overflow','hidden');
        
        if (footerMessage) {
          $ele.append('<div id="loading-footer"><span>' + footerMessage + '</span></div>');
        }

        if ($ele.attr('data-active') !== '1'){
            $ele.attr('data-active', '1');
            $ele.find('.message').attr('data-oldtext', $ele.find('.message').text()).text(messageText);
            $ele.addClass('displayBlock');
            if (showInstantly){
                $ele.addClass('opacity1');
            } else {
                _.defer(function(){
                    $ele.addClass('opacity1');
                });
            }
        }
    }

    function loadingHide() {

        var $ele = $('#journeyEngineLoading');

        $ele.attr('data-active', '0');
        $ele.removeClass('opacity1');
        $('body,html').css('overflow','auto');
        $("#journeyEngineSlidesContainer").css('opacity', '1');

        var speed = $ele.transitionDuration();

        _.delay(function(){
            if($ele.attr('data-active') !== '1'){
                $ele.removeClass('displayBlock');
                $ele.find('.message').text( $ele.find('.message').attr('data-oldtext') );
            }
        },speed);
        $('#loading-footer').remove();
    }

    function updateCurrentStepHiddenField( step ){
        var verticalCode = meerkat.site.vertical == 'car' ? 'quote' : meerkat.site.vertical;
        $("#" + verticalCode + "_journey_stage").val(step.navigationId);
    }

    meerkat.modules.register("journeyEngine", {
        init: initJourneyEngine,
        events: events,
        configure: configure,
        getStepIndex:getStepIndex,
        getCurrentStepIndex: getCurrentStepIndex,
        getFurtherestStepIndex: getFurtherestStepIndex,
        getStepsTotalNum: getStepsTotalNum,
        isCurrentStepValid: isCurrentStepValid,
        getFormData: getFormData,
        getSerializedFormData: getSerializedFormData,
        getCurrentStep: getCurrentStep,
        loadingShow: loadingShow,
        loadingHide: loadingHide,
        gotoPath: gotoPath,
        getPreviousStepId: getPreviousStepId,
        sessionCamRecorder: sessionCamRecorder,
        unlockJourney: unlock
    });

})(jQuery);