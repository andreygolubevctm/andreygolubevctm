;(function ($) {

    var meerkat = window.meerkat,
        attemptCount = 0,
        $elements = {};

    function init() {
        meerkat.modules.jqueryValidate.initJourneyValidator();
        _setupFields();
        validateDob();
        initEventListeners();
    }

    function _setupFields() {
        $elements = {
            startQuote: $('.remember-me-remove'),
            dobInput: $('#rememberme_primary_dob'),
            dobGroup: $('.remember-me-dob-group'),
            form: $('#rememberMeForm'),
            loadingPage: $('.journeyEngineLoader'),
            loadingMessage: $('.journeyEngineLoader > .message'),
            rememberMePage: $('#journeyEngineSlidesContainer')
        };
    }

    function initEventListeners() {
        $elements.startQuote.click(function (event) {
            event.preventDefault();
            showLoadingPage();
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
                meerkat.modules.leavePageWarning.disable();
                window.location.replace("health_quote_v4.jsp");
            },
            onError: function onError(obj, txt, errorThrown) {
                console.log(obj, errorThrown);
            }
        });
    }

    function showError(invalid_date) {
        invalid_date = invalid_date || false;
        $elements.dobGroup.removeClass('has-success').addClass('has-error');
	    $('#rememberme_primary_dob-error, #rememberme_additional-error').hide();
        if(invalid_date === true) {
	        $('#rememberme_primary_dob-error').show();
        } else if (!$('#rememberme_additional-error').length) {
            $('<label id="rememberme_additional-error" class="error">The date of birth you entered didn\'t match our records, enter your date of birth again or start a new quote</label>').insertAfter('#rememberme_primary_dob-error');
	        $('#rememberme_additional-error').show();
        }
    }

    function updateErrorRedirectMessage() {
        $elements.loadingMessage.html("Sorry, you have exceeded the number of attempts allowed.<br />Redirecting you now to start a new quote.");
    }

    function showLoadingPage() {
        $elements.rememberMePage.fadeOut();
        setTimeout(function () {
            $elements.loadingPage.fadeIn();
        }, 300);
    }

    function validateDob() {
        $elements.form.submit(function (e) {
            e.preventDefault();
            var $form = $(this);

            if ($form.valid()) {
                meerkat.modules.comms.get({
                    url: 'spring/rest/rememberme/quote/get.json',
                    data: {
                        quoteType: 'health',
                        userAnswer: $elements.dobInput.val()
                    },
                    cache: false,
                    errorLevel: 'silent',
                    onSuccess: function (result) {
                        if (result.validAnswer === true && result.transactionId !== "") {
                            meerkat.modules.leavePageWarning.disable();
                            $elements.loadingMessage.text('Loading Products & Prices Please wait...');
                            showLoadingPage();
                            var srcQSParams = {};
                            if(_.isEmpty(window.location.search)) {
                                var tmp = window.location.search.split("?").pop().split("&");
                                for(var i=0; i<tmp.length; i++) {
                                    var pieces = tmp[i].split("=");
                                    if(pieces.length === 2) {
                                        srcQSParams[pieces[0]] = pieces[1];
                                    }
                                }
                            }
                            var newQSParams = {
                                action : "remember",
                                transactionId : result.transactionId
                            };
                            var finalQSParams = _.extend({},srcQSParams,newQSParams);
                            var queryStr = [];
                            for(var j in finalQSParams) {
                                if(_.has(finalQSParams,j)) {
                                    queryStr.push(j+"="+finalQSParams[j]);
                                }
                            }
                            window.location.replace("health_quote_v4.jsp?" + queryStr.join("&") + "#results");
                        } else {
                            showError();
                            attemptCount++;
                        }
                    },
                    onError: function onError(obj, txt, errorThrown) {
                        console.log(obj, errorThrown);
                    }
                });
            } else {
                showError(true);
                attemptCount++;
            }
            if (attemptCount > 2) {
                showError();
                updateErrorRedirectMessage();
                showLoadingPage();
                setTimeout(function () {
                    deleteCookieAndRedirect();
                }, 800);
            }
        });
    }

    meerkat.modules.register('rememberMe', {
        init: init
    });

})(jQuery);