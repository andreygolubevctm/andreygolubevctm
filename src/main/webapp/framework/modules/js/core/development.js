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

    function initEnvironmentMonitor(){
        $("#copyright").after('<div class="buildEnvInfo_div">' +
            '<ul><li class="devEnv"></li><li>Transaction ID: <span class="devTransactionId"></span></li>' +
            '<li class="devService"></li><li>Revision #: <span class="devRevisionId"></span></li>' +
            '<li class="devService"><a href="data.jsp" target="_blank">View data bucket</a></li>' +
            '<li class="devService aggEngine">Unable to change aggregation engine</li>' +
            '</ul></div>');

        // $(".navMenu-row").before
        $transactionIdHolder = $(".devTransactionId");
        $environmentHolder = $(".devEnv");
        $revisionHolder = $(".devRevisionId");

        $transactionIdHolder.text(meerkat.modules.transactionId.get());
        $environmentHolder.text(meerkat.site.environment);
        $environmentHolder.addClass(meerkat.site.environment);
        $revisionHolder.text(meerkat.site.revision);



        if(meerkat.site.vertical === 'travel'){
            $aggEngineContainer = $('.aggEngine');

            $aggEngineContainer.html('Loading aggregators...');

            meerkat.modules.comms.get({
                url: "http://taws01_ass3:8080/launcher/wars",
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "fatal",
                onSuccess: function onSubmitSuccess(resultData) {

                    var select = 'Aggregation engine: <select><option value="">Default</option>';

                    for(var i = 0; i<resultData.NXI.length; i++){
                        var obj = resultData.NXI[i];
                        if(obj.context.lastIndexOf("travel-quote", 0) !== -1){
                            select += '<option value="'+obj.context+'">'+obj.context+'</option>';
                        }
                    }

                    select += '</select>';
                    $aggEngineContainer.html(select);
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
            jQuery(document).ready(function($) {
                initEnvironmentMonitor();
            });
        }
    }

    meerkat.modules.register("development", {
        init: initDevelopment
    });

})(jQuery);