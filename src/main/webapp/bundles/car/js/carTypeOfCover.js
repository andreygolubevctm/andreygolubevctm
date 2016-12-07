/**
 * Brief explanation of the module and what it achieves. <example: Example
 * pattern code for a meerkat module.> Link to any applicable confluence docs:
 * <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    /* Variables */
    var $typeOfCoverDropdown = $('#quote_optionsTypeOfCover'),
        $typeOfCover = $('#quote_typeOfCover'),
        $filterCoverType = $('#navbar-filter').find('.filter-cover-type'),
        $typeOfCoverOptions = {
            full: $typeOfCoverDropdown.find('option'),
            excTPFT: $typeOfCoverDropdown.find('option:not([value=TPFT])')

        },
        $tpftOption = $(':input.type_of_cover option').filter('[value=TPFT]'),
        $marketValue = $('#quote_vehicle_marketValue'),
        ctpMessageDialogId = null,
        $body = $('body');

    /* main entrypoint for the module to run first */
    function initCarTypeOfCover() {
        toggleTPFTOption($tpftOption);
        eventSubscriptions();
    }

    function eventSubscriptions() {
        $typeOfCoverDropdown.on('change', function changeTypeOfCover() {
            var typeOfCover = $(this).val();

            if (typeOfCover === 'CTP') {
                // show CTP modal message
                showCTPMessage();
            } else {
                // update hidden field
                $typeOfCover.val(typeOfCover);
            }
        });

        // When the type of cover filter changes, update type of cover dropdown
        meerkat.messaging.subscribe(meerkatEvents.carFilters.CHANGED, function onFilterChange(obj) {
            if (obj.hasOwnProperty('coverType')) {
                $typeOfCoverDropdown.val(obj.coverType);
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.car.VEHICLE_CHANGED, function onVehicleChanged() {
            toggleTPFTOption($tpftOption);
            meerkat.modules.carFilters.buildCoverTypeMenu($filterCoverType);
        });

        $(document).on('resultsFetchFinish', function onResultsFetchFinish() {
            // add class to body for toggling special features and some features rows when cover level not comprehensive
            $body.toggleClass('non-comprehensive-cover', $typeOfCover.val() !== 'COMPREHENSIVE');
        });
    }

    function toggleTPFTOption($tpftOption) {
        $typeOfCoverDropdown.empty();

        $tpftOption.toggleClass('hidden', $marketValue.val() > 20000);
        $typeOfCoverDropdown.append($typeOfCoverOptions[($marketValue.val() > 20000) ? 'excTPFT' : 'full']);

        _.defer(function() {
            // if previous selection was TPFT unselect
            if ($typeOfCover.val() === 'TPFT') {
                $typeOfCoverDropdown.val('');
            } else {
                if ($typeOfCover.val()) {
                    $typeOfCoverDropdown.val($typeOfCover.val());
                } else {
                    $typeOfCoverDropdown.val('');
                }
            }
        });
    }

    function showCTPMessage() {
        var buttons = [{
            label : "I would like to compare CTP insurance",
            className: "btn-next",
            closeWindow: true,
            action: function ctpModalButtonOneClicked() {
                window.open(meerkat.site.urls.exit.replace('car', 'ctp'), '_blank');
            }
        },{
            label : "I would like to change my selection",
            className: "btn-next",
            closeWindow: true,
            action: function ctpModalButtonTwoClicked() {
                meerkat.modules.dialogs.close(ctpMessageDialogId);
            }
        }];

        if (meerkat.modules.dialogs.isDialogOpen(ctpMessageDialogId) === false) {
            ctpMessageDialogId = meerkat.modules.dialogs.show({
                title: "Compulsory Third Party (CTP) Insurance",
                onOpen: function ctpModalOnOpen(modalId) {
                    var htmlContent = meerkat.site.ctpMessage,
                        $modal = $('#' + modalId);

                    meerkat.modules.dialogs.changeContent(modalId, htmlContent); // update the content

                    $modal.addClass('ctpMessagePopup'); // add class for css

                    // tweak the sizing to fit the content
                    $modal.find('.modal-body').outerHeight($('#' + modalId).find('.modal-body').outerHeight() - 20);
                    $modal.find('.modal-footer').outerHeight($('#' + modalId).find('.modal-footer').outerHeight() + 20);
                },
                onClose: function ctpModalOnClose(modalId) {
                    $typeOfCoverDropdown.val('');
                },
                buttons: buttons
            });
        }
    }

    meerkat.modules.register('carTypeOfCover', {
        initCarTypeOfCover : initCarTypeOfCover, // main entrypoint to be called.
        toggleTPFTOption: toggleTPFTOption
    });

})(jQuery);