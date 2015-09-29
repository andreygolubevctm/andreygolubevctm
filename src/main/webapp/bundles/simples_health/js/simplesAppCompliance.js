(function ($, undefined) {

    var meerkat = window.meerkat;
    var events = {
        healthAppCompliance: {}
    };

    function callback(isMuted) {
        if (typeof isMuted === 'undefined') {
            return false;
        }

        var action = isMuted === true ? "PauseRecord" : "ResumeRecord",
            success = false;

        meerkat.modules.comms.get({
            url: "ajax/xml/pauseResumeCall.json?action=" + action,
            dataType: "text",
            async: false,
            cache: false,
            errorLevel: 'silent',
            useDefaultErrorHandling: false,
            timeout: 20000
        }).done(function () {
            success = true;
            seize(isMuted);
        }).fail(function (jqXHR, textStatus, errorThrown) {

            var errorMessage = errorThrown;
            var errorResponse;

            // Don't parse
            if (jqXHR.status != 404 && jqXHR.status != 500) {
                try {
                    errorResponse = $.parseJSON(jqXHR.responseText);
                } catch (e1) {
                    errorResponse = {};
                }

                if (errorResponse.hasOwnProperty('errors') && errorResponse.errors.length > 0) {
                    errorMessage = errorResponse.errors[0].message;
                }
            }

            meerkat.modules.errorHandling.error({
                message: "The recording could not be paused/started. Please notify your supervisor if this continues to occur: " + errorMessage,
                page: "application_compliance.tag",
                description: "health_application_compliance.callback().  AJAX Request failed: " + jqXHR.responseText + ' ' + errorThrown,
                data: "state = " + isMuted,
                errorLevel: "warning"
            });
        });

        // Returns here because the ajax is synchronous
        return success;
    }


    function seize(isMuted) {
        if (isMuted === true) {
            //$('.button-wrapper, #navContainer').addClass('invisible');
            meerkat.messaging.publish(meerkat.modules.events.WEBAPP_LOCK, {
                source: 'application_compliance',
                disableFields: true
            });
        } else {
            //$('.button-wrapper, #navContainer').removeClass('invisible');
            meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, {source: 'application_compliance'});
        }
    }


    meerkat.modules.register("healthAppCompliance", {
        events: events,
        callback: callback
    });

})(jQuery);