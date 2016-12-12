/*

Handling of the rebate tiers based off situation

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		rebateTiers = {
			single:{
				incomeBaseTier:90000,
				incomeTier1:{
					from:90001,
					to:105000
				},incomeTier2:{
					from:105001,
					to:140000
				},
				incomeTier3:140001
			},
			familyOrCouple:{
				incomeBaseTier:180000,
				incomeTier1:{
					from:180001,
					to:210000
				},
				incomeTier2:{
					from:210001,
					to:280000
				},
				incomeTier3:280001
			}
		},
		$dependants,
		$incomeBase,
		$income,
		allowance = 0;

	function initHealthTiers(){
		$dependants = $('#health_healthCover_dependants');
		$incomeBase = $('#health_healthCover_incomeBase');
		$income = $('#health_healthCover_income');
	}

	function shouldShowDependants() {
		return allowance > 0;
	}

	// Manages the descriptive titles of the tier drop-down
	function setTiers(initMode){
		// Set the dependants allowance and income message
		if (!initMode) {
			allowance = meerkat.modules.healthRebate.getDependents();
			allowance = (allowance > 0 ? allowance * 1500 : 0);
		}

		//Set the tier type based on hierarchy of selection
		var _cover;
		if( $incomeBase.is(':visible') && $('#health_healthCover_incomeBase').find(':checked').length > 0 ) {
			_cover = $incomeBase.find(':checked').val();
		} else {
			_cover = meerkat.modules.healthChoices.returnCoverCode();
		}

		// Reset and then loop through all of the options
		$income.find('option').each( function() {
			//set default vars
			var $this = $(this);
			var _value = $this.val();
			var _text = '';

			// Calculate the Age Bonus
			if( meerkat.modules.healthRebate.getRates() === null){
				_ageBonus = 0;
			} else {
				_ageBonus = parseInt(meerkat.modules.healthRebate.getRates().ageBonus);
			}

			if(_cover === 'S' || _cover === 'SM' || _cover === 'SF' || _cover === ''){
				// Single tiers
				switch(_value) {
					case '0':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.single.incomeBaseTier) +' or less';
						break;
					case '1':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.single.incomeTier1.from) +' - $'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.single.incomeTier1.to);
						break;
					case '2':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.single.incomeTier2.from) +' - $'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.single.incomeTier2.to);
						break;
					case '3':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.single.incomeTier3) + '+ (no rebate)';
						break;
				}
			} else {
				// Family tiers
				if(_cover === 'C') { allowance = 0; }

				switch(_value) {
					case '0':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.familyOrCouple.incomeBaseTier + allowance) +' or less';
						break;
					case '1':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.familyOrCouple.incomeTier1.from + allowance) +' - $'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.familyOrCouple.incomeTier1.to + allowance);
						break;
					case '2':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.familyOrCouple.incomeTier2.from + allowance) +' - $'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.familyOrCouple.incomeTier2.to + allowance);
						break;
					case '3':
						_text = '$'+ meerkat.modules.currencyUtils.formatMoney(rebateTiers.familyOrCouple.incomeTier3 + allowance) + '+ (no rebate)';
						break;
					}
			}

			// Set Description
			if(_text !== ''){
				$this.text(_text);
			}
		});

		if (!initMode) {
			// after updating the dropdown, update the income label
			meerkat.modules.healthRebate.updateSelectedRebateLabel();
		}
	}

	meerkat.modules.register("healthTiers", {
		initHealthTiers: initHealthTiers,
		setTiers: setTiers,
		shouldShowDependants: shouldShowDependants
	});

})(jQuery);