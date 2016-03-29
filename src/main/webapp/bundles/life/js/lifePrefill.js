;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var occupationsPrefilled = false;

    function occupations() {
        if(!occupationsPrefilled) {
            $('#life_primary_occupation, #life_partner_occupation').each(function() {
                var $this = $(this);
                if(!!$this.val()) {
                    // Get the pluralised field
                    var $displayField = $this.parents('.row-content').find('#' + $this.attr('id') + 's');

                    if(!!occupationSelectionList) {
                        var selectedOccupation = occupationSelectionList.filter(function (val) {
                            return val.code === $this.val();
                        });

                        if(_.isArray(selectedOccupation) && selectedOccupation.length) {
                            $displayField.typeahead('setQuery', selectedOccupation[0].description);
                        }
                    }
                }
            });

            occupationsPrefilled = true;
        }
    }

    meerkat.modules.register("lifePrefill", {
        occupations: occupations,
        events: events
    });
})(jQuery);