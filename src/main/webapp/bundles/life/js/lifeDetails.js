;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var $partnerRadioContainer;
    var $partnerInsuranceAmountsFields;

    function initLifeDetails() {
        _initFields();
        _initEventListeners();
        _triggerFieldEvents();
    }

    function _initFields() {
        $partnerRadioContainer = $('#partnerSameCoverRadio');
        $partnerInsuranceAmountsFields = $('#partnerInsuranceAmountFields');
    }

    function _initEventListeners() {
        $('input[name="life_primary_insurance_partner"]').on('change', _togglePartnerCoverRadioContainer);
        $partnerRadioContainer.find('input[name="life_primary_insurance_samecover"]').on('change', _togglePartnerInsuranceAmountFieldsContainer);

        $('.insuranceAmountContainer input').on('blur', function() {
            $('.insuranceAmountContainer input').valid();
        });
    }

    function _triggerFieldEvents() {
        _togglePartnerCoverRadioContainer($('input[name="life_primary_insurance_partner"]:checked'));
    }

    function _togglePartnerCoverRadioContainer($field) {
        var $this = typeof $field.originalEvent === 'undefined' ? $field : $(this);
        $partnerRadioContainer.toggle($this.val() === 'Y');

        _togglePartnerInsuranceAmountFieldsContainer($partnerRadioContainer.find('input[name="life_primary_insurance_samecover"]'));
    }

    function _togglePartnerInsuranceAmountFieldsContainer($field) {
        var $this = typeof $field.originalEvent === 'undefined' ? $field : $(this);
        var $coverForRadioVal = $('input[name="life_primary_insurance_partner"]:checked');

        $partnerInsuranceAmountsFields.toggle($coverForRadioVal.val() === 'Y' && $this.val() === 'N');
    }

    meerkat.modules.register("lifeDetails", {
        init: initLifeDetails,
        events: events
    });
})(jQuery);