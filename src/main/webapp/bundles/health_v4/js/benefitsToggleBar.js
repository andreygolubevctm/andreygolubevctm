/**
 * Did try this as a deferred file but it randomly caused race conditions
 */

(function ($, undefined) {


    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        settings = {},
        currentStep;

    function initToggleBar(initSettings) {
        $(document).ready(function () {
            var $container = $(initSettings.container);

            $elements = {
                toggleBar: $container.find('.toggleBar'),
                benefitsOverflow: $container.find('.benefitsOverflow'),
                hospitalContainer: $container.find('.Hospital_container'),
                progressBar: $container.find('.journeyProgressBar')
            };

            $elements.targetContainer = $elements.toggleBar.data('targetcontainer');

            // position the benefit slider tabs
            $elements.toggleBar.find('.hospital').css('position', 'absolute');
            $elements.toggleBar.find('.extras').css('position', 'absolute');

            _setupToggleBarSettings();

            _setIsModal(initSettings.isModal || false);


            if (settings.isModal === false) {
                _attachToggleBar();
            }

            _setupToggleBarSettings();
            _eventSubscriptions();

            _setTabLabelCount($elements.hospitalOverlay, meerkat.modules.benefitsModel.getHospitalCount());
            _setTabLabelCount($elements.extrasOverlay, meerkat.modules.benefitsModel.getExtrasCount());
        });
    }

    // allows the togglebar to be placed in a certain position (eg benefits screen)
    function _attachToggleBar() {
        if (!_.isUndefined($elements.targetContainer)) {
            $elements.toggleBar.insertBefore($elements.targetContainer);
        }
    }

    function _beforePanelAnimationStart(type) {
        $elements.toggleBar.hide();
        if (settings[currentStep].isModal === false) {
            $elements.toggleBar.find('.'+type).removeAttr('style').css('position', 'absolute');
        }
    }

    // this is for the more info page that is regenerated everytime due to it being a modal
    function _eventSubscriptions() {
        // slide in/out the overlays
        $elements.toggleBar.find('.extras').on('click', function displayExtrasBenefits() {
            _beforePanelAnimationStart('hospital');
            $elements.benefitsOverflow.animate({ 'left': ($elements.hospitalContainer.width() * -1) }, 500).promise().then(function onExtrasAnimateComplete() {
                // reset to left position
                if (settings[currentStep].isModal === true) {
                    $elements.toggleBar.css('left', 0).fadeIn();
                } else {
                    _onPanelAnimationComplete('hospital');
                }
            });
        });

        $elements.toggleBar.find('.hospital').on('click', function displayHospitalBenefits() {
            _beforePanelAnimationStart('extras');
            $elements.benefitsOverflow.animate({ 'left': 0 }, 500).promise().then(function onHospitalAnimateComplete() {
                if (settings[currentStep].isModal === true) {
                    $elements.toggleBar.removeAttr('style').fadeIn();
                } else {
                    _onPanelAnimationComplete('extras');
                }
            });
        });

        if (settings[currentStep].isModal === false) {
            // updates toggle bar tab position during scroll for non-modal instances
            $(window).off("scroll." + settings.currentStep + "Scroll").on("scroll." + settings.currentStep + "Scroll", _.debounce(function () {
                _updateToggleBarTabPosition();
            }));
        }
    }

    function _onPanelAnimationComplete(type) {
        $elements.toggleBar.fadeIn().find('.'+type).fadeIn();
        settings[settings.currentStep].currentBenefit = type;
        _resetTBTabTopBottomFlags();
        _updateToggleBarTabPosition();
    }

    // resets the toggle bar tab flags when the benefit panels are animated in
    function _resetTBTabTopBottomFlags() {
        settings.bottomFixed = true;
        settings.topFixed = true;
    }

    function _setIsModal(isModal) {
        settings[currentStep].isModal = isModal;
    }

    // sets the number of selected benefits within the respective tab
    function _setTabLabelCount($tab, count) {
        $tab.find('span').text(count);
    }

    // sets up all the required variables to calculate the position of the togglebar tabs
    function _setupToggleBarSettings() {
        $(document).ready(function () {
            _.defer(function(){
                var tbTop = $elements.toggleBar.offset().top;

                currentStep = meerkat.modules.journeyEngine.getCurrentStep().navigationId;

                settings[currentStep] = {
                    toggleBarTop: tbTop,
                    toggleBarBottom: $elements.toggleBar.height() + tbTop,
                    toggleBarHeight: $elements.toggleBar.height(),
                    hospitalTabWidth: $elements.toggleBar.find('.hospital').width(),
                    extrasTabWidth: $elements.toggleBar.find('.extras').width(),
                    bottomFixed: false,
                    topFixed: false,
                    isModal: false,
                    currentBenefit: 'extras'
                };

                settings.currentStep = currentStep;
            });
        });
    }

    // Code takes care of the positioning of the toggle bar tabs.
    // 1. prevents the tabs going higher than the togglebar offset().top position
    // 2. prevents the tabs going lower than the togglebar height
    // 3. ensures the tabs are always displaying in the correct position when the other benefits screen is animated in
    // ---
    // Note this code only affects togglebar instances that are not used within a modal
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

    meerkat.modules.register("benefitsToggleBar", {
        initToggleBar: initToggleBar
    });

})(jQuery);