/**
 * Did try this as a deferred file but it randomly caused race conditions
 */

(function ($, undefined) {


    var meerkat = window.meerkat,
        $elements = {},
        settings = {},
        currentStep;

    function initToggleBar(initSettings) {
        $(document).ready(function () {
            // added delay as this seems to sort out the issues with  $elements.toggleBar.offset().top  within the function _setupToggleBarSettings()
            // thinking it is a race condition so added an extra 500ms
            _.delay(function delayInit() {
                var $container = $(initSettings.container);

                if (!_.isUndefined(initSettings.currentStep)) {
                    currentStep = initSettings.currentStep;
                }

                $elements = {
                    toggleBar: $container.find('.toggleBar'),
                    benefitsOverflow: $container.find('.benefitsOverflow'),
                    hospitalContainer: $container.find('.Hospital_container'),
                    extrasTab: $container.find('.toggleBar').find('.extras'),
                    hospitalTab: $container.find('.toggleBar').find('.hospital'),
                    progressBar: $container.find('.journeyProgressBar')
                };

                $elements.targetContainer = $elements.toggleBar.data('targetcontainer');

                _setupToggleBarSettings(initSettings);
                _attachToggleBar();
                _setLabelCounts();
                _eventSubscriptions();
            }, 500);
        });
    }

    // allows the togglebar to be placed in a certain position (eg benefits screen)
    function _attachToggleBar() {
        if (!_.isUndefined($elements.targetContainer) && (!settings.isModal)) {
            $elements.toggleBar.insertBefore($elements.targetContainer);
        }
    }

    function _beforePanelAnimationStart(type) {
        $elements.toggleBar.hide();
        if (settings[currentStep].isModal === false) {
            $elements.toggleBar.find('.' + type).removeAttr('style').css('position', 'absolute');
        }
    }

    // this is for the more info page that is regenerated everytime due to it being a modal
    function _eventSubscriptions() {

        // slide in/out the overlays
        $elements.toggleBar.find('.extras').off('click.extrasBar').on('click.extrasBar', function displayExtrasBenefits() {
            _beforePanelAnimationStart('extras');
            $elements.benefitsOverflow.animate({ 'left': ($elements.hospitalContainer.width() * -1) }, 500).promise().then(function onExtrasAnimateComplete() {
                // reset to left position
                $elements.toggleBar.addClass('extrasToggled').fadeIn();
                if (settings[currentStep].isModal === false) {
                    _setTabLabelCount($elements.hospitalTab, meerkat.modules.benefitsModel.getHospitalCount());
                    _onPanelAnimationComplete('hospital');
                }
            });
        });

        $elements.toggleBar.find('.hospital').off('click.hospitalBar').on('click.hospitalBar', function displayHospitalBenefits() {
            _beforePanelAnimationStart('hospital');
            $elements.benefitsOverflow.animate({ 'left': 0 }, 500).promise().then(function onHospitalAnimateComplete() {
                $elements.toggleBar.removeClass('extrasToggled').fadeIn();
                if (settings[currentStep].isModal === false) {
                    _setTabLabelCount($elements.extrasTab, meerkat.modules.benefitsModel.getExtrasCount());
                    _onPanelAnimationComplete('extras');
                }
            });
        });

        // updates toggle bar tab position during scroll for non-modal instances
        registerScroll();

    }

    function registerScroll() {
        deRegisterScroll();
        $(window).on("scroll.benefitsScroll", _updateToggleBarTabPosition);
    }

    function deRegisterScroll() {
        $(window).off("scroll.benefitsScroll");
    }

    function _onPanelAnimationComplete(type) {
        settings[currentStep].currentBenefit = type;
        _resetTBTabTopBottomFlags();
        _updateToggleBarTabPosition();
    }

    // resets the toggle bar tab flags when the benefit panels are animated in
    function _resetTBTabTopBottomFlags() {
        settings.bottomFixed = true;
        settings.topFixed = true;
    }

    function _setLabelCounts() {
        _setTabLabelCount($elements.hospitalTab, meerkat.modules.benefitsModel.getHospitalCount());
        _setTabLabelCount($elements.extrasTab, meerkat.modules.benefitsModel.getExtrasCount());
    }

    // sets the number of selected benefits within the respective tab
    function _setTabLabelCount($tab, count) {
        $tab.find('span').text(count);
    }

    // sets up all the required variables to calculate the position of the togglebar tabs
    function _setupToggleBarSettings(initSettings) {
        if (!$elements.toggleBar.length) {
            return;
        }
        var tbTop = $elements.toggleBar.offset().top,
            tbHeight = $elements.toggleBar.height();

        settings[currentStep] = {
            toggleBarTop: tbTop,
            toggleBarBottom: tbHeight + tbTop,
            toggleBarHeight: tbHeight,
            hospitalTabWidth: $elements.toggleBar.find('.hospital').width(),
            extrasTabWidth: $elements.toggleBar.find('.extras').width(),
            bottomFixed: false,
            topFixed: false,
            isModal: initSettings.isModal || false,
            currentBenefit: 'extras'
        };
    }

    // Code takes care of the positioning of the toggle bar tabs.
    // 1. prevents the tabs going higher than the togglebar offset().top position
    // 2. prevents the tabs going lower than the togglebar height
    // 3. ensures the tabs are always displaying in the correct position when the other benefits screen is animated in
    // ---
    // Note this code only affects togglebar instances that are not used within a modal
    function _updateToggleBarTabPosition() {
        if (!$elements.progressBar.length) return;

        var currentBenefit = settings[currentStep].currentBenefit,
            currentTabBenefitWidth = settings[currentStep][currentBenefit + 'TabWidth'],
            fixedBottomPos = settings[currentStep].toggleBarHeight - currentTabBenefitWidth;

        // check if the selection tab has moved past the top of the toggleBar. If so, stop it from moving up the page
        if (!settings.topFixed && $elements.progressBar.offset().top + $elements.progressBar.height() <= settings[currentStep].toggleBarTop) {
            // if so attach it to the top of the toggle bar
            var $currentBenefitTab = $elements.toggleBar.find('.' + currentBenefit),
                posNode = currentBenefit === 'hospital' ? 'left' : 'right';

            $currentBenefitTab.removeAttr('style').css('position', 'absolute').css(posNode, parseInt($currentBenefitTab.css(posNode)) - 4);
            settings.topFixed = true;
        }

        // check if we're scrolling somewhere between the top and bottom of the toggleBar
        if ((settings.bottomFixed || settings.topFixed) && ($elements.progressBar.offset().top + $elements.progressBar.height() > settings[currentStep].toggleBarTop) && ($elements.toggleBar.find('.' + currentBenefit).offset().top + currentTabBenefitWidth < settings[currentStep].toggleBarBottom)) {
            var fixedPos = (settings[currentStep].toggleBarTop - currentTabBenefitWidth) * -1;
            $elements.toggleBar.find('.' + currentBenefit).removeAttr('style').css('position', 'fixed').css('marginTop', fixedPos);
            settings.bottomFixed = false;
            settings.topFixed = false;
        }

        // check if we've scrolled past the bottom of the toggleBar. If so, stop it from moving down the page
        if (!settings.bottomFixed && $elements.toggleBar.find('.' + currentBenefit).offset().top + currentTabBenefitWidth >= (settings[currentStep].toggleBarBottom - currentTabBenefitWidth)) {
            $elements.toggleBar.find('.' + currentBenefit).removeAttr('style').css('position', 'absolute').css('marginTop', fixedBottomPos);
            settings.bottomFixed = true;
        }
    }

    meerkat.modules.register("benefitsToggleBar", {
        initToggleBar: initToggleBar,
        deRegisterScroll: deRegisterScroll,
        registerScroll: registerScroll
    });

})(jQuery);