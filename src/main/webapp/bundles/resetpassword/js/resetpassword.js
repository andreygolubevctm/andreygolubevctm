;(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
    };

    var steps;

    function initResetPasswordComponent() {
        _registerEventListeners();
        _setJourneyEngineSteps();

        $(document).ready(function() {
            meerkat.modules.journeyEngine.configure({
                startStepId: null,
                steps: _.toArray(steps)
            });
        });
    }

    function _registerEventListeners() {
        $(document).on("click", "#reset-password", _onClickResetPassword);
    }

    function _setJourneyEngineSteps(){
        meerkat.modules.journeyProgressBar.configure([]);

        steps = {
            startStep: {
                title: 'Reset Password',
                navigationId: 'resetPassword',
                slideIndex: 0,
                onInitialise: function() {
                    meerkat.modules.jqueryValidate.initJourneyValidator();
                }
            }
        };
    }

    function _onClickResetPassword() {
        if($("#resetPasswordForm").valid()) {
            var $resetPasswordButton = $("#reset-password");

            meerkat.modules.loadingAnimation.showInside($resetPasswordButton, true);

            var $ajax = meerkat.modules.comms.post({
                errorLevel: "warning",
                url: "generic/reset_password.json",
                data: {
                    reset_password: $("#reset_password").val(),
                    reset_confirm: $("#reset_confirm").val(),
                    reset_id: meerkat.site.resetPasswordId,
                    transcheck: $("#transcheck").val()
                }
            });

            var genericFailMessage = "We could not reset your password at this time";

            var onFail = function(message) {
                message = message || genericFailMessage;

                var successHTML = _.template($("#reset-fail-modal-template").html());

                meerkat.modules.dialogs.show({
                    title: "Reset Password Error",
                    htmlContent: successHTML({ message: message }),
                    hashId: "forgot-password",
                    buttons: [{
                        label: 'OK',
                        className: 'btn-secondary btn-close-dialog'
                    }],
                    onClose: function() {
                        window.location.replace("retrieve_quotes.jsp");
                    }
                });
            };

            $ajax
                .then(function(data) {
                    if(typeof data === "string")
                        data = JSON.parse(data);

                    if(typeof data.result !== "undefined") {
                        var result = data.result;

                        if(result === "OK") {
                            var successHTML = _.template($("#reset-success-modal-template").html());

                            var emailAddress = data.email;

                            meerkat.modules.dialogs.show({
                                title: "Password Change Successful",
                                htmlContent: successHTML({}),
                                hashId: "forgot-password",
                                buttons: [{
                                    label: 'OK',
                                    className: 'btn-secondary btn-close-dialog'
                                }],
                                onClose: function() {
                                    window.location.replace("retrieve_quotes.jsp?email="+encodeURIComponent(emailAddress));
                                }
                            });
                        } else {
                            if(data.message)
                                onFail(data.message);
                            else
                                onFail();
                        }
                    } else {
                        onFail();
                    }
                })
                .catch(function() {
                    onFail();
                })
                .always(function() {
                    meerkat.modules.loadingAnimation.hide($resetPasswordButton);
                });
        }
    }

    meerkat.modules.register('resetpasswordComponent', {
        init: initResetPasswordComponent,
        events: events
    });

})(jQuery);