;(function ($, undefined) {

    var meerkat = window.meerkat;

    var events = {
            tracking: {
                TOUCH: 'TRACKING_TOUCH',
                EXTERNAL: 'TRACKING_EXTERNAL',
                STEP_VALIDATION_ERROR: 'STEP_VALIDATION_ERROR'
            }
        },
        moduleEvents = events.tracking;

    var lastFieldTouch = null;
    var lastFieldTouchXpath = null;

    function recordTouch(touchType, touchComment, productId, includeFormData, callback) {

        var data = [];
        if (includeFormData) {
            data = meerkat.modules.journeyEngine.getFormData();
        }

        data.push({
            name: 'quoteType',
            value: meerkat.site.vertical
        });
        data.push({
            name: 'touchtype',
            value: touchType
        });
        data.push({
            name: 'comment',
            value: touchComment
        });
        data.push({
            name: 'productId',
            value: productId
        });

        meerkat.modules.comms.post({
            url: 'ajax/json/access_touch.jsp',
            data: data,
            errorLevel: "silent",
            onSuccess: function recordTouchSuccess(response) {
                if (_.has(response, "result") && _.has(response.result, "transactionId") && _.isNumber(response.result.transactionId) && response.result.transactionId > 0) {
                    meerkat.modules.transactionId.set(response.result.transactionId);
                }
                if (typeof callback === "function") callback(response);
            }
        });
    }

    /**
     * CTMIT-64 Testing recordDTM
     *
     */
    function recordDTM(method, value) {
        try {
            if (typeof _satellite === 'undefined') {
                throw "_satellite is undefined";
            }

            for (var key in value) {
                if (value.hasOwnProperty(key) && typeof value[key] !== 'function') {
                    if (value[key] !== null) {
                        var setVarValue = typeof value[key] === 'string' ? value[key].toLowerCase() : value[key];
                        _satellite.setVar(key, setVarValue);
                    } else {
                        _satellite.setVar(key, "");
                    }
                }
            }
            meerkat.logging.info("DTM", method, value);
            _satellite.track(method);


        } catch (e) {
            meerkat.logging.info("_satellite catch", method, value, e);
        }
    }

    /**
     * https://developers.google.com/tag-manager/quickstart
     * @param {String} method
     * @param {POJO} value
     */
    function recordGoogle(method, value) {
        try {
            if (typeof window.CtMDataLayer === 'undefined') {
                throw "Google Data Layer is undefined";
            }
            var data = {"event": method};
            var values = _.keys(value);
            for (var i = 0; i < values.length; i++) {
                var key = values[i];
                if (value[key] !== null) {
                    data[key] = typeof value[key] === 'string' ? value[key].toLowerCase() : value[key];
                }
            }
            meerkat.logging.info("Google", method, value);
            window.CtMDataLayer.push(data);

        } catch (e) {
            meerkat.logging.info("Google catch", method, value, e);
        }
    }

    function recordSupertag(method, value) {
        try {
            if (typeof superT === 'undefined') {
                throw "Supertag is undefined";
            }

            superT[method](value);
            meerkat.logging.info("Supertag", method, value);

        } catch (e) {
            meerkat.logging.info("Supertag catch", method, value, e);
        }
    }

    function getEmailId(emailAddress, marketing, oktocall, callback) {

        return meerkat.modules.comms.post({
            url: "ajax/json/get_email_id.jsp",
            data: {
                vertical: meerkat.site.vertical,
                email: emailAddress,
                m: marketing,
                o: oktocall
            },
            cache: true,
            errorLevel: "silent"
        });

    }

    function updateLastFieldTouch(label) {
        if (!_.isUndefined(label) && !_.isEmpty(label) && label !== lastFieldTouch) {
            lastFieldTouch = label;
            $('#' + lastFieldTouchXpath).val(lastFieldTouch);
            meerkat.logging.debug('last touched field: ' + lastFieldTouch);
        }
    }

    function applyLastFieldTouchListener() {

        $(document.body).on('click focus', 'form input, form select', function (e) {
            updateLastFieldTouch($(this).closest(':input').attr('name'));
        });

        $('a[data-slide-control]').on('click', function () {
            updateLastFieldTouch($(this).attr('data-slide-control') + '-' + meerkat.modules.journeyEngine.getCurrentStep().navigationId);
        });

        /* It may be necessary to add vertical/module specific listeners that
         * are not captured above. Eg the datepicker has a listener on its
         * change event that will call updateLastFieldTouch.
         */
    }

    function initLastFieldTracking() {

        var vertical = meerkat.site.vertical;
        vertical = vertical === 'car' ? 'quote' : vertical;
        lastFieldTouchXpath = vertical + '_lastFieldTouch';

        // Append tracking field to form so that it's value can also exist as an xpath
        $('#mainform').append($('<input/>', {
            type: 'hidden',
            name: lastFieldTouchXpath,
            id: lastFieldTouchXpath,
            value: ''
        }));

        applyLastFieldTouchListener();
    }

    function initTracking() {

        $(document).on("click", "a[data-tracking-type]", function onTrackedLinkClick(eventObject) {
            var touchType = $(eventObject.currentTarget).attr('data-tracking-type');
            var touchValue = $(eventObject.currentTarget).attr('data-tracking-value'); // optional.
            meerkat.modules.tracking.recordTouch(touchType, touchValue);
        });

        $(document).on("click", "a[data-supertag-method]", function onTrackedSupertagLinkClick(eventObject) {
            var supertagMethod = $(eventObject.currentTarget).attr('data-supertag-method');
            var supertagValue = $(eventObject.currentTarget).attr('data-supertag-value');
            meerkat.modules.tracking.recordSupertag(supertagMethod, supertagValue);
        });

        meerkat.messaging.subscribe(moduleEvents.TOUCH, function (eventObject) {
            if (typeof eventObject === 'undefined') return;

            var includeFormData = false;
            if (typeof eventObject.includeFormData !== 'undefined' && eventObject.includeFormData === true) includeFormData = true;

            recordTouch(eventObject.touchType, eventObject.touchComment, eventObject.productId, includeFormData, eventObject.callback);
        });

        meerkat.messaging.subscribe(moduleEvents.EXTERNAL, runTrackingCall);

        meerkat.messaging.subscribe(moduleEvents.STEP_VALIDATION_ERROR, function(step, errorList) {
            console.log('STEP_VALIDATION_ERROR');
            // console.log('errorList', errorList);
            if (errorList.length) {
                var filteredErrorList = errorList.filter(function(errorObj) {
                    var $element = $(errorObj.element);

                    return !$element.hasClass('dontSubmit') ? true : false;
                });

                var errorTrackingArr = [];

                filteredErrorList.slice(0,5).forEach(function (errorObj) {
                    var $element = $(errorObj.element),
                        trackingObj = {
                            method: 'errorTracking',
                            object: {
                                inputLabel: getInputLabel($element),
                                validationMessage: errorObj.message,
                                inputValue: getInputValue($element)
                            }
                        };
                    runTrackingCall(trackingObj);

                    errorTrackingArr.push(trackingObj);
                });

                console.log('ERROR_TRACKING', errorTrackingArr);
            }
        });

        $(document).ready(function () {

            initLastFieldTracking();
            if (typeof meerkat !== 'undefined' && typeof meerkat.site !== 'undefined' && typeof meerkat.site.tracking !== 'undefined' && meerkat.site.tracking.userTrackingEnabled === true) {
                meerkat.modules.utils.pluginReady('sessionCamRecorder').done(function () {
                    initUserTracking();
                });
            }
        });

    }

    function getInputType($element) {
        var inputType = $element.attr('type');

        if ($element.is('select')) {
            inputType = 'select';
        } else if ($element[0].hasAttribute('data-rule-dateEUR')) {
            inputType = 'date';
        }

        return inputType;
        // return $element.is('select') ? 'select' : $element.attr('type');
    }

    function getInputLabel($element) {
        var inputName = $element[0].name;
        return $('label.control-label[for='+inputName+']').text();
    }

    function getInputValue($element) {
        var inputType = getInputType($element),
            value;

        switch (inputType) {
            case 'checkbox':
            case 'radio':
            case 'select':
                value = $($element[0].name).is(':checked') === false ? 'no selection' : $element.val();
                break;

            case 'date':
                value = getDateValue($element);
                break;

            default:
                value = $element.val();
                break;
        }

        return value;
    }

    function getDateValue($element) {
        var inputId = $element[0].id,
            day = $('#' + inputId + 'InputD').val() ? $('#' + inputId + 'InputD').val() : 'DD',
            month = $('#' + inputId + 'InputM').val() ? $('#' + inputId + 'InputM').val() : 'MM',
            year = $('#' + inputId + 'InputY').val() ? $('#' + inputId + 'InputY').val() : 'YYYY';

        return day + ' ' + month + ' ' + year;
    }

    function runTrackingCall(eventObject, override) {

        // override: is to bypass the eventObject being overwritten by updateObjectData
        override = override || false;

        if (typeof eventObject === 'undefined') {
            return;
        }

        if (typeof meerkat.site.tracking !== 'object') {
            meerkat.site.tracking = {};
        }

        // Create the value object here, to reduce duplicate code.
        var values, object = eventObject.object;

        if (meerkat.site.tracking.superTagEnabled === true || meerkat.site.tracking.DTMEnabled === true || meerkat.site.tracking.GTMEnabled === true) {
        values = typeof object === 'function' ? object() : object;
        } else {
            // just set it to what it originally was.
            values = object;
        }

        // Add defaults to values if required
        values = override === false ? updateObjectData(values) : values;

        // Set a resolved promise to start with.
        var deferred = $.Deferred().resolve().promise();
        if (typeof values === 'object') {

            if (values.email !== null && values.email !== '' && values.emailID === null) {
                // Reset var deferred to the deferred result of the XHR object
                deferred = getEmailId(values.email, values.marketOptIn, values.okToCall).done(function (result) {
                    if (typeof result.emailId !== 'undefined') {
                        values.emailID = result.emailId;
                        values.email = null;
                    }
                });
            }
        }

        // run when it is either resolved OR rejected (emailID would just be null if failed).
        deferred.always(function () {
            if (meerkat.site.tracking.superTagEnabled === true) {
                recordSupertag(eventObject.method, values);
            }
            if (meerkat.site.tracking.DTMEnabled === true) {
                recordDTM(eventObject.method, values);
            }
            if (meerkat.site.tracking.GTMEnabled === true) {
                recordGoogle(eventObject.method, values);
            }
        });
    }

    function getCurrentJourney() {
        return meerkat.modules.splitTest.get();
    }

    function getTrackingVertical() {
        // Add any other vertical label overrides here
        var vertical = meerkat.site.vertical;
        if (vertical === 'home') {
            vertical = 'Home_Contents';
        }

        return vertical;
    }

    /**
     * To prefill certain global values between different tracking methods.
     */
    function updateObjectData(object) {

        if (typeof object.brandCode === "undefined") {
            object.brandCode = meerkat.site.tracking.brandCode;
        }

        if (typeof object.transactionID === "undefined") {
            object.transactionID = meerkat.modules.transactionId.get();
        }

        if (typeof object.rootID === "undefined") {
            object.rootID = meerkat.modules.transactionId.getRootId();
        }

        if (typeof object.currentJourney === "undefined") {
            object.currentJourney = getCurrentJourney();
        }

        if (typeof object.vertical === "undefined") {
            object.vertical = getTrackingVertical();
        }

        if (typeof object.simplesUser === "undefined") {
            object.simplesUser = meerkat.site.isCallCentreUser;
        }

        if (typeof object.contactCentreID === "undefined") {
            object.contactCentreID = meerkat.site.userId || null;
        }

        if (typeof object.campaignID === "undefined") {
            object.campaignID = $('input[name$=tracking_cid]').val() || null;
        }

        if (typeof object.verticalFilter === "undefined") {
            object.verticalFilter = (typeof meerkat.modules[meerkat.site.vertical] !== 'undefined' && typeof meerkat.modules[meerkat.site.vertical].getVerticalFilter === 'function' ? meerkat.modules[meerkat.site.vertical].getVerticalFilter() : null);
        }

        // Always ensure the tracking key exists
        object.trackingKey = meerkat.modules.trackingKey.get();

        object.lastFieldTouch = lastFieldTouch;

        return object;
    }

    /**
     * For sessioncam
     */
    function initUserTracking() {

        if (typeof window.sessionCamRecorder === 'undefined') {
            return;
        }
        if (typeof window.sessioncamConfiguration !== 'object') {
            window.sessioncamConfiguration = {};
        }
        if (typeof window.sessioncamConfiguration.customDataObjects !== 'object') {
            window.sessioncamConfiguration.customDataObjects = [];
        }
        var item = {
            key: "transactionId",
            value: meerkat.modules.transactionId.get()
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "brandCode",
            value: meerkat.site.tracking.brandCode
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "vertical",
            value: meerkat.site.vertical
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "rootID",
            value: meerkat.modules.transactionId.getRootId()
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
        item = {
            key: "currentJourney",
            value: getCurrentJourney()
        };
        window.sessioncamConfiguration.customDataObjects.push(item);
    }

    meerkat.modules.register("tracking", {
        init: initTracking,
        events: events,
        recordTouch: recordTouch,
        recordSupertag: recordSupertag,
        updateLastFieldTouch: updateLastFieldTouch,
        applyLastFieldTouchListener: applyLastFieldTouchListener,
        getCurrentJourney: getCurrentJourney,
        updateObjectData: updateObjectData,
        getTrackingVertical: getTrackingVertical
    });

})(jQuery);