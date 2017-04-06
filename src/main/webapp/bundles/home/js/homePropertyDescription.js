/**
 * Property Description set logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var initialised = false;
	var elements = {
			name:					"home_property",
			propertyType:			"home_property_propertyType",
			yearBuilt:				"home_property_yearBuilt",
			bestDescribesHome:		".bestDescribesHome",
			heritage:				".heritage"

	};

	function validateYearBuilt () {
		$('#'+elements.yearBuilt).blur();
	}
	/* Here you put all functions for use in your module */
	function toggleBestDescribesHome(speed){

		if( $('#'+elements.propertyType).find('option:selected').text().toLowerCase() == 'other') {
			$(elements.bestDescribesHome).slideDown(speed);
		} else {
			$(elements.bestDescribesHome).slideUp(speed);
		}

	}
	function toggleHeritage(speed){

		if( parseInt( $('#'+elements.yearBuilt).find('option:selected').val() ) <= 1914 ) {
			$(elements.heritage).slideDown(speed);
		} else {
			$(elements.heritage).slideUp(speed);
		}

	}
	function applyEventListeners() {
		$(document).ready(function() {
			$('#'+elements.propertyType).on('change', function(){
				toggleBestDescribesHome();
			});

			$('#'+elements.yearBuilt).on('change', function(){
				toggleHeritage();
			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomePropertyDetails() {
		if(!initialised) {
			initialised = true;
			log("[HomeProperties] Initialised"); //purely informational
			applyEventListeners();
			toggleBestDescribesHome(0);
			toggleHeritage(0);
		}
	}

	function setupButtonTileDropdownSelectors() {
		var propertyTypeItems = meerkat.modules.home.getHomeUnitsItems($('#home_property_propertyType')),
			wallMaterialItems = meerkat.modules.home.getHomeUnitsItems($('#home_property_wallMaterial')),
			roofMaterialItems = meerkat.modules.home.getHomeUnitsItems($('#home_property_roofMaterial')),
			settings = [{
				$container: $('#propertyTypeContainer'),
				items: propertyTypeItems[meerkat.modules.home.getPropertyType()]
			}, {
				$container: $('#wallMaterialContainer'),
				items: wallMaterialItems[meerkat.modules.home.getPropertyType()]
			}, {
				$container: $('#roofMaterialContainer'),
				items: roofMaterialItems[meerkat.modules.home.getPropertyType()]
			}];

		meerkat.modules.buttonTileDropdownSelector.initButtonTileDropdownSelector(settings);
	}

	meerkat.modules.register('homePropertyDetails', {
		initHomePropertyDetails: initHomePropertyDetails, //main entrypoint to be called.
		events: moduleEvents, //exposes the events object
		validateYearBuilt: validateYearBuilt,
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
		setupButtonTileDropdownSelectors: setupButtonTileDropdownSelectors
	});

})(jQuery);

