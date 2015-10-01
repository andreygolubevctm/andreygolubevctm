/**
 * Policy Holder question set logic
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {}, steps = null;

	/* Variables */
	var initialised = false;
	var elements = {
			name:						'home_policyHolder',
			anyoneOlder:				'home_policyHolder_anyoneOlder',
			oldestDOBRow:				'#oldest_person_DOB',
			anyoneOlderRow:				'#anyoneOlder',
			principalResidence:			"home_occupancy_principalResidence",
			over55:						".over55",
			otherOccupantsRow:			"#home_policyHolder_other_occupants",
			toggleJointPolicyHolder:	$(".toggleJointPolicyHolder"),
			jointPolicyHolder:			$("#jointPolicyHolder"),
			addPolicyHolderBtn:			$(".addPolicyHolderBtn"),
			oldestPersonDob:			$('#home_policyHolder_oldestPersonDob')

	};

	function toggleOldestPerson(speed){
		var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
		if( $('input[name='+elements.anyoneOlder+']:checked').val() == 'Y' && isPrincipalResidence){
			$(elements.oldestDOBRow).slideDown(speed);
		} else {
			$(elements.oldestDOBRow).slideUp(speed);
		}
		toggleOver55(speed);
	}

	function togglePolicyHolderFields(speed){
		var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
		if(isPrincipalResidence){
			$(elements.anyoneOlderRow+', '+elements.otherOccupantsRow).slideDown(speed);
			toggleOldestPerson(speed);
			toggleOver55(speed);
		} else {
			$(elements.anyoneOlderRow+', '+elements.over55+', '+elements.oldestDOBRow+', '+elements.otherOccupantsRow).slideUp(speed);
		}

	}

	function toggleOver55(speed){
		var isPrincipalResidence = meerkat.modules.homeOccupancy.isPrincipalResidence();
		var dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

		var dob = $("#"+elements.name+"_dob");
		var jointDob = $("#"+elements.name+"_jointDob");
		var anyoneOlder =  $('input[name='+elements.anyoneOlder+']:checked').val();

		if(isPrincipalResidence &&
			(
				( dob.val().match(dateFormat) && getAge( dob.val() ) >= 55 ) ||
				( jointDob.val().match(dateFormat) && getAge( jointDob.val() ) >= 55 ) ||
				( anyoneOlder === 'Y' && elements.oldestPersonDob.val().match(dateFormat) && getAge( elements.oldestPersonDob.val() ) >= 55 )
			)
		) {
			$(elements.over55).slideDown(speed, function() {
				blurOldestPersonField();
			});
		} else {
			$(elements.over55).slideUp(speed, function() {
				blurOldestPersonField();
			});
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
	function blurOldestPersonField () {
		elements.oldestPersonDob.trigger('blur');
	}
	function applyEventListeners() {
		$(document).ready(function() {
			$('input[name='+elements.anyoneOlder+']').on('change', function() {
				toggleOldestPerson();
			});

			$("#"+elements.name+"_dob, #"+elements.name+"_jointDob").add(elements.oldestPersonDob).on('change', function(){
				toggleOldestPerson();
				toggleOver55();
			});
			elements.toggleJointPolicyHolder.on("click", function(){
				if ( elements.jointPolicyHolder.is(":visible") ){
					elements.jointPolicyHolder.slideUp(400, function() {
						blurOldestPersonField();
					});
					elements.addPolicyHolderBtn.slideDown();
				} else {
					elements.jointPolicyHolder.slideDown(400, function() {
						blurOldestPersonField();
					});
					elements.addPolicyHolderBtn.slideUp();
				}
				toggleOver55();
			});
		});
	}
	/* main entrypoint for the module to run first */
	function initHomePolicyHolder() {
		if(!initialised) {
			initialised = true;
			log("[HomePolicyHolder] Initialised"); //purely informational
			applyEventListeners();
			togglePolicyHolderFields(0);
			toggleOldestPerson(0);
			toggleOver55(0);
			elements.jointPolicyHolder.hide();
			if ($("#home_policyHolder_jointFirstName").val() !== "" || $("#home_policyHolder_jointLastName").val() !== "" || $("#home_policyHolder_jointDob").val() !== "" || $("#home_policyHolder_jointDob").val() !== "") {
				elements.toggleJointPolicyHolder.click();
			}
		}
	}

	meerkat.modules.register('homePolicyHolder', {
		initHomePolicyHolder: initHomePolicyHolder, //main entrypoint to be called.
		togglePolicyHolderFields : togglePolicyHolderFields,
		events: moduleEvents //exposes the events object
		//here you can optionally expose functions for use on the 'meerkat.modules.example' object
	});

})(jQuery);