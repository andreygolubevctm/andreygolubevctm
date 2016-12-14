/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        events = {
            quickSelect: {
                CLEAR_BENEFITS: 'CLEAR_BENEFITS',
                PRESELECT_BENEFITS: 'PRESELECT_BENEFITS'
            }
        },
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
                selectedItems = isHospital ? meerkat.modules.benefitsModel.getHospital() : meerkat.modules.benefitsModel.getExtras(),
                 settings = {
                    isHospital: isHospital,
                    selectedItems: _.union(selectedItems, meerkat.modules.benefitsModel.getDefaultSelections($this.data('select-type')))
                };

                $this.closest($elements.quickSelect).next($elements.clear).removeClass('hidden');

                meerkat.messaging.publish(meerkatEvents.PRESELECT_BENEFITS, settings);
        });

        // clear selection
        $elements.clear.on('click', 'a', function clearSelectedBenefits() {
            var $this = $(this);

            $this.parent().addClass('hidden');
            meerkat.messaging.publish(meerkatEvents.CLEAR_BENEFITS, $this.closest($elements.hospital).length === 1);
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