(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        startDateIsValid = true,
        endDateIsValid = true,
        minDate = new Date("1000-01-01"),
        maxDate = new Date("9999-12-31");

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
            datesControls: xpath + 'dates_controls',
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

        setCustomPreviousCoverDatesValidation(applicant);

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

        setCustomPreviousCoverDatesValidation(applicant);

    }

    function setCustomPreviousCoverDatesValidation(applicant) {
        $elements[applicant].startDate.on('focusout', function () {
            validateCoverDates(applicant);
        });

        $elements[applicant].endDate.on('focusout', function () {
            validateCoverDates(applicant);
        });
    }

    function _addbtn_EventListener(applicant) {

        $elements[applicant].selectedRowId = -1;

        var myEntry = { "from": $elements[applicant].startDate.val(), "to": $elements[applicant].endDate.val()};
        var isDataTableValidationSuccessful = validateCoverDates(applicant);

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

    function _dateParts(date){
        var d = new Date(date),
            leadingZero = function(number){return ('0' + number).slice(-2);};

        return {
            year: d.getFullYear(),
            month: leadingZero(d.getMonth()+1),
            day: leadingZero(d.getDate())
        };
    }

    function _formatDate(date){
        var d	= _dateParts(date);
        return [d.year,d.month,d.day].join('-');
    }

    function _formatDate_dd_mm_yyyy(date) {
        var d	= _dateParts(date);
        return [d.day,d.month,d.year].join('-');
    }

    //type - "start" or "end"
    function _createValidationTag(type, fieldname, identifier, msg) {
        return '<div class="' + type + '-field  ' + identifier + 'validation" style="display: block;"><label id="' + fieldname + '-' + type + '" class="has-' + type + '" for="' + fieldname + '">' + msg + '</label></div>';
    }

    function _validateCoverDatesDataTable(applicant, startDateStr, endDateStr) {

        var lblStartDt = "",
             datesNotValidMessage = 'Please enter a valid {s1} date{s2}',
             s1_start = "",
             s1_end = "",
             s1,
             s2,
             startDateObj = null,
             endDateObj = null;
        if(startDateStr) {
            try { startDateObj = new Date(startDateStr); } catch (e) { startDateIsValid = false; }
        }
        if(endDateStr) {
            try { endDateObj = new Date(endDateStr); } catch (e) { endDateIsValid = false; }
        }

        $elements[applicant].startDateValidationLabel.parent().remove();
        $elements[applicant].endDateValidationLabel.parent().remove();
        $elements[applicant].startDateValidationLabel.remove();
        $elements[applicant].endDateValidationLabel.remove();
        $elements[applicant].startDate.prev().remove();
        $elements[applicant].endDate.prev().remove();

        if (!(startDateStr)) {
            startDateIsValid = false; s1_start = "start";
        } else if (startDateObj < minDate || startDateObj > maxDate) {
            startDateIsValid = false; s1_start = "start";
        } else {
            startDateIsValid = true;
        }

        if (!(endDateStr)) {
            endDateIsValid = false; s1_end = "end";
        } else if (endDateObj < minDate || endDateObj > maxDate) {
            endDateIsValid = false; s1_end = "end";
        } else if (endDateObj > new Date()) {
            endDateIsValid = false;
            datesNotValidMessage = "End date cannot be greater than today";
        } else {
            endDateIsValid = true;
        }

        if(startDateIsValid && endDateIsValid) {
            if (startDateStr === endDateStr) {
                startDateIsValid = false; endDateIsValid = false;
                datesNotValidMessage = "Start date cannot be equal to end date";
            } else if (startDateObj > endDateObj) {
                startDateIsValid = false; endDateIsValid = false;
                datesNotValidMessage = "Start date cannot be greater than end date";
            } else {
                startDateIsValid = true; endDateIsValid = true;
            }
        }

        s1 = s1_start ? s1_start : "";
        s1 = (s1_end ? (s1 ? s1 + " and " + s1_end : s1_end) : s1);
        s2 = s1_start && s1_end ? "s" : "";
        datesNotValidMessage = datesNotValidMessage.replace("{s1}", s1).replace("{s2}", s2);

        setTimeout(function() {
            changeStartDateErrorStatus(applicant, startDateIsValid);
            changeEndDateErrorStatus(applicant, endDateIsValid);
        }, 1);

        if (startDateIsValid && endDateIsValid) {
            $elements[applicant].validationContainer.html("");
            return true;
        } else {
            lblStartDt = _createValidationTag('error', $elements[applicant].datesControls, $elements[applicant].idPrefix, datesNotValidMessage);
            $elements[applicant].validationContainer.html(lblStartDt);
        }
        return false;
    }

    function changeStartDateErrorStatus(applicant, isSuccess) {
        $elements[applicant].startDate.parent().toggleClass("has-error", !isSuccess);
        $elements[applicant].startDate.parent().toggleClass("has-success", isSuccess);
        $elements[applicant].startDate.toggleClass("has-error", !isSuccess);
        $elements[applicant].startDate.toggleClass("has-success", isSuccess);
    }

    function changeEndDateErrorStatus(applicant, isSuccess) {
        $elements[applicant].endDate.parent().toggleClass("has-error", !isSuccess);
        $elements[applicant].endDate.parent().toggleClass("has-success", isSuccess);
        $elements[applicant].endDate.toggleClass("has-error", !isSuccess);
        $elements[applicant].endDate.toggleClass("has-success", isSuccess);
    }

    function validateCoverDates(applicant) {
        return _validateCoverDatesDataTable(applicant, $elements[applicant].startDate.val(), $elements[applicant].endDate.val());
    }

    function _displayCoverDatesDataTable(applicant) {

        var applicantValidationCheck = ($elements[applicant].coverDates.length > 0);

        if (applicant === 'partner') {
            applicantValidationCheck = (applicantValidationCheck && meerkat.modules.healthChoices.hasPartner());
        }

        if (applicantValidationCheck) {

        	var tableId = $elements[applicant].idPrefix + "CoverDatesDataTable";

        	var tableHtmlStr = "<table id='" + tableId + "' class='table table-striped'><thead><tr><th>Start</th><th>End</th><th>Days</th><th>Edit</th><th>Delete</th></tr></thead><tbody>";

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
        return !_.isUndefined($elements[applicant].coverDates) ? $elements[applicant].coverDates : '';
    }

    function getCoverDatesJSONstringify(applicant){
        return !_.isUndefined($elements[applicant].coverDates) ? JSON.stringify($elements[applicant].coverDates) : '';
    }

    function getCoverDatesFromHiddenField(applicant){
        return ((!_.isUndefined($elements[applicant].coverDatesHiddenField)) && $elements[applicant].coverDatesHiddenField.val().length > 0) ? $elements[applicant].coverDatesHiddenField.val() : '';
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