;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var _active = false,
        _modalViewed = false,
        _selectedResidentialState = '',
        $elements = {};

    function init() {
        $(document).ready(function () {
            //_setupFields();
            _active = false;
            _modalViewed = false;
            _selectedResidentialState = '';
        });
    }

    /*
    function _setupFields() {
        $elements = {
            state: $('#health_situation_state'),
            postcode: $('#health_situation_postcode'),
            suburb: $('#health_situation_suburb')
        };
    }
    */

    function activateFeature() {
        _active = true;

        // unsure if I should do a check here to prevent this being fired if the pages in in the xs media query size

        //Event listener triggers modal when user moves mouse within a few pixels from the top of the window
        $('[data-step="contact"]').on( "mousemove.goBackSkipContctDtlsModal", function( event ) {

            //for debugging purpose - note that the speed that the mouse is moved depends on the final cursor coordinate before the cursor leaves the window - it is possible for the y value to be 70 or higher
            // use this in conjunction with the div #log on the
            //$( "#log" ).text( "pageY: " + event.pageY );

            // If last Mouse Y Coordinate is less than 8px open modal  - note that the speed that the mouse is moved depends on the final cursor coordinate before the
            // cursor leaves the window - it is possible for the y value to be 70 or higher after the mouse has left the window if cursor was moved quickly
            if (event.pageY < 8) {
                showSkipContactDtlsModal();
            }
        });

    }
    function deactivateFeature() {
        _active = false;
    }
    function featureIsActive() {
        return _active;
    }

    function _modalTriggered() {
        _modalViewed = true;
    }

    function _getSkippedContactXpathVal() {
        return $('#health_contactDetails_skippedContact').val();
    }

    function modalHasBeenTriggered() {
        return _modalViewed;
    }
    function _getSelectedResidentialState() {
        return _selectedResidentialState;
    }
    function setResidentialState(residentialState) {
        _selectedResidentialState = residentialState || '';
    }

    function showSkipContactDtlsModal() {

        if (featureIsActive() !== true) return;

        //unbind the mousemove event
        $('[data-step="contact"]').unbind('mousemove.goBackSkipContctDtlsModal');

        //only triger modal once
        if (modalHasBeenTriggered() === true) return;
        _modalTriggered();

        // populate residential State value if it has already been set
        if( !_.isEmpty($('#health_situation_state').val()) ) {
            setResidentialState( $('#health_situation_state').val() );
        } else {

            //check if a value was supplied for state in the health_situation_location xpath
            if( !_.isEmpty($('#health_situation_location').val()) ) {
                var locationArray = $('#health_situation_location').val().split(" ");
                if( !_.isEmpty(locationArray[2]) ) {
                    var locationState = locationArray[2];
                    if (locationState !== "NULL") {
                        //found a valid value for state
                        setResidentialState(locationState);
                    }
                }
            }
        }

        var $e = $('#skip-contact-details-template');

        if ($e.length > 0) {
            templateCallback = _.template($e.html());

            var obj = meerkat.modules.moreInfo.getOpenProduct();

            var htmlContent = templateCallback(obj);

            var modalId = meerkat.modules.dialogs.show({
                htmlContent: htmlContent,
                title: '',
                closeOnHashChange: true,
                openOnHashChange: false,
                onOpen: function(modalId) {

                    if( !_.isEmpty(_getSelectedResidentialState()) ) {
                        $("#health_contactDetails_state_" + _getSelectedResidentialState() ).prop("checked", true);
                        $("#health_contactDetails_state_" + _getSelectedResidentialState() ).parent().addClass( "active" );
                    }

                    $('input[name=health_contactDetails_state]').click(function() {
                        //get the selected value and set the xpath
                        setResidentialState( $('input[name=health_contactDetails_state]:checked').val() );
                    });
                    $('.btn-skip-contact-dtls', $('#'+modalId)).on('click.goBackSkipContctDtlsModal', function(event) {
                        if (!_.isEmpty(_getSelectedResidentialState())) {
                            _removeRequiredFieldAttributes();

                            meerkat.modules.healthLocation.setResidentialState(_getSelectedResidentialState());

                            // this value is set only if user actually successfully skips the contact details
                            $('#health_contactDetails_skippedContact').val('Y');

                            meerkat.modules.dialogs.close(modalId);
                            meerkat.modules.journeyEngine.gotoPath('results');
                        } else {
                            //todo - fire proper validation if required
                            //alert('Please select a state');

                            //alternate to the the above todo - close the modal but dont hide the fields
                            meerkat.modules.dialogs.close(modalId);
                        }
                    });
                }
            });
        }

    }

    function _removeRequiredFieldAttributes() {

        $(".contact-details-contact-number").addClass('hidden');
        $(".health-required-blurb ~ .required_input").addClass('hidden');
        $(".health-required-blurb").addClass('hidden');
        $("#health-contact-fieldset.qe-window.fieldset div.content div h3").html("Please click Get Prices to continue");
    }


    meerkat.modules.register("healthExitModal", {
        events: moduleEvents,
        init: init,
        featureActivate: activateFeature,
        featureDeactivate: deactivateFeature,
        featureIsActive: featureIsActive,
        modalHasBeenTriggered: modalHasBeenTriggered,
        showSkipContactDtlsModal: showSkipContactDtlsModal
        //, getSkippedContactXpathVal: _getSkippedContactXpathVal
        //, removeRequiredFieldAttributes: _removeRequiredFieldAttributes

    });

})(jQuery);