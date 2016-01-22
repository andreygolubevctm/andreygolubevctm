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
            _.defer(function() {
                renderSnapshot();
            });
        });
         meerkat.messaging.subscribe(meerkat.modules.events.health.SNAPSHOT_FIELDS_CHANGE, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                renderSnapshot();
            });
        });
    }

    function renderSnapshot() {
        render();
        meerkat.modules.contentPopulation.render('.quoteSnapshot');
    }

    function showHide(data, selector, property, forceHide) {
        $(selector).each(function(){
            $(this)[_.isEmpty(data[property]) ? "hide" : "show"]();
        });
    }

    function render() {
        var data = getData();
        var noData = !hasData(data);
        // Toggle the panel title
        $('.quoteSnapshot > h4').first().text(noData ? "Who we compare" : "Quote Summary");
        // Toggle the default summary text
        $('.quoteSnapshot .default').each(function(){
            $(this)[noData ? "show" : "hide"]();
        });
        // Toggle normal content rows
        showHide(data,'.quoteSnapshot .cover-for','coverFor', noData);
        showHide(data,'.quoteSnapshot .living-in','livingIn', noData);
        showHide(data,'.quoteSnapshot .looking-to','lookingTo', noData);
        showHide(data,'.quoteSnapshot .cover-type','coverType', noData);
        // Populate hospital/extras
        if(!noData && !_.isEmpty(data.hospital)) {
            var $box = $('.quoteSnapshot .hospital .snapshot-list');
            $box.empty();
            for(var i = 0; i < data.hospital.length; i++) {
                $box.append(
                    $("<li/>").append(data.hospital[i])
                );
            }
        }
        if(!noData && !_.isEmpty(data.extras)) {
            var $box = $('.quoteSnapshot .extras .snapshot-list');
            $box.empty();
            for(var i = 0; i < data.extras.length; i++) {
                $box.append(
                    $("<li/>").append(data.extras[i])
                );
            }
        }
        // Toggle benefits rows
        showHide(data,'.quoteSnapshot .hospital','hospital', noData);
        showHide(data,'.quoteSnapshot .extras','extras', noData);
    }

    function getData() {
        var coverFor = $("#health_situation_healthCvr").val();
        var livingIn = $("#health_situation_location").val();
        var lookingTo = $("#health_situation_healthSitu").val();
        var coverType = $("#health_situation_coverType").val();
        var hospital = fetchAllHospitalCheckedValues();
        var extras = fetchAllExtrasCheckedValues();
        return {
            coverFor : _.isEmpty(coverFor) ? false : coverFor,
            livingIn : _.isEmpty(livingIn) ? false : livingIn,
            lookingTo : _.isEmpty(lookingTo) ? false : lookingTo,
            coverType : _.isEmpty(coverType) ? false : coverType,
            hospital : _.isEmpty(hospital) ? false : hospital,
            extras : _.isEmpty(extras) ? false : extras
        };
    }

    function hasData(data) {
        var props = _.keys(data);
        for(var i=0; i < props.length; i++) {
            if(!_.isEmpty(data[props[i]])) {
                return true;
            }
        }
        return false;
    }

    function fetchAllHospitalCheckedValues() {
        var list = [];
        $(".Hospital_container").find(':checked').each(function(item) {
            var label = $.trim($(this).next('label').find('span.iconLabel').text());
            if(!_.isEmpty(label)) {
                list.push(label);
            }

        });
        $(".Hospital_container .noIcons").find(':checked').each(function(item) {
            var label = $.trim($($(this).next('label').contents()[0]).text());
            if(!_.isEmpty(label)) {
                list.push(label);
            }
        });
        return list;
    }

    function fetchAllExtrasCheckedValues() {
        var list = [];
        $(".GeneralHealth_container").find(':checked').each(function(item) {
            var label = $.trim($(this).next('label').find('span.iconLabel').text());
            if(!_.isEmpty(label)) {
                list.push(label);
            }
        });
        $(".GeneralHealth_container .noIcons").find(':checked').each(function(item) {
            var label = $.trim($($(this).next('label').contents()[0]).text());
            if(!_.isEmpty(label)) {
                list.push(label);
            }
        });
        return list;
    }

    meerkat.modules.register('healthSnapshot', {
        init:initHealthSnapshot
    });

})(jQuery);