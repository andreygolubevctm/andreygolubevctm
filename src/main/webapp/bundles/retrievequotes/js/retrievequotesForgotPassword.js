;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var forgotPasswordModal;

    function initRetrieveQuotesForgotPassword() {
        _registerEventListeners();
    }

    function _registerEventListeners() {
        $(document)
            .on("click", ".forgot-password", _onForgotPasswordLinkClick)
            .on("click", ".reset-password", _onResetPasswordLinkClick);
    }

    function _onForgotPasswordLinkClick() {
        var forgotPasswordFormHTML = _.template($("#forgot-password-template").html());

        forgotPasswordModal = meerkat.modules.dialogs.show({
            htmlContent: forgotPasswordFormHTML({}),
            hashId: "forgot-password",
            buttons: [
                {
                    label: 'Back',
                    className: 'btn-close-dialog'
                },
                {
                    label: 'Reset Password',
                    className: 'btn-secondary reset-password'
                }
            ],
            onOpen: function(dialogId) {
                // Setup validation on the forgot password form
                meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($("#forgot-password-form"));

                var usedEmail = $("#login_email").val();
                $("#login_forgotten_email").val(usedEmail);
            }
        });
    }

    function _onResetPasswordLinkClick() {
        var $emailField = $("#login_forgotten_email");

        if($emailField.valid()) {
            var $resetPasswordButton = $(".reset-password");

            meerkat.modules.loadingAnimation.showInside($resetPasswordButton, true);

            var $ajax = meerkat.modules.comms.post({
                errorLevel: "warning",
                url: "ajax/json/forgotten_password.jsp",
                data: {
                    email: $emailField.val()
                }
            });

            var genericFailMessage = "We could not send your password reset email at this time";

            var onFail = function(message) {
                message = message || genericFailMessage;

                var successHTML = _.template($("#reset-password-failure-template").html());

                meerkat.modules.dialogs.show({
                    title: "Reset Password Error",
                    htmlContent: successHTML({ message: message }),
                    hashId: "forgot-password",
                    buttons: [{
                        label: 'OK',
                        className: 'btn-secondary btn-close-dialog'
                    }]
                });
            };

            $ajax
                .then(function(data) {
                    if(typeof data === "string")
                        data = JSON.parse(data);

                    if(typeof data.result !== "undefined") {
                        var result = data.result;

                        if(result === "OK") {
                            var successHTML = _.template($("#reset-password-success-template").html(), {variable: "data"});

                            meerkat.modules.dialogs.show({
                                title: "Reset Password",
                                htmlContent: successHTML({email: $emailField.val()}),
                                hashId: "forgot-password",
                                buttons: [{
                                    label: 'OK',
                                    className: 'btn-secondary btn-close-dialog'
                                }]
                            });
                        } else {
                            var message = data.message || genericFailMessage,
                                errorObj = {
                                    "login_forgotten_email": message
                                };

                            $("#forgot-password-form").validate().showErrors(errorObj);
                        }
                    } else {
                        onFail();
                    }
                })
                .catch(function() {
                    onFail();
                })
                .always(function() {
                    meerkat.modules.dialogs.close(forgotPasswordModal);
                    meerkat.modules.loadingAnimation.hide($resetPasswordButton);
                });
        }
    }

    meerkat.modules.register("retrievequotesComponentForgotPassword", {
        init: initRetrieveQuotesForgotPassword
    });

})(jQuery);