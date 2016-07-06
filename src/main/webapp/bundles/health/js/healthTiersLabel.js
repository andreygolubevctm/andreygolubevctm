/*

Handling of the rebate tiers hidden field

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		initialised = false,
		$income,
		$healthCoverIncomeLabel;

	function init(){
		$(document).ready(function () {
			initHealthTiers();
		});
	}


	function initHealthTiers(){
		if(!initialised) {
			initialised = true;
			$income = $('#health_healthCover_income');
			$healthCoverIncomeLabel = $('#health_healthCover_incomelabel');
		}
	};


	setIncomeLabel = function() {
		// Store the text of the income question - for reports and audits.
        var $selectedIncome = $income.find(':selected');
		var incomeLabel = ($selectedIncome.val().length > 0) ? $selectedIncome.text() : '';
		$healthCoverIncomeLabel.val( incomeLabel );
	};

    clearIncomeLabel = function() {
		$healthCoverIncomeLabel.val('');
    };

	meerkat.modules.register("healthTiersLabel", {
		init : init,
		setIncomeLabel : setIncomeLabel,
        clearIncomeLabel : clearIncomeLabel
	});

})(jQuery);