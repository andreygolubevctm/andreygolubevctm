(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $healthCoverRebate;

    function init() {
        $(document).ready(function () {
            $healthCoverRebate = $('input[name=health_healthCover_rebate]');

            // Handle pre-filled
            toggleInboundOutbound();
            toggleDialogueInChatCallback();
            meerkat.modules.provider_testing.setApplicationDateCalendar();

            $('.follow-up-call input:checkbox, .simples-privacycheck-statement input:checkbox').on('change', function () {
                toggleDialogueInChatCallback();
            });

            // Handle toggle inbound/outbound
            $('input[name=health_simples_contactType]').on('change', function () {
                toggleInboundOutbound();
            });

            $healthCoverRebate.on('change', function () {
                toggleRebateDialogue($(this).val());
            });

            $('select[name=health_situation_healthCvr]').on('change', function toggleAboutYouFields() {
                toggleRebateDialogue($healthCoverRebate.val());
            });

            $('.simples-dialogue.optionalDialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function () {
                $(this).find('h3 + div').slideToggle(200);
            });

            meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.SHOW, function () {
                $('.simples-dialogue-results').hide();
                $('.simples-dialogue-more-info').show();
            });

            meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.HIDE, function () {
                $('.simples-dialogue-more-info').hide();
                $('.simples-dialogue-results').show();
            });
        });
    }

    // Hide/show simple dialogues when toggle inbound/outbound in simples journey
    function toggleInboundOutbound() {
        // Inbound
        if ($('#health_simples_contactType_inbound').is(':checked')) {
            $('body')
                .removeClass('outbound')
                .addClass('inbound');
        }
        // Outbound
        else {
            $('body')
                .removeClass('inbound')
                .addClass('outbound');
        }
    }

    // Disable/enable follow up/New quote dialogue when the other checkbox ticked in Chat Callback sesction in simples
    function toggleDialogueInChatCallback() {
        var $followUpCallField = $('.follow-up-call input:checkbox');
        var $privacyCheckField = $('.simples-privacycheck-statement input:checkbox');

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
        var $dialogue55 = $('.simples-dialogue-55'),
            $dialogue56 = $('.simples-dialogue-56');

        $dialogue55.addClass('hidden');
        $dialogue56.addClass('hidden');

        if (reducePremium === "Y") {
            switch (meerkat.modules.health.getSituation()) {
                case 'SM':
                case 'SF':
                    $dialogue55.removeClass('hidden');
                    break;
                case 'C':
                case 'F':
                    $dialogue56.removeClass('hidden');
                    break;
            }
        }
    }

    meerkat.modules.register("simplesBindings", {
        init: init
    });

})(jQuery);