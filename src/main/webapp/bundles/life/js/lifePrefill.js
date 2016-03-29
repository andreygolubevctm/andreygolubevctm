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
                    // Get the tag list
                    var $list = $this.parents('.row').next('.row').find('.selected-tags');

                    if(!!occupationSelectionList) {
                        var selectedOccupation = occupationSelectionList.filter(function (val) {
                            return val.code === $this.val();
                        });

                        if(_.isArray(selectedOccupation) && selectedOccupation.length) {
                            var occ = selectedOccupation[0];
                            var descriptionHTML = meerkat.modules.selectTags.getHTML(occ.description);
                            meerkat.modules.selectTags.appendToTagList($list, descriptionHTML, occ.description, occ.code);
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