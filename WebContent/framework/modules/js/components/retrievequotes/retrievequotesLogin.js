/**
 * Description:
 * External documentation:
 */

;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            retrievequotesLogin: {

            }
        },
        moduleEvents = events.retrievequotesLogin,
        failModalId,
        $loginFailureTemplate,
        htmlTemplate = function() { return "" };

    function initLogin(){

         _registerEventListeners();

        $(document).ready(function($) {
            $loginFailureTemplate = $("#failed-login-template");
            if($loginFailureTemplate.length) {
                htmlTemplate = _.template($loginFailureTemplate.html());
            }
        });

    }

    function _registerEventListeners() {
        $(document).on("click", "#js-too-many-attempts", function() {
            meerkat.modules.dialogs.close(failModalId);
            $(document).find(".forgot-password").trigger("click");
        });
    }

    /**
     * Simply responsible for the AJAX request
     */
    function doLoginAndRetrieve() {
        meerkat.modules.loadingAnimation.showInside($(".btn-login"), true);
        var data = meerkat.modules.form.getData($('#loginForm'));
        return meerkat.modules.comms.post({
            url: "ajax/json/retrieve_quotes.jsp",
            data: data,
            async: false,
            errorLevel: "warning",
            useDefaultErrorHandling: false,
            cache: false,
            dataType: "json"
        });
    }

    /**
     * Handles if it fails, what to show the user.
     * @param jqXHR
     * @param textStatus
     * @param errorThrown
     * @returns {boolean}
     */
    function handleLoginFailure(jqXHR, textStatus, errorThrown) {

        meerkat.modules.journeyEngine.unlockJourney();
        meerkat.modules.address.setHash("login");

        var responseText = jqXHR.responseText;
        if(!responseText) {
            _submitError({url: jqXHR.url}, "No responseText for request");
            return false;
        }
        var responseJson = {};
        try {
            responseJson = $.parseJSON(responseText);
        } catch(e) {
            _submitError(e, "Could not decode responseText to JSON");
        }

        _failureModal(responseJson);
    }

    function _submitError(exception, errorThrown) {
        meerkat.messaging.publish(meerkatEvents.WEBAPP_UNLOCK, { source:'retrievequotesLogin'});
        meerkat.modules.errorHandling.error({
            message:		"An error occurred when attempting to login. Please try again.",
            page:			"retrievequotesLogin.js:doLoginAndRetrieve()",
            errorLevel:		"warning",
            description:	errorThrown,
            data: exception
        });
    }

    /**
     * Display the correct modal for the user.
     * @param json
     * @private
     */
    function _failureModal(json) {

        var templateObj = {};
        if(json.length && typeof json[0].error !== 'undefined') {
            if(json[0].error == 'exceeded-attempts') {
                templateObj.suspended = true;
            } else {
                templateObj.errorMessage = json[0].error;
            }
        } else {
            templateObj.errorMessage = "The email address or password that you entered was incorrect.";
        }

        failModalId = meerkat.modules.dialogs.show({
            title: "A Problem Occurred",
            htmlContent: htmlTemplate(templateObj),
            buttons: [{
                label: "Ok",
                className: 'btn-default',
                closeWindow: true
            }]
        });
    }

    meerkat.modules.register("retrievequotesLogin", {
        init: initLogin,
        events: events,
        doLoginAndRetrieve: doLoginAndRetrieve,
        handleLoginFailure: handleLoginFailure
    });

})(jQuery);