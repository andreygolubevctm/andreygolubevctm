;(function ($) {

    var meerkat = window.meerkat,
        attemptCount = 0,
        $elements = {};

    function init() {
        _setupFields();
        validateDob();
        initEventListeners();
    }

    function _setupFields() {
        $elements = {
            dobInput: $('#rememberme_primary_dob'),
            dobGroup: $('.remember-me-dob-group'),
            form: $('#rememberMeForm'),
            loadingPage: $('.journeyEngineLoader'),
            loadingMessage: $('.journeyEngineLoader > .message'),
            rememberMePage: $('#journeyEngineSlidesContainer')
        };
    }

    function initEventListeners() {
        $('.remember-me-remove').click(function () {
            event.preventDefault();
            deleteCookieAndRedirect();
        });

        $elements.dobInput.on("change", function () {
            var $error = $('.remember-me-dob-group label.error');
            if ($error.length) {
                $elements.dobGroup.removeClass('has-error');
                $error.hide();
            }
        });
    }

    function deleteCookieAndRedirect() {
        meerkat.modules.comms.post({
            url: 'spring/rest/rememberme/quote/deleteCookie.json',
            data: {
                quoteType: 'health'
            },
            dataType: 'json',
            cache: true,
            errorLevel: "silent",
            onSuccess: function onSuccess() {
                window.location.replace("/ctm/health_quote_v4.jsp");
            },
            onError: function onError(obj, txt, errorThrown) {
                console.log(obj, errorThrown);
            }
        });
    }

    function showSuccess() {
        $elements.dobGroup.removeClass('has-error').addClass('has-success');
        $('.remember-me-dob-group label.error').hide();
    }

    function showError() {
        $elements.dobGroup.removeClass('has-success').addClass('has-error');
        $('.remember-me-dob-group label.error').show();
    }

    function updateErrorRedirectMessage(){
        $elements.loadingMessage.hide();
        var $attemptsMessage = $("<h4>Sorry, you have exceeded the number of attempts allowed.</h4>");
        $attemptsMessage.add("<h4>Redirecting you now to start a new quote...</h4>").insertAfter($elements.loadingMessage);
    }

    function validateDob() {
        $elements.form.submit(function (e) {
            e.preventDefault();
            var $form = $(this);

            if (attemptCount > 2) {
                showError();
                updateErrorRedirectMessage();

                $elements.rememberMePage.fadeOut();

                setTimeout(function(){
                    $elements.loadingPage.fadeIn();
                }, 300);

                setTimeout(function() {
                    deleteCookieAndRedirect();
                }, 1000);
            }
            else if ($form.valid()) {
                var data = {
                    quoteType: 'health',
                    userAnswer: $elements.dobInput.val()
                };

                console.log(data);

                meerkat.modules.comms.get({
                    url: 'spring/rest/rememberme/quote/get.json',
                    data: data,
                    cache: true,
                    errorLevel: "silent",
                    onSuccess: function onSuccess() {
                        showSuccess();
                        console.log('yes!');
                        // window.location.replace("/ctm/health_quote_v4.jsp#results");
                    },
                    onError: function onError(obj, txt, errorThrown) {
                        console.log(obj, errorThrown);
                    }
                });
            }else {
                showError();
                attemptCount++;
            }
        });
    }

    meerkat.modules.register('rememberMe', {
        init: init
    });

})(jQuery);