(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function init() {
        $(document).ready(function () {
            // Handle pre-filled
            toggleInboundOutbound();
            toggleDialogueInChatCallback();
            meerkat.modules.provider_testing.setApplicationDateCalendar();

            initDBDrivenCheckboxes();
            applyEventListeners();
            eventSubscriptions();
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
        var $healthContactType = $('input[name=health_simples_contactType]'),
            $healthCoverRebate = $('input[name=health_healthCover_rebate]'),
            $healthSituationCvr = $('select[name=health_situation_healthCvr]');

        $('.follow-up-call input:checkbox, .simples-privacycheck-statement input:checkbox').on('change', function () {
            toggleDialogueInChatCallback();
        });

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

    // Disable/enable follow up/New quote dialogue when the other checkbox ticked in Chat Callback sesction in simples
    function toggleDialogueInChatCallback() {
        var $followUpCallField = $('.follow-up-call input:checkbox'),
            $privacyCheckField = $('.simples-privacycheck-statement input:checkbox');

        if ($followUpCallField.is(':checked')) {
            $privacyCheckField.attr('checked', false);
            $privacyCheckField.prop('disabled', true);
            $('.simples-privacycheck-statement .error-field').hide();
        } else if ($privacyCheckField.is(':checked')) {
            $followUpCallField.attr('checked', false);
            $followUpCallField.prop('disabled', true);
            $('.follow-up-call .error-field').hide();
        } else {
            $privacyCheckField.prop('disabled', false);
            $followUpCallField.prop('disabled', false);
            $('.simples-privacycheck-statement .error-field').show();
            $('.follow-up-call .error-field').show();
        }
    }

    function toggleRebateDialogue(reducePremium) {
        var $dialogue56 = $('.simples-dialogue-56');

        $dialogue56.addClass('hidden');

        if (reducePremium === "Y") {
            $dialogue56.removeClass('hidden');
        }
    }

    meerkat.modules.register("simplesBindings", {
        init: init
    });

})(jQuery);