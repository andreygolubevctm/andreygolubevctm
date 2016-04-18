;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {};

    function initIPDetails() {
        _initFields();
        _initEventListeners();
        _triggerFieldEvents();
    }

    function _initFields() {}

    function _initEventListeners() {
        $('#ip_primary_insurance_income').on('blur', function(e) {
            var newVal = Number($(this).val()) * 0.75 / 12;
            $('#ip_primary_insurance_amount').val(newVal);
        });

        $('#ip_primary_occupations').on('typeahead:selected', function(e, data) {
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

    function _triggerFieldEvents() {}

    meerkat.modules.register("ipDetails", {
        init: initIPDetails,
        events: events
    });
})(jQuery);