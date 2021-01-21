/**
 * healthValidateBSB provides the functionality to validate
 * BSB numbers entered for Simples users.
 */
;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info,
        meerkatEvents = meerkat.modules.events;

    var serviceUrl = false;

    /**
     * Setup the page
     */
    function initValidateBSB() {
        $(document).ready(function(){
            if (meerkat.site.isCallCentreUser) {
                // Add listener to validate button
                $('#bank-account-fields-group').find('.btn-validate').on('click', validate);
                // Show/Hide rows depending if we have a BSB already
                if (hasBSB()) {
                    showRows();
                } else {
                    hideRows();
                }
                // Show hidden rows for non-Simples users
            } else {
                showRows();
            }
        });
    }

    /**
     * Returns the service URL and sets it if empty
     * @returns {string}
     */
    function getServiceURL() {
        if(serviceUrl === false) {
            var url = 'spring/bsbdetails';
            if (!_.isUndefined(meerkat.site.bsbServiceURL) && !_.isEmpty(meerkat.site.bsbServiceURL)) {
                url = meerkat.site.bsbServiceURL;
            }
            serviceUrl = url;
        }
        return serviceUrl;
    }

    /**
     * Make ajax call to service to validate BSB and update the
     * view based on the response
     */
    function validate() {
        if(hasBSB()) {
            // Flush existing messages
            $('#bank-account-fields-group').find('.bsb-validator-messages').empty();
            // Populate request data with BSB
            var data = {
                bsbNumber : $.trim($('#health_payment_bank_bsb').val())
            };
            meerkat.modules.comms.get({
                url: getServiceURL(),
                data: data,
                cache: true,
                dataType: 'json',
                useDefaultErrorHandling: false,
                errorLevel: 'silent',
                timeout: 10000,
                onSuccess: function onSubmitSuccess(resultData) {
                    if(validateResponse(resultData)) {
                        // Update bank name field
                        $('#health_payment_bank_name').val(resultData.bankName);
                        renderSuccess();
                    } else {
                        renderError();
                    }
                },
                onError: renderError
            });
        } else {
            renderMessage("error","Please enter a valid BSB number");
        }
    }

    /**
     * Verify the service response contains the min data to proceed
     * @param response
     * @returns {boolean}
     */
    function validateResponse(response) {
        if(response && _.isObject(response)) {
            if(_.has(response,'found') && response.found === true) {
                if(_.has(response,'bankName') && !_.isEmpty(response.bankName)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Render the SUCCESS message to the form
     */
    function renderSuccess() {
        renderMessage("success","This BSB matched successfully");
        showRows();
    }

    /**
     * Render the ERROR message to the form
     */
    function renderError() {
        renderMessage("error", "The BSB wasn\'t recognised, please input manually");
        showRows();
    }

    /**
     * Common method for rendering messages to the page
     * @param type
     * @param copy
     */
    function renderMessage(type,copy) {
        $('#bank-account-fields-group').find('.bsb-validator-messages').empty()
            .append(
                '<p class="' + type + '">' + copy + '</p>'
            );
    }

    /**
     * Verify the BSB entered is valid
     * @returns {boolean}
     */
    function hasBSB() {
        var regex = new RegExp("^[0-9]{3}[- ]?[0-9]{3}$");
        var value = $('#health_payment_bank_bsbinput').val();
        return regex.test(value);
    }

    /**
     * Show hidden bank detail rows
     */
    function showRows() {
        $('#bank-account-fields-group .bank-row').show();
    }

    /**
     * Hide bank detail rows
     */
    function hideRows() {
        $('#bank-account-fields-group .bank-row').hide();
    }

    meerkat.modules.register('healthValidateBSB', {
        init:initValidateBSB
    });

})(jQuery);