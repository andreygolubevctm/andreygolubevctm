;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        msg = meerkat.messaging;

    var aggregationServicePromise;
    var aggregationServices = ['travel', 'car', 'home', 'health', 'utilities', 'fuel'],
        applicationServices = ['health', 'utilities'],
        validatorServices = ['health'];
    // Refresh just the css when shift+s is pressed
    function initRefreshCSS() {
        function refreshStyles(event) {
            var target = event.target,
                tagName = target.tagName.toLowerCase(),
                linkTags;

            if (!(event.shiftKey && event.which === 83)) {
                return;
            }

            if (tagName === "input" || tagName === "textarea" || tagName === "select") {
                return;
            }

            linkTags = document.getElementsByTagName('link');

            //http://david.dojotoolkit.org/recss.html
            for (var i = 0; i < linkTags.length; i++) {
                var linkTag = linkTags[i];
                if (linkTag.rel.toLowerCase().indexOf('stylesheet') >= 0) {
                    var href = linkTag.getAttribute('href');
                    href = href.replace(/(&|\?)forceReload=\d+/, '');
                    href = href + (href.indexOf('?') >= 0 ? '&' : '?') + 'forceReload=' + new Date().getTime();
                    linkTag.setAttribute('href', href);
                }
            }
        }

        if (window.addEventListener) {
            window.addEventListener('keypress', refreshStyles);
        }
    }

    function hasAggregationService() {
        return activeForVertical(aggregationServices);
    }

    function hasApplicationService() {
        return activeForVertical(applicationServices);
    }

    function hasValidatorService() {
        return activeForVertical(validatorServices);
    }

    function activeForVertical(service) {
        return service.indexOf(meerkat.site.vertical) !== -1;
    }

    function hasStaticBranches() {
        return true;
    }

    function initEnvironmentMonitor() {

        // Build information bar
        $("#copyright").after('<div class="buildEnvInfo_div">' +
            '<ul><li class="devEnv"></li>' +
            '<li>Transaction ID: <span class="devTransactionId"></span></li>' +
            '<li>Revision #: <span class="devRevisionId"></span></li>' +
            '<li class="devService"><a href="data.jsp" target="_blank">View data bucket</a></li>' +
            '<li class="devService aggEngine"></li>' +
            '<li class="devService applyEngine"></li>' +
            '<li class="devService validatorEngine"></li>' +
            '<li class="devService staticEngine"></li>' +
            '</ul></div>');

        // Populate information bar
        var $transactionIdHolder = $(".devTransactionId");
        var $environmentHolder = $(".devEnv");
        var $revisionHolder = $(".devRevisionId");

        $transactionIdHolder.text(meerkat.modules.transactionId.get());
        $environmentHolder.text(meerkat.site.environment).addClass(meerkat.site.environment);
        $revisionHolder.text(meerkat.site.revision);

        var $aggEngineContainer = $('.devService.aggEngine').hide();
        var $applicationEngineContainer = $('.devService.applyEngine').hide();
        var $validatorEngineContainer = $('.devService.validatorEngine').hide();
        var $staticBranchesContainer = $('.devService.staticEngine').hide();

        // Add aggregation service switcher (
        if (hasAggregationService() === true) {

            $aggEngineContainer.show();
            $aggEngineContainer.html('Loading aggregators...');

            var aggregationBaseUrl = "http://web-ctm-dev.ctm.cloud.local:8080"; // for NXI


            aggregationServicePromise = meerkat.modules.comms.get({
                url: aggregationBaseUrl + "/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = '<label>Aggregation service: <select id="developmentAggregatorEnvironment"><option value="">' + meerkat.site.environment.toUpperCase() + '</option>';

                    for (var i = 0; i < resultData.NXI.length; i++) {
                        var obj = resultData.NXI[i];

                        // Add any travel-quote branch to the list (except for the default if viewing this on NXI)

                        var vertical = meerkat.site.vertical;
                        if (vertical === 'home') {
                            vertical = 'homecontents';
                        }

                        if (vertical === 'utilities') {
                            vertical = 'energy';
                        }

                        var verticalQuoteAppPath = "/" + vertical + "-quote";
                        if (obj.context.indexOf(verticalQuoteAppPath) !== -1 && (obj.context === verticalQuoteAppPath && meerkat.site.environment === 'nxi') === false) {

                            var val = aggregationBaseUrl + obj.context;
                            var selected = '';
                            if (val === localStorage.getItem("aggregationService_" + meerkat.site.vertical)) {
                                selected = 'selected="true" ';
                            }

                            select += '<option value="' + val + '" ' + selected + '>NXI' + obj.context.toUpperCase() + '</option>';
                        }
                    }

                    select += '</select></label>';
                    $aggEngineContainer.html(select);

                    $("#developmentAggregatorEnvironment").change(function onDevEnvChange(eventObject) {
                        localStorage.setItem("aggregationService_" + meerkat.site.vertical, $("#developmentAggregatorEnvironment").val());
                    });


                }
            });

        }

        // Add application service switcher (
        if (hasApplicationService() === true) {

            $applicationEngineContainer.show();
            $applicationEngineContainer.html('Loading application services...');

            var applicationBaseUrl = "http://web-ctm-dev.ctm.cloud.local:8080"; // for NXI


            meerkat.modules.comms.get({
                url: applicationBaseUrl + "/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = '<label>Application service: <select id="developmentApplicationEnvironment"><option value="">' + meerkat.site.environment.toUpperCase() + '</option>';

                    for (var i = 0; i < resultData.NXI.length; i++) {
                        var obj = resultData.NXI[i];

                        // Add any travel-quote branch to the list (except for the default if viewing this on NXI)

                        var vertical = meerkat.site.vertical;

                        if (vertical === 'utilities') {
                            vertical = 'energy';
                        }

                        var verticalQuoteAppPath = "/" + vertical + "-apply";
                        if (obj.context.indexOf(verticalQuoteAppPath) !== -1 && (obj.context === verticalQuoteAppPath && meerkat.site.environment === 'nxi') === false) {

                            var val = applicationBaseUrl + obj.context;
                            var selected = '';
                            if (val === localStorage.getItem("applicationService_" + meerkat.site.vertical)) {
                                selected = 'selected="true" ';
                            }

                            select += '<option value="' + val + '" ' + selected + '>NXI' + obj.context.toUpperCase() + '</option>';
                        }
                    }

                    select += '</select></label>';
                    $applicationEngineContainer.html(select);

                    $("#developmentApplicationEnvironment").change(function onDevEnvChange(eventObject) {
                        localStorage.setItem("applicationService_" + meerkat.site.vertical, $("#developmentApplicationEnvironment").val());
                    });


                }
            });

        }

        if (hasValidatorService() === true) {

            $validatorEngineContainer.show();
            $validatorEngineContainer.html('Loading Validator services...');

            var validatorBaseUrl = "http://web-ctm-dev.ctm.cloud.local:8080"; // for NXI


            meerkat.modules.comms.get({
                url: validatorBaseUrl + "/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = '<label>Validator service: <select id="developmentValidatorEnvironment"><option value="">' + meerkat.site.environment.toUpperCase() + '</option>';

                    for (var i = 0; i < resultData.NXI.length; i++) {
                        var obj = resultData.NXI[i];

                        // Add any travel-quote branch to the list (except for the default if viewing this on NXI)

                        var appPath = "/contact-validator";
                        if (obj.context.indexOf(appPath) !== -1 && (obj.context === appPath && meerkat.site.environment === 'nxi') === false) {

                            var val = validatorBaseUrl + obj.context;
                            var selected = '';
                            if (val === localStorage.getItem("contact_validator")) {
                                selected = 'selected="true" ';
                            }

                            select += '<option value="' + val + '" ' + selected + '>NXI' + obj.context.toUpperCase() + '</option>';
                        }
                    }

                    select += '</select></label>';
                    $validatorEngineContainer.html(select);

                    $("#environmentValidatorOverride").val(localStorage.getItem("contact_validator"));

                    $("#developmentValidatorEnvironment").change(function onDevEnvChange(eventObject) {
                        localStorage.setItem("contact_validator", $("#developmentValidatorEnvironment").val());
                        $("#environmentValidatorOverride").val($("#developmentValidatorEnvironment").val());
                    });


                }
            });

        }

        // Static Content
        if (hasStaticBranches()) {
            $staticBranchesContainer.show();
            $staticBranchesContainer.html('Loading static content...');

            var staticBaseUrl = "http://web-ctm-dev.ctm.cloud.local:8080"; // for NXI


            meerkat.modules.comms.get({
                url: staticBaseUrl + "/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = '<label>Static Branches: <select id="developmentStaticBranches"><option value="">' + meerkat.site.environment.toUpperCase() + '</option>';

                    for (var i = 0; i < resultData.NXI.length; i++) {
                        var obj = resultData.NXI[i];

                        var staticBranchPath = "/static_";
                        if (obj.context.indexOf(staticBranchPath) !== -1 && (obj.context === staticBranchPath && meerkat.site.environment === 'nxi') === false) {

                            var val = obj.context;
                            var selected = '';
                            if (val === localStorage.getItem("staticBranches_" + meerkat.site.vertical)) {
                                selected = 'selected="true" ';
                            }

                            select += '<option value="' + val + '" ' + selected + '>NXI' + obj.context.toUpperCase() + '</option>';
                        }
                    }

                    select += '</select></label>';
                    $staticBranchesContainer.html(select);

                    var changeEvent = function onDevEnvChange(eventObject) {
                        localStorage.setItem("staticBranch_" + meerkat.site.vertical, $("#developmentStaticBranches").val());
                        $('body').find('a').each(function () {
                            $e = $(this);
                            var href = $e.attr("href");
                            if (href && !_.isEmpty(href)) {
                                var branch = $("#developmentStaticBranches").val();
                                var re = [
                                    // Fix URLs with existing static path
                                    new RegExp("\/static(((\_){1})([A-Z]{1,6})(-{1})([0-9]+))?\/", ""),
                                    // Fix health brochure links with existing static path
                                    new RegExp("\&staticBranch\=\/static(((\_){1})([A-Z]{1,6})(-{1})([0-9]+))?", "")
                                ];
                                href = href.replace(re[0], branch + "/").replace(re[1], "&staticBranch=" + branch);

                                // Test for health brochures that don't have a static path
                                if (/^health\_brochure\.jsp\?((\S)+)\.pdf$/.test(href)) {
                                    href += "&staticBranch=" + branch;
                                }

                                // Apply amended HREF
                                $e.attr("href", href);
                            }
                        });
                    };

                    $("#developmentStaticBranches").change(changeEvent);
                    $('body').change(changeEvent);
                }
            });
        }

        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateDevTransId(eventObject) {
            $transactionIdHolder.text(eventObject.transactionId);
        });
    }

    // Initialise Dev helpers
    function initDevelopment() {

        if (meerkat.site.isDev === true) {

            initRefreshCSS();

            $(document).ready(function ($) {
                initEnvironmentMonitor();
            });
        }

        if(!!window.LogRocket) {
            window.LogRocket.identify(meerkat.modules.transactionId.get());
        }
    }

    function getAggregationServicePromise() {
        return aggregationServicePromise;
    }

    meerkat.modules.register("development", {
        init: initDevelopment,
        getAggregationServicePromise: getAggregationServicePromise
    });

})(jQuery);