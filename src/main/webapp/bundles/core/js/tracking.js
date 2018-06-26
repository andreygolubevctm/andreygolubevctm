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
    var googleAnalyticsClientId = "";

    function recordTouch(touchType, touchComment, productId, includeFormData, callback, customFields) {

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

        if(_.isArray(customFields) && !_.isEmpty(customFields)) {
            _.each(customFields, function(field) {
                if(!_.isEmpty(field) && _.isObject(field) && _.has(field,"name") && _.has(field,"value")) {
                    data.push(field);
                }
            }, this);
        }

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
            recordTouch(eventObject.touchType, eventObject.touchComment, eventObject.productId, includeFormData, eventObject.callback, eventObject.customFields);
        });

        meerkat.messaging.subscribe(moduleEvents.EXTERNAL, runTrackingCall);

        $(document).ready(function () {

            initLastFieldTracking();
            if (typeof meerkat !== 'undefined' && typeof meerkat.site !== 'undefined' && typeof meerkat.site.tracking !== 'undefined' && meerkat.site.tracking.userTrackingEnabled === true) {
                meerkat.modules.utils.pluginReady('sessionCamRecorder').done(function () {
                    initUserTracking();
                });
            }
            addGAClientID();
            addGTMInternalUser();
        });

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

    /**
     * addGTMInternalUser() adds a global variable to the window object to
     * allow GA to recognise internal and external traffic. Internal is any
     * user on local network or quote started with preload..
     */
    function addGTMInternalUser() {
        window.gtmInternalUser = meerkat.site && meerkat.site.gtmInternalUser ? meerkat.site.gtmInternalUser : false;
    }

    /**
     * addGAClientID() adds a new or updates an existing xpath to store the GA Client ID
     * which is used for tracking purposes.
     */
    function addGAClientID() {
        var gaClientId = null;

        if(meerkat.site.isCallCentreUser) {
            // Maintain gaClientId from online journey if available
            gaClientId = _.has(meerkat.site,'gaClientId') && !_.isEmpty(meerkat.site.gaClientId) ? meerkat.site.gaClientId : null;
        } else {
            // Otherwise, retrieve the _ga cookie and assign its value to gaClientId
            var cookieStr = document.cookie;
            if (!_.isEmpty(cookieStr)) {
                var rawCookies = cookieStr.split(";");
                for (var i = 0; i < rawCookies.length; i++) {
                    var cookie = $.trim(rawCookies[i]).split("=");
                    if (cookie.length === 2) {
                        if (cookie[0] === "_ga") {
                            gaClientId = cookie[1];
                            break;
                        }
                    }
                }
            }

            // Derive element name and if exists then assign value or create a new one
            if (!_.isEmpty(gaClientId)) {
                var temp = gaClientId.split('.');
                if (temp.length >= 2) {
                    var partB = temp.pop();
                    var partA = temp.pop();
                    gaClientId = partA + '.' + partB;
                }
            }
        }

	    var elementName = (meerkat.site.vertical === 'car' ? 'quote' : meerkat.site.vertical) + '_gaclientid';
        var $gaClientId = $('#' + elementName);
        if($gaClientId && $gaClientId.length && !_.isEmpty($gaClientId.val())) {
	        gaClientId = $gaClientId.val();
        } else if(!_.isEmpty(gaClientId)) {
            if ($gaClientId && $gaClientId.length) {
	            $gaClientId.val(gaClientId);
            } else {
                $('#mainform').prepend($('<input/>', {
                    type: 'hidden',
                    id: elementName,
                    name: elementName,
                    value: gaClientId
                }));
            }
        }
	    if(!_.isEmpty(gaClientId)) {
		    googleAnalyticsClientId = gaClientId;
	    }
    }

    /**
     * Public method to send sale data to Google Analytics
     * @param dataIn
     */
    function sendSaleDataToGoogleMeasurementProtocol(dataIn) {
        try {
            var data = !_.isEmpty(dataIn) && _.isObject(dataIn) ? dataIn : {};
            if(!_.isEmpty(data)) {
                appendDefaultsToSaleData(data);
                if(isValidSaleObject(data)) {
                    meerkat.modules.comms.post({
                        url: 'https://www.google-analytics.com/collect',
                        data: data,
                        cache: false,
                        errorLevel: "silent",
                        useDefaultErrorHandling: true
                    });
                } else {
                    meerkat.logging.info("sendSaleDataToGoogleMeasurementProtocol invalidData", data);
                }
            }
        } catch(e) {
            meerkat.logging.info("sendSaleDataToGoogleMeasurementProtocol catch", dataIn, e);
        }
    }

    /**
     * Verify that obj has minimum expected keys. Just as a safety net because
     * sendSaleDataToGoogleMeasurementProtocol is publicly exposed.
     * @param obj
     * @returns {boolean}
     */
    function isValidSaleObject(obj) {
        var keys = _.keys(obj);
        var trustList = ['v','t','ec','ea','el','ds','dp','cid','ti','tid'];
        for(var i=0; i<trustList.length; i++) {
            if(_.indexOf(keys, trustList[i]) === -1) {
                return false;
            }
        }
        return true;
    }

    /**
     * Append common properties to the sale data
     * @param saleData
     */
    function appendDefaultsToSaleData(saleData) {
        var gaCode = getGACode();
        var tranId = meerkat.modules.transactionId.get();
        var clientId = _.has(meerkat.site,'gaClientId') && !_.isEmpty(meerkat.site.gaClientId) ? meerkat.site.gaClientId : null;
        if(!_.isNull(gaCode)) {
            _.extend(saleData,{tid:gaCode});
        }
        if(_.isNumber(tranId)) {
            _.extend(saleData,{ti:tranId});
        }
        // Always send clientId even if empty (only empty when pure simples quote)
        _.extend(saleData,{cid:clientId});
    }

    /**
     * Return the environment specific GA code via window.gaData
     * @returns {null}
     */
    function getGACode() {
        try {
            var gaData = window.gaData || null;
            if(!_.isEmpty(gaData) && _.isObject(gaData)) {
                var props = _.keys(gaData);
                var test = /^UA-/;
                for(var i=0; i<props.length; i++) {
                    if(props[i].search(test) === 0) {
                        return props[i];
                    }
                }
            }
        } catch(e) {
            meerkat.logging.info("getGACode catch", e);
        }
        return null;
    }

    function getGaClientId() {
        return googleAnalyticsClientId.toString();
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
        getTrackingVertical: getTrackingVertical,
        sendSaleDataToGoogleMeasurementProtocol : sendSaleDataToGoogleMeasurementProtocol,
        getGaClientId: getGaClientId
    });

})(jQuery);