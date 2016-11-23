/**
 * Brief explanation of the module and what it achieves. <example: Example
 * pattern code for a meerkat module.> Link to any applicable confluence docs:
 * <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined) {

    var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

    var events = {
        carEditDetails : {}
    }, moduleEvents = events.carTypeOfCover;

    /* Variables */
    var $typeOfCoverDropdown = $('#quote_optionsTypeOfCover'),
        $typeOfCover = $('#quote_typeOfCover'),
        ctpMessageDialogId = null;

    /* main entrypoint for the module to run first */
    function initCarTypeOfCover() {
        if ($typeOfCover.val()) {
            $typeOfCoverDropdown.val($typeOfCover.val());
        }

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
    }

    function showCTPMessage() {
        var buttons = [{
            label : "I would like to compare CTP insurance",
            className: "btn-next",
            closeWindow: true,
            action: function() {
                window.location = meerkat.site.urls.exit.replace('car', 'ctp');
            }
        },{
            label : "I would like to change my selection",
            className: "btn-next",
            closeWindow: true,
            action: function() {
                meerkat.modules.dialogs.close(ctpMessageDialogId);
            }
        }];

        if(meerkat.modules.dialogs.isDialogOpen(ctpMessageDialogId) === false) {
            ctpMessageDialogId = meerkat.modules.dialogs.show({
                title: "Compulsory Third Party (CTP) Insurance",
                onOpen: function (modalId) {
                    var htmlContent = $('#ctp-message-template').html(),
                        $modal = $('#' + modalId);

                    meerkat.modules.dialogs.changeContent(modalId, htmlContent); // update the content

                    $modal.addClass('ctpMessagePopup'); // add class for css

                    // tweak the sizing to fit the content
                    $modal.find('.modal-body').outerHeight($('#' + modalId).find('.modal-body').outerHeight() - 20);
                    $modal.find('.modal-footer').outerHeight($('#' + modalId).find('.modal-footer').outerHeight() + 20);
                },
                onClose: function (modalId) {
                    $typeOfCoverDropdown.val('');
                },
                buttons: buttons
            });
        }
    }

    meerkat.modules.register('carTypeOfCover', {
        initCarTypeOfCover : initCarTypeOfCover // main entrypoint to be called.
    });

})(jQuery);