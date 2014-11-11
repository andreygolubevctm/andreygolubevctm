/*
 *
 * Handling of the start page
 *
*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$firstname,
		$surname,
		$email,
		$marketing,
		$iAm,
		$lookingTo,
		$currentHomeLoan,
		$purchasePrice,
		$loanAmount,
		$amountOwing,
		$currentLoanPanel,
		$existingOwnerPanel,
		$purchasePricePanel;


	function applyEventListeners(){

		$(document.body).on('click', '.btn-view-brands', displayBrandsModal);

		$marketing.on('change', function() {

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

		$iAm.on("change", function() {
			var arr = [],
			currLookingToValue = $lookingTo.val();
			$lookingTo.val('');
			if ($iAm.val() === 'E') {
				arr = [{code:'APL', label: 'Buy another property to live in'},
					{code:'IP', label: 'Buy an investment property'},
					{code:'REP', label: 'Renovate my existing property'},
					{code:'CD', label: 'Consolidate my debt'},
					{code:'CL', label: 'Compare better home loan options'}
				];
				$existingOwnerPanel.addClass('show_Y').removeClass('show_N').removeClass('show_');
			} else {
				arr = [{code:'FH', label: 'Buy my first home'},{code:'IP', label: 'Buy an investment property'}];
				//$lookingTo.html('<option value="">Please choose...</option><option value="FH">Buy my first home</option><option value="IP">Buy an investment property</option>');
				$existingOwnerPanel.addClass('show_N').removeClass('show_Y').removeClass('show_');
				$amountOwing.val('');
			}
			for(var currOpts = [], opts = '<option id="homeloan_details_goal_" value="">Please choose...</option>', i = 0; i < arr.length; i++) {
				opts += '<option id="homeloan_details_goal_'+arr[i].code+'" value="'+arr[i].code+'">'+arr[i].label+'</option>';
				currOpts.push(arr[i].code);
			}

			$lookingTo.html(opts);
			if(currLookingToValue && currOpts.indexOf(currLookingToValue) != -1)  {
				$lookingTo.val(currLookingToValue).change();
			}
		});

		// Init the dropdown option for preload or from load quote
		if($iAm.val() !== '') {
			$iAm.change();
		}

		$lookingTo.on("change", function() {
			if ($lookingTo.val() === 'FH' || $lookingTo.val() === 'APL' || $lookingTo.val() === 'IP') {
				$purchasePricePanel.addClass('show_Y').removeClass('show_N').removeClass('show_');
			} else {
				$purchasePricePanel.addClass('show_N').removeClass('show_Y').removeClass('show_');
				$purchasePrice.val('');
			}
		});

		$currentHomeLoan.on("change", function() {
			if ($('#homeloan_details_currentLoan_Y').is(':checked')) {
				$amountOwing.val('');
				$currentLoanPanel.addClass('show_Y').removeClass('show_N').removeClass('show_');
			} else {
				$currentLoanPanel.addClass('show_N').removeClass('show_Y').removeClass('show_');
				$amountOwing.val('');
			}
		});

		// Keep purchase price and loan amount validations in sync

		$loanAmount.on('blur.hmlValidate', function() {
			if ($purchasePrice.val().length === 0) return;

			_.delay(function checkValidation() {
				$purchasePrice.isValid(true);
			}, 250);
		});

		$purchasePrice.on('blur.hmlValidate', function() {
			if ($loanAmount.val().length === 0) return;

			_.delay(function checkValidation() {
				$loanAmount.isValid(true);
			}, 250);
		});

	}

	function init(){

		//Elements need to be in the page
		$(document).ready(function() {
			$firstname = $('#homeloan_contact_firstName');
			$surname = $('#homeloan_contact_lastName');
			$email = $('#homeloan_contact_email');
			$marketing = $('#homeloan_contact_optIn');
			$iAm = $("#homeloan_details_situation");
			$lookingTo = $("#homeloan_details_goal");
			$currentHomeLoan = $('input:radio[name="homeloan_details_currentLoan"]');
			$purchasePrice = $('#homeloan_loanDetails_purchasePriceentry');
			$loanAmount = $('#homeloan_loanDetails_loanAmountentry');
			$amountOwing = $('#homeloan_details_amountOwingentry');
			$currentLoanPanel = $('#homeloan_details_currentLoanToggleArea');
			$existingOwnerPanel = $('.homeloan_details_existingToggleArea');
			$purchasePricePanel = $('.homeloan_loanDetails_purchasePriceToggleArea');
			$firstname.removeAttr('required');
			$surname.removeAttr('required');
			$email.removeAttr('required');

			applyEventListeners();

		});
	}

	function displayBrandsModal(event) {

			var template = _.template($('#brands-template').html());
			var obj = {};

			obj.pretext = "<h2>Our Home Loan Lender Panel</h2><p>We can help you find a loan to suit your needs. With access to over 1,300 home loan products from 29 of Australia's reputable lenders, finding a tailored loan to suit your needs has never been so easy.</p>";

			var htmlContent = template(obj);

			var brands = meerkat.modules.dialogs.show({
					title : $(this).attr('title'),
					htmlContent : htmlContent,
					hashId : 'brands',
					closeOnHashChange: true,
					openOnHashChange: false
			});

			return false;
	}

	meerkat.modules.register("homeloanStart", {
		init: init
	});

})(jQuery);