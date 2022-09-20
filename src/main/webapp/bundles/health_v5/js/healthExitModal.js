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
            _setupFields();
            _active = false;
            _modalViewed = false;
            _selectedResidentialState = '';
        });
    }

    function _setupFields() {
        $elements = {
            exitModalPage: $('[data-step="contact"]'),
            exitModalPageSubmitBtn1: $('[data-slide-control="next"].slide-control-get-prices'),
            exitModalPageSubmitBtn2: $('[data-slide-control="next"]').filter(function(){ return $(this).text() === 'Get Prices '; }),
            state: $('#health_situation_state'),
            trackingXPath: $('#health_contactDetails_skippedContact'),
            name: $('#health_contactDetails_name'),
            mobileNumber: $('#health_contactDetails_contactNumber_mobileinput'),
            otherNumber: $('#health_contactDetails_contactNumber_otherinput'),
            email: $('#health_contactDetails_email'),
            postcode: $('#health_situation_postcode'),
            postcodeWrapper: $('.health_contact_details_postcode_wrapper'),
            location: $('#health_situation_location'),
            requiredBlurb: $(".health-required-blurb")
        };
    }

    function activateFeature() {
        init();
        _active = true;
        // unsure if I should do a check here to prevent this being fired if the pages in in the xs media query size

        //Event listener triggers modal when user moves mouse within a few pixels from the top of the window
        $elements.exitModalPage.on( "mousemove.skipContctDtlsModal", function( event ) {

            // If last Mouse Y Coordinate is less than 8px open modal  - note that the speed that the mouse is moved depends on the final cursor coordinate before the
            // cursor leaves the window - it is possible for the y value to be 70 or higher after the mouse has left the window if cursor was moved quickly
            if ($elements.exitModalPage.scrollTop() > 0) {
                // deduct the scroll offset
                if ((event.pageY - $elements.exitModalPage.scrollTop()) < 8) {
                    showSkipContactDtlsModal();
                }
            } else {
                if (event.pageY < 8) {
                    showSkipContactDtlsModal();
                }
            }
        });

        //Event listener triggers deactivate if user clicks either of the 'next' buttons to move forward to the results page
        $elements.exitModalPageSubmitBtn1.on( "click.skipContctDtlsModal1", function( event ) {
            deactivateFeature();
        });
        $elements.exitModalPageSubmitBtn2.on( "click.skipContctDtlsModal2", function( event ) {
            deactivateFeature();
        });


    }
    function deactivateFeature() {
        _active = false;
        //unbind the mousemove event
        $elements.exitModalPage.off('mousemove.skipContctDtlsModal');
        $elements.exitModalPage.off('click.skipContctDtlsModal1');
        $elements.exitModalPage.off('click.skipContctDtlsModal2');
    }

    function _featureIsActive() {
        return _active;
    }

    function _modalTriggered() {
        _modalViewed = true;
    }

    function _modalHasBeenTriggered() {
        return _modalViewed;
    }

    function _getSelectedResidentialState() {
        return _selectedResidentialState;
    }

    function setResidentialState(residentialState) {
        _selectedResidentialState = residentialState || '';
    }

    function showSkipContactDtlsModal() {

        if (_featureIsActive() !== true) return;

        //only show modal on the contact page (dont remove the listener if navigating back to insurance preferences or about you page / using browser back button
        if ( meerkat.modules.journeyEngine.getCurrentStep()['navigationId'].toLowerCase() !== 'contact') return;

        //unbind the mousemove event
        deactivateFeature();

        //only trigger modal once
        if (_modalHasBeenTriggered() === true) return;
        _modalTriggered();

        // populate residential State value if it has already been set
        if( !_.isEmpty( $elements.state.val()) ) {
            setResidentialState( $elements.state.val() );
        }

        var $e = $('#skip-contact-details-template');

        if ($e.length > 0) {

            //dont show modal if content does not exist
            if ($e.html().length > 0) {

                templateCallback = _.template($e.html());

                var obj = meerkat.modules.moreInfo.getOpenProduct();
                var htmlContent = templateCallback(obj);

                var modalId = meerkat.modules.dialogs.show({
                    htmlContent: htmlContent,
                    title: '',
                    closeOnHashChange: true,
                    openOnHashChange: false,
                    onOpen: function(modalId) {

                        $modalElements = {
                            state: $('input[name=health_contactDetails_state]')
                        };

                        if( !_.isEmpty(_getSelectedResidentialState()) ) {
                            $("#health_contactDetails_state_" + _getSelectedResidentialState() ).prop("checked", true).change();
                        }

                        _addEcommerceDataModalImpression();

                        $modalElements.state.click(function() {
                            //get the selected value and set the xpath
                            setResidentialState( $('input[name=health_contactDetails_state]:checked').val() );
                        });
                        $('.btn-skip-contact-dtls', $('#'+modalId)).on('click.skipContctDtlsModal', function(event) {
                            if (!_.isEmpty(_getSelectedResidentialState())) {
                                _removeRequiredFieldAttributes();

                                meerkat.modules.healthLocation.setResidentialState(_getSelectedResidentialState());

                                // this value is set only if user actually successfully skips the contact details
                                $elements.trackingXPath.val('Y');
                                _addEcommerceDataModalSubmission();

                                meerkat.modules.dialogs.close(modalId);
                                meerkat.modules.journeyEngine.gotoPath('results');
                            } else {
                                // we could remove the required fields at this point too
                                meerkat.modules.dialogs.close(modalId);
                            }
                        });
                    }

                });
            }
        }
    }

    function _removeRequiredFieldAttributes() {
        // remove '* fields are required' text
        $(".health-required-blurb").addClass('hidden');

        // remove required attributes
        $('#health_contactDetails_name').removeAttr("required");

        $elements.mobileNumber.removeAttr("required");
        $elements.mobileNumber.removeAttr("aria-required");
        $elements.mobileNumber.removeAttr("aria-invalid");
        $elements.mobileNumber.removeAttr("data-rule-requireonecontactnumber");
        $elements.mobileNumber.removeAttr("data-rule-validatemobiletelno").change();
        $elements.mobileNumber.removeRule('requireOneContactNumber');

        $elements.otherNumber.removeAttr("required");
        $elements.otherNumber.removeAttr("aria-required");
        $elements.otherNumber.removeAttr("aria-invalid");
        $elements.otherNumber.removeAttr("data-rule-requireonecontactnumber");
        $elements.otherNumber.removeAttr("data-rule-validatelandlinetelno").change();
        $elements.otherNumber.removeRule('requireOneContactNumber');

        $elements.email.removeAttr("required");

        $elements.postcode.removeAttr("required");
        $elements.postcode.removeAttr("aria-required");
        $elements.postcode.removeAttr("aria-invalid");

        $elements.location.removeAttr("data-rule-locationselection");
        $elements.location.removeClass("validate");

        //remove required asterisk from labels
        $elements.name.parent().parent().removeClass("required_input");
        $elements.mobileNumber.parent().parent().removeClass("required_input");
        $elements.otherNumber.parent().parent().parent().removeClass("required_input"); //.contact-details-contact-number
        $elements.mobileNumber.parent().parent().parent().removeClass("required_input");
        $elements.otherNumber.parent().parent().removeClass("required_input");
        $elements.email.parent().parent().parent().removeClass("required_input");
        $elements.postcode.parent().parent().parent().removeClass("required_input");
    }

    function _addEcommerceDataModalImpression() {
        //Variables for banner impression
        var bannerPopupImpression = {
            event: "trackQuoteExitPopUp",
            eventCategory: "exit banner popup",
            eventAction: (meerkat.site.vertical.toLowerCase() + " - " + meerkat.modules.journeyEngine.getCurrentStep()['navigationId'].toLowerCase()),
            eventLabel: "exit banner impressions"
        };
        // "eventAction": "{{vertical name}} - {{slide name}}" (e.g health - contact page)

        if (!_.isEmpty(dataLayer)) {
            dataLayer.push(bannerPopupImpression);
        }
    }

    function _addEcommerceDataModalSubmission() {
        //Variables for banner submission
        var bannerPopupSubmissions = {
            event: "trackQuoteExitPopUp",
            eventCategory: "exit banner popup",
            eventAction: (meerkat.site.vertical.toLowerCase() + " - " + meerkat.modules.journeyEngine.getCurrentStep()['navigationId'].toLowerCase()),
            eventLabel: "exit banner submissions"
        };
        // "eventAction": "{{vertical name}} - {{slide name}}" (e.g health - contact page)

        if (!_.isEmpty(dataLayer)) {
            dataLayer.push(bannerPopupSubmissions);
        }
    }

    meerkat.modules.register("healthExitModal", {
        events: moduleEvents,
        init: init,
        activateFeature: activateFeature,
        deactivateFeature: deactivateFeature,
        showSkipContactDtlsModal: showSkipContactDtlsModal
    });

})(jQuery);