(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var $healthContactType,
        $healthCoverRebate,
        $healthSituationCvr,
        $healthSitCoverType;

    function init() {
        $(document).ready(function () {
            // cache selectors
            $healthContactType = $('input[name=health_simples_contactType]');
            $healthCoverRebate = $('input[name=health_healthCover_rebate]');
            $healthSituationCvr = $('select[name=health_situation_healthCvr]');
            $healthSitCoverType = $('#health_situation_coverType');

            // Handle pre-filled
            toggleInboundOutbound();
            toggleBenefitsDialogue();
            initDBDrivenCheckboxes();
            applyEventListeners();
            eventSubscriptions();

            meerkat.modules.provider_testing.setApplicationDateCalendar();
        });
    }

    // Check dynamic checkboxes on preload=true
    function initDBDrivenCheckboxes() {
        if (!meerkat.site.hasOwnProperty('simplesCheckboxes')) return;

        var simplesObj = meerkat.site.simplesCheckboxes.simples;
        if (!_.isEmpty(simplesObj)) {
            for (var key in simplesObj) {
                var $element = $('#health_simples_' + key);
                if($element.is(':checkbox')) {
                    $element.prop('checked', simplesObj[key] === 'Y');
                }
            }
        }
    }

    function applyEventListeners() {

        // Handle toggle inbound/outbound
        $healthContactType.on('change', function () {
            toggleInboundOutbound();
        });

        $healthCoverRebate.on('change', function () {
            toggleRebateDialogue($(this).val());
        });

        $healthSituationCvr.on('change', function() {
            toggleRebateDialogue($healthCoverRebate.val());
        });

        $('.simples-dialogue.optionalDialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function () {
            $(this).find('h3 + div').slideToggle(200);
        });

        $healthSitCoverType.on('change', toggleBenefitsDialogue);
    }

    function eventSubscriptions() {
        var $simplesResults = $('.simples-dialogue-results'),
            $simplesMoreInfo = $('.simples-dialogue-more-info');

        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.SHOW, function () {
            $simplesResults.hide();
            $simplesMoreInfo.show();
        });

        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.HIDE, function () {
            $simplesMoreInfo.hide();
            $simplesResults.show();
        });
    }

    // Hide/show simple dialogues when toggle inbound/outbound in simples journey
    function toggleInboundOutbound() {
        var $body = $('body');

        // Inbound
        if ($('#health_simples_contactType_inbound').is(':checked')) {
            $body
                .removeClass('outbound')
                .addClass('inbound');
        }
        // Outbound
        else {
            $body
                .removeClass('inbound')
                .addClass('outbound');
        }
    }

    function toggleRebateDialogue(reducePremium) {
        var $dialogue56 = $('.simples-dialogue-56');

        $dialogue56.addClass('hidden');

        if (reducePremium === "Y") {
            $dialogue56.removeClass('hidden');
        }
    }

    function toggleBenefitsDialogue() {
        var $hospitalScripts = $('.simples-dialogue-hospital-cover'),
            $extrasScripts = $('.simples-dialogue-extras-cover');

        switch ($healthSitCoverType.find('input:checked').val().toLowerCase()) {
            case 'c':
                $hospitalScripts.show();
                $extrasScripts.show();
                break;
            case 'h':
                $hospitalScripts.show();
                $extrasScripts.hide();
                break;
            case 'e':
                $hospitalScripts.hide();
                $extrasScripts.show();
                break;
            default:
                $hospitalScripts.hide();
                $extrasScripts.hide();
                break;
        }
    }

    meerkat.modules.register("simplesBindings", {
        init: init
    });

})(jQuery);