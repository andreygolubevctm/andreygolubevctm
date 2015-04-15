/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;
    var moduleEvents = {
        creditcard: {}
    }, $mainForm, product;
    function initCreditCard() {
        $(document).ready(function() {
            if (meerkat.site.vertical !== "creditcard") return false;
            product = meerkat.site.product;
            if (product === null) {
                return false;
            }
            if (meerkat.modules.tracking.getCurrentJourney() == "2") {
                trackTransfer();
                setTimeout(function() {
                    redirectTo(product, "justRedirect");
                }, 200);
                return;
            }
            $mainForm = $("#mainform");
            setupDefaultValidationOnForm($mainForm);
            applyEventListeners();
        });
    }
    function applyEventListeners() {
        $("#creditcard_location").on("blur", function() {
            setLocation($(this).val());
        });
        $(".cc-just-continue").on("click", function justContinueToPartner(e) {
            e.preventDefault();
            var $el = $(this);
            saveDetails($el).done(function() {
                redirectTo(product, "justContinueToPartner");
            }).fail(function() {
                meerkat.modules.loadingAnimation.hide($el);
                $(".cc-just-continue, .cc-submit-details").removeClass("disabled");
            });
        });
        $(".cc-submit-details").on("click", function submitDetails(e) {
            e.preventDefault();
            var $el = $(this);
            if (isValid()) {
                saveDetails($el).done(function() {
                    redirectTo(product, "submitDetails");
                });
            } else {
                meerkat.modules.loadingAnimation.hide($el);
                $(".cc-just-continue, .cc-submit-details").removeClass("disabled");
            }
        });
        $("#creditcard_privacyoptin").on("change", function() {
            var checked = $(this).prop("checked");
            $("#creditcard_terms").val(checked ? "Y" : "N");
            $("#creditcard_marketing").val(checked ? "Y" : "N");
        });
        $("#creditcard_competition_optIn").on("change", function() {
            var $name = $("#creditcard_name"), $email = $("#creditcard_email"), $location = $("#creditcard_location");
            if ($(this).prop("checked")) {
                $name.rules("add", {
                    required: true,
                    messages: {
                        required: "Please enter your name to be eligible for the promotion"
                    }
                });
                $email.rules("add", {
                    required: true,
                    messages: {
                        required: "Please enter your email address to be eligible for the promotion"
                    }
                });
                $location.rules("add", {
                    required: true,
                    messages: {
                        required: "Please enter your post code and choose a location to be eligible for the promotion"
                    }
                });
            } else {
                $name.rules("remove", "required");
                $name.rules("add", {
                    required: true,
                    messages: {
                        required: "Please enter your full name"
                    }
                });
                $email.rules("remove", "required");
                $email.rules("add", {
                    required: true,
                    messages: {
                        required: "Please enter your email address"
                    }
                });
                $location.rules("remove", "required");
                $location.rules("add", {
                    required: true,
                    messages: {
                        required: "Please enter your Postcode/Suburb"
                    }
                });
                $name.valid();
                $email.valid();
                $location.valid();
            }
        });
    }
    function redirectTo(product, methodName) {
        if (typeof product.handoverUrl == "string" && product.handoverUrl.length > 1) {
            window.location.replace(product.handoverUrl);
        } else {
            meerkat.modules.errorHandling.error({
                errorLevel: "warning",
                message: "An error occurred. Sorry about that!<br /><br />Please go back and try again.",
                page: "creditcard.js:" + methodName,
                description: "No handoverUrl in results object.",
                data: product
            });
            return false;
        }
    }
    function saveDetails($submitButton) {
        $(".cc-just-continue, .cc-submit-details").addClass("disabled");
        meerkat.modules.loadingAnimation.showInside($submitButton, true);
        trackTransfer();
        var data = meerkat.modules.journeyEngine.getSerializedFormData($("#mainform"));
        data += "&quoteType=" + meerkat.site.vertical;
        return meerkat.modules.comms.post({
            url: "ajax/write/creditcard_submit.jsp",
            data: data,
            errorLevel: "silent"
        });
    }
    function isValid() {
        var isFormValid = true;
        $mainForm.each(function(index, element) {
            $element = $(element);
            var formValid = $element.valid();
            if (formValid === false) isFormValid = false;
        });
        return isFormValid;
    }
    function trackTransfer() {
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: "trackQuoteTransfer",
            object: {
                productID: product.code,
                productBrandCode: product.provider.code,
                productName: product.shortDescription
            }
        });
    }
    function setLocation(location) {
        if (isValidLocation(location)) {
            var value = $.trim(String(location));
            var pieces = value.split(" ");
            var state = pieces.pop();
            var postcode = pieces.pop();
            var suburb = pieces.join(" ");
            $("#creditcard_state").val(state);
            $("#creditcard_postcode").val(postcode);
            $("#creditcard_suburb").val(suburb);
        }
    }
    function isValidLocation(location) {
        var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);
        value = $.trim(String(location));
        if (value !== "") {
            if (value.match(search_match)) {
                return true;
            }
        }
        return false;
    }
    meerkat.modules.register("creditcard", {
        init: initCreditCard,
        events: moduleEvents
    });
})(jQuery);