;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        msg = meerkat.messaging;

    // Refresh just the css when shift+s is pressed
    function initRefreshCSS(){
        function refreshStyles(event){
            var target = event.target,
                tagName = target.tagName.toLowerCase(),
                linkTags;

            if(!(event.shiftKey && event.which === 83)){
                return;
            }

            if(tagName === "input" || tagName === "textarea" || tagName === "select"){
                return;
            }

            linkTags = document.getElementsByTagName('link');

            //http://david.dojotoolkit.org/recss.html
            for(var i = 0; i < linkTags.length ; i++){
                var linkTag = linkTags[i];
                if(linkTag.rel.toLowerCase().indexOf('stylesheet')>=0){
                    var href = linkTag.getAttribute('href');
                    href = href.replace(/(&|\?)forceReload=\d+/,'');
                    href = href + (href.indexOf('?')>=0?'&':'?') + 'forceReload=' + new Date().getTime();
                    linkTag.setAttribute('href',href);
                }
            }
        }

        if(window.addEventListener){
            window.addEventListener('keypress', refreshStyles);
        }
    }

    function hasAggregationService(){
        if(meerkat.site.vertical === 'travel' || meerkat.site.vertical === 'car' || meerkat.site.vertical === 'home' ||
            meerkat.site.vertical === 'health'){
            return true;
        }
        return false;
    }

    function hasApplicationService(){
        if(meerkat.site.vertical === 'health'){
            return true;
        }
        return false;
    }

    function initEnvironmentMonitor(){

        // Build information bar
        $("#copyright").after('<div class="buildEnvInfo_div">' +
            '<ul><li class="devEnv"></li>' +
            '<li>Transaction ID: <span class="devTransactionId"></span></li>' +
            '<li>Revision #: <span class="devRevisionId"></span></li>' +
            '<li class="devService"><a href="data.jsp" target="_blank">View data bucket</a></li>' +
            '<li class="devService aggEngine"></li>' +
            '<li class="devService applyEngine"></li>' +
            '</ul></div>');

        // Populate information bar
        var $transactionIdHolder = $(".devTransactionId");
        var $environmentHolder = $(".devEnv");
        var $revisionHolder = $(".devRevisionId");

        $transactionIdHolder.text(meerkat.modules.transactionId.get());
        $environmentHolder.text(meerkat.site.environment).addClass(meerkat.site.environment);
        $revisionHolder.text(meerkat.site.revision);

        // Add aggregation service switcher (
        if(hasAggregationService() === true){

            var $aggEngineContainer = $('.aggEngine');
            $aggEngineContainer.html('Loading aggregators...');

            var aggregationBaseUrl = "http://taws01_ass3:8080"; // for NXI


            meerkat.modules.comms.get({
                url: aggregationBaseUrl+"/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = '<label>Aggregation service: <select id="developmentAggregatorEnvironment"><option value="">'+meerkat.site.environment.toUpperCase()+'</option>';

                    for(var i = 0; i<resultData.NXI.length; i++){
                        var obj = resultData.NXI[i];

                        // Add any travel-quote branch to the list (except for the default if viewing this on NXI)

                        var vertical = meerkat.site.vertical;
                        if (vertical === 'home') {
                            vertical = 'homecontents';
                        }

                        var verticalQuoteAppPath = "/"+ vertical +"-quote";
                        if(obj.context.indexOf(verticalQuoteAppPath) !== -1 && (obj.context === verticalQuoteAppPath && meerkat.site.environment === 'nxi') === false){

                            var val = aggregationBaseUrl+obj.context;
                            var selected = '';
                            if(val === localStorage.getItem("aggregationService_"+meerkat.site.vertical)){
                                selected = 'selected="true" ';
                            }

                            select += '<option value="'+val+'" '+selected+'>NXI'+obj.context.toUpperCase()+'</option>';
                        }
                    }

                    select += '</select></label>';
                    $aggEngineContainer.html(select);

                    $("#developmentAggregatorEnvironment").change(function onDevEnvChange(eventObject){
                        localStorage.setItem("aggregationService_"+meerkat.site.vertical, $("#developmentAggregatorEnvironment").val());
                    });


                }
            });

        }

        // Add application service switcher (
        if(hasApplicationService() === true){

            var $applicationEngineContainer = $('.applyEngine');
            $applicationEngineContainer.html('Loading application services...');

            var applicationBaseUrl = "http://taws01_ass3:8080"; // for NXI


            meerkat.modules.comms.get({
                url: applicationBaseUrl+"/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = '<label>Application service: <select id="developmentApplicationEnvironment"><option value="">'+meerkat.site.environment.toUpperCase()+'</option>';

                    for(var i = 0; i<resultData.NXI.length; i++){
                        var obj = resultData.NXI[i];

                        // Add any travel-quote branch to the list (except for the default if viewing this on NXI)

                        var vertical = meerkat.site.vertical;

                        var verticalQuoteAppPath = "/"+ vertical +"-apply";
                        if(obj.context.indexOf(verticalQuoteAppPath) !== -1 && (obj.context === verticalQuoteAppPath && meerkat.site.environment === 'nxi') === false){

                            var val = applicationBaseUrl+obj.context;
                            var selected = '';
                            if(val === localStorage.getItem("applicationService_"+meerkat.site.vertical)){
                                selected = 'selected="true" ';
                            }

                            select += '<option value="'+val+'" '+selected+'>NXI'+obj.context.toUpperCase()+'</option>';
                        }
                    }

                    select += '</select></label>';
                    $applicationEngineContainer.html(select);

                    $("#developmentApplicationEnvironment").change(function onDevEnvChange(eventObject){
                        localStorage.setItem("applicationService_"+meerkat.site.vertical, $("#developmentApplicationEnvironment").val());
                    });


                }
            });

        }

        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateDevTransId(eventObject) {
            $transactionIdHolder.text(eventObject.transactionId);
        });
    }

    // Initialise Dev helpers
    function initDevelopment() {

        if(meerkat.site.isDev === true){

            initRefreshCSS();

            $(document).ready(function($) {
                initEnvironmentMonitor();
            });
        }
    }

    meerkat.modules.register("development", {
        init: initDevelopment
    });

})(jQuery);