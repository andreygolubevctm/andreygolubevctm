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
		$incomeMessage,
		$incomeBase,
		$income;

	initHealthTiers =  function(){
		$dependants = $('#health_healthCover_dependants');
		$incomeMessage = $('#health_healthCover_incomeMessage');
		$incomeBase = $('#health_healthCover_incomeBase');
		$income = $('#health_healthCover_income');
	};

	// Manages the descriptive titles of the tier drop-down
	setTiers =  function(initMode){
		// Set the dependants allowance and income message
		var _allowance = ($dependants.val() - 1);

		if( _allowance > 0 ){
			_allowance = _allowance * 1500;
			$incomeMessage.text('this includes an adjustment for your dependants');
		} else {
			_allowance = 0;
			$incomeMessage.text('');
		}

		//Set the tier type based on hierarchy of selection
		var _isSingleFamilyType = _.indexOf(['','S', 'SF', 'SM'], meerkat.modules.healthChoices.returnCoverCode()) !== -1;
		var _cover = meerkat.modules.healthChoices.returnCoverCode();
		var _base = false;
		if( $incomeBase.css('display') !== 'none' && $incomeBase.find(':checked').length > 0 ) {
			_base = $incomeBase.find(':checked').val();
		}

		// Reset and then loop through all of the options
		$income.find('option').each( function() {
			//set default vars
			var $this = $(this);
			var _value = $this.val();
			var _text = '';

			// Calculate the Age Bonus
			if( meerkat.modules.health.getRates() === null){
				_ageBonus = 0;
			} else {
				_ageBonus = parseInt(meerkat.modules.health.getRates().ageBonus);
			}

			if((_isSingleFamilyType && _base !== 'H') || _base === 'S'){
				// Single tiers
				switch(_value) {
					case '0':
						_text = '$'+ formatMoney(rebateTiers.single.incomeBaseTier) +' or less (Base Tier, Tier 0)';
						break;
					case '1':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier1.from) +' - $'+ formatMoney(rebateTiers.single.incomeTier1.to) + ' (Tier 1)';
						break;
					case '2':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier2.from) +' - $'+ formatMoney(rebateTiers.single.incomeTier2.to) + ' (Tier 2)';
						break;
					case '3':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier3) + '+ (Tier 3 - no rebate)';
						break;
				}
			} else {
				// Family tiers
				if(_cover === 'C') { _allowance = 0; }

				switch(_value) {
					case '0':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeBaseTier + _allowance) +' or less (Base Tier, Tier 0)';
						break;
					case '1':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier1.from + _allowance) +' - $'+ formatMoney(rebateTiers.familyOrCouple.incomeTier1.to + _allowance) + '  (Tier 1)';
						break;
					case '2':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier2.from + _allowance) +' - $'+ formatMoney(rebateTiers.familyOrCouple.incomeTier2.to + _allowance) + '  (Tier 2)';
						break;
					case '3':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier3 + _allowance) + '+ (Tier 3 - no rebate)';
						break;
					}
			}

			// Set Description
			if(_text !== ''){
				$this.text(_text);
			}
		});

	
	};

	function getIncome() {
		return $income.val();
	}

	meerkat.modules.register("healthTiers", {
		initHealthTiers: initHealthTiers,
		setTiers: setTiers,
		getIncome: getIncome
	});

})(jQuery);