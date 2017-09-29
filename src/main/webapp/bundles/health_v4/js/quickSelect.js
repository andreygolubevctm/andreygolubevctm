/**
 * Description: Preselects benefits for benefits step. Can't defer this file otherwise it throws an error for those modules that subscribe to the CLEAR_BENEFITS events
 */

(function($, undefined) {

    var meerkat = window.meerkat,
        events = {
            quickSelect: {
                CLEAR_BENEFITS: 'CLEAR_BENEFITS'
            },
            benefits: {
                BENEFIT_SELECTED: 'BENEFIT_SELECTED'
            }
        },
        quickSelect = events.quickSelect,
        benefitEvents = events.benefits,
        $elements = {};

    function init() {
        $elements = {
            quickSelect: $('.quickSelect'),
            clear: $('.quickSelectContainer .clearSelection'),
            hospital: $('.Hospital_container')
        };

        _eventSubscription();
    }

    function _eventSubscription() {
        // quick selection options
        $elements.quickSelect.on('click', 'a', function preSelectBenefits(){
            var $this = $(this),
                isHospital = $this.closest($elements.hospital).length === 1,
                isBenefitsSwitchedOn = isHospital ?
                    meerkat.modules.benefitsSwitch.isHospitalOn() : meerkat.modules.benefitsSwitch.isExtrasOn();

            if (isBenefitsSwitchedOn) {
                var selectedItems = isHospital ? meerkat.modules.benefitsModel.getHospital() : meerkat.modules.benefitsModel.getExtras(),
                    options = {
                        isHospital: isHospital,
                        benefitIds: _.union(selectedItems, meerkat.modules.benefitsModel.getDefaultSelections($this.data('select-type')))
                    };

                $this.closest($elements.quickSelect).next($elements.clear).removeClass('hidden');
                meerkat.messaging.publish(benefitEvents.BENEFIT_SELECTED, options);
            }
        });

        // clear selection
        $elements.clear.on('click', 'a', function clearSelectedBenefits() {
            var $this = $(this);

            $this.parent().addClass('hidden');
            meerkat.messaging.publish(quickSelect.CLEAR_BENEFITS, $this.closest($elements.hospital).length === 1);
        });
    }

    function showClearSelection() {
        $elements.clear.removeClass('hidden');
    }

    meerkat.modules.register("quickSelect", {
        init : init,
        events: events,
        showClearSelection: showClearSelection
    });

})(jQuery);