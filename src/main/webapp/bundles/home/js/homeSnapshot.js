/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
			homeSnapshot: {
			}
		},
		$coverType = $('#home_coverType');

	function initHomeSnapshot() {

		// Initial render
		meerkat.messaging.subscribe(meerkat.modules.events.journeyEngine.READY, function renderSnapshotOnJourneyReadySubscription() {
			_.defer(function() {
				renderSnapshot();
			});
		});

        registerSnapShotFields();
	}

    function getHomeAmount($sourceElement) {
        return meerkat.modules.home.getCoverType() === 'H' || meerkat.modules.home.getCoverType() === 'HC' ? $sourceElement.val() : '';
    }

    function getContentAmount($sourceElement) {
        return meerkat.modules.home.getCoverType() === 'C' || meerkat.modules.home.getCoverType() === 'HC' ? $sourceElement.val() : '';
    }

    function getJointHolderName($sourceElement) {
        return meerkat.modules.homePolicyHolder.getHasJointHolder() === true ? $sourceElement.val() + ' ' + $('#home_policyHolder_jointFirstName').val() + ' ' + $('#home_policyHolder_jointLastName').val() : '';
    }

    function getJointHolderDob($sourceElement) {
        return meerkat.modules.homePolicyHolder.getHasJointHolder() === true ? $sourceElement.val() : '';
    }

	/**
	 * Which icon to render depending on what the cover type is.
	 */
	function renderSnapshot() {
		var coverType = $coverType.val();
		var $snapshotBox = $(".quoteSnapshot");

		if (!_.isEmpty(coverType)) {
			$snapshotBox.removeClass('hidden');
		} else {
			$snapshotBox.addClass('hidden');
		}

        meerkat.modules.contentPopulation.render('.cover-snapshot', true);
        meerkat.modules.contentPopulation.render('.amount-snapshot', true);
        meerkat.modules.contentPopulation.render('.holder-snapshot', true);
	}

    /**
     * Register all fields change events here instead of doing it one by one through other modules
     */
    function registerSnapShotFields() {

        var fieldsArray = [
            $coverType,
            $("#home_property_address_nonStd"),
            $('#home_property_address_autofilllessSearch'),
            $('#home_property_address_streetSearch'),
            $('#home_property_address_streetNum'),
            $('#home_property_address_nonStdPostCode'),
            $('#home_property_address_suburb'),
            $('#home_property_address_nonStdStreet'),
            $('#home_property_address_unitShop'),
            $('#home_property_address_nonStdUnitType'),
            $('#home_coverAmounts_rebuildCostentry'),
            $('#home_coverAmounts_replaceContentsCostentry'),
            $('#home_policyHolder_title'),
            $('#home_policyHolder_firstName'),
            $('#home_policyHolder_lastName'),
            $('#home_policyHolder_dob'),
            $('#home_policyHolder_jointTitle'),
            $('#home_policyHolder_jointFirstName'),
            $('#home_policyHolder_jointLastName'),
            $('#home_policyHolder_jointDob'),
            $('#home_coverAmounts_replaceContentsCostLandlordentry')
        ];

        $(fieldsArray).each(function () {
            $(this).on('change blur', function snapshotFieldChanged(){
                _.defer(renderSnapshot);
            });
        });

        $(".toggleJointPolicyHolder").on('click', function snapshotToogleClicked() {
            _.defer(renderSnapshot);
        });
    }

	/**
	 * Utility function used here and in edit details
	 */
	function getIcon() {
		var icon = 'icon-home-contents';
		switch($coverType.val()) {
			case 'Home Cover Only':
				icon = 'icon-house';
				break;
			case 'Contents Cover Only':
				icon = 'icon-contents';
				break;
		}
		return icon;
	}

	/*
	*	Get the first line of the full address
	*/
	function getAddressFirstLine($element) {
		var address = "";
		if($element) {
			address = $element.val();
			if (address.indexOf(",") > 0) {
				var pieces = address.split(/,/g);
				address = $.trim(pieces[0]);
			}
		}
		return address;
	}

	meerkat.modules.register('homeSnapshot', {
		init: initHomeSnapshot,
		events: events,
		getIcon: getIcon,
		getAddressFirstLine: getAddressFirstLine,
        getHomeAmount: getHomeAmount,
        getContentAmount: getContentAmount,
        getJointHolderName: getJointHolderName,
        getJointHolderDob: getJointHolderDob
	});

})(jQuery);