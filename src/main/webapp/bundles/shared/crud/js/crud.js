/**
 * CRUD interface handler for creating CRUD pages
 *
 */
;(function($, undefined){
	
	var meerkat = window.meerkat,
		log = meerkat.logging.info;

    var events = {
            crud: {
                CRUD_MODAL_OPENED: 'CRUD_MODAL_OPENED'
            }
        },
        moduleEvents = events.crud;
	
	var loadingOverlayHTML = [
			"<div id='crud-loading-overlay'>",
				"<div class='spinner'>",
					"<div class='bounce1'></div>",
					"<div class='bounce2'></div>",
					"<div class='bounce3'></div>",
				"</div>",
				"<p></p>",
			"</div>"
		],
		$loadingOverlay,
		blurElements = "#page, #dynamic_dom";
	var crudModel;
	
	function init() {
        crudModel = meerkat.modules.crudModel;

		$loadingOverlay = $(loadingOverlayHTML.join(""))
			.appendTo("body");
	}

	function _showLoading(text) {
		$loadingOverlay
			.find("p")
			.text(text)
			.end()
			.stop()
			.fadeIn();
		$(blurElements).addClass("blur");
	}

	function _hideLoading() {
		$(blurElements).removeClass("blur");
		$loadingOverlay.stop().fadeOut();
	}
	
	function dataCRUD(settings) {
		var that = this;
		this.dataSet = new crudModel.dataSet();
		this.modalId = "";
		this.models = {};
		
		for(var i in settings) {
			this[i] = settings[i];
		}
		
		// Check if we already have a method for handing results rendering
		// otherwise default to throwing it into the appropriate container
		if(!this.renderResults) {
			this.renderResults = function() {
				var results = that.dataSet.get(),
					resultsHTML = "";

				for(var i = 0; i < results.length; i++) {
					resultsHTML += results[i].html;
				}

				$(".sortable-results-table")
					.html(resultsHTML)
					.closest(".row")
					.find("h1 small")
					.text("(" + results.length + ")");
			};
		}
		
		// Check if we have manually defined the required views
		if(!this.views) {
			this.views = {
				row: $('.crud-row-template').html(),
				modal: $('.crud-modal-template').html()
			};
		}
		
		$(document)
			.on("click", ".crud-results-toggle", function() {
				var $this = $(this),
					$container = $this.closest(".row").find(".sortable-results-table");

				if($this.hasClass("table-hidden")) {
					$container.slideDown(400, function(){
						$this.removeClass("table-hidden");
					}).removeClass('hidden');
				} else {
					$container.slideUp(400, function() {
						$this.addClass("table-hidden");
					}).addClass('hidden');
				}
			})
			.on("click", ".crud-new-entry", function() {
				that.openModal();
			})
			.on("click", ".crud-edit-entry", function() {
				var $row = $(this).closest(".sortable-results-row");
				that.openModal($row);
			})
			.on("click", ".crud-clone-entry", function() {
				var $row = $(this).closest(".sortable-results-row");
				that.openModal($row, true);
			})
			.on("click", ".crud-delete-entry", function() {
				var doDelete = confirm("Do you want to delete the record?");
				
				if(doDelete) {
					var $row = $(this).closest(".sortable-results-row");
					that.destroy($row);
				}
			})
            .on("click", ".crud-cancel-entry", function() {
                var doCancel = confirm("Do you want to cancel the record?");

                if(doCancel) {
                    var $row = $(this).closest(".sortable-results-row");
                    that.cancel($row);
                }
            });
	}

    /**
     * Appends modal content to mainForm of body
     */
	dataCRUD.prototype.appendToMainForm = function() {
        var model,
            modalHTML;

        model = new crudModel.dbModel(this.models.db);
        var modalHTMLTemplate = _.template(this.views.modal, { variable: "data" });
        modalHTML = modalHTMLTemplate(model);

        $('#mainform').append(modalHTML);
	};
	
	/**
	 * Opens a modal for creating or editing a record
	 * @param $targetRow
	 * @param isClone bool Forces new record to be written if true
	 */
	dataCRUD.prototype.openModal = function($targetRow, isClone) {
		isClone = isClone || false;
		
		var that = this,
			m,
			modalHTML,
            searchId;

		if($targetRow) {
            searchId = $targetRow.data("id");
            m = this.dataSet.get(searchId).data;
        } else if (_.isFunction(this.models.db)) {
		    m = new crudModel.dbModel(this.models.db());
		} else {
			m = new crudModel.dbModel(this.models.db);
		}

		if(isClone)
			m.modalAction = "clone"; 
		else if($targetRow)
			m.modalAction = "edit";
		else
			m.modalAction = "create";
		
		var modalHTMLTemplate = _.template(this.views.modal, { variable: "data" });
		modalHTML = modalHTMLTemplate(m);
		this.modalId = meerkat.modules.dialogs.show({
			htmlContent: modalHTML
		});

		// Initialize the text editors
		var $textAreas = $("#" + this.modalId + " textarea.form-control.editor");
		if($textAreas.length) {
			$textAreas.trumbowyg({
				fullscreenable: false,
				removeformatPasted: true,
				resetCss: true,
				btns: ["strong", "em", "underline", "|", "unorderedList", "orderedList", "|", "link"]
			});
		}

        $(document).on("click", "#" + that.modalId + " .crud-save-entry", function() {
            var $modal = $("#" + that.modalId),
                data = that.getSaveRequestData($modal, searchId);

            // If we are cloning, don't pass the target row so that we can force a new
            // record instead of an update
            if(isClone)
                that.save(data);
            else
                that.save(data, $targetRow);
        });

        meerkat.messaging.publish(moduleEvents.CRUD_MODAL_OPENED, { modalId: this.modalId });
	};

    /**
     * Default request data structure when saving a record,
     * override the method if you have different request model
     */
    dataCRUD.prototype.getSaveRequestData = function ($modal) {
        var $inputs = $modal.find("input, textarea, select"),
            data = {};

        for(var i = 0; i < $inputs.length; i++) {
            var $input = $($inputs[i]);
            data[$input.attr("name")] = $input.val();
        }

        return data;
    };
	
	/**
	 * Forces the results to render
	 */
	dataCRUD.prototype.sortRenderResults = function() {
		var $sortElement = $(document).find(".sort-by"),
			key = $sortElement.data("sortkey"),
			direction = $sortElement.data("sortdir");

		if (typeof key === 'string' && key.match('/./')) {
			this.dataSet.sort(key, direction, this.renderResults);
		} else {
			this.renderResults();
		}
	};
	
	/**
	 * 
	 * @returns {crudModel.newDataSet}
	 */
	dataCRUD.prototype.dataSet = function() {
		return this.dataSet;
	};
	
	/**
	 * Fetches all records from the server and renders them to the page
	 * @returns promise
	 */
	dataCRUD.prototype.get = function(data) {
		this.dataSet.empty();

		data = data || {};

		var that = this,
			onSuccess = function(response) {
				if(typeof response === "string")
					response = JSON.parse(response);

				if(response.length) {
					for (var i = 0; i < response.length; i++) {
						var datum = response[i],
							obj = new crudModel.datumModel(that.primaryKey, that.models.datum, datum, that.views.row);
						that.dataSet.push(obj);
					}
				}
				
				that.sortRenderResults();
			};
		
		return this.promise("getAllRecords", data, onSuccess, "get");
	};
	
	/**
	 * Triggers a create / update depending on the passed content
	 * @param data
	 * @param $targetRow
	 */
	dataCRUD.prototype.save = function(data, $targetRow) {
		var that = this,
			onSuccess = function(response) {
				if(typeof response === "string")
					response = JSON.parse(response);

				var responseObject = new crudModel.datumModel(that.primaryKey, that.models.datum, response, that.views.row);
		
				if($targetRow) {
					var index = that.dataSet.getIndex(responseObject.id);
					
					if(index !== -1) {
						that.dataSet.updateIndex(index, responseObject);
					} else {
						that.dataSet.push(responseObject);
					}
				} else {
					that.dataSet.push(responseObject);
				}
				
				that.sortRenderResults();

				meerkat.modules.dialogs.close(that.modalId);
			};
			
		$targetRow ? this.update(data, onSuccess) : this.create(data, onSuccess);
	};
	
	/**
	 * Creates a new record in the database
	 * @param data
	 * @returns
	 */
	dataCRUD.prototype.create = function(data, onSuccess) {
		return this.promise("create", data, onSuccess);
	};
	
	/**
	 * Updates a record in the database
	 * @param data
	 * @returns
	 */
	dataCRUD.prototype.update = function(data, onSuccess) {
		return this.promise("update", data, onSuccess);
	};
	
	/**
	 * Returns a data object used to tell the server what record to delete.
	 * By default contains only the primary key. Looking to delete by a 
	 * number of fields? Override this method!
	 * @returns string
	 */
	dataCRUD.prototype.getDeleteRequestData = function($row) {
		var data = {},
			deleteKey = this.primaryKey,
			deleteId = $row.data("id");

		data[deleteKey] = deleteId;
		
		return data;
	};
	
	/**
	 * DESTROYS a record from the database
	 * @param $row
	 * @returns
	 */
	dataCRUD.prototype.destroy = function($row) {
		var that = this;
			data = this.getDeleteRequestData($row),
			deleteKey = this.primaryKey;
			
		var index = this.dataSet.getIndex(data[deleteKey]),
			onSuccess = function() {
				$row.animate({
					opacity: 0
				}, 400, "swing", function(){
					if(index !== -1)
						that.dataSet.splice(index);
					
					that.sortRenderResults();
				});
			};

		return this.promise("delete", data, onSuccess);
	};
    /**
     * Placeholder for cancel a record, currently only used for reward
     * @param $row
     */
	dataCRUD.prototype.cancel = function ($row) {

    };
	
	/**
	 * Returns an AJAX promise via the comms module and utilises a modified error handler.
	 */
	dataCRUD.prototype.promise = function(action, data, onSuccess, method, forceJson) {
		method = method || "post";
		
		var finalURL = this.baseURL + "/" + action + ".json";

		var loadingText;

		switch(action) {
			case "getAllRecords":
            case "find":
				loadingText = "Fetching Records";
				break;
			case "create":
				loadingText = "Creating Record";
				break;
			case "update":
				loadingText = "Submitting";
				break;
			case "delete":
				loadingText = "Deleting Record";
				break;
			default:
				loadingText = "Loading";
		}

		_showLoading(loadingText);

		var ajaxSettings = {
            url: finalURL,
            data: data,
            errorLevel: "warning",
            onSuccess: function(data, textStatus, jqXHR) {
                if(typeof data === "string" && data !== "success")
                    data = JSON.parse(data);

                if(data && !data.hasOwnProperty("error")) {
                    if(onSuccess)
                        onSuccess(data);
                } else {
                    var error = (typeof data !== "undefined" && data !== null && typeof data.error !== "undefined") ? data.error : [];
                    _handleErrorObject(error);
                }
            },
            onComplete: function() {
                _hideLoading();
            },
            onErrorDefaultHandling: _handleAJAXError
        };

		if(forceJson === true) {
		    ajaxSettings.contentType = 'application/json; charset=utf-8';
            ajaxSettings.doStringify = true;
        }

		return meerkat.modules.comms[method](ajaxSettings);
	};
	
	function _handleErrorObject(error) {
		var errorList = [];
		
		for(var i = 0; i < error.length; i++) {
			var err = error[i],
				$formGroup = $(".modal").find("[name='" + err.elementXpath + "']").closest(".form-group");
			
			$formGroup.addClass("has-error");
			errorList.push(err.message);
		}
		
		var errorListHTML = "<li>" + errorList.join("</li><li>") + "</li>";
		
		$(".modal").find(".error-list").html(errorListHTML);
	}
	
	function _handleAJAXError(jqXHR, textStatus, errorThrown, settings, data) {
		var errorObj;
		
		if(jqXHR && typeof jqXHR.responseText === "string") {
			jqXHR.responseText = JSON.parse(jqXHR.responseText);
			errorObj = jqXHR.responseText.error;
		}
		
		if(errorObj) {
			_handleErrorObject(errorObj);
		} else {
			var errorObject = {
				errorLevel:		settings.errorLevel,
				message:		jqXHR.responseText,
				page:			'crud.js',
				description:	"Error loading url: " + settings.url + ' : ' + textStatus + ' ' + errorThrown,
				data:			data
			};
			
			if(!meerkat.modules.dialogs.isDialogOpen("dataObjectDialog")) {
				meerkat.modules.errorHandling.error(errorObject);
			}
		}
	}
	
	meerkat.modules.register('crud', {
		init: init,
		newCRUD: dataCRUD,
        events: events
	});
	
})(jQuery);