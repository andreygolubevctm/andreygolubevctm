/*
 *
 * Handling of the start page
 *
 */
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $firstname,
        $surname,
        $email,
        $marketing,
        $iAm,
        iAm,
        $lookingTo,
        $currentHomeLoan,
        $purchasePrice,
        $purchasePriceHidden,
        $loanAmount,
        $amountOwing,
        $amountOwingHidden,
        $currentLoanPanel,
        $existingOwnerPanel,
        $purchasePricePanel,
        sessionCamStep = null;


    function applyEventListeners() {
        $(document.body).on('click', '.btn-view-brands', displayBrandsModal);

        $marketing.on('change', function () {

            if ($(this).is(':checked')) {
                $firstname.attr('required', 'required').valid();
                $surname.attr('required', 'required').valid();
                $email.attr('required', 'required').valid();
            } else {
                $firstname.removeAttr('required').valid();
                $surname.removeAttr('required').valid();
                $email.removeAttr('required').valid();
            }
        });

        $iAm.on("change", function () {
            var arr = [],
                $iAmChecked = $(iAm + ':checked'),
                currLookingToValue = $lookingTo.val();
            $lookingTo.val('');
            if ($iAmChecked.val() === 'E') {
                arr = [{code: 'APL', label: 'Buy another property to live in'},
                    {code: 'IP', label: 'Buy an investment property'},
                    {code: 'REP', label: 'Renovate my existing property'},
                    {code: 'CD', label: 'Consolidate my debt'},
                    {code: 'CL', label: 'Compare better home loan options'}
                ];
                toggleView($existingOwnerPanel, true);
            } else {
                arr = [{code: 'FH', label: 'Buy my first home'},
                    {code: 'IP', label: 'Buy an investment property'}
                ];
                toggleView($existingOwnerPanel, false);
                $amountOwing.val('');
                $amountOwingHidden.val('');
                $propertyWorth.val('');
                $propertyWorthHidden.val('');
            }
            for (var currOpts = [], opts = '<option id="homeloan_details_goal_" value="">Please choose...</option>', i = 0; i < arr.length; i++) {
                opts += '<option id="homeloan_details_goal_' + arr[i].code + '" value="' + arr[i].code + '">' + arr[i].label + '</option>';
                currOpts.push(arr[i].code);
            }

            $lookingTo.html(opts);
            if (currLookingToValue && currOpts.indexOf(currLookingToValue) != -1) {
                $lookingTo.val(currLookingToValue).change();
            }

            var sessionCamStep = getSessionCamStep();
            sessionCamStep.navigationId += "-iAm-" + $iAm.val();
            meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
        });

        // Init the dropdown option for preload or from load quote
        if ($iAm.val() !== '') {
            $iAm.change();
        }

        $lookingTo.on("change", function () {
            var val = $(this).val(),
                currentLoan = $('#homeloan_details_currentLoan_Y').is(':checked');
            if (val == 'CD' || val == 'CL') {
                $amountOwing.val('');
                $amountOwingHidden.val('');
                toggleView($currentLoanPanel, false);
                toggleView($purchasePricePanel, false);
                $purchasePrice.val('');
                $purchasePriceHidden.val('');
            } else if (val === 'FH' || val === 'APL' || val === 'IP') {
                if (currentLoan) {
                    toggleView($currentLoanPanel, true);
                }
                toggleView($purchasePricePanel, true);
            } else {
                if (currentLoan) {
                    toggleView($currentLoanPanel, true);
                }
                toggleView($purchasePricePanel, false);
                $purchasePrice.val('');
                $purchasePriceHidden.val('');
            }
            var sessionCamStep = getSessionCamStep();
            sessionCamStep.navigationId += "-iAm-" + $iAm.val() + "-lookingTo-" + $lookingTo.val();
            meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
        });

        $currentHomeLoan.on("change", function () {
            if ($('#homeloan_details_currentLoan_Y').is(':checked')
                && $lookingTo.val() != 'CD' && $lookingTo.val() != 'CL') {
                toggleView($currentLoanPanel, true);
            } else {
                toggleView($currentLoanPanel, false);
            }
            $amountOwing.val('');
            $amountOwingHidden.val('');
            var sessionCamStep = getSessionCamStep();
            sessionCamStep.navigationId += "-iAm-" + $iAm.val() + "-lookingTo-" + $lookingTo.val() + "-currentLoan-" + $currentHomeLoan.val();
            meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
        });

        // Keep purchase price and loan amount validations in sync

        $purchasePrice.on('blur.hmlValidate', function () {
            if ($loanAmount.val().length === 0) {
                return;
            }

            _.delay(function checkValidation() {
                $loanAmount.isValid(true);
            }, 250);
        });

    }

    /**
     * Pass the element container to hide
     * makeVisible: true will show it, false will hide it.
     */
    function toggleView($el, makeVisible) {
        if (makeVisible) {
            $el.addClass('show_Y').removeClass('show_N show_');
        } else {
            $el.addClass('show_N').removeClass('show_Y show_');
        }

    }

    function init() {

        //Elements need to be in the page
        $(document).ready(function () {
            $firstname = $('#homeloan_contact_firstName');
            $surname = $('#homeloan_contact_lastName');
            $email = $('#homeloan_contact_email');
            $marketing = $('#homeloan_contact_optIn');
            $iAm = $("input[name=homeloan_details_situation]");
            iAm = "input[name=homeloan_details_situation]";
            $lookingTo = $("#homeloan_details_goal");
            $currentHomeLoan = $('input:radio[name="homeloan_details_currentLoan"]');
            $purchasePrice = $('#homeloan_loanDetails_purchasePriceentry');
            $purchasePriceHidden = $('#homeloan_loanDetails_purchasePrice');
            $loanAmount = $('#homeloan_loanDetails_loanAmountentry');
            $amountOwing = $('#homeloan_details_amountOwingentry');
            $amountOwingHidden = $('#homeloan_details_amountOwing');
            $propertyWorth = $('#homeloan_details_assetAmountentry');
            $propertyWorthHidden = $('#homeloan_details_assetAmount');
            $currentLoanPanel = $('#homeloan_details_currentLoanToggleArea');
            $existingOwnerPanel = $('.homeloan_details_existingToggleArea');
            $purchasePricePanel = $('.homeloan_loanDetails_purchasePriceToggleArea');

            applyEventListeners();

        });
    }

    function displayBrandsModal(event) {

        var template = _.template($('#brands-template').html());
        var obj = {};

        obj.pretext = "<h2>Our Home Loan Lender Panel</h2><p>We can help you find a loan to suit your needs. With access to home loan products from over 45 of Australia's reputable lenders, finding a tailored loan to suit your needs has never been so easy.</p>";

        var htmlContent = template(obj);

        var brands = meerkat.modules.dialogs.show({
            title: $(this).attr('title'),
            htmlContent: htmlContent,
            hashId: 'brands',
            closeOnHashChange: true,
            openOnHashChange: false
        });

        return false;
    }

    function getSessionCamStep() {
        if (sessionCamStep === null) {
            sessionCamStep = meerkat.modules.journeyEngine.getCurrentStep();
        }
        return _.extend({}, sessionCamStep); // prevent external override
    }

    meerkat.modules.register("homeloanStart", {
		init: init
    });

})(jQuery);
