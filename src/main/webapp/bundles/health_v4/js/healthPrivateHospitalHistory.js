(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    var primaryCoverDates = [],
        primarySelectedRowId = -1,
        partnerCoverDates = [],
        partnerSelectedRowId = -1;

    function init() {
        _setupFields();
        _applyEventListeners_primary();
        _applyEventListeners_partner();

        primaryCoverDates = [];
        primarySelectedRowId = -1;
        partnerCoverDates = [];
        partnerSelectedRowId = -1;

       addPrimaryCoverDatesTableValidation();
       addPartnerCoverDatesTableValidation();
    }

    function _setupFields() {

        var xpath1 = "health_previousfund_primary_fundHistory_",
            xpath2 = "health_previousfund_partner_fundHistory_";

        $elements = {

            primary: {
                startDateFieldName: xpath1 + 'dates_controls_startDateInput',
                endDateFieldName: xpath1 + 'dates_controls_endDateInput',
                addBtnFieldName: xpath1 + 'dates_controls_add',
                cancelBtnFieldName: xpath1 + 'dates_controls_cancel',
                startDate: $('input[name=' + xpath1 + 'dates_controls_startDateInput]'),
                endDate: $('input[name=' + xpath1 + 'dates_controls_endDateInput]'),
                addBtn: $('#' + xpath1 + 'dates_controls_add'),
                editBtn: $('#' + xpath1 + 'dates_controls_edit'),
                cancelBtn: $('#' + xpath1 + 'dates_controls_cancel'),
                startDateValidationLabel: $('#' + xpath1 + 'dates_controls_startDateInput-error'),
                endDateValidationLabel: $('#' + xpath1 + 'dates_controls_endDateInput-error'),
                validationContainer: $('#' + xpath1 + 'dates_controls_datesEntryValidationContainer'),
                validationContainerId: xpath1 + 'dates_controls_datesEntryValidationContainer',
                coverHistoryTableContainer: $('#' + xpath1 + 'dates_dataTableContainer'),
                idPrefix: 'primary_',
                coverDatesHiddenField: $('input[name=' + xpath1 + 'dates_coverDates]')
            },
            partner: {
                startDateFieldName: xpath2 + 'dates_controls_startDateInput',
                endDateFieldName: xpath2 + 'dates_controls_endDateInput',
                addBtnFieldName: xpath2 + 'dates_controls_add',
                cancelBtnFieldName: xpath2 + 'dates_controls_cancel',
                startDate: $('input[name=' + xpath2 + 'dates_controls_startDateInput]'),
                endDate: $('input[name=' + xpath2 + 'dates_controls_endDateInput]'),
                addBtn: $('#' + xpath2 + 'dates_controls_add'),
                editBtn: $('#' + xpath2 + 'dates_controls_edit'),
                cancelBtn: $('#' + xpath2 + 'dates_controls_cancel'),
                startDateValidationLabel: $('#' + xpath2 + 'dates_controls_startDateInput-error'),
                endDateValidationLabel: $('#' + xpath2 + 'dates_controls_endDateInput-error'),
                validationContainer: $('#' + xpath2 + 'dates_controls_datesEntryValidationContainer'),
                validationContainerId: xpath2 + 'dates_controls_datesEntryValidationContainer',
                coverHistoryTableContainer: $('#' + xpath2 + 'dates_dataTableContainer'),
                idPrefix: 'partner_',
                coverDatesHiddenField: $('input[name=' + xpath2 + 'dates_coverDates]')
            }
        };
    }

    function _applyEventListeners_primary() {

        $elements.primary.addBtn.on('click', function primaryAddPrivateHospitalHistoryRow() {
            event.preventDefault();

            primarySelectedRowId = -1;

            var myEntry = { "from": $elements.primary.startDate.val(), "to": $elements.primary.endDate.val()};

            if (_validatePrimaryCoverDatesDataTable($elements.primary.startDate.val(), $elements.primary.endDate.val())) {
                primaryCoverDates.push(myEntry);
                primaryCoverDates.sort(function(a, b){
                    return (b["to"] > a["to"]);
                });

                $elements.primary.startDate.val("");
                $elements.primary.endDate.val("");

                _displayPrimaryCoverDatesDataTable();

                $elements.primary.coverDatesHiddenField.val(JSON.stringify(primaryCoverDates));
            }
        });

        $elements.primary.editBtn.on('click', function primaryEditPrivateHospitalHistoryRow() {
            event.preventDefault();

            var myEntry = { "from": $elements.primary.startDate.val(), "to": $elements.primary.endDate.val()};

            if (_validatePrimaryCoverDatesDataTable($elements.primary.startDate.val(), $elements.primary.endDate.val())) {
                primaryCoverDates.splice(primarySelectedRowId, 1);
                primaryCoverDates.push(myEntry);
                primarySelectedRowId = -1;
                primaryCoverDates.sort(function(a, b){
                    return (b["to"] > a["to"]);
                });

                $elements.primary.startDate.val("");
                $elements.primary.endDate.val("");
                $elements.primary.addBtn.show();
                $elements.primary.editBtn.toggleClass( "hidden", true );
                $elements.primary.cancelBtn.toggleClass( "hidden", true );

                _displayPrimaryCoverDatesDataTable();

                $elements.primary.coverDatesHiddenField.val(JSON.stringify(primaryCoverDates));
            }
        });

        $elements.primary.cancelBtn.on('click', function primaryCancelEditPrivateHospitalHistoryRow() {
            event.preventDefault();
            $elements.primary.startDate.val("");
            $elements.primary.endDate.val("");

            $("#" + $elements.primary.idPrefix + "row_" + primarySelectedRowId).toggleClass( "editRow info", false );

            $elements.primary.addBtn.show();
            $elements.primary.editBtn.toggleClass( "hidden", true );
            $elements.primary.cancelBtn.toggleClass( "hidden", true );

            primarySelectedRowId = -1;
        });

    }

    function _applyEventListeners_partner() {

        $elements.partner.addBtn.on('click', function partnerAddPrivateHospitalHistoryRow() {
            event.preventDefault();

            partnerSelectedRowId = -1;

            var myEntry = { "from": $elements.partner.startDate.val(), "to": $elements.partner.endDate.val()};

            if (_validatePartnerCoverDatesDataTable($elements.partner.startDate.val(), $elements.partner.endDate.val())) {
                partnerCoverDates.push(myEntry);
                partnerCoverDates.sort(function(a, b){
                    return (b["to"] > a["to"]);
                });

                $elements.partner.startDate.val("");
                $elements.partner.endDate.val("");

                _displayPartnerCoverDatesDataTable();

                $elements.partner.coverDatesHiddenField.val(JSON.stringify(partnerCoverDates));
            }
        });

        $elements.partner.editBtn.on('click', function partnerEditPrivateHospitalHistoryRow() {
            event.preventDefault();

            var myEntry = { "from": $elements.partner.startDate.val(), "to": $elements.partner.endDate.val()};

            if (_validatePartnerCoverDatesDataTable($elements.partner.startDate.val(), $elements.partner.endDate.val())) {
                partnerCoverDates.splice(partnerSelectedRowId, 1);
                partnerCoverDates.push(myEntry);
                partnerSelectedRowId = -1;
                partnerCoverDates.sort(function(a, b){
                    return (b["to"] > a["to"]);
                });

                $elements.partner.startDate.val("");
                $elements.partner.endDate.val("");
                $elements.partner.addBtn.show();
                $elements.partner.editBtn.toggleClass( "hidden", true );
                $elements.partner.cancelBtn.toggleClass( "hidden", true );

                _displayPartnerCoverDatesDataTable();

                $elements.partner.coverDatesHiddenField.val(JSON.stringify(partnerCoverDates));
            }
        });

        $elements.partner.cancelBtn.on('click', function partnerCancelEditPrivateHospitalHistoryRow() {
            event.preventDefault();
            $elements.partner.startDate.val("");
            $elements.partner.endDate.val("");

            $("#" + $elements.partner.idPrefix + "row_" + partnerSelectedRowId).toggleClass( "editRow info", false );

            $elements.partner.addBtn.show();
            $elements.partner.editBtn.toggleClass( "hidden", true );
            $elements.partner.cancelBtn.toggleClass( "hidden", true );

            partnerSelectedRowId = -1;
        });

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

    //type - "start" or "end"
    function _createValidationTag(type, fieldname, identifier, msg) {
        return '<div class="' + type + '-field  ' + identifier + 'validation" style="display: block;"><label id="' + fieldname + '-' + type + '" class="has-' + type + '" for="' + fieldname + '">' + msg + '</label></div>';
    }

    function _validatePrimaryCoverDatesDataTable(startDt, endDt) {

        var lblStartDt = "";
        var lblEndDt = "";
        var errorMsgTxt = "";

        $elements.primary.startDateValidationLabel.parent().remove();
        $elements.primary.endDateValidationLabel.parent().remove();

        if (!(startDt)) {
            errorMsgTxt = "Please enter a start date";
            lblStartDt = _createValidationTag('error', $elements.primary.startDateFieldName, $elements.primary.idPrefix, errorMsgTxt);
        } else if (!(endDt)) {
            errorMsgTxt = "Please enter an end date";
            lblEndDt = _createValidationTag('error', $elements.primary.endDateFieldName, $elements.primary.idPrefix, errorMsgTxt);
        } else if (startDt === endDt) {
            errorMsgTxt = "Start date cannot be equal to end date";
            lblStartDt = _createValidationTag('error', $elements.primary.startDateFieldName, $elements.primary.idPrefix, errorMsgTxt);
        } else if (startDt > endDt) {
            errorMsgTxt = "Start date cannot be greater than end date";
            lblEndDt = _createValidationTag('error', $elements.primary.endDateFieldName, $elements.primary.idPrefix, errorMsgTxt);
        } else if (endDt > _formatDate(new Date())) {
            errorMsgTxt = "End date cannot be greater than today";
            lblEndDt = _createValidationTag('error', $elements.primary.endDateFieldName, $elements.primary.idPrefix, errorMsgTxt);
        } else {

            $elements.primary.startDate.toggleClass( "has-error", false );
            $elements.primary.endDate.toggleClass( "has-error", false );
            $elements.primary.startDate.parent().toggleClass( "has-error", false );
            $elements.primary.endDate.parent().toggleClass( "has-error", false );
            $elements.primary.startDate.toggleClass( "has-success", true );
            $elements.primary.endDate.toggleClass( "has-success", true );
            $elements.primary.validationContainer.html("");

            return true;
        }

        if (lblStartDt.length > 0) {
            $elements.primary.startDate.parent().toggleClass( "has-error", true );
            $elements.primary.validationContainer.html(lblStartDt);
        } else {
            $elements.primary.endDate.parent().toggleClass( "has-error", true );
            $elements.primary.validationContainer.html(lblEndDt);
        }

        return false;
    }

    function _validatePartnerCoverDatesDataTable(startDt, endDt) {

        var lblStartDt = "";
        var lblEndDt = "";
        var errorMsgTxt = "";

        $elements.partner.startDateValidationLabel.parent().remove();
        $elements.partner.endDateValidationLabel.parent().remove();

        if (!(startDt)) {
            errorMsgTxt = "Please enter a start date";
            lblStartDt = _createValidationTag('error', $elements.partner.startDateFieldName, $elements.partner.idPrefix, errorMsgTxt);
        } else if (!(endDt)) {
            errorMsgTxt = "Please enter an end date";
            lblEndDt = _createValidationTag('error', $elements.partner.endDateFieldName, $elements.partner.idPrefix, errorMsgTxt);
        } else if (startDt === endDt) {
            errorMsgTxt = "Start date cannot be equal to end date";
            lblStartDt = _createValidationTag('error', $elements.partner.startDateFieldName, $elements.partner.idPrefix, errorMsgTxt);
        } else if (startDt > endDt) {
            errorMsgTxt = "Start date cannot be greater than end date";
            lblEndDt = _createValidationTag('error', $elements.partner.endDateFieldName, $elements.partner.idPrefix, errorMsgTxt);
        } else if (endDt > _formatDate(new Date())) {
            errorMsgTxt = "End date cannot be greater than today";
            lblEndDt = _createValidationTag('error', $elements.partner.endDateFieldName, $elements.partner.idPrefix, errorMsgTxt);
        } else {

            $elements.partner.startDate.toggleClass( "has-error", false );
            $elements.partner.endDate.toggleClass( "has-error", false );
            $elements.partner.startDate.parent().toggleClass( "has-error", false );
            $elements.partner.endDate.parent().toggleClass( "has-error", false );
            $elements.partner.startDate.toggleClass( "has-success", true );
            $elements.partner.endDate.toggleClass( "has-success", true );
            $elements.partner.validationContainer.html("");

            return true;
        }

        if (lblStartDt.length > 0) {
            $elements.partner.startDate.parent().toggleClass( "has-error", true );
            $elements.partner.validationContainer.html(lblStartDt);
        } else {
            $elements.partner.endDate.parent().toggleClass( "has-error", true );
            $elements.partner.validationContainer.html(lblEndDt);
        }

        return false;
    }

    function _displayPrimaryCoverDatesDataTable() {

        if (primaryCoverDates.length > 0) {

        	var tableId = $elements.primary.idPrefix + "CoverDatesDataTable";

        	var tableHtmlStr = "<br /><table id='" + tableId + "' class='table table-striped'><thead><tr><th>Start</th><th>End</th><th>Days</th><th>Edit</th><th>Delete</th></tr></thead><tbody>";

			for (var i = 0; i < primaryCoverDates.length; i++) {

    			var row = "<tr id='" + $elements.primary.idPrefix + "row_" + i + "'>";
    			row += "<td>" + primaryCoverDates[i]["from"] +"</td>";
    			row += "<td>" + primaryCoverDates[i]["to"] + "</td>";
    			row += "<td>" + _daysBetween((primaryCoverDates[i]["from"]), (primaryCoverDates[i]["to"])) +"</td>";
    			row += "<td class='editCoverDatesRow'><a href='javascript:;'><span class='icon icon-pencil' title='Edit Row'><span class='sr-only'>Click here to edit row for " + primaryCoverDates[i]["from"] + " to " + primaryCoverDates[i]["to"] + "</span></span></a></td>";
    			row += "<td class='delCoverDatesRow'><a href='javascript:;'><span class='icon icon-cross' title='Delete Row'><span class='sr-only'>Click here to delete row for " + primaryCoverDates[i]["from"] + " to " + primaryCoverDates[i]["to"] + "</span></span></a></td>";
    			row += "</tr>";

        		tableHtmlStr += row;
    		}
    		tableHtmlStr += "</tbody></table>";

    		$elements.primary.coverHistoryTableContainer.html(tableHtmlStr);

        	$("#" + tableId + " .editCoverDatesRow").on("click", function() {
            	event.preventDefault();

                var id = $(this).parent().attr('id');
                primarySelectedRowId = id.replace($elements.primary.idPrefix + "row_", "");

                $(this).parent().addClass("editRow info");

                $elements.primary.startDate.val(primaryCoverDates[primarySelectedRowId]["from"]);
                $elements.primary.endDate.val(primaryCoverDates[primarySelectedRowId]["to"]);
                $elements.primary.addBtn.hide();
                $elements.primary.editBtn.toggleClass( "hidden", false );
                $elements.primary.cancelBtn.toggleClass( "hidden", false );
            });

        	$("#" + tableId + " .delCoverDatesRow").on("click", function() {
            	event.preventDefault();
            	primarySelectedRowId = -1;
				$elements.primary.startDate.val("");
				$elements.primary.endDate.val("");
				$elements.primary.addBtn.show();
				$elements.primary.editBtn.toggleClass( "hidden", true );
				$elements.primary.cancelBtn.toggleClass( "hidden", true );

                var id = $(this).parent().attr('id');
                var rowIndex = id.replace($elements.primary.idPrefix + "row_", "");
                primaryCoverDates.splice(rowIndex, 1);
                _displayPrimaryCoverDatesDataTable();

                $elements.primary.coverDatesHiddenField.val(JSON.stringify(primaryCoverDates));
            });

            $elements.primary.coverHistoryTableContainer.show();

        } else {
            $elements.primary.coverHistoryTableContainer.hide();
            $elements.primary.coverDatesHiddenField.val("");
        }
        addPrimaryCoverDatesTableValidation();

	}

    function _displayPartnerCoverDatesDataTable() {

        if (partnerCoverDates.length > 0) {

        	var tableId = $elements.partner.idPrefix + "CoverDatesDataTable";

        	var tableHtmlStr = "<br /><table id='" + tableId + "' class='table table-striped'><thead><tr><th>Start</th><th>End</th><th>Days</th><th>Edit</th><th>Delete</th></tr></thead><tbody>";

			for (var i = 0; i < partnerCoverDates.length; i++) {

    			var row = "<tr id='" + $elements.partner.idPrefix + "row_" + i + "'>";
    			row += "<td>" + partnerCoverDates[i]["from"] +"</td>";
    			row += "<td>" + partnerCoverDates[i]["to"] + "</td>";
    			row += "<td>" + _daysBetween((partnerCoverDates[i]["from"]), (partnerCoverDates[i]["to"])) +"</td>";
    			row += "<td class='editCoverDatesRow'><a href='javascript:;'><span class='icon icon-pencil' title='Edit Row'><span class='sr-only'>Click here to edit row for " + partnerCoverDates[i]["from"] + " to " + partnerCoverDates[i]["to"] + "</span></span></a></td>";
    			row += "<td class='delCoverDatesRow'><a href='javascript:;'><span class='icon icon-cross' title='Delete Row'><span class='sr-only'>Click here to delete row for " + partnerCoverDates[i]["from"] + " to " + partnerCoverDates[i]["to"] + "</span></span></a></td>";
    			row += "</tr>";

        		tableHtmlStr += row;
    		}
    		tableHtmlStr += "</tbody></table>";

    		$elements.partner.coverHistoryTableContainer.html(tableHtmlStr);

        	$("#" + tableId + " .editCoverDatesRow").on("click", function() {
            	event.preventDefault();

                var id = $(this).parent().attr('id');
                partnerSelectedRowId = id.replace($elements.partner.idPrefix + "row_", "");

                $(this).parent().addClass("editRow info");

                $elements.partner.startDate.val(partnerCoverDates[partnerSelectedRowId]["from"]);
                $elements.partner.endDate.val(partnerCoverDates[partnerSelectedRowId]["to"]);
                $elements.partner.addBtn.hide();
                $elements.partner.editBtn.toggleClass( "hidden", false );
                $elements.partner.cancelBtn.toggleClass( "hidden", false );
            });

        	$("#" + tableId + " .delCoverDatesRow").on("click", function() {
            	event.preventDefault();
            	partnerSelectedRowId = -1;
				$elements.partner.startDate.val("");
				$elements.partner.endDate.val("");
				$elements.partner.addBtn.show();
				$elements.partner.editBtn.toggleClass( "hidden", true );
				$elements.partner.cancelBtn.toggleClass( "hidden", true );

                var id = $(this).parent().attr('id');
                var rowIndex = id.replace($elements.partner.idPrefix + "row_", "");
                partnerCoverDates.splice(rowIndex, 1);
                _displayPartnerCoverDatesDataTable();

                $elements.partner.coverDatesHiddenField.val(JSON.stringify(partnerCoverDates));
            });

            $elements.partner.coverHistoryTableContainer.show();

        } else {
            $elements.partner.coverHistoryTableContainer.hide();
            $elements.partner.coverDatesHiddenField.val("");
        }
        addPartnerCoverDatesTableValidation();

	}

    function getPrimaryCoverDates(){
        return typeof primaryCoverDates !== 'undefined' ? primaryCoverDates : '';
    }

    function getPartnerCoverDates(){
        return typeof partnerCoverDates !== 'undefined' ? partnerCoverDates : '';
    }

    function getPrimaryCoverDatesJSONstringify(){
        return typeof primaryCoverDates !== 'undefined' ? JSON.stringify(primaryCoverDates) : '';
    }

    function getPartnerCoverDatesJSONstringify(){
        return typeof partnerCoverDates !== 'undefined' ? JSON.stringify(partnerCoverDates) : '';
    }

    function getPrimaryCoverDatesFromHiddenField(){
        return ((typeof $elements.primary.coverDatesHiddenField !== 'undefined') && $elements.primary.coverDatesHiddenField.val().length > 0) ? $elements.primary.coverDatesHiddenField.val() : '';
    }

    function getPartnerCoverDatesFromHiddenField(){
        return ((typeof $elements.partner.coverDatesHiddenField !== 'undefined') && $elements.partner.coverDatesHiddenField.val().length > 0) ? $elements.partner.coverDatesHiddenField.val() : '';
    }

    function addPrimaryCoverDatesTableValidation() {

        if (primaryCoverDates.length > 0) {
            removePrimaryCoverDatesTableValidation();
        } else {
            $elements.primary.startDate.prop('required',true);
            $elements.primary.endDate.prop('required',true);

            $elements.primary.coverDatesHiddenField.toggleClass( 'validate', true );
            $elements.primary.coverDatesHiddenField.prop('required', true);

            $elements.primary.coverDatesHiddenField.attr({
                'data-validation-placement' : '#' + $elements.primary.validationContainerId,
                'title' : 'Please add your private health insurance cover history',
                'aria-required': 'true'
            });

            $elements.primary.coverDatesHiddenField.rules( 'add', {
                required: true,
                minlength: 3,
                messages: {
                    required: 'Please add your private health insurance cover history',
                    minlength: 'Please add your private health insurance cover history'
                }
            });

        }
    }

    function removePrimaryCoverDatesTableValidation() {
        $elements.primary.startDate.prop('required',false);
        $elements.primary.endDate.prop('required',false);

        $elements.primary.validationContainer.html("");
        $elements.primary.validationContainer.parent().parent().toggleClass( 'has-error', false );

        $elements.primary.coverDatesHiddenField.rules( 'remove' );
        $elements.primary.coverDatesHiddenField.toggleClass( 'validate', false );
        $elements.primary.coverDatesHiddenField.toggleClass( 'has-error', false );
        $elements.primary.coverDatesHiddenField.prop('required',false);
        $elements.primary.coverDatesHiddenField.removeAttr('aria-required');
        $elements.primary.coverDatesHiddenField.removeAttr('data-validation-placement');
    }

    function addPartnerCoverDatesTableValidation() {

        if (partnerCoverDates.length > 0) {
            removePartnerCoverDatesTableValidation();
        } else {
            $elements.partner.startDate.prop('required', true);
            $elements.partner.endDate.prop('required', true);

            $elements.partner.coverDatesHiddenField.toggleClass( 'validate', true );
            $elements.partner.coverDatesHiddenField.prop('required',true);

            $elements.partner.coverDatesHiddenField.attr({
                'data-validation-placement' : '#' + $elements.partner.validationContainerId,
                'title' : 'Please add your partner&apos;s private health insurance cover history',
                'aria-required': 'true'
            });

            $elements.partner.coverDatesHiddenField.rules( 'add', {
                required: true,
                minlength: 3,
                messages: {
                    required: 'Please add your private health insurance cover history',
                    minlength: 'Please add your private health insurance cover history'
                }
            });

        }
    }

    function removePartnerCoverDatesTableValidation() {
        $elements.partner.startDate.prop('required', false);
        $elements.partner.endDate.prop('required', false);

        $elements.partner.validationContainer.html("");
        $elements.partner.validationContainer.parent().parent().toggleClass( 'has-error', false );

        $elements.partner.coverDatesHiddenField.rules( 'remove' );
        $elements.partner.coverDatesHiddenField.toggleClass( 'validate', false );
        $elements.partner.coverDatesHiddenField.toggleClass( 'has-error', false );
        $elements.partner.coverDatesHiddenField.prop('required', false);
        $elements.partner.coverDatesHiddenField.removeAttr('aria-required');
        $elements.partner.coverDatesHiddenField.removeAttr('data-validation-placement');
    }

	meerkat.modules.register("healthPrivateHospitalHistory", {
		init: init,
        getPrimaryCoverDates: getPrimaryCoverDates,
        getPartnerCoverDates: getPartnerCoverDates,
        getPrimaryCoverDatesJSONstringify: getPrimaryCoverDatesJSONstringify,
        getPartnerCoverDatesJSONstringify: getPartnerCoverDatesJSONstringify,
        getPrimaryCoverDatesFromHiddenField: getPrimaryCoverDatesFromHiddenField,
        getPartnerCoverDatesFromHiddenField: getPartnerCoverDatesFromHiddenField,
        addPrimaryValidation: addPrimaryCoverDatesTableValidation,
        removePrimaryValidation: removePrimaryCoverDatesTableValidation,
        addPartnerValidation: addPartnerCoverDatesTableValidation,
        removePartnerValidation: removePartnerCoverDatesTableValidation
	});

})(jQuery);