;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var $signUpForm;

    function initFuelSignup() {
        _registerEventListeners();
        $(document).ready(function() {
            $signUpForm = $("#sign-up-form");
            meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($signUpForm);
        });
    }

    function _registerEventListeners() {
        $(document)
            .on("click", "#fuel_signup_terms, #fuel_signup_privacyoptin", _toggleCheckboxHidden)
            .on("click", ".fuel-sign-up", _onClickFuelSignup);
    }

    function _toggleCheckboxHidden(e) {
        var $this = $(e.target),
            hiddenVal = $this.prop("checked") ? "Y" : "";
        $("#" + $this.attr("id") + "Hidden").val(hiddenVal).valid();
    }

    function _onClickFuelSignup() {
        if($signUpForm.valid()) {
            var $promise = meerkat.modules.comms.post({
                errorLevel: "warning",
                url: "ajax/write/fuel_signup.jsp",
                dataType: "xml",
                data: $signUpForm.serialize()
            });

            $promise
                .done(function(xml) {
                    var resultCode = $(xml).find("resultcode").text();

                    if(resultCode === "0") {
                        // Success
                        _signupSuccess();
                    } else {
                        // Failure
                        _signupFail();
                    }
                })
                .fail(_signupFail);
        }
    }

    function _signupSuccess() {
        var data = $signUpForm.serializeArray(),
            templateData = {};

        for(var i = 0; i < data.length; i++) {
            var current = data[i],
                name = current.name.match(/[a-zA-Z]{1,}$/g)[0];
            templateData[name] = current.value;
        }

        var htmlTemplate = _.template($("#signup-success-template").html(), { variable: "data" });
        $signUpForm.html(htmlTemplate(templateData));
    }

    function _signupFail() {
        $signUpForm.find(".form-submit-error-message").removeClass("hidden");
    }

    meerkat.modules.register("fuelSignup", {
        init: initFuelSignup
    });
})(jQuery);