setupBoilerplate = function(base) {
    document.write('<script src="' + base + 'common/js/ipp/jquery.min.js">\x3C/script>');
    document.write('<script src="' + base + 'framework/jquery/lib/jquery-2.1.4.min.js">\x3C/script>');
    document.write('<script src="' + base + 'framework/lib/js/modernizr-2.8.3.min.js">\x3C/script>');
    document.write('<script src="' + base + 'framework/lib/js/underscore-1.8.3.min.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/jquery.validate.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/meerkat/js/meerkat.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/meerkat/js/meerkat.logging.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/meerkat/js/meerkat.modules.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/numberUtils/js/numberUtils.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/utils.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/transactionId.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/tracking.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/deviceMediaState.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/dialogs.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/loadingAnimation.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/performanceProfiling.js">\x3C/script>');
    document.write('<script src="' + base + '/assets/js/libraries/bootstrap.min.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/results/js/Results.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/results/js/ResultsView.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/results/js/ResultsPagination.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/results/js/ResultsPagination.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/validationAddress.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/validationBaseRules.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/validationCurrency.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/validationDateRangeRules.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/validationNameRules.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/validation/js/validationPhoneNumberRules.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/contactDetails.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/shared/sendEmail/js/sendEmail.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/journeyEngine.js">\x3C/script>');
    document.write('<script src="' + base + '/bundles/core/js/form.js">\x3C/script>');

    $.support.transition = false;
    // See https://github.com/axemclion/grunt-saucelabs#test-result-details-with-qunit
    QUnit.done(function (results) {
        window.global_test_results = results
    })

    ;
    (function (meerkat) {

        var siteConfig = {
            title: 'Kitchen sink: Current &amp; new - Compare The Market',
            name: 'Compare The Market Australia',
            brand: 'ctm',
            vertical: 'default',
            isDev: true, //boolean determined from conditions above in this tag
            isCallCentreUser: false,
            environment: 'localhost',
            //could be: localhost, integration, qa, staging, prelive, prod
            logpath: '/ctm/ajax/write/register_fatal_error.jsp?uncache=',
            urls: {
                root: 'http://localhost:8080/',
                exit: 'http://int.comparethemarket.com.au/',
                quote: '',
                privacyPolicy: '/ctm/legal/privacy_policy.pdf',
                websiteTerms: '/ctm/legal/website_terms_of_use.pdf',
                fsg: ''
            },
            liveChat: {
                config: {
                    lpServer: "server.lon.liveperson.net",
                    lpTagSrv: "sr1.liveperson.net",
                    lpNumber: "1563103",
                    deploymentID: "1",
                    pluginsConsoleDebug: false
                },
                instance: {
                    brand: 'ctm',
                    vertical: 'Health',
                    unit: 'health-insurance-sales',
                    button: 'chat-health-insurance-sales'
                }
            }
        };
        //pluginsConsoleDebug above will suppress debug console logs being output for our liveperson plugins.
        var options = {};
        meerkat != null && meerkat.init(siteConfig, options);

    })(window.meerkat);

    $(document).ready(function () {
        var vertical = "health";
        var frequency = "Monthly";

        meerkat.site = {
            title: 'Health Quote - Compare The Market Australia',
            name: 'Compare the Market',
            vertical: vertical,
            quoteType: vertical,
            isDev: true, //boolean determined from conditions above in this tag
            isCallCentreUser: false,
            showLogging: true,
            environment: 'localhost',
            //could be: localhost, integration, qa, staging, prelive, prod
            initialTransactionId: 2204245,
            // DO NOT rely on this variable to get the transaction ID, it gets wiped by the transactionId module. Use transactionId.get() instead
            urls: {
                base: 'http://localhost:8080/ctm/',
                exit: 'http://int.comparethemarket.com.au/health-insurance/'
            },
            content: {
                brandDisplayName: 'comparethemarket.com.au'
            },
            //This is just for supertag tracking module, don't use it anywhere else
            tracking: {
                brandCode: 'ctm'
            },
            leavePageWarning: {
                enabled: true,
                message: "You're leaving?! Before you go, why don't you save your quote so you can easily review your health insurance options at a later date"
            },
            liveChat: {
                config: {},
                instance: {},
                enabled: false
            },
            navMenu: {
                type: 'default',
                direction: 'right'
            },
            useNewLogging: true
        };

        meerkat.modules.transactionId.set = function (transactionId) {

        };

        // mock out server call
        meerkat.modules.optIn = {
            fetch: function (settings) {
                var result = {
                    optInMarketing: true
                };
                settings.onSuccess(result);
            }
        };

    });

    function setMinAgeValidation($field, ageMin, title) {
        $field.addRule('youngestDOB', ageMin, title + ' age cannot be under ' + ageMin);

    }

    $(document).ready(function () {
        /**
         * CTM Custom Unhighlight function
         * We define this as a prototype, so that the function only needs to be in memory once.
         * Without this, it would be cloned on every init of the validator.
         * @param element
         * @param errorClass
         * @param validClass
         */
        $.validator.prototype.ctm_unhighlight = function (element, errorClass, validClass) {
            if (!element) return;
            errorClass = errorClass || this.settings.errorClass;
            validClass = validClass || this.settings.validClass;


            if (element.type === "radio") {
                this.findByName(element.name).removeClass(errorClass).addClass(validClass);
            } else {
                $(element).removeClass(errorClass).addClass(validClass);
            }

            var $wrapper = $(element).closest('.row-content, .fieldrow_value');
            var $errorContainer = $wrapper.find('.error-field');


            $errorContainer.find('label[for="' + element.name + '"]').remove();

            if ($wrapper.find(':input.has-error').length > 0) {
                return;
            }

            $wrapper.removeClass(errorClass).addClass(validClass);

            if ($errorContainer.find('label').length > 0) {
                if ($errorContainer.is(':visible')) {
                    $errorContainer.stop().slideUp(100);
                }
                else {
                    $errorContainer.hide();
                }
            }
        };

        if (typeof meerkat.modules.jqueryValidate !== "undefined") {
            meerkat.modules.jqueryValidate.initJourneyValidator();
        }

    });
}
