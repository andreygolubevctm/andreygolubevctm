;(function($, undefined){

    /**
     * checkboxIE8 modularises the javascript previously location in the field_new:checkbox tag.
     * It applies the listener onLoad however also provides a method to allow it to be called
     * when a checkbox is dynamically generated.
     **/

    var meerkat = window.meerkat,
        meerkatEvents =  meerkat.modules.events;


    function init(){
        $(document).ready(support);
    }

    function support() {
        // Limit selection to forms and modals
        $forms = $('html.lt-ie9 form, html.lt-ie9 #dynamic_dom');

        if($forms.length) {
            // Add listener to checkboxes
            $forms.off('change.checkedForIE').on('change.checkedForIE', '.checkbox input, .compareCheckbox input', function applyCheckboxClicks() {
                var $this = $(this);
                if ($this.is(':checked')) {
                    $this.addClass('checked');
                }
                else {
                    $this.removeClass('checked');
                }
            });

            // Trigger listener on existing elements to set initial state
            $forms.find('.checkbox input').change();
        }
    }

    meerkat.modules.register("checkboxIE8", {
        init: init,
        support: support
    });

})(jQuery);