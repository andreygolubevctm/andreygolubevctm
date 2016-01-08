/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info,
        meerkatEvents = meerkat.modules.events;

    var events = {
            healthSnapshot: {
                RENDER_HEALTH_SNAPSHOT : "RENDER_HEALTH_SNAPSHOT"
            }
        },
        moduleEvents = events.healthSnapshot;


    function initHealthSnapshot() {
        subscription();

    }

    function subscription() {

        // Initial render
        meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.BEFORE_STEP_CHANGED, function renderSnapshotOnJourneyReadySubscription() {
            console.log("inside subscription block");
            _.defer(function() {
                renderStep1();
                renderCovertype();
                renderBenefits();
                renderExtras();
                meerkat.modules.contentPopulation.render('.quoteSnapshot');
            });
        });

    }

    function renderBenefits() {
        var list = fetchAllHospitalCheckedValues();
        var coverTypeValue = $("#health_situation_coverType").val();
        var renderIt = false;
        if( !_.isEmpty(coverTypeValue) && (coverTypeValue === 'C' || coverTypeValue === 'H' )) {
            renderIt = true;
        }
        var template = _.template($("#snapshots-benefits-template").html()),
            data = {};
        data.benefitList = list;
        data.renderIt = renderIt;
        var html = template(data);
        console.log("the html is:"+html);
        $(".snapshots-benefits-container").html(html);
    }

    function renderExtras() {
        var list =  fetchAllExtrasCheckedValues();
        var coverTypeValue = $("#health_situation_coverType").val();
        var renderIt = false;
        if( !_.isEmpty(coverTypeValue) && (coverTypeValue === 'C' || coverTypeValue === 'E' )) {
            renderIt = true;
        }
        var template = _.template($("#snapshots-extras-template").html()),
            data = {};
        data.extrasList = list;
        data.renderIt = renderIt;
        var html = template(data);
        $(".snapshots-extras-container").html(html);

    }



    function fetchAllHospitalCheckedValues() {
        var list = [];
        $(".Hospital_container").find(':checked').each(function(item) {
            var $this = $(this);
            var label = $this.next('label').find('span.iconLabel').text();
            list.push(label);

        });
        return list;
    }

    function fetchAllExtrasCheckedValues() {
        var list = [];
        $(".GeneralHealth_container").find(':checked').each(function(item) {
            var $this = $(this);
            var label = $this.next('label').find('span.iconLabel').text();
            list.push(label);
        });
        return list;
    }

    function renderCovertype() {
        var coverTypeValue = $("#health_situation_coverType").val();
        var renderIt = false;
        if(!_.isEmpty(coverTypeValue) && (coverTypeValue === 'C' || coverTypeValue === 'E' || coverTypeValue === 'H') ) {
            renderIt = true;
        }
        var template = _.template($("#snapshots-covertype-template").html());
            data = {};
        data.renderIt = renderIt;
        var html = template(data);
        $(".snapshots-covertype-container").html(html);

    }

    function renderStep1() {
        var coverFor = $("#health_situation_healthCvr").val();
        var location = $("#health_situation_location").val();
        var lookingFor = $("#health_situation_healthSitu").val();
        var $mainHeaderText = $(".quoteSnapshot > h4").first();

        var renderAll = false;
        var comingFromWebsite =  false;
        if(!_.isEmpty(coverFor) && !_.isEmpty(location) && _.isEmpty(lookingFor) ) {
            comingFromWebsite = true;
            $mainHeaderText.text("Quote Summary");
        }
        if(!_.isEmpty(coverFor) && !_.isEmpty(location) && !_.isEmpty(lookingFor) ) {
            renderAll = true;
            $mainHeaderText.text("Quote Summary");
        }
        else  {
            $mainHeaderText.text("Who we compare");
        }

        var template = _.template($("#snapshots-step1-template").html());
            data = {};
        data.comingFromWebsite = comingFromWebsite;
        data.renderAll = renderAll;
        var html = template(data);
        $(".snapshots-step1-container").html(html);

    }




    meerkat.modules.register('healthSnapshot', {
        init:initHealthSnapshot


    });

})(jQuery);