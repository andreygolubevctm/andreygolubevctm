;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;
    var events = {};

    var $partnerRadioContainer;
    var $partnerInsuranceAmountsFields;

    function initIPDetails() {
        _initFields();
        _initEventListeners();
        _triggerFieldEvents();
    }

    function _initFields() {
        $partnerRadioContainer = $('#partnerSameCoverRadio');
        $partnerInsuranceAmountsFields = $('#partnerInsuranceAmountFields');
    }

    function _initEventListeners() {
        $('input[name="ip_primary_insurance_partner"]').on('change', _togglePartnerCoverRadioContainer);
        $partnerRadioContainer.find('input[name="ip_primary_insurance_samecover"]').on('change', _togglePartnerInsuranceAmountFieldsContainer);

        $('.insuranceAmountContainer input').on('blur', function() {
            $('.insuranceAmountContainer input').valid();
        });

        $('#ip_primary_occupations, #ip_partner_occupations').on('typeahead:selected', function(e, data) {
            var $this = $(this);
            var idPrefix = $this.attr('id').replace('_occupations', '');
            var hannover = data.groupId;
            var title = data.description;

            $('#' + idPrefix + '_hannover').val(hannover);
            $('#' + idPrefix + '_occupationTitle').val(title);
        });

        $('#ip_primary_postCode').on('blur', function(e) {
            meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, { source: 'ipDetails.js' });
           meerkat.modules.comms.post({
               url: '/' + meerkat.site.urls.context + 'ajax/json/get_state.jsp',
               data: {
                   postCode: $(this).val()
               },
               dataType: 'json',
               cache: true,
               errorLevel: 'silent',
               onSuccess: function onSubmitSuccess(resultData) {
                   if(_.isArray(resultData) && resultData.length) {
                       $('#ip_primary_state').val(resultData[0].state);
                   }
               },
               onComplete: function onSubmitComplete() {
                   meerkat.messaging.publish(meerkat.modules.events.WEBAPP_UNLOCK, { source: 'ipDetails.js' });
               }
           });
        });
    }

    function _triggerFieldEvents() {
        _togglePartnerCoverRadioContainer($('input[name="ip_primary_insurance_partner"]:checked'));
    }

    function _togglePartnerCoverRadioContainer($field) {
        var $this = typeof $field.originalEvent === 'undefined' ? $field : $(this);
        $partnerRadioContainer.toggle($this.val() === 'Y');

        _togglePartnerInsuranceAmountFieldsContainer($partnerRadioContainer.find('input[name="ip_primary_insurance_samecover"]'));
    }

    function _togglePartnerInsuranceAmountFieldsContainer($field) {
        var $this = typeof $field.originalEvent === 'undefined' ? $field : $(this);
        var $coverForRadioVal = $('input[name="ip_primary_insurance_partner"]:checked');

        $partnerInsuranceAmountsFields.toggle($coverForRadioVal.val() === 'Y' && $this.val() === 'N');
    }

    meerkat.modules.register("ipDetails", {
        init: initIPDetails,
        events: events
    });
})(jQuery);