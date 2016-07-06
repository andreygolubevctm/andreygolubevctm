/*

Handling of the rebate tiers hidden field

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		initialised = false;


	setIncomeLabel = function() {
		// Store the text of the income question - for reports and audits.
        var $selectedIncome = meerkat.modules.healthTiersView.getIncome().find(':selected');
		var incomeLabel = ($selectedIncome.val().length > 0) ? $selectedIncome.text() : '';
		meerkat.modules.healthTiersView.getIncomeLabel().val( incomeLabel );
	};

    clearIncomeLabel = function() {
		meerkat.modules.healthTiersView.getIncomeLabel().val('');
    };

	meerkat.modules.register("healthTiersLabel", {
		setIncomeLabel : setIncomeLabel,
        clearIncomeLabel : clearIncomeLabel
	});

})(jQuery);