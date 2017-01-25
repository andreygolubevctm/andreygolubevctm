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
            },
            partner: {
                fund: $('#partnerFund').find('select'),
                fundContainer: $('#partnerpreviousfund')
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
            if (noneOption.length === 0) {
                 element.append(
                    $("<option/>",{
                        value:	noCurrentFund,
                        text:	"No current health fund"
                    })
                );
            }
            element.val(noCurrentFund);
            $fundFields.hide();
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
