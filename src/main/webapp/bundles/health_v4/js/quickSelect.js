/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
       $elements = {};

    function init() {
        $elements = {
            quickSelect: $('.quickSelect'),
            hospital: $('.Hospital_container'),
            extras: $('.GeneralHealth_container')
        };

        _eventSubscription();
    }

    function _eventSubscription() {
        $elements.quickSelect.on('click', 'a', function preSelectBenefits(){
            var $this = $(this),
                selectType = $this.data('select-type');

                // update the model if we're updating a health benefit
                meerkat.modules.benefitsModel.setIsHospital($this.closest($elements.hospital).length === 1);

                _addDefaultBenefits(selectType);
        });
    }

    function _addDefaultBenefits(selectType) {


        var defaultSelections = meerkat.modules.benefitsModel.getDefaultSelections(selectType),
            benefitType = meerkat.modules.benefitsModel.getBenefitType();

            // update the dom with the selected benefits
            _.each(defaultSelections, function addDefaultBenefits(id) {
                $elements[benefitType].find('[data-benefit-id='+id+']').prop('checked', 'checked');
            });

            // update the model with all the selected benefits
            meerkat.modules.benefitsModel.updateBenefits();
    }

    meerkat.modules.register("quickSelect", {
        init : init
    });

})(jQuery);