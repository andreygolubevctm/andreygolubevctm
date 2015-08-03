/**
 * Home Cover Amounts
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var elements = {
			abovePolicyLimitsElement:		"home_coverAmounts_abovePolicyLimits",
			abovePolicyLimitsAmount:		".abovePolicyLimitsAmount",
			itemsAwayElement:				"home_coverAmounts_itemsAway",
			specifyPersonalEffectsElement:	"home_coverAmounts_specifyPersonalEffects",
			bicycle:						"#home_coverAmounts_specifiedPersonalEffects_bicycle",
			bicycleentry:					"#home_coverAmounts_specifiedPersonalEffects_bicycleentry",
			musical:						"#home_coverAmounts_specifiedPersonalEffects_musical",
			clothing:						"#home_coverAmounts_specifiedPersonalEffects_clothing",
			jewellery:						"#home_coverAmounts_specifiedPersonalEffects_jewellery",
			sporting:						"#home_coverAmounts_specifiedPersonalEffects_sporting",
			photo:							"#home_coverAmounts_specifiedPersonalEffects_photo",
			coverTotal:						"#home_coverAmounts_coverTotal",
			principalResidence:				"home_occupancy_principalResidence",
			specifiedItems:					"#specifiedItemsRows",
			abovePolicyLimits:				"#abovePolicyLimitsRow",
			rebuildCost:					"#rebuildCostRow",
			replaceContentsCost:			"#replaceContentsCostRow",
			unspecifiedCoverAmount:			"#unspecifiedCoverAmountRow",
			specifyPersonalEffects:			"#specifyPersonalEffectsRow",
			itemsAway:						"#itemsAwayRow",
			coverType:						'#home_coverType',
			specifiedValues:				'.specifiedValues',
			contentsCost:					"#home_coverAmounts_replaceContentsCostentry"

	};

	function toggleAbovePolicyLimitsAmount (speed){
		if( $('input[name='+elements.abovePolicyLimitsElement+']:checked').val() == 'Y'){
			$(elements.abovePolicyLimitsAmount).slideDown(speed);
		}else{
			$(elements.abovePolicyLimitsAmount).slideUp(speed);
		}
	}

	function toggleCoverAmountsFields(speed){
		$(elements.rebuildCost+', '+elements.replaceContentsCost).find('input[type="hidden"]').each(function(){
			var $this = $(this);
			if($this.val() !== '') {
				$this.attr('data-value', $this.val()).val('');
			}
		});
		var coverType = $(elements.coverType).find('option:selected').val();
		switch(coverType){
			case "Home Cover Only":
				$(elements.abovePolicyLimits+', '+
					elements.replaceContentsCost+', '+
					elements.abovePolicyLimitsAmount+', '+
					elements.itemsAway+', '+
					elements.unspecifiedCoverAmount+', '+
					elements.specifiedItems+', '+
					elements.specifyPersonalEffects
					).slideUp(speed);
				$(elements.rebuildCost).slideDown(speed);

				$hidden = $(elements.rebuildCost+' input[type="hidden"]');
				$hidden.val($hidden.attr('data-value'));

				break;
			case "Contents Cover Only":
				$(elements.rebuildCost).slideUp(speed);
				$(elements.replaceContentsCost+', '+
				elements.abovePolicyLimits+', '+
				elements.itemsAway+', '+
				elements.specifyPersonalEffects
				).slideDown(speed);

				$hidden = $(elements.replaceContentsCost+' input[type="hidden"]');
				$hidden.val($hidden.attr('data-value'));

				break;
			case "Home & Contents Cover":
				$(elements.rebuildCost+', '+
				elements.replaceContentsCost+', '+
				elements.abovePolicyLimits+', '+
				elements.itemsAway+', '+
				elements.specifyPersonalEffects
				).slideDown(speed);

				$hidden = $(elements.rebuildCost+' input[type="hidden"]');
				$hidden.val($hidden.attr('data-value'));
				$hidden = $(elements.replaceContentsCost+' input[type="hidden"]');
				$hidden.val($hidden.attr('data-value'));

				break;
			default:
				break;
		}
		togglePersonalEffectsFields(speed);

	}
	function updateTotalPersonalEffects() {


			var bicycle = Number($(elements.bicycle).val());
			var musical = Number($(elements.musical).val());
			var clothing = Number($(elements.clothing).val());
			var jewellery = Number($(elements.jewellery).val());
			var sporting = Number($(elements.sporting).val());
			var photo = Number($(elements.photo).val());

			var totalVal = bicycle + musical + clothing + jewellery + sporting + photo;

			$(elements.coverTotal).val(totalVal).trigger("blur");

	}

	function togglePersonalEffectsFields(speed) {
		var coverType = $(elements.coverType).find('option:selected').val();
		var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
		if( $('input[name='+elements.itemsAwayElement+']:checked').val() == 'Y' ){

			$(elements.unspecifiedCoverAmount+', '+elements.specifyPersonalEffects).slideDown(speed);

			if( $('input[name='+elements.specifyPersonalEffectsElement+']:checked').val() == 'Y' ){
				$(elements.specifiedItems).slideDown(speed);
			} else {
				$(elements.specifiedItems).slideUp(speed);
			}

		} else {
			hidePersonalEffectsFields(speed);
		}
		if(isPrincipalResidence && $.inArray(coverType, ['Home & Contents Cover', 'Contents Cover Only']) != -1){
			$(elements.itemsAway).slideDown(speed);
		} else {
			$(elements.itemsAway).slideUp(speed);
			hidePersonalEffectsFields(speed);
		}

	}

	function hidePersonalEffectsFields(speed){
		$(elements.unspecifiedCoverAmount+', '+
		elements.specifyPersonalEffects+', '+
		elements.specifiedItems
		).slideUp(speed);
	}

	function applyEventListeners() {
		$(document).ready(function() {
			$('input[name='+elements.abovePolicyLimitsElement+']').on('change', function(){
				toggleAbovePolicyLimitsAmount();
			});

			$('input[name='+elements.itemsAwayElement+'], input[name='+elements.specifyPersonalEffectsElement+']').on('change', function(){
				togglePersonalEffectsFields();
			});

			$(elements.specifiedValues+', '+elements.contentsCost).on('blur', function(){
				updateTotalPersonalEffects();
			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomeCoverAmounts() {
		log("[HomeCoverAmounts] Initialised"); //purely informational
		applyEventListeners();
		$(document).ready(function() {
			toggleAbovePolicyLimitsAmount(0);
			togglePersonalEffectsFields(0);
		});
	}

	meerkat.modules.register('homeCoverAmounts', {
		initHomeCoverAmounts: initHomeCoverAmounts, //main entrypoint to be called.
		toggleCoverAmountsFields: toggleCoverAmountsFields,
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);