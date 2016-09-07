;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info,
        meerkatEvents = meerkat.modules.events;

    var events = {},
        moduleEvents = events;


    function initValidateBSB() {
        $(document).ready(function(){
            if (meerkat.site.isCallCentreUser) {
                $('#bank-account-fields-group').find('.btn-validate').on('click', validate);
                if (hasBSB()) {
                    showRows();
                } else {
                    hideRows();
                }
            }
        });
    }

    function validate() {
        if(hasBSB()) {
            $('#bank-account-fields-group').find('.bsb-validator-messages').empty();
            var data = {
                bsb : $.trim($('#health_payment_bank_bsbinput').val())
            };
            meerkat.modules.comms.post({
                /* TODO: update this url when known */
                url: 'ajax/write/competition.jsp',
                data: data,
                cache: false,
                dataType: 'json',
                useDefaultErrorHandling: false,
                errorLevel: 'silent',
                timeout: 30000,
                onSuccess: function onSubmitSuccess(resultData) {
                    /* TODO: update response validation when structure known */
                    if(resultData && _.isObject(resultData) && _.has(resultData,'success') && resultData.success) {
                        $('#health_payment_bank_name').val(resultData.name);
                        renderSuccess();
                    } else {
                        renderError();
                    }
                },
                onError: renderError
            });
        } else {
            renderMessage("error","Please enter a BSB number");
        }
    }

    function renderSuccess(data) {
        renderMessage("success","This BSB matched successfully");
        showRows();
    }

    function renderError() {
        renderMessage("error", "The BSB wasn\'t recognised, please input manually");
        showRows();
    }

    function renderMessage(type,copy) {
        $('#bank-account-fields-group').find('.bsb-validator-messages').empty()
        .append(
            '<p class="' + type + '">' + copy + '</p>'
        );
    }

    function hasBSB() {
        var regex = new RegExp("^[0-9]{3}[- ]?[0-9]{3}$");
        var value = $('#health_payment_bank_bsbinput').val();
        return regex.test(value);
    }

    function showRows() {
        $('#bank-account-fields-group .bank-row').show();
    }

    function hideRows() {
        $('#bank-account-fields-group .bank-row').hide();
    }

    meerkat.modules.register('healthValidateBSB', {
        init:initValidateBSB
    });

})(jQuery);