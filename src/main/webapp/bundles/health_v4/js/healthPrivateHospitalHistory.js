(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    function init() {
        _setupFields();
        _applyEventListeners_primary();
        _applyEventListeners_partner();
    }

    function _setupFields() {

        $elements = {
            primary: _createFieldReferences('health_previousfund_', 'primary', '_fundHistory_'),
            partner: _createFieldReferences('health_previousfund_', 'partner', '_fundHistory_')
        };
    }

    function _createFieldReferences ( xpathPrefix, applicant, xpathPostFix) {

        var xpath = xpathPrefix + applicant + xpathPostFix;

        return {
            startDateFieldName: xpath + 'dates_controls_startDateInput',
            endDateFieldName: xpath + 'dates_controls_endDateInput',
            addBtnFieldName: xpath + 'dates_controls_add',
            cancelBtnFieldName: xpath + 'dates_controls_cancel',
            startDate: $('input[name=' + xpath + 'dates_controls_startDateInput]'),
            endDate: $('input[name=' + xpath + 'dates_controls_endDateInput]'),
            addBtn: $('#' + xpath + 'dates_controls_add'),
            editBtn: $('#' + xpath + 'dates_controls_edit'),
            cancelBtn: $('#' + xpath + 'dates_controls_cancel'),
            startDateValidationLabel: $('#' + xpath + 'dates_controls_startDateInput-error'),
            endDateValidationLabel: $('#' + xpath + 'dates_controls_endDateInput-error'),
            validationContainer: $('#' + xpath + 'dates_controls_datesEntryValidationContainer'),
            validationContainerId: xpath + 'dates_controls_datesEntryValidationContainer',
            coverHistoryTableContainer: $('#' + xpath + 'dates_dataTableContainer'),
            idPrefix: applicant + '_',
            coverDatesHiddenField: $('input[name=' + xpath + 'dates_coverDates]'),
            coverDates: [],
            selectedRowId: -1
        };
    }

    function _applyEventListeners_primary() {

        var applicant = 'primary';

        $elements[applicant].addBtn.on('click', function primaryAddPrivateHospitalHistoryRow() {
            event.preventDefault();

            _addbtn_EventListener(applicant);
        });

        $elements[applicant].editBtn.on('click', function primaryEditPrivateHospitalHistoryRow() {
            event.preventDefault();

            _editbtn_EventListener(applicant);
        });

        $elements[applicant].cancelBtn.on('click', function primaryCancelEditPrivateHospitalHistoryRow() {
            event.preventDefault();

            _cancelbtn_EventListener(applicant);
        });

    }

    function _applyEventListeners_partner() {

        var applicant = 'partner';

        $elements[applicant].addBtn.on('click', function partnerAddPrivateHospitalHistoryRow() {
            event.preventDefault();

            _addbtn_EventListener(applicant);
        });

        $elements[applicant].editBtn.on('click', function partnerEditPrivateHospitalHistoryRow() {
            event.preventDefault();

            _editbtn_EventListener(applicant);
        });

        $elements[applicant].cancelBtn.on('click', function partnerCancelEditPrivateHospitalHistoryRow() {
            event.preventDefault();

            _cancelbtn_EventListener(applicant);
        });

    }

    function _addbtn_EventListener(applicant) {

        $elements[applicant].selectedRowId = -1;

        var myEntry = { "from": $elements[applicant].startDate.val(), "to": $elements[applicant].endDate.val()};
        var isDataTableValidationSuccessful = _validateCoverDatesDataTable(applicant, $elements[applicant].startDate.val(), $elements[applicant].endDate.val());

        if (isDataTableValidationSuccessful) {
            $elements[applicant].coverDates.push(myEntry);
            $elements[applicant].coverDates.sort(function(a, b){
                return (b["to"] > a["to"]);
            });

            $elements[applicant].startDate.val("");
            $elements[applicant].endDate.val("");

            _displayCoverDatesDataTable(applicant);

            $elements[applicant].coverDatesHiddenField.val(JSON.stringify($elements[applicant].coverDates));
        }
    }

    function _editbtn_EventListener(applicant) {

        var myEntry = { "from": $elements[applicant].startDate.val(), "to": $elements[applicant].endDate.val()};
        var isDataTableValidationSuccessful = _validateCoverDatesDataTable(applicant, $elements[applicant].startDate.val(), $elements[applicant].endDate.val());

        if (isDataTableValidationSuccessful) {
            $elements[applicant].coverDates.splice($elements[applicant].selectedRowId, 1);
            $elements[applicant].coverDates.push(myEntry);
            $elements[applicant].selectedRowId = -1;
            $elements[applicant].coverDates.sort(function(a, b){
                return (b["to"] > a["to"]);
            });

            $elements[applicant].startDate.val("");
            $elements[applicant].endDate.val("");
            $elements[applicant].addBtn.show();
            $elements[applicant].editBtn.toggleClass( "hidden", true );
            $elements[applicant].cancelBtn.toggleClass( "hidden", true );

            _displayCoverDatesDataTable(applicant);

            $elements[applicant].coverDatesHiddenField.val(JSON.stringify($elements[applicant].coverDates));
        }
    }

    function _cancelbtn_EventListener(applicant) {

        $elements[applicant].startDate.val("");
        $elements[applicant].endDate.val("");

        $("#" + $elements[applicant].idPrefix + "row_" + $elements[applicant].selectedRowId).toggleClass( "editRow info", false );

        $elements[applicant].addBtn.show();
        $elements[applicant].editBtn.toggleClass( "hidden", true );
        $elements[applicant].cancelBtn.toggleClass( "hidden", true );

        $elements[applicant].selectedRowId = -1;
    }

    // Due to floating point maths there is a chance that this may not be 100% accurate
    // It may be better to use a library like moment to calculate this
    function _daysBetween(startDt, endDt) {
    	var d1 = new Date(startDt);
        var d2 = new Date(endDt);

        var milliSecondsPerDay = (24 * 60 * 60 * 1000);   // hours * minutes * seconds * milliseconds

       return (Math.ceil((d2 - d1) / milliSecondsPerDay));
    }

    // It may be better to use a library like moment to do this
    function _formatDate(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2) {
            month = '0' + month;
        }
        if (day.length < 2) {
            day = '0' + day;
        }

        return [year, month, day].join('-');
    }

    function _formatDate_dd_mm_yyyy(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2) {
            month = '0' + month;
        }
        if (day.length < 2) {
            day = '0' + day;
        }

        return day + '-' + month +'-' + year;
    }



    //type - "start" or "end"
    function _createValidationTag(type, fieldname, identifier, msg) {
        return '<div class="' + type + '-field  ' + identifier + 'validation" style="display: block;"><label id="' + fieldname + '-' + type + '" class="has-' + type + '" for="' + fieldname + '">' + msg + '</label></div>';
    }

    function _validateCoverDatesDataTable(applicant, startDt, endDt) {

        var lblStartDt = "";
        var lblEndDt = "";
        var errorMsgTxt = "";

        $elements[applicant].startDateValidationLabel.parent().remove();
        $elements[applicant].endDateValidationLabel.parent().remove();

        if (!(startDt)) {
            errorMsgTxt = "Please enter a start date";
            lblStartDt = _createValidationTag('error', $elements[applicant].startDateFieldName, $elements[applicant].idPrefix, errorMsgTxt);
        } else if (!(endDt)) {
            errorMsgTxt = "Please enter an end date";
            lblEndDt = _createValidationTag('error', $elements[applicant].endDateFieldName, $elements[applicant].idPrefix, errorMsgTxt);
        } else if (startDt === endDt) {
            errorMsgTxt = "Start date cannot be equal to end date";
            lblStartDt = _createValidationTag('error', $elements[applicant].startDateFieldName, $elements[applicant].idPrefix, errorMsgTxt);
        } else if (startDt > endDt) {
            errorMsgTxt = "Start date cannot be greater than end date";
            lblEndDt = _createValidationTag('error', $elements[applicant].endDateFieldName, $elements[applicant].idPrefix, errorMsgTxt);
        } else if (endDt > _formatDate(new Date())) {
            errorMsgTxt = "End date cannot be greater than today";
            lblEndDt = _createValidationTag('error', $elements[applicant].endDateFieldName, $elements[applicant].idPrefix, errorMsgTxt);
        } else {

            $elements[applicant].startDate.toggleClass( "has-error", false );
            $elements[applicant].endDate.toggleClass( "has-error", false );
            $elements[applicant].startDate.parent().toggleClass( "has-error", false );
            $elements[applicant].endDate.parent().toggleClass( "has-error", false );
            $elements[applicant].startDate.toggleClass( "has-success", true );
            $elements[applicant].endDate.toggleClass( "has-success", true );
            $elements[applicant].validationContainer.html("");

            return true;
        }

        if (lblStartDt.length > 0) {
            $elements[applicant].startDate.parent().toggleClass( "has-error", true );
            $elements[applicant].validationContainer.html(lblStartDt);
        } else {
            $elements[applicant].endDate.parent().toggleClass( "has-error", true );
            $elements[applicant].validationContainer.html(lblEndDt);
        }

        return false;
    }

    function _displayCoverDatesDataTable(applicant) {

        var applicantValidationCheck = ($elements[applicant].coverDates.length > 0);

        if (applicant === 'partner') {
            applicantValidationCheck = (applicantValidationCheck && meerkat.modules.healthChoices.hasPartner());
        }

        if (applicantValidationCheck) {

        	var tableId = $elements[applicant].idPrefix + "CoverDatesDataTable";

        	var tableHtmlStr = "<br /><table id='" + tableId + "' class='table table-striped'><thead><tr><th>Start</th><th>End</th><th>Days</th><th>Edit</th><th>Delete</th></tr></thead><tbody>";

			for (var i = 0; i < $elements[applicant].coverDates.length; i++) {

    			var row = "<tr id='" + $elements[applicant].idPrefix + "row_" + i + "'>";
    			row += "<td>" + _formatDate_dd_mm_yyyy($elements[applicant].coverDates[i]["from"]) +"</td>";
    			row += "<td>" + _formatDate_dd_mm_yyyy($elements[applicant].coverDates[i]["to"]) + "</td>";
    			row += "<td>" + _daysBetween(($elements[applicant].coverDates[i]["from"]), ($elements[applicant].coverDates[i]["to"])) +"</td>";
    			row += "<td class='editCoverDatesRow'><a href='javascript:;'><span class='icon icon-pencil' title='Edit Row'><span class='sr-only'>Click here to edit row for " + _formatDate_dd_mm_yyyy($elements[applicant].coverDates[i]["from"]) + " to " + _formatDate_dd_mm_yyyy($elements[applicant].coverDates[i]["to"]) + "</span></span></a></td>";
    			row += "<td class='delCoverDatesRow'><a href='javascript:;'><span class='icon icon-cross' title='Delete Row'><span class='sr-only'>Click here to delete row for " + _formatDate_dd_mm_yyyy($elements[applicant].coverDates[i]["from"]) + " to " + _formatDate_dd_mm_yyyy($elements[applicant].coverDates[i]["to"]) + "</span></span></a></td>";
    			row += "</tr>";

        		tableHtmlStr += row;
    		}
    		tableHtmlStr += "</tbody></table>";

    		$elements[applicant].coverHistoryTableContainer.html(tableHtmlStr);

        	$("#" + tableId + " .editCoverDatesRow").on("click", function() {
            	event.preventDefault();

                var id = $(this).parent().attr('id');
                $elements[applicant].selectedRowId = id.replace($elements[applicant].idPrefix + "row_", "");

                $(this).parent().addClass("editRow info");

                $elements[applicant].startDate.val($elements[applicant].coverDates[$elements[applicant].selectedRowId]["from"]);
                $elements[applicant].endDate.val($elements[applicant].coverDates[$elements[applicant].selectedRowId]["to"]);
                $elements[applicant].addBtn.hide();
                $elements[applicant].editBtn.toggleClass( "hidden", false );
                $elements[applicant].cancelBtn.toggleClass( "hidden", false );
            });

        	$("#" + tableId + " .delCoverDatesRow").on("click", function() {
            	event.preventDefault();
            	$elements[applicant].selectedRowId = -1;
				$elements[applicant].startDate.val("");
				$elements[applicant].endDate.val("");
				$elements[applicant].addBtn.show();
				$elements[applicant].editBtn.toggleClass( "hidden", true );
				$elements[applicant].cancelBtn.toggleClass( "hidden", true );

                var id = $(this).parent().attr('id');
                var rowIndex = id.replace($elements[applicant].idPrefix + "row_", "");
                $elements[applicant].coverDates.splice(rowIndex, 1);

                _displayCoverDatesDataTable(applicant);

                $elements[applicant].coverDatesHiddenField.val(JSON.stringify($elements[applicant].coverDates));
            });

            $elements[applicant].coverHistoryTableContainer.show();

        } else {
            $elements[applicant].coverHistoryTableContainer.hide();
            $elements[applicant].coverDatesHiddenField.val("");
        }

        addCoverDatesTableValidation(applicant);

	}

    function getCoverDates(applicant){
        return typeof $elements[applicant].coverDates !== 'undefined' ? $elements[applicant].coverDates : '';
    }

    function getCoverDatesJSONstringify(applicant){
        return typeof $elements[applicant].coverDates !== 'undefined' ? JSON.stringify($elements[applicant].coverDates) : '';
    }

    function getCoverDatesFromHiddenField(applicant){
        return ((typeof $elements[applicant].coverDatesHiddenField !== 'undefined') && $elements[applicant].coverDatesHiddenField.val().length > 0) ? $elements[applicant].coverDatesHiddenField.val() : '';
    }


    function addCoverDatesTableValidation(applicant) {

        if (applicant === 'partner') {
            if (!meerkat.modules.healthChoices.hasPartner()) {
                return;
            }
        }

        if ($elements[applicant].coverDates.length > 0) {
            removeCoverDatesTableValidation(applicant);
        } else {
            $elements[applicant].startDate.prop('required',true);
            $elements[applicant].endDate.prop('required',true);

            $elements[applicant].coverDatesHiddenField.toggleClass( 'validate', true );
            $elements[applicant].coverDatesHiddenField.prop('required', true);

            $elements[applicant].coverDatesHiddenField.attr({
                'data-validation-placement' : '#' + $elements[applicant].validationContainerId,
                'title' : 'Please add your ' + ((applicant === 'primary') ? '' : 'partner&apos;s ') + 'private health insurance cover history',
                'aria-required': 'true'
            });

            // because the result is using JSON.stringify an empty array will look like this '[]' and wont contain any usable data until at is much longer than 3 characters
            // Note that the webservice that uses this data expects an array || null, it will throw an error if it is sent a string
            $elements[applicant].coverDatesHiddenField.rules( 'add', {
                required: true,
                minlength: 3,
                messages: {
                    required: 'Please add your ' + ((applicant === 'primary') ? '' : 'partner&apos;s ') + 'private health insurance cover history',
                    minlength: 'Please add your ' + ((applicant === 'primary') ? '' : 'partner&apos;s ') + 'private health insurance cover history'
                }
            });

        }

    }

    function removeCoverDatesTableValidation(applicant) {

        if (applicant === 'partner') {
            if (!meerkat.modules.healthChoices.hasPartner()) {
                return;
            }
        }

        $elements[applicant].startDate.prop('required',false);
        $elements[applicant].endDate.prop('required',false);

        $elements[applicant].validationContainer.html("");
        $elements[applicant].validationContainer.parent().parent().toggleClass( 'has-error', false );

        $elements[applicant].coverDatesHiddenField.rules( 'remove' );
        $elements[applicant].coverDatesHiddenField.toggleClass( 'validate', false );
        $elements[applicant].coverDatesHiddenField.toggleClass( 'has-error', false );
        $elements[applicant].coverDatesHiddenField.prop('required',false);
        $elements[applicant].coverDatesHiddenField.removeAttr('aria-required');
        $elements[applicant].coverDatesHiddenField.removeAttr('data-validation-placement');
    }


    function getPrimaryCoverDates() {
        return getCoverDates('primary');
    }

    function getPartnerCoverDates() {
        return getCoverDates('partner');
    }

    function getPrimaryCoverDatesJSONstringify() {
        return getCoverDatesJSONstringify('primary');
    }

    function getPartnerCoverDatesJSONstringify() {
        return getCoverDatesJSONstringify('partner');
    }

    function getPrimaryCoverDatesFromHiddenField() {
        return getCoverDatesFromHiddenField('primary');
    }

    function getPartnerCoverDatesFromHiddenField() {
        return getCoverDatesFromHiddenField('partner');
    }

    function addPrimaryValidation() {
        addCoverDatesTableValidation('primary');
    }

    function removePrimaryValidation() {
        removeCoverDatesTableValidation('primary');
    }

    function addPartnerValidation() {
        addCoverDatesTableValidation('partner');
    }

    function removePartnerValidation() {
        removeCoverDatesTableValidation('partner');
    }

	meerkat.modules.register("healthPrivateHospitalHistory", {
		init: init,
        getPrimaryCoverDates: getPrimaryCoverDates,
        getPartnerCoverDates: getPartnerCoverDates,
        getPrimaryCoverDatesJSONstringify: getPrimaryCoverDatesJSONstringify,
        getPartnerCoverDatesJSONstringify: getPartnerCoverDatesJSONstringify,
        getPrimaryCoverDatesFromHiddenField: getPrimaryCoverDatesFromHiddenField,
        getPartnerCoverDatesFromHiddenField: getPartnerCoverDatesFromHiddenField,
        addPrimaryValidation: addPrimaryValidation,
        removePrimaryValidation: removePrimaryValidation,
        addPartnerValidation: addPartnerValidation,
        removePartnerValidation: removePartnerValidation
	});

})(jQuery);