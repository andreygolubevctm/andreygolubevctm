(function ($, undefined) {

    $('.simples-dialogue.optionalDialogue h3.toggle').parent('.simples-dialogue').addClass('toggle').on('click', function() {
        $(this).find('h3 + div').slideToggle(200);
    });

})(jQuery);