;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var $callIdField,
        $callDirectionField,
        $customerPhoneNoField,
        $vdnField,
        $vdnInputField;

    function init() {
        if(meerkat.site.isCallCentreUser !== true) return;

        $(document).ready(function() {
            $callIdField = $('#health_tracking_callId');
            $callDirectionField = $('#health_tracking_direction');
            $customerPhoneNoField = $('#health_tracking_customerPhoneNo');
            $vdnField = $('#health_tracking_VDN');
            $vdnInputField = $('#health_tracking_vdnInput');

            // Only show VDN input if it is a inbound call
            // We can't rely on CTI service because this input is a backup when CTI failed to return VDN
            // Therefore we are using the checkbox that consultant ticked in start page
            $('input[name=health_simples_contactType]').on('change', function() {
                toggleVdnInput();
            });
            // toggle for first time page load
            toggleVdnInput()
        });
    }

    function toggleVdnInput() {
        if ($('#health_simples_contactType_inbound').is(':checked')) {
            $vdnInputField.parents('.fieldrow').removeClass('hidden');

            // sync vdn and vdnInput when page load
            $vdnInputField.val($vdnField.val());

            // update hidden vdn when consultant change it manually
            $vdnInputField.on('change', function () {
                $vdnField.val($(this).val());
            });
        } else {
            $vdnInputField.parents('.fieldrow').addClass('hidden');
        }
    }

    function fetchCallInfo() {
        if (canFetch() !== true) return;

        var data = {};
        data.xpath = 'health/tracking';

        meerkat.modules.comms.get({
            url: 'general/phones/callInfo/get.json',
            cache: false,
            errorLevel: 'silent',
            dataType: 'json',
            data: data,
            useDefaultErrorHandling: false
        })
        .done(function onSuccess(json) {
            saveCallInfo(json);
        })
        .fail(function onError(obj, txt, errorThrown) {
            exception(txt + ': ' + errorThrown);
        });
    }

    function saveCallInfo(callInfo) {
        if (isCallInfoValid(callInfo) !== true) return;

        $callIdField.val(callInfo.callId);
        $callDirectionField.val(callInfo.direction);
        $customerPhoneNoField.val(callInfo.customerPhoneNo);
        if (callInfo.hasOwnProperty('vdns') && callInfo.vdns.length > 0) {
            $vdnField.val(callInfo.vdn[0]);
            $vdnInputField.val(callInfo.vdn[0]);
        }
    }

    function isCallInfoValid(callInfo) {
        if (callInfo.hasOwnProperty('errors') && callInfo.errors.length > 0) {
            debug(callInfo.errors[0].message);
            return false;
        }

        if (!callInfo.hasOwnProperty('callId') || !callInfo.callId || callInfo.callId.length === 0 || callInfo.callId === '0' ) {
            debug("CallInfo is not valid");
            return false;
        }

        return true;
    }

    function canFetch() {
        if(meerkat.site.isCallCentreUser !== true) return false;

        if ($callIdField.length === 0 || !$callIdField.val() || $callIdField.val().length === 0 || $callIdField.val() === '0') {
            return true;
        }else if($callDirectionField.val() === 'I' && (!$vdnField.val() || $vdnField.val().length === 0)) {
            return true;
        }
        return false;
    }

    meerkat.modules.register("simplesCallInfo", {
        init: init,
        fetchCallInfo: fetchCallInfo
    });

})(jQuery);