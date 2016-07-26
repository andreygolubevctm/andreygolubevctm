(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    $('.simples-dialogue.optionalDialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function() {
        $(this).find('h3 + div').slideToggle(200);
    });

    meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.SHOW, function() {
        $('.simples-dialogue-results').hide();
        $('.simples-dialogue-more-info').show();
    });

    meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.HIDE, function() {
        $('.simples-dialogue-more-info').hide();
        $('.simples-dialogue-results').show();
    });

})(jQuery);