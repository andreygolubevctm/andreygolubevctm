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
            url: "spring/rest/simples/pauseResumeCall.json?action=" + action,
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

            try {
                var responseJson = $.parseJSON(jqXHR.responseText);
                if (responseJson.hasOwnProperty('errors') && responseJson.errors.hasOwnProperty('message')) {
                    errorMessage = responseJson.errors.message;
                }
            } catch (e1) {
            }

            meerkat.modules.errorHandling.error({
                message: "The recording could not be paused/started: <strong>" + errorMessage +"</strong>.<br><br>Remember that to pause/resume you must be on a call and the call can not be on hold.<br>Please notify your supervisor if this continues to occur.",
                page: "application_compliance.tag",
                description: "health_application_compliance.callback(). AJAX Request failed. state=" + isMuted + '. ' + errorThrown,
                data: jqXHR,
                errorLevel: "warning"
            });
        });

        // Returns here because the ajax is synchronous
        return success;
    }


    function seize(isMuted) {
        if (isMuted === true) {
             meerkat.messaging.publish(meerkat.modules.events.WEBAPP_LOCK, {
                 source: 'application_compliance',
                 disableFields: true
             });
        } else {
            meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, {source: 'application_compliance'});
        }
    }


    meerkat.modules.register("healthAppCompliance", {
        events: events,
        callback: callback
    });

})(jQuery);