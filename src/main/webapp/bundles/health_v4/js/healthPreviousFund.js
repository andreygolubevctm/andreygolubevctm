;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        events = {
             healthPreviousFund: {
                 POPULATE_PARTNER: 'POPULATE_PREVIOUS_FUND_PARTNER',
                 POPULATE_PRIMARY: 'POPULATE_PREVIOUS_FUND_PRIMARY'
            }
        },
        moduleEvents = events.healthPreviousFund,
        $elements = {},
        noCurrentFund = 'NONE';


    function init() {
        $(document).ready(function() {
            _setupFields();
            _applyEventListeners();
            _eventSubscriptions();
        });
    }

    function _setupFields() {
        $elements = {
            primary: {
                fund: $('#clientFund').find('select'),
                fundContainer: $('#health_previousfund'),
                everHadPrivateHospital_1: $(':input[name=health_application_primary_everHadCoverPrivateHospital1]')
            },
            partner: {
                fund: $('#partnerFund').find('select'),
                fundContainer: $('#partnerpreviousfund'),
                everHadPrivateHospital_1: $(':input[name=health_application_partner_everHadCoverPrivateHospital1]')
            }
        };
    }

    function _applyEventListeners() {
        // Show/hide membership number and authorisation checkbox questions for previous funds.
        $('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').on('change', function(){
            meerkat.modules.healthCoverDetails.displayHealthFunds();
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.POPULATE_PRIMARY, function primaryCoverChange(hasCover) {
            _coverChange(hasCover, 'primary');
        });

        meerkat.messaging.subscribe(moduleEvents.POPULATE_PARTNER, function partnerCoverChange(hasCover) {
            _coverChange(hasCover, 'partner');
        });
    }

    function _coverChange(hasCover, person) {
        var element = $elements[person].fund,
            noneOption = element.find('option[value="' + noCurrentFund + '"]'),
            // did this so i don't rely on the id's
            $fundFields = $elements[person].fundContainer;

        $fundFields.show();
        if (hasCover === 'Y') {
            if (element.val() === noCurrentFund) {
                element.val('');
            }
            noneOption.remove();
        } else if (hasCover == 'N') {

            // This inserts 'No current health fund', in future it could be displayed at this point, so that users could select their previous fund
            // if they have previously had extras cover and previously served waiting periods etc.. but dont currently have cover
            if ($elements[person].everHadPrivateHospital_1.filter(':checked').val() === 'N') {
                if (noneOption.length === 0) {
                     element.append(
                        $("<option/>",{
                            value:	noCurrentFund,
                            text:	"No current health fund"
                        })
                    );
                }
                element.val(noCurrentFund);
            }

            // This hides the previous fund field - this field is hidden but not mutated if does not currently have health insurance but has not selected
            // an answer for previous health insurance it is hidden and updated to NONE if No cover and no previous Hospital cover is selected
            if (_.isUndefined($elements[person].everHadPrivateHospital_1.filter(':checked').val()) || $elements[person].everHadPrivateHospital_1.filter(':checked').val() === 'N') {
                $fundFields.hide();
            }
        }
        meerkat.modules.healthCoverDetails.displayHealthFunds();
    }

    function getPrimaryFund(){
        return typeof $elements.primary.fund !== 'undefined' ? $elements.primary.fund.val() : '';
    }

    function getPartnerFund(){
        return typeof $elements.partner.fund !== 'undefined' ? $elements.partner.fund.val() : '';
    }

    meerkat.modules.register('healthPreviousFund', {
        init: init,
        events: events,
        getPrimaryFund : getPrimaryFund,
        getPartnerFund : getPartnerFund
    });

})(jQuery);
