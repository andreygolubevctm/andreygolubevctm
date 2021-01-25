;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {};

    function init() {
        $(document).ready(function () {
            $('#benefitsForm').find('.benefit-label-container').each(function(){
                var $this = $(this);
                var $btn = $this.find('.benefit-toggle a');
                var $copy = $this.find('.benefit-description');
                $btn.on("click.toggle", function () {
                    var isToggled = $copy.is(':visible');
                    $(this).toggleClass('toggled', !isToggled);
                    $copy[isToggled ? 'removeClass' : 'addClass']('in', {duration:200});
                });
            });

            _eventSubscriptions();
        });
    }

    function _eventSubscriptions() {}

    meerkat.modules.register('healthBenefitsRowToggle', {
        init: init,
        events: moduleEvents
    });

})(jQuery);