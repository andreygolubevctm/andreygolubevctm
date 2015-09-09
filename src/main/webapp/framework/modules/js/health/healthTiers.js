/*

Handling of the rebate tiers based off situation

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		initialised = false,
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
		$income,
		$tier,
		$medicare;

	initHealthTiers =  function(){
		if(!initialised) {
			initialised = true;
			$dependants = $('#health_healthCover_dependants');
			$incomeMessage = $('#health_healthCover_incomeMessage');
			$incomeBase = $('#health_healthCover_incomeBase');
			$income = $('#health_healthCover_income');
			$tier = $('#health_healthCover_tier');
			$medicare = $('.health-medicare_details');
		}
	};

	// Manages the descriptive titles of the tier drop-down
	setTiers =  function(initMode){
		if(!initialised) {
			initHealthTiers();
		}
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
		var _cover;
		if( $incomeBase.is(':visible') && $('#health_healthCover_incomeBase').find(':checked').length > 0 ) {
			_cover = $incomeBase.find(':checked').val();
		} else {
			_cover = healthChoices.returnCoverCode();
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

			if(_cover === 'S' || _cover === 'SM' || _cover === 'SF' || _cover === ''){
				// Single tiers
				switch(_value) {
					case '0':
						_text = '$'+ formatMoney(rebateTiers.single.incomeBaseTier + _allowance) +' or less';
						break;
					case '1':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier1.from + _allowance) +' - $'+ formatMoney(rebateTiers.single.incomeTier1.to + _allowance);
						break;
					case '2':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier2.from + _allowance) +' - $'+ formatMoney(rebateTiers.single.incomeTier2.to + _allowance);
						break;
					case '3':
						_text = '$'+ formatMoney(rebateTiers.single.incomeTier3 + _allowance) + '+ (no rebate)';
						break;
				}
			} else {
				// Family tiers
				switch(_value) {
					case '0':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeBaseTier + _allowance) +' or less';
						break;
					case '1':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier1.from + _allowance) +' - $'+ formatMoney(rebateTiers.familyOrCouple.incomeTier1.to + _allowance);
						break;
					case '2':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier2.from + _allowance) +' - $'+ formatMoney(rebateTiers.familyOrCouple.incomeTier2.to + _allowance);
						break;
					case '3':
						_text = '$'+ formatMoney(rebateTiers.familyOrCouple.incomeTier3 + _allowance) + '+ (no rebate)';
						break;
					}
			}

			// Set Description
			if(_text !== ''){
				$this.text(_text);
			}

			// Hide these questions as they are not required
			if( healthCoverDetails.getRebateChoice() == 'N' || !healthCoverDetails.getRebateChoice() ) {
				if(initMode){
					$tier.hide();
				}else{
					$tier.slideUp();
				}

				$medicare.hide();
				meerkat.modules.form.clearInitialFieldsAttribute($medicare);
			} else {

				if(initMode){
					$tier.show();
				}else{
					$tier.slideDown();
				}

				$medicare.show();
			}
		});

	
	};

	meerkat.modules.register("healthTiers", {
		initHealthTiers: initHealthTiers,
		setTiers: setTiers
	});

})(jQuery);