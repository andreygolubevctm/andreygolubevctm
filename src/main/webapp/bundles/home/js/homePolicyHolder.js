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
			toggleRetired(speed);
		} else {
			$(elements.retired+', '+elements.otherOccupantsRow).slideUp(speed);
		}

	}

	function toggleRetired(speed){
		var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
		var dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
		var dob = $("#"+elements.name+"_dob");
		var jointDob = $("#"+elements.name+"_jointDob");

		if(isPrincipalResidence &&
			(
				( dob.val().match(dateFormat) && getAge( dob.val() ) >= 55 ) ||
				( jointDob.val().match(dateFormat) && getAge( jointDob.val() ) >= 55 )
			)
		) {
			$(elements.retired).slideDown(speed);
		} else {
			$(elements.retired).slideUp(speed);
		}
	}

	function getAge (dateString) {
		var today = new Date();
		var dateSplit = dateString.split("/").reverse();
		var age = today.getFullYear() - parseInt(dateSplit[0],10);
		var m = today.getMonth()+1 - parseInt(dateSplit[1],10);
		if (m < 0 || (m === 0 && today.getDate() < parseInt(dateSplit[2],10))) {
			age--;
		}
		return age;
	}

	function applyEventListeners() {
		$(document).ready(function() {
			$("#"+elements.name+"_dob, #"+elements.name+"_jointDob").on('change', function(){
				toggleRetired();
			});
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
