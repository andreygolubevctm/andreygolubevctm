/*

Handling of the rebate tiers hidden field

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		$income,
		$healthCoverIncomeLabel;

	function init(){
		$(document).ready(function () {
			initHealthTiers();
		});
	}
	
	function initHealthTiers(){
		$income = $('#health_healthCover_income');
		$healthCoverIncomeLabel = $('#health_healthCover_incomelabel');
	}


	function setIncomeLabel() {
		// Store the text of the income question - for reports and audits.
        var $selectedIncome = $income.find(':selected');
		var incomeLabel = ($selectedIncome.val().length > 0) ? $selectedIncome.text() : '';
		$healthCoverIncomeLabel.val( incomeLabel );
	}

	meerkat.modules.register("healthTiersLabel", {
		init : init,
		setIncomeLabel : setIncomeLabel
	});

})(jQuery);