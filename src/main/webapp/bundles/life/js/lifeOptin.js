;(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {};

    var $contactDetailsCall,
        $contactDetailsOptin,
        $contactDetailsEmail,
        $contactDetailsNumberInput;

    function initLifeOptin() {
        _initFields();
        _initEventListeners();
    }

    function _initFields() {
        $contactDetailsCall = $('#life_contactDetails_call');
        $contactDetailsOptin = $('#life_contactDetails_optIn');
        $contactDetailsEmail = $('#life_contactDetails_email');
        $contactDetailsNumberInput = $('#life_contactDetails_contactNumberinput');

        if( String($contactDetailsNumberInput.val()).length ) {
            $contactDetailsNumberInput.trigger("blur");
        }
    }

    function _initEventListeners() {
        var life_contactDetails_original_phone_number = $('#life_contactDetails_contactNumber').val();

        $contactDetailsNumberInput.on('update keypress blur', function(){
            var $me = $(this),
                tel = $me.val();

            $contactDetailsCall.val( tel.length && tel != $me.attr('placeholder') ? 'Y' : 'N' );

            if(!tel.length || life_contactDetails_original_phone_number != tel){
                $contactDetailsCall.find('label[aria-pressed="true"]').each(function(key, value){
                    var $this = $(this);
                    $this.attr("aria-pressed", "false");
                    $this.removeClass("ui-state-active");
                    $('#' + $this.attr("for")).removeAttr("checked");
                });
            }

            life_contactDetails_original_phone_number = tel;
        });

        // competition
        $('#life_contactDetails_competition_optin[type="checkbox"]').on('change', function(e){
            if(this.checked) {
                // Opt In -- Unset phone number as mandatory field
                $contactDetailsNumberInput.setRequired(true);
            } else {
                // Opt Out -- Unset phone number as mandatory field
                $contactDetailsNumberInput.setRequired(false).valid();
            }
        });
/* NOT SURE IF THIS IS REQUIRED ANYMORE
        $contactDetailsOptin.change(function() {
            $(document).trigger(SaveQuote.setMarketingEvent, [$(this).attr('checked'), $contactDetailsEmail.val()]);
        });

        $contactDetailsEmail.change(function() {
            $(document).trigger(SaveQuote.setMarketingEvent, [$contactDetailsOptin.attr('checked'), $(this).val()]);
        });*/

    }

    meerkat.modules.register("lifeOptin", {
        init: initLifeOptin,
        events: events
    });
})(jQuery);