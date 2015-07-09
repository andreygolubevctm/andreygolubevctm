/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events;
    var moduleEvents = {
        competition: {},
        WEBAPP_LOCK: "WEBAPP_LOCK",
        WEBAPP_UNLOCK: "WEBAPP_UNLOCK"
    };
    var steps = null;
    function initJourneyEngine() {
        if (meerkat.site.pageAction === "submit") {
            meerkat.modules.journeyEngine.configure(null);
        } else {
            initProgressBar(false);
            meerkat.modules.journeyEngine.configure({
                startStepId: null,
                steps: _.toArray(steps)
            });
            var transaction_id = meerkat.modules.transactionId.get();
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: "trackQuoteEvent",
                object: {
                    action: "Start",
                    transactionID: parseInt(transaction_id, 10),
                    vertical: "meerkat",
                    verticalFilter: "competition"
                }
            });
        }
    }
    function initProgressBar(render) {
        setJourneyEngineSteps();
    }
    function setJourneyEngineSteps() {
        var startStep = {
            title: "Enter",
            navigationId: "enter",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.competition.getTrackingFieldsObject
            },
            onInitialise: function initStartStep() {}
        };
        var submitStep = {
            title: "Submit",
            navigationId: "submit",
            slideIndex: 0,
            externalTracking: {
                method: "trackQuoteForms",
                object: meerkat.modules.competition.getTrackingFieldsObject
            },
            onInitialise: function() {},
            onBeforeEnter: function() {}
        };
        steps = {
            startStep: startStep,
            submitStep: submitStep
        };
    }
    function saveDetails($submitButton) {
        $submitButton.addClass("disabled");
        meerkat.modules.loadingAnimation.showInside($submitButton, true);
        var data = meerkat.modules.journeyEngine.getSerializedFormData($("#mainForm"));
        var redirectUrl = $("#competition_returnUrl").val();
        data += "&quoteType=" + meerkat.site.vertical;
        meerkat.modules.comms.post({
            url: "ajax/write/competition.jsp",
            data: data,
            cache: false,
            dataType: "json",
            useDefaultErrorHandling: true,
            errorLevel: "silent",
            timeout: 3e4,
            onSuccess: function onSubmitSuccess(resultData) {
                var promocode = "";
                if (resultData.promocode) {
                    promocode = "?promocode=" + resultData.promocode;
                }
                window.location = redirectUrl + promocode;
            }
        });
    }
    function isValid() {
        var isFormValid = true;
        $("#mainForm").each(function(index, element) {
            $element = $(element);
            var formValid = $element.valid();
            if (formValid === false) isFormValid = false;
        });
        return isFormValid;
    }
    function getTrackingFieldsObject() {
        try {
            var transactionId = meerkat.modules.transactionId.get();
            var email = $("#competition_contact_email").val();
            var marketOptIn = $("#competition_contact_optIn").is(":checked") ? "Y" : "N";
            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();
            var actionStep = "";
            switch (current_step) {
              case 0:
                actionStep = "enter";
                break;

              case 1:
                actionStep = "submit";
                break;
            }
            var response = {
                vertical: "meerkat",
                verticalFilter: "competition",
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                postCode: null,
                state: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null
            };
            return response;
        } catch (e) {
            return false;
        }
    }
    function initCompetition() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "competition") return false;
            initJourneyEngine();
            applyEventListeners();
        });
    }
    function applyEventListeners() {
        $(".btn-next").on("click", function submitDetails(e) {
            e.preventDefault();
            var $el = $(this);
            if (isValid()) {
                saveDetails($el);
            }
        });
    }
    meerkat.modules.register("competition", {
        init: initCompetition,
        events: moduleEvents,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info, $firstname, $surname, $email, $marketing;
    function applyEventListeners() {
        $marketing.on("change", function() {
            if ($(this).is(":checked")) {
                $firstname.attr("required", "required").valid();
                $surname.attr("required", "required").valid();
                $email.attr("required", "required").valid();
            } else {
                $firstname.removeAttr("required").valid();
                $surname.removeAttr("required").valid();
                $email.removeAttr("required").valid();
            }
        });
    }
    function toggleView($el, makeVisible) {
        if (makeVisible) {
            $el.addClass("show_Y").removeClass("show_N show_");
        } else {
            $el.addClass("show_N").removeClass("show_Y show_");
        }
    }
    function init() {
        $(document).ready(function() {
            $firstname = $("#competition_contact_firstName");
            $surname = $("#competition_contact_lastName");
            $email = $("#competition_contact_email");
            $marketing = $("#competition_contact_optIn");
            $firstname.removeAttr("required");
            $surname.removeAttr("required");
            $email.removeAttr("required");
            applyEventListeners();
        });
    }
    meerkat.modules.register("competitionStart", {
        init: init
    });
})(jQuery);