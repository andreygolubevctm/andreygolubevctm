/**
 * Policy Holder question set logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var initialised = false,
        hasJointHolder = false;
	var elements = {
			name:						'home_policyHolder',
			principalResidence:			"home_occupancy_principalResidence",
			isLandlord:					"home_occupancy_isLandlord",
        	retired:					".retired",
			otherOccupantsRow:			"#home_policyHolder_other_occupants",
			toggleJointPolicyHolder:	$(".toggleJointPolicyHolder"),
			jointPolicyHolder:			$("#jointPolicyHolder"),
			addPolicyHolderBtn:			$(".addPolicyHolderBtn")
	};



	function togglePolicyHolderFields(speed){
		var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
		if(isPrincipalResidence){
			$(elements.otherOccupantsRow).slideDown(speed);
		} else {
			$(elements.retired+', '+elements.otherOccupantsRow).slideUp(speed);
		}
        toggleRetired(speed);
	}

    /**
     * Responsible for show/hide `is any person retired` question.
     * - show question when applicant is principle resident, else hide (if landlord).
     *
     * @param speed
     */
    function toggleRetired(speed) {
        var isLandlord = meerkat.site.isLandlord;
        if (isLandlord) {
            $(elements.retired).slideUp(speed); //hide
        } else {
            $(elements.retired).slideDown(speed); //show
        }
    }

	function applyEventListeners() {
		$(document).ready(function() {
			elements.toggleJointPolicyHolder.on("click", function(){
				if ( elements.jointPolicyHolder.is(":visible") ){
                    hasJointHolder = false;
					elements.jointPolicyHolder.slideUp(400);
					elements.addPolicyHolderBtn.slideDown();
				} else {
                    hasJointHolder = true;
					elements.jointPolicyHolder.slideDown(400);
					elements.addPolicyHolderBtn.slideUp();
				}
				toggleRetired();
			});
		});
	}
    function getHasJointHolder() {
        return hasJointHolder;
    }
	/* main entrypoint for the module to run first */
	function initHomePolicyHolder() {
		if(!initialised) {
			initialised = true;
			log("[HomePolicyHolder] Initialised"); //purely informational
			applyEventListeners();
			togglePolicyHolderFields(0);
			toggleRetired(0);
			elements.jointPolicyHolder.hide();
			if ($("#home_policyHolder_jointFirstName").val() !== "" || $("#home_policyHolder_jointLastName").val() !== "" || $("#home_policyHolder_jointDob").val() !== "") {
				elements.toggleJointPolicyHolder.click();
			}
		}
	}

	meerkat.modules.register('homePolicyHolder', {
		initHomePolicyHolder: initHomePolicyHolder, //main entrypoint to be called.
		togglePolicyHolderFields : togglePolicyHolderFields,
        getHasJointHolder: getHasJointHolder,
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);
