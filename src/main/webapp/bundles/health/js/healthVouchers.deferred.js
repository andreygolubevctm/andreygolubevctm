/**
 * Description: External documentation:
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception,
        $elements = {},
        data = null;

    function init() {
        resetData();
        $(document).ready(function () {
            if(meerkat.site.isCallCentreUser) {
                $elements.root = $('#healthVouchers');
                $elements.wrappers = {
                    available:  $elements.root.find('.voucherIsAvailable').first(),
                    type:       $elements.root.find('.healthVoucherTypeRow').first(),
                    mando:      $elements.root.find('.voucher.mando').first(),
                    other:      $elements.root.find('.voucher.other').first()
                };
                $elements.triggers = {
                    available:  $elements.root.find('.healthVoucherAvailableRow').first().find('input'),
                    type:       $elements.wrappers.type.find("select").first()
                };
                applyEventListeners();
                updateView();
            }
        });
    }

    function resetData() {
        data = {
            available : false,
            isMando :   false,
            isOther :   false,
            other :     false
        };
    }

    function setMando() {
        data.isMando = true;
        data.isOther = false;
        data.other = false;
    }

    function setOther() {
        data.isMando = false;
        data.isOther = true;
        data.other = {
            reason :        null,
            value :         null,
            refererred :    null,
            email :         null,
            approvedby :    null
        };
    }

    function applyEventListeners() {
        $elements.triggers.available.on('change', function(){
            resetData();
            data.available = $(this).val() === 'Y';
            updateView();
        });
        $elements.triggers.type.on('change', function(){
            switch($(this).val()){
                case 'other':
                    setOther();
                    break;
                case 'mando':
                default:
                    setMando();
                    break;
            }
            updateView();
        });
    }

    function updateView() {
        if(data.available) {
            $elements.wrappers.available.slideDown('fast', function(){
                $elements.wrappers.type.slideDown('fast', function(){
                    if(data.isMando) {
                        $elements.wrappers.other.slideUp('fast', function () {
                            $elements.wrappers.mando.slideDown('fast', function () {

                            });
                        });
                    } else if(data.isOther) {
                        $elements.wrappers.mando.slideUp('fast', function(){
                            $elements.wrappers.other.slideDown('fast', function(){

                            });
                        });
                    }
                });
            });
        } else {
            $elements.wrappers.available.slideUp('fast', function(){

            });
        }
    }

    meerkat.modules.register("healthVouchers", {
        init: init
    });

})(jQuery);