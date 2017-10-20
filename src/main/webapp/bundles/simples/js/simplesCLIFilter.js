;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info,
        errorMsgElement = $('.simples-clifilter-pane-body .alert.alert-danger'),
        successMsgElement = $('.simples-clifilter-pane-body .alert.alert-danger'),
        baseUrl = '';

    var $targetForm = false;

    function init() {
        $(document).ready(function() {

            baseUrl = meerkat.modules.simples.getBaseUrl();

            errorMsgElement.html('').addClass('hidden');
            successMsgElement.html('').addClass('hidden');

            // Event: CLI Filter form submit (uses #dynamic_dom because that is static on the page so retains the event binds)
            $('.add-to-cli-filter').on('click', '[data-provide="simples-clifilter-submit"]', function(event) {
                performSubmit($(this).attr("data-filter-stylecode-id"));
            });

        });
    }

    function updateValidationMsg(data) {
        data = data || {};

        var errorMsgElement = $('.simples-clifilter-pane-body .alert.alert-danger');
        var successMsgElement = $('.simples-clifilter-pane-body .alert.alert-danger');

        errorMsgElement.addClass('hidden').html('');
        successMsgElement.addClass('hidden').html('');

        if (data.errorMessage && data.errorMessage.length > 0) {
            // Error message has been specified elsewhere
            $('.simples-clifilter-pane-body .alert.alert-danger').html(data.errorMessage).removeClass('hidden');
        }
        if (data.successMessage && data.successMessage.length > 0) {
            $('.simples-clifilter-pane-body .alert.alert-success').html(data.successMessage).removeClass('hidden');
        }

    }

    function performSubmit(filterStylecodeId) {

        //Setup target form
        $targetForm = $('.add-to-cli-filter #simples-add-clifilter');

        if (validateForm()) {
            var formData = {
                value: $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, ''),
                cliStyleCodeId: filterStylecodeId
            };

            var url = baseUrl + 'spring/rest/simples/clifilter/add.json',
                successMessage = 'Success : ' + formData.value + ' is added to CLI Filter';
            makeAjaxCall(url, formData, successMessage);
        }

    }

    function makeAjaxCall(url, formData, successMessage) {
        meerkat.modules.comms.post({
            url: url,
            dataType: 'json',
            cache: false,
            errorLevel: 'silent',
            timeout: 10000,
            data: formData,
            onSuccess: function onSuccess(json) {
                if(json.outcome === 'success') {
                    updateValidationMsg({'successMessage': successMessage});
                } else {
                    updateValidationMsg({'errorMessage': 'Failed : ' + json.outcome});
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                updateValidationMsg({errorMessage: txt + ': ' + errorThrown});
            }
        });
    }

    function validateForm() {

        if ($targetForm === false) return false;

        var phoneNumber = $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, '');
        var $error = $targetForm.find('.form-error');

        if (phoneNumber === '' || !isValidPhoneNumber(phoneNumber)) {
            $error.text('Please enter a valid phone number.');
            return false;
        }

        $error.text('');
        return true;
    }

    // Validate phone number
    function isValidPhoneNumber(phone) {
        if (phone.length === 0) return true;

        var valid = true;
        var strippedValue = phone.replace(/[^0-9]/g, '');
        if (strippedValue.length === 0 && phone.length > 0) {
            return false;
        }

        var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
        valid = phoneRegex.test(strippedValue);
        return valid;
    }

    meerkat.modules.register('simplesCLIFilter', {
        init: init
    });

})(jQuery);
