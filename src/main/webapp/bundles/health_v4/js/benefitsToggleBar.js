/**
 * Did try this as a deferred file but it randomly caused race conditions
 */

(function ($, undefined) {


    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        settings = {},
        currentScrollPos = 0;

    function init() {
        $(document).ready(function () {
            $elements = {
                toggleBar: $('.toggleBar'),
                benefitsOverflow: $('.benefitsOverflow'),
                hospitalContainer: $('.Hospital_container'),
                progressBar: $('.journeyProgressBar')
            };

            $elements.targetContainer = $elements.toggleBar.data('targetcontainer');

            _eventsSubscription();
        });
    }

    function setupToggleBarSettings() {
        var tbTop = $elements.toggleBar.offset().top,
            offset = 20,
            currentStep = meerkat.modules.journeyEngine.getCurrentStep().navigationId;

        settings[currentStep] = {
            toggleBarTop: tbTop,
            toggleBarBottom: $elements.toggleBar.height() + tbTop,
            toggleBarHeight:  $elements.toggleBar.height(),
            hospitalTabWidth: $elements.toggleBar.find('.hospital').width(),
            extrasTabWidth: $elements.toggleBar.find('.extras').width(),
            bottomFixed: false,
            topFixed: false,
            currentBenefit: 'extras'
        };

        settings.currentStep = currentStep;
        console.log("DDD START5",settings, $elements.toggleBar.height());
        // position the benefit slider tabs
        $elements.toggleBar.find('.hospital').css('position', 'absolute');
        $elements.toggleBar.find('.extras').css('position', 'absolute');
    }

    function attachToggleBar() {
        if (!_.isUndefined($elements.targetContainer)) {
            $elements.toggleBar.insertBefore($elements.targetContainer);
        }
    }

    function _eventsSubscription() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function extrasOverlayEnterXsState() {
            _setOverlayLabelCount($elements.hospitalOverlay, meerkat.modules.benefitsModel.getHospitalCount());
            _setOverlayLabelCount($elements.extrasOverlay, meerkat.modules.benefitsModel.getExtrasCount());
            setupToggleBarSettings();
        });

        // slide in/out the overlays
        $elements.toggleBar.find('.extras').on('click', function displayExtrasBenefits() {
            $elements.toggleBar.hide().find('.extras').removeAttr('style').css('position', 'absolute');
            $elements.benefitsOverflow.animate({ 'left': ($elements.hospitalContainer.width() * -1) }, 500).promise().then(function onExtrasAnimateComplete() {
                // reset to left position
                $elements.toggleBar.fadeIn().find('.hospital').fadeIn();
                settings[meerkat.modules.journeyEngine.getCurrentStep().navigationId].currentBenefit = 'hospital';
                _resetTopBottomFlags();
                _updateToggleBarTabPosition();
            });
        });

        $elements.toggleBar.find('.hospital').on('click', function displayHospitalBenefits() {
            $elements.toggleBar.hide().find('.hospital').removeAttr('style').css('position', 'absolute');
            $elements.benefitsOverflow.animate({ 'left': 0 }, 500).promise().then(function onHospitalAnimateComplete() {
                $elements.toggleBar.fadeIn().find('.extras').fadeIn();
                settings[meerkat.modules.journeyEngine.getCurrentStep().navigationId].currentBenefit = 'extras';
                _resetTopBottomFlags();
                _updateToggleBarTabPosition();
            });
        });

        $(window).off("scroll.benefitScroll").on("scroll.benefitScroll", _.debounce(function() {
            _updateToggleBarTabPosition();
        }));
    }

    function _resetTopBottomFlags() {
        settings.bottomFixed = true;
        settings.topFixed = true;
    }

    function _updateToggleBarTabPosition() {
        var currentBenefit = settings[settings.currentStep].currentBenefit,
            currentTabBenefitWidth = settings[settings.currentStep][currentBenefit + 'TabWidth'],
            fixedBottomPos = settings[settings.currentStep].toggleBarHeight - currentTabBenefitWidth;

        // check if the selection tab has moved past the top of the toggleBar. If so, stop it from moving up the page
        if (!settings.topFixed && $elements.progressBar.offset().top + $elements.progressBar.height() <= settings[settings.currentStep].toggleBarTop) {
            // if so attach it to the top of the toggle bar
            $elements.toggleBar.find('.'+settings[settings.currentStep].currentBenefit).removeAttr('style').css('position', 'absolute');
            settings.topFixed = true;
        }

        // check if we're scrolling somewhere between the top and bottom of the toggleBar
        if ((settings.bottomFixed || settings.topFixed) && ($elements.progressBar.offset().top + $elements.progressBar.height() > settings[settings.currentStep].toggleBarTop) && ($elements.toggleBar.find('.'+currentBenefit).offset().top + currentTabBenefitWidth < settings[settings.currentStep].toggleBarBottom)) {
            var fixedPos = (settings[settings.currentStep].toggleBarTop - currentTabBenefitWidth) * -1;
            $elements.toggleBar.find('.'+currentBenefit).removeAttr('style').css('position', 'fixed').css('marginTop', fixedPos);
            settings.bottomFixed = false;
            settings.topFixed = false;
        }

        // check if we've scrolled past the bottom of the toggleBar. If so, stop it from moving down the page
        if (!settings.bottomFixed && $elements.toggleBar.find('.'+currentBenefit).offset().top + currentTabBenefitWidth >= settings[settings.currentStep].toggleBarBottom) {
            $elements.toggleBar.find('.' + currentBenefit).removeAttr('style').css('position', 'absolute').css('marginTop', fixedBottomPos);
            settings.bottomFixed = true;
        }
    }

    function initLabelCount() {
        _setOverlayLabelCount($elements.toggleBar.find('.hospital'), meerkat.modules.benefitsModel.getHospitalCount());
        _setOverlayLabelCount($elements.toggleBar.find('.extras'), meerkat.modules.benefitsModel.getExtrasCount());
    }

    function _setOverlayLabelCount($overlay, count) {
        $overlay.find('span').text(count);
    }

    meerkat.modules.register("benefitsToggleBar", {
        init: init,
        attachToggleBar: attachToggleBar,
        initLabelCount: initLabelCount,
        setupToggleBarSettings: setupToggleBarSettings
    });

})(jQuery);