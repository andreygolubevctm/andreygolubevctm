;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    var events = {
            healthSnapshot: {
                RENDER_HEALTH_SNAPSHOT : "RENDER_HEALTH_SNAPSHOT"
            }
        },
        moduleEvents = events.healthSnapshot;


    function initHealthSnapshot() {
        $(document).ready(function(){
            elements = {
                preResultsTemplate : $("#pre-results-row-content-template"),
                primaryDob : $('#health_healthCover_primary_dob'),
                contactName : $('#health_contactDetails_name'),
                state : $('#health_situation_state'),
                suburb : $('#health_situation_suburb'),
                situation : $('#health_situation_healthCvr'),
                dependants : $('#health_healthCover_dependants')
            };
        });
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
        meerkat.messaging.subscribe(meerkat.modules.events.RESULTS_SORTED, function renderSnapshotOnJourneyReadySubscription() {
            _.defer(function() {
                renderSnapshot();
            });
        });
    }

    function renderSnapshot() {
        meerkat.modules.contentPopulation.render('.quoteSnapshot');
        _.defer(render);
    }

    function showHide(data, selector, property, forceHide) {
        $(selector).each(function(){
            $(this)[_.isEmpty(data[property]) ? "hide" : "show"]();
        });
    }

    function render() {
        var data = getData();
        var noData = !hasData(data),
            $box, i;
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

        if(!noData && !_.isEmpty(data.coverType)) {
            $('.cover-type .snapshot-items').text(data.coverType);
        }

        // Populate hospital/extras
        if(!noData && !_.isEmpty(data.hospital)) {
            $box = $('.quoteSnapshot .hospital .snapshot-list');
            $box.empty();
            for(i = 0; i < data.hospital.length; i++) {
                $box.append(
                    $("<li/>").append(data.hospital[i])
                );
            }
        }
        if(!noData && !_.isEmpty(data.extras)) {
            $box = $('.quoteSnapshot .extras .snapshot-list');
            $box.empty();
            for(i = 0; i < data.extras.length; i++) {
                $box.append(
                    $("<li/>").append(data.extras[i])
                );
            }
        }
        // Toggle benefits rows.
        showHide(data,'.quoteSnapshot .hospital','hospital', noData);
        showHide(data,'.quoteSnapshot .extras','extras', noData);

        $('.quoteSnapshot').toggle(!noData && meerkat.modules.journeyEngine.getCurrentStepIndex() < 3);
    }

    function getData() {
        var coverFor = $("#health_situation_healthCvr").val();
        var livingIn = $("#health_situation_location").val();
        var lookingTo = $.trim($("input[name=health_situation_healthSitu]").filter(":checked").closest('label').text());
        var coverType = $("#health_situation_coverType input:checked").parent().text();
        var tieredCoverType = $('#health_situation_coverType input').filter(":checked").val();
        var hospital = fetchAllHospitalCheckedValues(tieredCoverType);
        var extras = fetchAllExtrasCheckedValues(tieredCoverType);

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

    function fetchAllHospitalCheckedValues(coverType) {
        var list = [];
        if(_.indexOf(["C","H"], coverType) >= 0) {
            $(".Hospital_container").find(':checked').each(function (item) {
                var label = $.trim($(this).next('label').find('span.iconLabel').text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }

            });
            $(".Hospital_container .noIcons").find(':checked').each(function (item) {
                var label = $.trim($($(this).next('label').contents()[0]).text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }
            });
        }
        return list;
    }

    function fetchAllExtrasCheckedValues(coverType) {
        var list = [];
        if(_.indexOf(["C","E"], coverType) >= 0) {
            $(".GeneralHealth_container").find(':checked').each(function (item) {
                var label = $.trim($(this).next('label').find('span.iconLabel').text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }
            });
            $(".GeneralHealth_container .noIcons").find(':checked').each(function (item) {
                var label = $.trim($($(this).next('label').contents()[0]).text());
                if (!_.isEmpty(label)) {
                    list.push(label);
                }
            });
        }
        return list;
    }

    /**
     * Utility function to map cover type to a label.
     * @returns {*}
     */
    function getLabelForCoverType() {
        switch(meerkat.modules.health.getCoverType()) {
            case 'C':
                return "Hospital and Extras";
            case 'H':
                return "Hospital";
            case 'E':
                return "Extras";
        }
        return "";
    }

    /**
     * Utility function to map situation to a label.
     * @returns {*}
     */
    function getLabelForSituation() {
        var situationCopy = '';
        var situationCopySuffix = '';
        var situation = meerkat.modules.health.getSituation();
        if(!_.isEmpty(situation)) {
            situationCopy = elements.situation.find("option[value='" + situation + "']").text();
            situationCopySuffix = '';
            if (situation === 'SPF') {
                var dependants = elements.dependants.val();
                if(!_.isEmpty(dependants)) {
                    var childrenLabel = dependants + ' ' + (parseInt(dependants, 10) > 1 ? 'children' : 'child');
                situationCopySuffix = " (" + childrenLabel + ")";
                }
            }
        }
        return situationCopy + situationCopySuffix;
    }
    
    function renderPreResultsRowSnapshot() {
        var primary_dob = elements.primaryDob.val();
        var age = meerkat.modules.age.returnAge(primary_dob, true);

        var obj = {
            name: elements.contactName.val(),
            state: elements.state.val(),
            age: age,
            suburb: elements.suburb.val(),
            situation: getLabelForSituation()
        };
        var template = meerkat.modules.templateCache.getTemplate(elements.preResultsTemplate);
        $('.preResultsContainer').html(template(obj));
    }

    meerkat.modules.register('healthSnapshot', {
        init:initHealthSnapshot,
        renderPreResultsRowSnapshot: renderPreResultsRowSnapshot
    });

})(jQuery);