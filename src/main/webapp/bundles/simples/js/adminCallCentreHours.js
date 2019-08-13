/**
 * Call Centre Hours module for Simples
 * 
 * Allows for functionality related to adding / editing / deleting
 * call centre hours for different verticals.
 */
;(function($, undefined){
	
	var meerkat = window.meerkat,
		exception = meerkat.logging.exception,
		log = meerkat.logging.info;
	
	var rowTemplate,
		noResultsTemplate;

	function init() {
		$(document).ready(function() {
			rowTemplate = $('#opening-hours-row-template').html();
			noResultsTemplate = $('#opening-hours-row-noresults-template').html();
			
			_loadHoursInformation();
			
			$(document)
				// Refreshes the displayed hours
				.on("click", ".opening-hours-refresh", _loadHoursInformation)
				// Shows a new opening hours row for the table on which the link / button was clicked
				.on("click", ".opening-hours-new", function simplesOpeningHoursNewClick() {
					_showNewOpeningHoursInputs(this);
				})
				// Shows the populated inputs for editing a particular opening hours entry
				.on('click', '.opening-hours-table .edit, .opening-hours-table .cancel', function simplesOpeningHoursEditClick() {
					_toggleHiddenInputsOnClick(this);
				})
				// Saves the opening hours information to DB (new or update)
				.on('click', '.opening-hours-table .save', function simplesOpeningHoursEditClick() {
					_saveHours(this);
				})
				// Deletes an opening hours entry from the DB
				.on('click', '.opening-hours-table .delete', function simplesOpeningHoursDeleteClick() {
					_deleteHours(this);
				});
		});
	}
	
	/*
	 * Shows the inputs for a new opening hours entry.
	 */
	function _showNewOpeningHoursInputs(clickedButton) {
		var $this = $(clickedButton),
			$row = $this.closest(".row"),
			$table = $row.find("table");
			
		// Only show the new opening hours entry row if we haven't already opened one
		if(!$table.find("#opening-hours-new").length) {
			// Remove the no-results message
			$table.find("#opening-hours-noresults").remove();
			
			// Get the current date in a cute format
			var date = new Date(),
				formattedDate = date.getFullYear() + '-' + ("0" + (date.getMonth() + 1)).slice(-2) + '-' + ("0" + (date.getDate())).slice(-2);

			// Dummy data to be used in the pre-population of form fields
			var data = {
				openingHoursId: "new",
				hoursType: $table.data("hourstype"),
				effectiveStart: formattedDate,
				effectiveEnd: formattedDate,
				startTime: "08:00",
				endTime: "22:00",
				description: "Monday",
				verticalId: 4
			};
			
			// Set the dummy data values required by specific hours types
			if(data.hoursType === "S") {
				data.date = formattedDate;
			} else if(data.hoursType === "N") {
				data.daySequence = 0;
			}
			
			// Add the fields to the table as the first row
			var rowHtml = _getHoursRowHtml(data),
				$tr = $(rowHtml).appendTo(
					$table.find("tbody")
				);
			
			_toggleHiddenInputs($tr);
		}
	}
	
	function _toggleHiddenInputsOnClick(clickedButton) {
		var $this = $(clickedButton),
			$tr = $this.closest("tr");
		
		if($tr.data("id") === "new") {
			_removeRow($tr);
		} else {
			_toggleHiddenInputs($tr);
			
			// Reset inputs to default values
			$tr
				.find("input")
				.each(function() {
					this.value = this.defaultValue;  
				})
				.end()
				.find("select")
				.each(function() {
					$(this)
						.find("option")
						.prop("selected", function() {
							return this.defaultSelected;
						});
				});
		}
	}
	
	/*
	 * Removes a <tr> element from a table.
	 */
	function _removeRow($tr) {
		var $tbody = $tr.closest("tbody");
		
		$tr
			.find("td")
				.addClass("danger")
				.end()
			.fadeOut(400, function() {
				$(this).remove();
				
				if(!$tbody.find("tr").length)
					$tbody.append(_.template(noResultsTemplate));
			});
	}
	
	function _getHoursType(type) {
		return (type === "N" ? "Normal" : "Special");
	}
	
	/*
	 * Toggle between hidden inputs and the normal row view.
	 */
	function _toggleHiddenInputs($tableRow) {
		var $elements = $tableRow.find("input, span, button, select");
		
		$elements.each(function() {
			var $el = $(this);
			
			if($el.hasClass("hidden"))
				$el.removeClass("hidden");
			else
				$el.addClass("hidden");
		});
	}
	
	/*
	 * Requests all opening hours from the server and assigns them to the
	 * normal and special hours tables.
	 */
	function _loadHoursInformation() {
		if(rowTemplate) {
			var allRecordsUrl = "getAllRecords",
				$openingHours = _getAjaxPromise(allRecordsUrl, {
					hoursType: "N"
				}, "get"),
				$specialHours = _getAjaxPromise(allRecordsUrl, {
					hoursType: "S"
				}, "get");
			
			// Populate a supplied table with the response of the getAllRecords AJAX request
			var setUpTable = function simplesOpeningHoursSetUpTable($table, response) {
				$table.find("tbody").html(_getHoursAllHtml(response));
				
				// Initialize the rowSorter plugin which allows drag and drop sorting
				// on the "normal hours" table.
				if($table.data("hourstype") === "N") {
					$table.rowSorter({
						handler: "td.sorter span",
						onDrop: function(tbody, row, newIndex, oldIndex) {
							// Check what position the table row was moved to.
							// This allows us to only update the records that we need to
							// instead of resaving the entire list each time.
							if(newIndex < oldIndex) {
								_saveHoursFromSort($table, newIndex);
							} else {
								_saveHoursFromSort($table, oldIndex);
							}
						}
					});
				}
			};

			$openingHours.then(function(response) {
				setUpTable($('#hours-normal-row-container'), response);
			})
			.catch(function onError(obj, txt, errorThrown) {
				exception(txt + ': ' + errorThrown);
			});
			
			$specialHours.then(function(response) {
				setUpTable($("#hours-special-row-container"), response); 
			})
			.catch(function onError(obj, txt, errorThrown) {
				exception(txt + ': ' + errorThrown);
			});
		}
	}
	
	/*
	 * Takes a table row, finds its inputs and their values, and returns a populated
	 * object consisting of the common fields.
	 */
	function _getDataToSave($tableRow) {
		return {
			description: $tableRow.find(".description input, .description select").val(),
			startTime: $tableRow.find(".startTime input").val(),
			effectiveStart: $tableRow.find(".effectiveStart input").val(),
			endTime: $tableRow.find(".endTime input").val(),
			effectiveEnd: $tableRow.find(".effectiveEnd input").val(),
			hoursType: $tableRow.data("hourstype"),
			verticalId: $tableRow.find(".verticalId select").val()
		};
	}
	
	/*
	 * Saves a whole bunch of entries after sorting. Only updates
	 * values for rows with an index greater than or equal to the
	 * specified start position.
	 */
	function _saveHoursFromSort($tbody, startPosition) {
		var $trs = $tbody.find("tr:gt(" + startPosition + ")");
		$trs.each(function() {
			var $tr = $(this);
			
			var data = _getDataToSave($tr);
			data.openingHoursId = $tr.data("id");

			if(data.hoursType === "S") {
				data.date = $tr.find(".date input").val();
			} else if(data.hoursType === "N") {
				data.daySequence = $tr.index() + 1;
			}
			
			// Update the specified table row's DB record
			var $setHours = _getAjaxPromise("update", data);
			
			$setHours.then(function(response) {
				if(typeof response === "string")
					response = JSON.parse(response);
		
				if(response)
					$tr.replaceWith(_getHoursRowHtml(response));
			})
			.catch(function onError(obj, txt, errorThrown) {
				exception(txt + ': ' + errorThrown);
			});
		});
	}
	
	/*
	 * Create / save an opening hours record
	 */
	function _saveHours(clickedButton) {
		var $this = $(clickedButton),
			$tr = $this.closest("tr"),
			$tbody = $this.closest("tbody");
		
		var data = _getDataToSave($tr);

		if(data.hoursType === "S") {
			data.date = $tr.find(".date input").val();
		}

		var $setHours;
		
		if($this.data('id') === "new") {
			data.daySequence = 1;
			$setHours = _getAjaxPromise("create", data);
		} else {
			data.openingHoursId = $this.data("id");
			data.daySequence = $tr.index() + 1;
			$setHours = _getAjaxPromise("update", data);
		}
		
		$setHours.then(function(response) {
			if(typeof response === "string")
				response = JSON.parse(response);

			$tr.replaceWith(_getHoursRowHtml(response));
			if($this.data('id') === "new") {
				$this.data("id", response.daySequence);
				
				if($tr.data("hourstype") === "N")
					_saveHoursFromSort($tbody, 0); 
			}
		})
		.catch(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
	}
	
	/*
	 * Delete an opening hours record
	 */
	function _deleteHours(clickedButton) {
		var $this = $(clickedButton),
			id = $this.data("id"),
			$tr = $this.closest("tr"),
			$tbody = $this.closest("tbody");
		
		var message = [
			"Do you really want to delete the opening hours:",
			"Day: " + $tr.find(".description input, .description select").val(),
			"Start: " + $tr.find(".startTime input").val() + " " + $tr.find(".effectiveStart input").val(),
			"End: " + $tr.find(".endTime input").val() + " " + $tr.find(".effectiveEnd input").val(),
			"Hours Type: " + _getHoursType($tr.data("hourstype"))
		].join("\n");
	
		if(confirm(message)) {
			$deleteHours = _getAjaxPromise("delete", {
				openingHoursId: id
			});
			
			$deleteHours.then(function(response) {
				if(typeof response === "string" && response !== "success")
					response = JSON.parse(response);
				
				if(response === "success" || (typeof response.result !== "undefined" && response.result === "success")) {
					_removeRow($this.closest("tr"));
					
					if($tr.data("hourstype") === "N")
						_saveHoursFromSort($tbody, 0);
				}
			})
			.catch(function onError(obj, txt, errorThrown) {
				exception(txt + ': ' + errorThrown);
			});
		}
	}
	
	/*
	 * Helper for handling opening hours AJAX requests.
	 */
	function _getAjaxPromise(url, data, method) {
		method = method || "post";

		url = "admin/openinghours/" + url + ".json";

		return meerkat.modules.comms[method]({
			url: url,
			data: data,
			errorLevel: "warning",
			onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {
				if(typeof jqXHR.responseText === "string")
					jqXHR.responseText = JSON.parse(jqXHR.responseText);

				var errorMessage = (jqXHR.responseText.error[0] && jqXHR.responseText.error[0].message) ? jqXHR.responseText.error[0].message : false;

				var errorObject = {
					errorLevel:		settings.errorLevel,
					message:		errorMessage,
					page:			'simplesCallCentreHours.js',
					description:	"Error loading url: " + settings.url + ' : ' + textStatus + ' ' + errorThrown,
					data:			data
				};

				if(!meerkat.modules.dialogs.isDialogOpen("openingHoursErrorDialog") && errorMessage) {
					meerkat.modules.errorHandling.error(errorObject);
				}
			}
		});
	}

	/*
	 * Returns the entire HTML contents which should be put into the <tbody> tag
	 */
	function _getHoursAllHtml(rowArray) {
		if(typeof rowArray === "string")
			rowArray = JSON.parse(rowArray);
		
		var rowHtml = [];
		
		for(var i = 0; i < rowArray.length; i++) {
			rowHtml.push(_getHoursRowHtml(rowArray[i]));
		}
		
		if(rowHtml.length) {
			return rowHtml.join('');
		} else {
			return _.template(noResultsTemplate);
		}
	}
	
	/*
	 * Gets the HTML for a particular row using a template and specified data
	 */
	function _getHoursRowHtml(rowData) {
		var htmlTemplate = _.template(rowTemplate);
		return htmlTemplate(rowData);
	}
	
	meerkat.modules.register('adminCallCentreHours', {
		init: init
	});

})(jQuery);
