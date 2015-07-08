/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var rowTemplate, noResultsTemplate;
    function init() {
        $(document).ready(function() {
            rowTemplate = $("#opening-hours-row-template").html();
            noResultsTemplate = $("#opening-hours-row-noresults-template").html();
            _loadHoursInformation();
            $(document).on("click", ".opening-hours-refresh", _loadHoursInformation).on("click", ".opening-hours-new", function simplesOpeningHoursNewClick() {
                _showNewOpeningHoursInputs(this);
            }).on("click", ".opening-hours-table .edit, .opening-hours-table .cancel", function simplesOpeningHoursEditClick() {
                _toggleHiddenInputsOnClick(this);
            }).on("click", ".opening-hours-table .save", function simplesOpeningHoursEditClick() {
                _saveHours(this);
            }).on("click", ".opening-hours-table .delete", function simplesOpeningHoursDeleteClick() {
                _deleteHours(this);
            });
        });
    }
    function _showNewOpeningHoursInputs(clickedButton) {
        var $this = $(clickedButton), $row = $this.closest(".row"), $table = $row.find("table");
        if (!$table.find("#opening-hours-new").length) {
            $table.find("#opening-hours-noresults").remove();
            var date = new Date(), formattedDate = date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + ("0" + date.getDate()).slice(-2);
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
            if (data.hoursType === "S") {
                data.date = formattedDate;
            } else if (data.hoursType === "N") {
                data.daySequence = 0;
            }
            var rowHtml = _getHoursRowHtml(data), $tr = $(rowHtml).prependTo($table.find("tbody"));
            _toggleHiddenInputs($tr);
        }
    }
    function _toggleHiddenInputsOnClick(clickedButton) {
        var $this = $(clickedButton), $tr = $this.closest("tr");
        if ($tr.data("id") === "new") {
            _removeRow($tr);
        } else {
            _toggleHiddenInputs($tr);
            $tr.find("input").each(function() {
                this.value = this.defaultValue;
            }).end().find("select").each(function() {
                $(this).find("option").prop("selected", function() {
                    return this.defaultSelected;
                });
            });
        }
    }
    function _removeRow($tr) {
        var $tbody = $tr.closest("tbody");
        $tr.find("td").addClass("danger").end().fadeOut(400, function() {
            $(this).remove();
            if (!$tbody.find("tr").length) $tbody.append(_.template(noResultsTemplate));
        });
    }
    function _getHoursType(type) {
        return type === "N" ? "Normal" : "Special";
    }
    function _toggleHiddenInputs($tableRow) {
        var $elements = $tableRow.find("input, span, button, select");
        $elements.each(function() {
            var $el = $(this);
            if ($el.hasClass("hidden")) $el.removeClass("hidden"); else $el.addClass("hidden");
        });
    }
    function _loadHoursInformation() {
        if (rowTemplate) {
            var allRecordsUrl = "getAllRecords", $openingHours = _getAjaxPromise(allRecordsUrl, {
                hoursType: "N"
            }, "get"), $specialHours = _getAjaxPromise(allRecordsUrl, {
                hoursType: "S"
            }, "get");
            var setUpTable = function simplesOpeningHoursSetUpTable($table, response) {
                $table.find("tbody").html(_getHoursAllHtml(response));
                if ($table.data("hourstype") === "N") {
                    $table.rowSorter({
                        handler: "td.sorter span",
                        onDrop: function(tbody, row, newIndex, oldIndex) {
                            if (newIndex < oldIndex) {
                                _saveHoursFromSort($table, newIndex);
                            } else {
                                _saveHoursFromSort($table, oldIndex);
                            }
                        }
                    });
                }
            };
            $openingHours.done(function(response) {
                setUpTable($("#hours-normal-row-container"), response);
            });
            $specialHours.done(function(response) {
                setUpTable($("#hours-special-row-container"), response);
            });
        }
    }
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
    function _saveHoursFromSort($tbody, startPosition) {
        var $trs = $tbody.find("tr:gt(" + startPosition + ")");
        $trs.each(function() {
            var $tr = $(this);
            var data = _getDataToSave($tr);
            data.openingHoursId = $tr.data("id");
            if (data.hoursType === "S") {
                data.date = $tr.find(".date input").val();
            } else if (data.hoursType === "N") {
                data.daySequence = $tr.index() + 1;
            }
            var $setHours = _getAjaxPromise("update", data);
            $setHours.done(function(response) {
                if (typeof response === "string") response = JSON.parse(response);
                if (response) $tr.replaceWith(_getHoursRowHtml(response));
            });
        });
    }
    function _saveHours(clickedButton) {
        var $this = $(clickedButton), $tr = $this.closest("tr"), $tbody = $this.closest("tbody");
        var data = _getDataToSave($tr);
        if (data.hoursType === "S") {
            data.date = $tr.find(".date input").val();
        }
        var $setHours;
        if ($this.data("id") === "new") {
            data.daySequence = 1;
            $setHours = _getAjaxPromise("create", data);
        } else {
            data.openingHoursId = $this.data("id");
            data.daySequence = $tr.index() + 1;
            $setHours = _getAjaxPromise("update", data);
        }
        $setHours.done(function(response) {
            if (typeof response === "string") response = JSON.parse(response);
            $tr.replaceWith(_getHoursRowHtml(response));
            if ($this.data("id") === "new") {
                $this.data("id", response.daySequence);
                if ($tr.data("hourstype") === "N") _saveHoursFromSort($tbody, 0);
            }
        });
    }
    function _deleteHours(clickedButton) {
        var $this = $(clickedButton), id = $this.data("id"), $tr = $this.closest("tr"), $tbody = $this.closest("tbody");
        var message = [ "Do you really want to delete the opening hours:", "Day: " + $tr.find(".description input, .description select").val(), "Start: " + $tr.find(".startTime input").val() + " " + $tr.find(".effectiveStart input").val(), "End: " + $tr.find(".endTime input").val() + " " + $tr.find(".effectiveEnd input").val(), "Hours Type: " + _getHoursType($tr.data("hourstype")) ].join("\n");
        if (confirm(message)) {
            $deleteHours = _getAjaxPromise("delete", {
                openingHoursId: id
            });
            $deleteHours.done(function(response) {
                if (typeof response === "string" && response !== "success") response = JSON.parse(response);
                if (response === "success" || typeof response.result !== "undefined" && response.result === "success") {
                    _removeRow($this.closest("tr"));
                    if ($tr.data("hourstype") === "N") _saveHoursFromSort($tbody, 0);
                }
            });
        }
    }
    function _getAjaxPromise(url, data, method) {
        method = method || "post";
        url = "admin/openinghours/" + url + ".json";
        return meerkat.modules.comms[method]({
            url: url,
            data: data,
            errorLevel: "warning",
            onErrorDefaultHandling: function(jqXHR, textStatus, errorThrown, settings, data) {
                if (typeof jqXHR.responseText === "string") jqXHR.responseText = JSON.parse(jqXHR.responseText);
                var errorObject = {
                    errorLevel: settings.errorLevel,
                    message: jqXHR.responseText,
                    page: "simplesCallCentreHours.js",
                    description: "Error loading url: " + settings.url + " : " + textStatus + " " + errorThrown,
                    data: data
                };
                if (!meerkat.modules.dialogs.isDialogOpen("openingHoursErrorDialog")) {
                    meerkat.modules.errorHandling.error(errorObject);
                }
            }
        });
    }
    function _getHoursAllHtml(rowArray) {
        if (typeof rowArray === "string") rowArray = JSON.parse(rowArray);
        var rowHtml = [];
        for (var i = 0; i < rowArray.length; i++) {
            rowHtml.push(_getHoursRowHtml(rowArray[i]));
        }
        if (rowHtml.length) {
            return rowHtml.join("");
        } else {
            return _.template(noResultsTemplate);
        }
    }
    function _getHoursRowHtml(rowData) {
        return _.template(rowTemplate, rowData);
    }
    meerkat.modules.register("adminCallCentreHours", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var loadingOverlayHTML = [ "<div id='crud-loading-overlay'>", "<div class='spinner'>", "<div class='bounce1'></div>", "<div class='bounce2'></div>", "<div class='bounce3'></div>", "</div>", "<p></p>", "</div>" ], $loadingOverlay, blurElements = "#page, #dynamic_dom";
    var dataSetModule;
    function init() {
        dataSetModule = meerkat.modules.adminDataSet;
        $loadingOverlay = $(loadingOverlayHTML.join("")).appendTo("body");
    }
    function _showLoading(text) {
        $loadingOverlay.find("p").text(text).end().stop().fadeIn();
        $(blurElements).addClass("blur");
    }
    function _hideLoading() {
        $(blurElements).removeClass("blur");
        $loadingOverlay.stop().fadeOut();
    }
    function dataCRUD(settings) {
        var that = this;
        this.dataSet = new dataSetModule.dataSet();
        this.modalId = "";
        this.models = {};
        for (var i in settings) {
            this[i] = settings[i];
        }
        if (!this.renderResults) {
            this.renderResults = function() {
                var results = that.dataSet.get(), resultsHTML = "";
                for (var i = 0; i < results.length; i++) {
                    resultsHTML += results[i].html;
                }
                $(".sortable-results-table").html(resultsHTML).closest(".row").find("h1 small").text("(" + results.length + ")");
            };
        }
        if (!this.views) {
            this.views = {
                row: $(".crud-row-template").html(),
                modal: $(".crud-modal-template").html()
            };
        }
        $(document).on("click", ".crud-results-toggle", function() {
            var $this = $(this), $container = $this.closest(".row").find(".sortable-results-table");
            if ($this.hasClass("table-hidden")) {
                $container.slideDown(400, function() {
                    $this.removeClass("table-hidden");
                });
            } else {
                $container.slideUp(400, function() {
                    $this.addClass("table-hidden");
                });
            }
        }).on("click", ".crud-new-entry", function() {
            that.openModal();
        }).on("click", ".crud-edit-entry", function() {
            var $row = $(this).closest(".sortable-results-row");
            that.openModal($row);
        }).on("click", ".crud-clone-entry", function() {
            var $row = $(this).closest(".sortable-results-row");
            that.openModal($row, true);
        }).on("click", ".crud-delete-entry", function() {
            var doDelete = confirm("Do you want to delete the record?");
            if (doDelete) {
                var $row = $(this).closest(".sortable-results-row");
                that.destroy($row);
            }
        });
    }
    dataCRUD.prototype.openModal = function($targetRow, isClone) {
        isClone = isClone || false;
        var that = this, m, modalHTML;
        if ($targetRow) {
            var searchId = $targetRow.data("id");
            m = this.dataSet.get(searchId).data;
        } else {
            m = new dataSetModule.dbModel(this.models.db);
        }
        if (isClone) m.modalAction = "clone"; else if ($targetRow) m.modalAction = "edit"; else m.modalAction = "create";
        modalHTML = _.template(this.views.modal, m, {
            variable: "data"
        });
        this.modalId = meerkat.modules.dialogs.show({
            htmlContent: modalHTML
        });
        var $textAreas = $("#" + this.modalId + " textarea.form-control");
        if ($textAreas.length) {
            $textAreas.trumbowyg({
                fullscreenable: false,
                removeformatPasted: true,
                resetCss: true,
                btns: [ "strong", "em", "underline", "|", "unorderedList", "orderedList", "|", "link" ]
            });
        }
        $(document).on("click", "#" + that.modalId + " .crud-save-entry", function() {
            var $modal = $("#" + that.modalId), $inputs = $modal.find("input, textarea, select"), data = {};
            for (var i = 0; i < $inputs.length; i++) {
                var $input = $($inputs[i]);
                data[$input.attr("name")] = $input.val();
            }
            if (isClone) that.save(data); else that.save(data, $targetRow);
        });
    };
    dataCRUD.prototype.sortRenderResults = function() {
        var $sortElement = $(document).find(".sort-by"), key = $sortElement.data("sortkey"), direction = $sortElement.data("sortdir");
        this.dataSet.sort(key, direction, this.renderResults);
    };
    dataCRUD.prototype.dataSet = function() {
        return this.dataSet;
    };
    dataCRUD.prototype.get = function() {
        this.dataSet.empty();
        var that = this, onSuccess = function(data) {
            if (typeof data === "string") data = JSON.parse(data);
            if (data.length) {
                for (var i = 0; i < data.length; i++) {
                    var datum = data[i], obj = new dataSetModule.datumModel(that.primaryKey, that.models.datum, datum, that.views.row);
                    that.dataSet.push(obj);
                }
            }
            that.sortRenderResults();
        };
        return this.promise("getAllRecords", {}, onSuccess, "get");
    };
    dataCRUD.prototype.save = function(data, $targetRow) {
        var that = this, onSuccess = function(response) {
            if (typeof response === "string") response = JSON.parse(response);
            var responseObject = new dataSetModule.datumModel(that.primaryKey, that.models.datum, response, that.views.row);
            if ($targetRow) {
                var index = that.dataSet.getIndex(responseObject.id);
                if (index !== -1) {
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
    dataCRUD.prototype.create = function(data, onSuccess) {
        return this.promise("create", data, onSuccess);
    };
    dataCRUD.prototype.update = function(data, onSuccess) {
        return this.promise("update", data, onSuccess);
    };
    dataCRUD.prototype.getDeleteRequestData = function($row) {
        var data = {}, deleteKey = this.primaryKey, deleteId = $row.data("id");
        data[deleteKey] = deleteId;
        return data;
    };
    dataCRUD.prototype.destroy = function($row) {
        var that = this;
        data = this.getDeleteRequestData($row), deleteKey = this.primaryKey;
        var index = this.dataSet.getIndex(data[deleteKey]), onSuccess = function() {
            $row.animate({
                opacity: 0
            }, 400, "swing", function() {
                if (index !== -1) that.dataSet.splice(index);
                that.sortRenderResults();
            });
        };
        return this.promise("delete", data, onSuccess);
    };
    dataCRUD.prototype.promise = function(action, data, onSuccess, method) {
        method = method || "post";
        var finalURL = this.baseURL + "/" + action + ".json";
        var loadingText;
        switch (action) {
          case "getAllRecords":
            loadingText = "Fetching Records";
            break;

          case "create":
            loadingText = "Creating Record";
            break;

          case "update":
            loadingText = "Updating Record";
            break;

          case "delete":
            loadingText = "Deleting Record";
            break;

          default:
            loadingText = "Loading";
        }
        _showLoading(loadingText);
        return meerkat.modules.comms[method]({
            url: finalURL,
            data: data,
            errorLevel: "warning",
            onSuccess: function(data, textStatus, jqXHR) {
                if (typeof data === "string" && data !== "success") data = JSON.parse(data);
                if (data && !data.hasOwnProperty("error")) {
                    if (onSuccess) onSuccess(data);
                } else {
                    var error = typeof data !== "undefined" && data !== null && typeof data.error !== "undefined" ? data.error : [];
                    _handleErrorObject(error);
                }
            },
            onComplete: function() {
                _hideLoading();
            },
            onErrorDefaultHandling: _handleAJAXError
        });
    };
    function _handleErrorObject(error) {
        var errorList = [];
        for (var i = 0; i < error.length; i++) {
            var err = error[i], $formGroup = $(".modal").find("[name='" + err.elementXpath + "']").closest(".form-group");
            $formGroup.addClass("has-error");
            errorList.push(err.message);
        }
        var errorListHTML = "<li>" + errorList.join("</li><li>") + "</li>";
        $(".modal").find(".error-list").html(errorListHTML);
    }
    function _handleAJAXError(jqXHR, textStatus, errorThrown, settings, data) {
        var errorObj;
        if (jqXHR && typeof jqXHR.responseText === "string") {
            jqXHR.responseText = JSON.parse(jqXHR.responseText);
            errorObj = jqXHR.responseText.error;
        }
        if (errorObj) {
            _handleErrorObject(errorObj);
        } else {
            var errorObject = {
                errorLevel: settings.errorLevel,
                message: jqXHR.responseText,
                page: "adminDataCRUD.js",
                description: "Error loading url: " + settings.url + " : " + textStatus + " " + errorThrown,
                data: data
            };
            if (!meerkat.modules.dialogs.isDialogOpen("dataObjectDialog")) {
                meerkat.modules.errorHandling.error(errorObject);
            }
        }
    }
    meerkat.modules.register("adminDataCRUD", {
        init: init,
        newCRUD: dataCRUD
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    function datumModel(idKey, datumAdditionalFields, response, templateHTML) {
        this.id = response[idKey];
        this.data = new dbModel(response);
        if (datumAdditionalFields) {
            var data = datumAdditionalFields(response);
            for (var i in data) {
                if (i === "extraData") {
                    var extraData = data[i];
                    for (var j in extraData) {
                        var field = extraData[j];
                        this.data[j] = typeof field === "function" ? field() : field;
                    }
                } else {
                    this[i] = data[i];
                }
            }
        }
        this.html = _.template(templateHTML, this.data, {
            variable: "data"
        });
        return this;
    }
    function dbModel(data) {
        var date = new Date(), formattedDate = date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + ("0" + date.getDate()).slice(-2);
        this.effectiveStart = formattedDate;
        this.effectiveEnd = formattedDate;
        for (var i in data) {
            this[i] = data[i];
        }
        return this;
    }
    dbModel.prototype.setProperty = function(property, value) {
        this[property] = value;
    };
    function dataSet() {
        var that = this;
        this.dataSet = [];
        $(document).on("click", ".data-sorter .toggle", function() {
            var $this = $(this), sortKey = $this.data("sortkey"), sortDir = $this.attr("data-sortdir"), callback = $this.closest(".data-sorter").data("refreshcallback");
            $(".data-sorter .toggle").removeClass("sort-by").attr("data-sortdir", "desc");
            $this.addClass("sort-by");
            sortDir = sortDir === "asc" ? "desc" : "asc";
            $this.attr("data-sortdir", sortDir);
            that.sort(sortKey, sortDir, callback);
        });
    }
    dataSet.prototype.empty = function() {
        this.dataSet = [];
    };
    dataSet.prototype.set = function(dataSet) {
        this.dataSet = dataSet;
    };
    dataSet.prototype.push = function(data) {
        this.dataSet.push(data);
    };
    dataSet.prototype.get = function(id) {
        if (id) {
            return this.dataSet.filter(function(el) {
                return el.id === id;
            })[0];
        } else {
            return this.dataSet;
        }
    };
    dataSet.prototype.getByType = function(type) {
        return this.get().filter(function(el) {
            if (el.data.type) return el.data.type === type; else return false;
        });
    };
    dataSet.prototype.getIndex = function(objectId) {
        var index = -1;
        for (var j = 0; j < this.dataSet.length; j++) {
            if (this.dataSet[j].id === objectId) {
                index = j;
            }
        }
        return index;
    };
    dataSet.prototype.updateIndex = function(index, data) {
        this.dataSet[index] = data;
    };
    dataSet.prototype.splice = function(index, count) {
        count = count || 1;
        this.dataSet.splice(index, count);
    };
    dataSet.prototype.sort = function(key, direction, callback) {
        var keyChain = key.split(".");
        direction = direction || "asc";
        var sort = function(a, b) {
            for (var i = 0; i < keyChain.length; i++) {
                var keyChainItem = keyChain[i];
                a = a[keyChainItem];
                b = b[keyChainItem];
            }
            if (typeof a === "string") a = a.toLowerCase();
            if (typeof b === "string") b = b.toLowerCase();
            if (a < b && direction === "asc" || a > b && direction === "desc") return -1;
            if (a > b && direction === "asc" || a < b && direction === "desc") return 1;
            return 0;
        };
        var sortedDataSet = this.dataSet.sort(sort);
        this.set(sortedDataSet);
        if (typeof callback === "string") _getObject(callback)(); else if (typeof callback === "function") callback();
    };
    var _getObject = function(methodPath) {
        var keyChain = methodPath.split("."), object = window;
        for (var i = 0; i < keyChain.length; i++) {
            object = object[keyChain[i]];
        }
        return object;
    };
    meerkat.modules.register("adminDataSet", {
        dataSet: dataSet,
        dbModel: dbModel,
        datumModel: datumModel
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var CRUD;
    function init() {
        $(document).ready(function() {
            if ($("#fund-capping-limits-container").length) {
                CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
                    baseURL: "../../admin/cappingLimits",
                    primaryKey: "cappingLimitsKey",
                    models: {
                        datum: function(data) {
                            return {
                                extraData: {
                                    limitLeft: data.cappingAmount - data.currentJoinCount,
                                    category: function() {
                                        return data.cappingLimitCategory === "H" ? "Hard" : "Soft";
                                    },
                                    type: function() {
                                        var curDate = new Date().setHours(0, 0, 0, 0);
                                        if (new Date(data.effectiveEnd).setHours(0, 0, 0, 0) >= curDate) {
                                            return "current";
                                        } else {
                                            return "past";
                                        }
                                    }
                                }
                            };
                        }
                    },
                    renderResults: renderCappingsHTML
                });
                CRUD.getDeleteRequestData = function($row) {
                    return CRUD.dataSet.get($row.data("id")).data;
                };
                CRUD.get();
                $(document).on("change", "#modal-limit-type", function() {
                    var $this = $(this), val = $this.val(), $category = $("#modal-category");
                    if (val === "Monthly") {
                        $category.attr("disabled", "disabled").val("H");
                    } else {
                        $category.removeAttr("disabled");
                    }
                });
            }
        });
    }
    function renderCappingsHTML() {
        var types = [ "current", "past" ];
        for (var i = 0; i < types.length; i++) {
            var type = types[i], cappings = CRUD.dataSet.getByType(type), cappingHTML = "";
            for (var j = 0; j < cappings.length; j++) {
                cappingHTML += cappings[j].html;
            }
            $("#" + type + "-cappings-container").html(cappingHTML).closest(".row").find("h1 small").text("(" + cappings.length + ")");
        }
    }
    function refresh() {
        CRUD.renderResults();
    }
    meerkat.modules.register("adminFundCappingLimits", {
        init: init,
        refresh: refresh
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var CRUD;
    function init() {
        $(document).ready(function() {
            if ($("#admin-fund-warning-message-container").length) {
                CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
                    baseURL: "../../admin/fundwarning",
                    primaryKey: "messageId",
                    models: {
                        datum: function(message) {
                            return {
                                extraData: {
                                    providerName: function() {
                                        var providerInfo = providers.filter(function(a) {
                                            return a.value === message.providerId;
                                        });
                                        return providerInfo.length ? providerInfo[0].text : "";
                                    }
                                }
                            };
                        }
                    }
                });
                CRUD.get();
            }
        });
    }
    function refresh() {
        CRUD.renderResults();
    }
    meerkat.modules.register("adminFundWarningMessage", {
        init: init,
        refresh: refresh
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var CRUD;
    function init() {
        $(document).ready(function() {
            if ($("#special-offers-container").length) {
                CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
                    baseURL: "admin/offers",
                    primaryKey: "offerId",
                    models: {
                        datum: function(offer) {
                            return {
                                extraData: {
                                    type: function() {
                                        var curDate = new Date(), startDate = new Date(offer.effectiveStart).setHours(0, 0, 0, 0), endDate = new Date(offer.effectiveEnd).setHours(23, 59, 59, 0);
                                        if (startDate > curDate.setHours(0, 0, 0, 0)) {
                                            return "future";
                                        } else if (startDate <= curDate.setHours(0, 0, 0, 0) && endDate >= curDate.setHours(23, 59, 59, 0)) {
                                            return "current";
                                        } else {
                                            return "past";
                                        }
                                    }
                                }
                            };
                        }
                    },
                    renderResults: renderOffersHTML
                });
                CRUD.get();
            }
        });
    }
    function renderOffersHTML() {
        var types = [ "current", "future", "past" ];
        for (var i = 0; i < types.length; i++) {
            var type = types[i], offers = CRUD.dataSet.getByType(type), offerHTML = "";
            for (var j = 0; j < offers.length; j++) {
                offerHTML += offers[j].html;
            }
            $("#" + type + "-special-offers-container").html(offerHTML).closest(".row").find("h1 small").text("(" + offers.length + ")");
        }
    }
    function refresh() {
        CRUD.renderResults();
    }
    meerkat.modules.register("adminSpecialOffers", {
        init: init,
        refresh: refresh
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    function getBaseUrl() {
        if (meerkat.site && typeof meerkat.site.urls !== "undefined") {
            if (typeof meerkat.site.urls.context !== "undefined") {
                return "/" + meerkat.site.urls.context;
            } else if (typeof meerkat.site.urls.base !== "undefined") {
                return meerkat.site.urls.base;
            }
        }
    }
    meerkat.modules.register("simples", {
        getBaseUrl: getBaseUrl
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var modalId = false, currentTransactionId = false, currentMessage = false, templateComments = false, templatePostpone = false, $actionsDropdown = false, $homeButton = false;
    function init() {
        $(document).ready(function() {
            $homeButton = $("nav .simples-homebutton");
            var $checkHasActionsDropdown = $("[data-provide='simples-quote-actions']");
            if ($checkHasActionsDropdown.length > 0) {
                $checkHasActionsDropdown.each(function() {
                    $actionsDropdown = $(this);
                    $actionsDropdown.on("click", ".action-complete", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionFinish("complete");
                    });
                    $actionsDropdown.on("click", ".action-unsuccessful", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionFinish("unsuccessful");
                    });
                    $actionsDropdown.on("click", ".action-postpone", function(event) {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionPostpone(false, "postpone");
                    });
                    $actionsDropdown.on("click", ".action-comment", function(event) {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionComments();
                    });
                    $actionsDropdown.on("click", ".action-remove-pm", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionFinish("remove_pm");
                    });
                    $actionsDropdown.on("click", ".action-complete-pm", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionPostpone(true, "complete_pm");
                    });
                    $actionsDropdown.on("click", ".action-change-time", function() {
                        if ($(this).parent("li").hasClass("disabled")) return false;
                        actionPostpone(true, "change_time");
                    });
                });
                meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
                    currentTransactionId = obj || false;
                    updateMenu();
                });
                meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
                    currentMessage = obj || false;
                    if (currentMessage.hasOwnProperty("transaction")) {
                        currentTransactionId = currentMessage.transaction.transactionId;
                    }
                    updateMenu();
                });
                $e = $("#simples-template-comments");
                if ($e.length > 0) {
                    templateComments = _.template($e.html());
                }
                $e = $("#simples-template-postpone");
                if ($e.length > 0) {
                    templatePostpone = _.template($e.html());
                }
            }
        });
    }
    function updateMenu() {
        var showMenu = false;
        var $tranId = $actionsDropdown.find(".simples-show-transactionid");
        var $msgId = $actionsDropdown.find(".simples-show-messageid");
        var $actionCompleteParent = $actionsDropdown.find(".action-complete").parent("li");
        var $actionUnsuccessfulParent = $actionsDropdown.find(".action-unsuccessful").parent("li");
        var $actionPostponeParent = $actionsDropdown.find(".action-postpone").parent("li");
        var $actionCommentParent = $actionsDropdown.find(".action-comment").parent("li");
        var $actionCompletePmParent = $actionsDropdown.find(".action-complete-pm").parent("li");
        var $actionChangeTimeParent = $actionsDropdown.find(".action-change-time").parent("li");
        var $actionRemovePmParent = $actionsDropdown.find(".action-remove-pm").parent("li");
        if (currentTransactionId !== false) {
            showMenu = true;
            $tranId.text(currentTransactionId);
            $actionCommentParent.removeClass("disabled");
        } else {
            showMenu = false;
            $tranId.text("None");
            $actionCommentParent.addClass("disabled");
        }
        if (currentMessage === false || isNaN(currentMessage.message.messageId)) {
            if (showMenu === false) showMenu = false;
            $msgId.text("None");
            $actionCompleteParent.addClass("disabled");
            $actionUnsuccessfulParent.addClass("disabled");
            $actionPostponeParent.addClass("disabled");
            $actionCompletePmParent.addClass("disabled");
            $actionChangeTimeParent.addClass("disabled");
            $actionRemovePmParent.addClass("disabled");
        } else {
            showMenu = true;
            $msgId.text(currentMessage.message.messageId);
            $actionCompleteParent.removeClass("disabled");
            $actionUnsuccessfulParent.removeClass("disabled");
            $actionRemovePmParent.removeClass("disabled");
            if (currentMessage.message.hasOwnProperty("canPostpone") && currentMessage.message.canPostpone === true) {
                $actionPostponeParent.removeClass("disabled");
                $actionCompletePmParent.removeClass("disabled");
                $actionChangeTimeParent.removeClass("disabled");
            } else {
                $actionPostponeParent.addClass("disabled");
                $actionCompletePmParent.addClass("disabled");
                $actionChangeTimeParent.addClass("disabled");
            }
            if (isCompletedAsPM()) {
                $actionRemovePmParent.show();
                $actionChangeTimeParent.show();
                $actionCompleteParent.hide();
                $actionCompletePmParent.hide();
                $actionPostponeParent.hide();
                $actionUnsuccessfulParent.hide();
            } else {
                $actionRemovePmParent.hide();
                $actionChangeTimeParent.hide();
                $actionCompleteParent.show();
                $actionCompletePmParent.show();
                $actionPostponeParent.show();
                $actionUnsuccessfulParent.show();
            }
        }
        if (showMenu) {
            $actionsDropdown.removeClass("hidden");
        } else {
            $actionsDropdown.addClass("hidden");
        }
    }
    function actionFinish(type) {
        if (!type) return;
        var parentStatusId = 0;
        if (type === "complete") {
            parentStatusId = 2;
        } else if (type === "unsuccessful") {
            parentStatusId = 6;
        } else if (type === "remove_pm") {
            parentStatusId = 33;
            type = "complete";
        }
        var isFailJoin = false;
        if (currentMessage.message.sourceId === 5 || currentMessage.message.sourceId === 8) {
            isFailJoin = true;
        }
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            url: "simples/ajax/message_statuses.html.jsp?parentStatusId=" + parentStatusId + "&isFailJoin=" + isFailJoin,
            buttons: [ {
                label: "Cancel",
                className: "btn-cancel",
                closeWindow: true
            }, {
                label: "OK",
                className: "btn-cta message-savebutton",
                closeWindow: false
            } ],
            onOpen: function(id) {
                modalId = id;
                var $button = $("#" + modalId).find(".message-savebutton");
                $button.prop("disabled", true);
            },
            onLoad: function() {
                var $modal = $("#" + modalId);
                var $button = $modal.find(".message-savebutton");
                $modal.find("input[type=radio]").on("change", function() {
                    $button.prop("disabled", false);
                });
                $button.on("click", function loadClick() {
                    $button.prop("disabled", true);
                    meerkat.modules.loadingAnimation.showInside($button, true);
                    var statusId = $modal.find("input[type=radio]:checked").val();
                    meerkat.modules.simplesMessage.performFinish(type, {
                        statusId: parentStatusId,
                        reasonStatusId: statusId
                    }, function performCallback() {
                        if ($homeButton.length > 0) $homeButton[0].click();
                        meerkat.modules.dialogs.close(modalId);
                    });
                });
            }
        });
    }
    function actionPostpone(assignToUser, type) {
        if (!type) return;
        var parentStatusId = 0;
        var heading = "";
        if (type === "postpone") {
            parentStatusId = 4;
            heading = "Postpone this message";
        } else if (type === "complete_pm") {
            parentStatusId = 31;
            heading = "Complete as PM";
        } else if (type === "change_time") {
            parentStatusId = 32;
            heading = "Change Time";
        }
        heading = encodeURIComponent(heading);
        meerkat.modules.dialogs.show({
            title: " ",
            className: _.indexOf([ 31, 32 ], parentStatusId) >= 0 ? "simples-messagescolumn-dialog" : "simples-postpone-dialog",
            buttons: [ {
                label: "Cancel",
                className: "btn-cancel",
                closeWindow: true
            }, {
                label: "Postpone",
                className: "btn-save btn-cta message-savebutton",
                closeWindow: false
            } ],
            onOpen: function postponeModalOpen(id) {
                modalId = id;
                var $modal = $("#" + modalId);
                var $button = $modal.find(".message-savebutton");
                $button.prop("disabled", true);
                meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
                meerkat.modules.comms.get({
                    url: "simples/ajax/message_statuses.json.jsp?parentStatusId=" + parentStatusId + "&heading=" + heading,
                    dataType: "json",
                    cache: true,
                    errorLevel: "silent"
                }).done(function onSuccess(json) {
                    json.parentStatusId = parentStatusId;
                    updateModal(json, templatePostpone);
                }).fail(function onError(obj, txt, errorThrown) {
                    updateModal(null, templatePostpone);
                }).always(function onComplete() {
                    $button.prop("disabled", false);
                    $("#postponehour").val("04");
                    var getDateFormat = function(dateObj) {
                        return dateObj.getFullYear() + "-" + ("0" + (dateObj.getMonth() + 1)).slice(-2) + "-" + ("0" + dateObj.getDate()).slice(-2);
                    };
                    var currentDate = new Date();
                    var today = getDateFormat(currentDate);
                    currentDate.setMonth(currentDate.getMonth() + 6);
                    var future = getDateFormat(currentDate);
                    var $picker = $modal.find("#postponedate_calendar");
                    $picker.datepicker({
                        startDate: today,
                        endDate: future,
                        clearBtn: false,
                        format: "yyyy-mm-dd"
                    }).find("table").addClass("table");
                    $modal.on("changeDate", $picker, function picker(e) {
                        $modal.find("#postponedate").val(e.format("yyyy-mm-dd"));
                    });
                    $button.on("click", function saveClick() {
                        $button.prop("disabled", true);
                        meerkat.modules.loadingAnimation.showInside($button, true);
                        var data = {
                            postponeDate: $modal.find("#postponedate").val(),
                            postponeTime: $modal.find("#postponehour").val() + ":" + $modal.find("#postponeminute").val(),
                            postponeAMPM: $modal.find('input[name="postponeampm"]:checked').val(),
                            statusId: parentStatusId,
                            reasonStatusId: $modal.find('select[name="reason"]').val(),
                            comment: $modal.find("textarea").val(),
                            assignToUser: assignToUser
                        };
                        if (!_.isString(data.postponeDate) || data.postponeDate.length === 0 || (!_.isString(data.postponeAMPM) || data.postponeAMPM.length === 0)) {
                            meerkat.modules.dialogs.show({
                                title: " ",
                                htmlContent: "Please check fields: date, time and AM/PM.",
                                buttons: [ {
                                    label: "OK",
                                    className: "btn-cta",
                                    closeWindow: true
                                } ]
                            });
                            $button.prop("disabled", false);
                            meerkat.modules.loadingAnimation.hide($button);
                            return;
                        }
                        meerkat.modules.simplesMessage.performFinish("postpone", data, function performCallback() {
                            if ($homeButton.length > 0) $homeButton[0].click();
                            meerkat.modules.dialogs.close(modalId);
                        }, function callbackError() {
                            $button.prop("disabled", false);
                            meerkat.modules.loadingAnimation.hide($button);
                        });
                    });
                    var $messages = $modal.find(".personal-messages-container");
                    $messages.empty();
                    meerkat.modules.simplesPostponedQueue.initDateStuff();
                    var messages = document.getElementById("simplesiframe").contentWindow.meerkat.modules.simplesPostponedQueue.getMessageQueue();
                    if (!_.isEmpty(messages)) {
                        for (var i = 0; i < messages.length; i++) {
                            $messages.append($("<span/>").addClass("well").append($("<strong/>").append(messages[i].contactName)).append(":&nbsp;" + formatWhenToAction(messages[i].whenToAction)));
                        }
                    }
                });
            }
        });
    }
    function actionComments() {
        openModal(function() {
            meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
        });
        meerkat.modules.comms.get({
            url: "simples/comments/list.json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: currentTransactionId
            },
            onSuccess: function onSuccess(json) {
                updateModal(json, templateComments);
            },
            onError: function onError(obj, txt, errorThrown) {
                var json = {
                    errors: [ {
                        message: txt + ": " + errorThrown
                    } ]
                };
                updateModal(json, templateComments);
            }
        });
    }
    function openModal(callbackOpen) {
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                if (typeof callbackOpen === "function") {
                    callbackOpen();
                }
            }
        });
    }
    function updateModal(data, template) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof template === "function") {
            htmlContent = template(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    function isCompletedAsPM() {
        if (currentMessage.hasOwnProperty("messageaudits")) {
            for (var i = 0; i < currentMessage.messageaudits.length; i++) {
                var auditObj = currentMessage.messageaudits[i];
                if (auditObj.hasOwnProperty("statusId") && auditObj.statusId === 31) {
                    return true;
                }
            }
        }
        return false;
    }
    function formatWhenToAction(dateStr) {
        var whenToAction = Date.parse(dateStr) || false;
        if (whenToAction !== false) {
            whenToAction = new Date(whenToAction);
            var ampm = "am";
            var hours = whenToAction.getHours();
            if (hours < 10) {
                hours = "0" + hours;
            } else if (hours == 12) {
                ampm = "pm";
            } else if (hours > 12) {
                ampm = "pm";
                hours -= 12;
            }
            var minutes = whenToAction.getMinutes() < 10 ? "0" + whenToAction.getMinutes() : whenToAction.getMinutes();
            return whenToAction.getDayNameShort() + " " + whenToAction.getDate() + " " + whenToAction.getMonthNameShort() + " " + hours + ":" + minutes + ampm;
        } else {
            return dateStr;
        }
    }
    meerkat.modules.register("simplesActions", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var modalId = false, templateBlackList = false, action = false, $targetForm = false;
    function init() {
        $(document).ready(function() {
            $('[data-provide="simples-blacklist-action"]').on("click", "a", function(event) {
                event.preventDefault();
                action = $(this).data("action");
                var $e = $("#simples-template-blacklist-" + action);
                if ($e.length > 0) {
                    templateBlackList = _.template($e.html());
                }
                openModal();
            });
            $("#dynamic_dom").on("click", '[data-provide="simples-blacklist-submit"]', function(event) {
                event.preventDefault();
                performSubmit();
            });
        });
    }
    function openModal() {
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                updateModal();
            },
            onClose: function() {}
        });
    }
    function updateModal(data) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof templateBlackList === "function") {
            if (data.errorMessage && data.errorMessage.length > 0) {}
            htmlContent = templateBlackList(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent);
    }
    function performSubmit() {
        $targetForm = $("#simples-" + action + "-blacklist");
        if (validateForm()) {
            var formData = {
                action: action,
                value: $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, ""),
                channel: $targetForm.find('select[name="channel"]').val().trim(),
                comment: $targetForm.find('textarea[name="comment"]').val().trim()
            };
            meerkat.modules.comms.post({
                url: "simples/ajax/blacklist_action.jsp",
                dataType: "json",
                cache: false,
                errorLevel: "silent",
                timeout: 5e3,
                data: formData,
                onSuccess: function onSuccess(json) {
                    updateModal(json);
                },
                onError: function onError(obj, txt, errorThrown) {
                    updateModal({
                        errorMessage: txt + ": " + errorThrown
                    });
                }
            });
        }
    }
    function validateForm() {
        if ($targetForm === false) return false;
        var phoneNumber = $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, "");
        console.log(phoneNumber);
        var channel = $targetForm.find('select[name="channel"]').val().trim();
        var comment = $targetForm.find('textarea[name="comment"]').val().trim();
        var $error = $targetForm.find(".form-error");
        if (phoneNumber === "" || !isValidPhoneNumber(phoneNumber)) {
            $error.text("Please enter a valid phone number.");
            return false;
        }
        if (channel === "" || channel !== "phone" && channel !== "sms") {
            $error.text("Channel has to be either [Phone] or [SMS].");
            return false;
        }
        if (comment === "") {
            $error.text("Comment length can not be zero.");
            return false;
        }
        $error.text("");
        return true;
    }
    function isValidPhoneNumber(phone) {
        if (phone.length === 0) return true;
        var valid = true;
        var strippedValue = phone.replace(/[^0-9]/g, "");
        if (strippedValue.length === 0 && phone.length > 0) {
            return false;
        }
        var phoneRegex = new RegExp("^(0[234785]{1}[0-9]{8})$");
        valid = phoneRegex.test(strippedValue);
        return valid;
    }
    meerkat.modules.register("simplesBlackList", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var events = {
        simplesInterface: {
            TRANSACTION_ID_CHANGE: "TRANSACTION_ID_CHANGE"
        }
    }, moduleEvents = events.simplesInterface;
    var $iframe = $("#simplesiframe");
    function resizeIframe() {
        if ($iframe.length === 0) return;
        var buffer = 8;
        var height = window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
        height -= $iframe.position().top + buffer;
        height = height < 50 ? 50 : height;
        $iframe.height(height);
    }
    function receiveMessage(event) {
        try {
            if (event.data.eventType === "transactionId") {
                meerkat.messaging.publish(moduleEvents.TRANSACTION_ID_CHANGE, event.data.transactionId);
            }
        } catch (e) {
            log("Error receiving postMessage", e);
        }
    }
    function init() {
        $(document).ready(resizeIframe);
        $(window).resize(_.debounce(resizeIframe));
        if (window.addEventListener) {
            window.addEventListener("message", receiveMessage, false);
        }
    }
    meerkat.modules.register("simplesInterface", {
        init: init,
        events: events
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var $iframe = $("#simplesiframe");
    var baseUrl = "";
    function init() {
        $(document).ready(function() {
            baseUrl = meerkat.modules.simples.getBaseUrl();
            $(document.body).on("click", ".needs-loadsafe", function loadsafeClick(event) {
                event.preventDefault();
                var $this = $(this);
                var addBaseUrlToHref = false;
                if ($this.parent().parent().hasClass("dropdown")) {
                    $this.parent().parent().find(".dropdown-toggle").dropdown("toggle");
                }
                if ($this.hasClass("needs-baseurl")) addBaseUrlToHref = true;
                loadsafe($this.attr("href"), addBaseUrlToHref);
            });
        });
    }
    function loadsafe(href, addBaseUrlToHref) {
        if (!href || href.length === 0) return;
        addBaseUrlToHref = addBaseUrlToHref || false;
        href += href.indexOf("?") >= 0 ? "&" : "?";
        href += "ts=" + new Date().getTime();
        if (addBaseUrlToHref === true) {
            href = baseUrl + href;
        }
        var loadingUrl = baseUrl + "simples/loading.jsp?url=" + encodeURIComponent(href);
        if ($iframe.length > 0) {
            $iframe.attr("src", loadingUrl);
        } else {
            window.location = loadingUrl;
        }
    }
    meerkat.modules.register("simplesLoadsafe", {
        init: init,
        loadsafe: loadsafe
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var events = {
        simplesMessage: {
            MESSAGE_CHANGE: "MESSAGE_CHANGE"
        }
    }, moduleEvents = events.simplesMessage;
    var templateMessageDetail = false, currentMessage = false, $messageDetailsContainer, baseUrl = "";
    function init() {
        $(document).ready(function() {
            baseUrl = meerkat.modules.simples.getBaseUrl();
            $e = $("#simples-template-messagedetail");
            if ($e.length > 0) {
                templateMessageDetail = _.template($e.html());
            }
            $(".simples-menubar .simples-homebutton").on("click.simplesMessage", function clickHome(event) {
                setCurrentMessage(false);
                meerkat.messaging.publish(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, false);
            });
            var $checkSimplesHome = $(".simples-home");
            if ($checkSimplesHome.length > 0) {
                $(".message-getnext").on("click.simplesMessage", function clickNext(event) {
                    event.preventDefault();
                    var $button = $(event.target);
                    if ($button.prop("disabled") === true) {
                        return;
                    }
                    $button.prop("disabled", true).addClass("disabled");
                    $messageDetailsContainer.empty();
                    meerkat.modules.loadingAnimation.showInside($messageDetailsContainer);
                    getNextMessage(function nextComplete() {
                        $button.prop("disabled", false).removeClass("disabled");
                    });
                });
            }
            $messageDetailsContainer = $(".simples-message-details-container");
            var messageId = 0;
            if ($messageDetailsContainer.length > 0) {
                renderMessageDetails(false, $messageDetailsContainer);
                meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
                    renderMessageDetails(obj, $messageDetailsContainer);
                    messageId = obj.message.messageId;
                });
                $messageDetailsContainer.on("click", ".messagedetail-loadbutton", loadMessage);
                $messageDetailsContainer.on("click", "button[data-phone]", makeCall);
            }
        });
    }
    function makeCall(event) {
        event.preventDefault();
        var button = $(this);
        var phone = button.attr("data-phone");
        meerkat.modules.loadingAnimation.showAfter(button);
        meerkat.modules.comms.get({
            url: baseUrl + "simples/phones/call?phone=" + phone,
            cache: false,
            errorLevel: "warning",
            onComplete: function() {
                meerkat.modules.loadingAnimation.hide(button);
            }
        });
    }
    function loadMessage(event) {
        event.preventDefault();
        if (currentMessage === false || !currentMessage.hasOwnProperty("message")) {
            alert("Message details have not been stored correctly - can not load.");
            return;
        }
        var $button = $(event.target);
        $button.prop("disabled", true).addClass("disabled");
        meerkat.modules.loadingAnimation.showAfter($button);
        meerkat.modules.comms.post({
            url: baseUrl + "simples/ajax/message_set_inprogress.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                messageId: currentMessage.message.messageId
            },
            onSuccess: function onSuccess(json) {
                if (json.hasOwnProperty("errors") && json.errors.length > 0) {
                    alert("Could not set message to In Progress...\n" + json.errors[0].message);
                    $button.prop("disabled", false).removeClass("disabled");
                    meerkat.modules.loadingAnimation.hide($button);
                    return;
                }
                var url = "simples/loadQuote.jsp?brandId=" + currentMessage.transaction.styleCodeId + "&verticalCode=" + currentMessage.transaction.verticalCode + "&transactionId=" + encodeURI(currentMessage.transaction.newestTransactionId) + "&action=amend";
                log(url);
                meerkat.modules.simplesLoadsafe.loadsafe(url, true);
            },
            onError: function onError(obj, txt, errorThrown) {
                alert("Could not set message to In Progress...\n" + txt + ": " + errorThrown);
                $button.prop("disabled", false).removeClass("disabled");
                meerkat.modules.loadingAnimation.hide($button);
            }
        });
    }
    function isMobile(value) {
        var phoneRegex = new RegExp("^(0[45]{1}[0-9]{8})$");
        return phoneRegex.test(value);
    }
    function getNextMessage(callbackComplete) {
        meerkat.modules.comms.get({
            url: baseUrl + "simples/messages/next.json",
            cache: false,
            errorLevel: "silent"
        }).done(function onSuccess(json) {
            if (!json.hasOwnProperty("message") || !json.message.hasOwnProperty("messageId") || json.message.messageId === 0) {
                $messageDetailsContainer.html(templateMessageDetail(json));
            } else {
                setCurrentMessage(json);
            }
        }).fail(function onError(obj, txt, errorThrown) {
            var json = {
                errors: [ {
                    message: txt + ": " + errorThrown
                } ]
            };
            $messageDetailsContainer.html(templateMessageDetail(json));
        }).always(function onComplete() {
            if (typeof callbackComplete === "function") {
                callbackComplete();
            }
        });
    }
    function performFinish(type, data, callbackSuccess, callbackError) {
        if (!type) return;
        if (currentMessage === false || !currentMessage.hasOwnProperty("message")) {
            alert("Message details have not been stored correctly - can not load.");
            return;
        }
        if (currentMessage.message.messageId === false || isNaN(currentMessage.message.messageId)) {
            alert("No Message ID is currently known, so can not set as complete.");
            return;
        }
        data = data || {};
        data.messageId = currentMessage.message.messageId;
        meerkat.modules.comms.post({
            url: baseUrl + "simples/ajax/message_set_" + type + ".jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: data,
            onSuccess: function onSuccess(json) {
                if (json.hasOwnProperty("errors") && json.errors.length > 0) {
                    alert("Could not set to " + type + "...\n" + json.errors[0].message);
                    if (typeof callbackError === "function") callbackError();
                    return;
                }
                setCurrentMessage(false);
                if (typeof callbackSuccess === "function") callbackSuccess();
            },
            onError: function onError(obj, txt, errorThrown) {
                alert("Could not set to " + type + "...\n" + txt + ": " + errorThrown);
                if (typeof callbackError === "function") callbackError();
            }
        });
    }
    function getCurrentMessage() {
        return currentMessage;
    }
    function setCurrentMessage(message) {
        if (window.self !== window.top) {
            window.top.meerkat.modules.simplesMessage.setCurrentMessage(message);
        }
        currentMessage = message;
        meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, currentMessage);
    }
    function renderMessageDetails(message, $destination) {
        $destination = $destination || false;
        if ($destination === false || $destination.length === 0) return;
        if (message === false) {
            $(".simples-home-buttons, .simples-notice-board").removeClass("hidden");
        } else {
            $(".simples-home-buttons, .simples-notice-board").addClass("hidden");
            if (isMobile(message.message.phoneNumber2) && !isMobile(message.message.phoneNumber1)) {
                var x = message.message.phoneNumber1;
                message.message.phoneNumber1 = message.message.phoneNumber2;
                message.message.phoneNumber2 = x;
            }
        }
        $destination.html(templateMessageDetail(message));
    }
    meerkat.modules.register("simplesMessage", {
        init: init,
        events: events,
        getNextMessage: getNextMessage,
        getCurrentMessage: getCurrentMessage,
        setCurrentMessage: setCurrentMessage,
        performFinish: performFinish,
        renderMessageDetails: renderMessageDetails
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var templatePQ = false, $container = false, baseUrl = "", viewMessageInProgress = false, currentMessageQueue = [];
    function init() {
        $(document).ready(function() {
            $container = $(".simples-postpone-queue-container");
            if ($container.length === 0) return;
            baseUrl = meerkat.modules.simples.getBaseUrl();
            initDateStuff();
            var $e = $("#simples-template-postponed-queue");
            if ($e.length > 0) {
                templatePQ = _.template($e.html());
            }
            $container.on("click.viewMessage", ".simples-postponed-message", viewMessage);
            meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
                var $messages = $container.find(".simples-postponed-message");
                $messages.removeClass("active");
                if (obj !== false) {
                    $messages.filter('[data-messageId="' + obj.message.messageId + '"]').addClass("active");
                }
            });
            refresh();
        });
    }
    function initDateStuff() {
        Date.locale = {
            month_names: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ],
            month_names_short: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
            day_of_week: [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ],
            day_of_week_short: [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
        };
        Date.prototype.getMonthName = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.month_names[this.getUTCMonth()];
            } else {
                return Date.locale.month_names[this.getMonth()];
            }
        };
        Date.prototype.getMonthNameShort = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.month_names_short[this.getUTCMonth()];
            } else {
                return Date.locale.month_names_short[this.getMonth()];
            }
        };
        Date.prototype.getDayName = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.day_of_week[this.getUTCDay()];
            } else {
                return Date.locale.day_of_week[this.getDay()];
            }
        };
        Date.prototype.getDayNameShort = function(asUTC) {
            if (asUTC === true) {
                return Date.locale.day_of_week_short[this.getUTCDay()];
            } else {
                return Date.locale.day_of_week_short[this.getDay()];
            }
        };
    }
    function viewMessage(event) {
        event.preventDefault();
        var $element = $(event.target);
        if (!$element.hasClass("simples-postponed-message")) {
            $element = $element.parents(".simples-postponed-message");
        }
        if (viewMessageInProgress === true || $element.hasClass("disabled") || $element.hasClass("active")) {
            return;
        }
        var messageId = $element.attr("data-messageId");
        viewMessageInProgress = true;
        meerkat.modules.loadingAnimation.showInside($element);
        $element.addClass("disabled");
        meerkat.modules.comms.get({
            url: baseUrl + "simples/messages/get.json?messageId=" + encodeURI(messageId),
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        }).done(function onSuccess(json) {
            if (!json.hasOwnProperty("message") || !json.message.hasOwnProperty("messageId")) {
                alert("Failed to load message: invalid response");
            } else {
                meerkat.modules.simplesMessage.setCurrentMessage(json);
            }
        }).fail(function onError(obj, txt, errorThrown) {
            if (obj.hasOwnProperty("responseJSON") && obj.responseJSON.hasOwnProperty("errors") && obj.responseJSON.errors.length > 0) {
                alert("Failed to load message\n" + obj.responseJSON.errors[0].message);
            } else {
                alert("Unsuccessful because: " + txt + ": " + errorThrown);
            }
        }).always(function onComplete() {
            viewMessageInProgress = false;
            meerkat.modules.loadingAnimation.hide($element);
            $element.removeClass("disabled");
        });
    }
    function refresh() {
        if ($container === false || $container.length === 0) return;
        $container.html("Fetching postponed queue...");
        meerkat.modules.comms.get({
            url: baseUrl + "simples/messages/postponed.json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        }).done(function onSuccess(json) {
            var htmlContent = "";
            if (typeof templatePQ !== "function") {
                htmlContent = "Unsuccessful because: template not configured.";
            } else {
                setMessageQueue(json);
                htmlContent = templatePQ(json);
            }
            $container.html(htmlContent);
        }).fail(function onError(obj, txt, errorThrown) {
            $container.html("Unsuccessful because: " + txt + ": " + errorThrown);
        });
    }
    function setMessageQueue(json) {
        currentMessageQueue = [];
        if (_.isObject(json) && json.hasOwnProperty("messages") && _.isArray(json.messages) && json.messages.length > 0) {
            for (var i = 0; i < json.messages.length; i++) {
                currentMessageQueue.push({
                    contactName: json.messages[i].contactName,
                    whenToAction: json.messages[i].whenToAction
                });
            }
        }
    }
    function getMessageQueue() {
        return currentMessageQueue;
    }
    meerkat.modules.register("simplesPostponedQueue", {
        init: init,
        initDateStuff: initDateStuff,
        getMessageQueue: getMessageQueue
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var modalId = false, searchTerm = false, templateQuoteDetails = false;
    function init() {
        $(document).ready(function() {
            $('[data-provide="simples-quote-finder"]').on("click", "a", function(event) {
                event.preventDefault();
                launch();
            });
            $("#dynamic_dom").on("submit", "form.simples-search-quotedetails", function searchModalSubmit(event) {
                event.preventDefault();
                searchTerm = $(this).find(":input[name=keywords]").val();
                performSearch();
            });
            var $e = $("#simples-template-quotedetails");
            if ($e.length > 0) {
                templateQuoteDetails = _.template($e.html());
            }
        });
    }
    function launch() {
        modalId = meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                performSearch();
            },
            onClose: function() {}
        });
    }
    function performSearch() {
        updateModal();
        if (searchTerm === false || searchTerm === "") return;
        var validatedData = validateSearch(searchTerm);
        if (validatedData.valid === false) {
            validatedData.errorMessage = "The search term is not valid. Must be valid email or transaction ID";
            updateModal(validatedData);
            return;
        }
        meerkat.modules.comms.post({
            url: "simples/ajax/quote_finder.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false,
            data: validatedData,
            onSuccess: function onSearchSuccess(json) {
                var data = {};
                if (typeof window.InspectorJSON === "undefined") {
                    data.errorMessage = "InspectorJSON plugin is not available.";
                } else if (json.hasOwnProperty("findQuotes") && json.findQuotes.hasOwnProperty("quotes")) {
                    data.results = json.findQuotes.quotes;
                    if (!_.isArray(data.results)) {
                        data.results = [ json.findQuotes.quotes ];
                    }
                }
                updateModal(data);
                if (data.hasOwnProperty("errorMessage") === false) {
                    jsonViewer(data.results);
                }
            },
            onError: function onError(obj, txt, errorThrown) {
                updateModal({
                    errorMessage: txt + ": " + errorThrown
                });
            }
        });
    }
    function jsonViewer(results) {
        var obj = {};
        var id;
        for (var i in results) {
            if (results[i].hasOwnProperty("quote")) {
                id = results[i].id + " - Car";
                obj[id] = {};
                obj[id] = results[i].quote;
            } else if (results[i].hasOwnProperty("health")) {
                id = results[i].id + " - Health";
                obj[id] = {};
                obj[id] = results[i].health;
            } else if (results[i].hasOwnProperty("ip")) {
                id = results[i].id + " - IP";
                obj[id] = {};
                obj[id] = results[i].ip;
            } else if (results[i].hasOwnProperty("life")) {
                id = results[i].id + " - Life";
                obj[id] = {};
                obj[id] = results[i].life;
            } else if (results[i].hasOwnProperty("travel")) {
                id = results[i].id + " - Travel";
                obj[id] = {};
                obj[id] = results[i].travel;
            } else if (results[i].hasOwnProperty("utilities")) {
                id = results[i].id + " - Utilities";
                obj[id] = {};
                obj[id] = results[i].utilities;
            } else if (results[i].hasOwnProperty("home")) {
                id = results[i].id + " - Home & Contents";
                obj[id] = {};
                obj[id] = results[i].home;
            } else if (results[i].hasOwnProperty("homeloan")) {
                id = results[i].id + " - Home Loan";
                obj[id] = {};
                obj[id] = results[i].homeloan;
            } else {
                id = results[i].id + " - Unhandled vertical";
                obj[id] = {};
            }
        }
        if (typeof viewer === "object" && viewer instanceof InspectorJSON) {
            viewer.destroy();
        }
        viewer = new InspectorJSON({
            element: $("#quote-details-container")[0],
            collapsed: true,
            debug: false,
            json: obj
        });
    }
    function updateModal(data) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof templateQuoteDetails === "function") {
            data.results = data.results || "";
            data.keywords = data.keywords || searchTerm || "";
            if (data.errorMessage && data.errorMessage.length > 0) {} else if (data.keywords === "") {
                data.errorMessage = "Please enter something to search for.";
            } else if (data.results === "") {
                data.results = meerkat.modules.loadingAnimation.getTemplate();
            }
            htmlContent = templateQuoteDetails(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {
            $("#" + modalId + " .modal-header").empty().prepend($("#" + modalId + " #simples-search-modal-header"));
        });
    }
    function validateSearch(term) {
        var result = {
            valid: false,
            term: $.trim(term),
            type: false
        };
        if (term.length > 0) {
            if (isTransactionId(term)) {
                result = $.extend(result, {
                    valid: true,
                    type: "transactionid"
                });
            } else if (isValidEmailAddress(term)) {
                result = $.extend(result, {
                    valid: true,
                    type: "email"
                });
            }
        }
        return result;
    }
    function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
        return pattern.test(emailAddress);
    }
    function isTransactionId(tranId) {
        try {
            var test = parseInt(String(tranId), 10);
            return !isNaN(test);
        } catch (e) {
            return false;
        }
    }
    meerkat.modules.register("simplesQuoteFinder", {
        init: init
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var moduleEvents = {};
    var modalId = false, templateSearch = false, templateMoreInfo = false, templateComments = false, searchResults = false, searchTerm = "";
    function init() {
        $(document).ready(function() {
            eventDelegates();
            var $e = $("#simples-template-search");
            if ($e.length > 0) {
                templateSearch = _.template($e.html());
            }
            $e = $("#simples-template-moreinfo");
            if ($e.length > 0) {
                templateMoreInfo = _.template($e.html());
            }
            $e = $("#simples-template-comments");
            if ($e.length > 0) {
                templateComments = _.template($e.html());
            }
        });
    }
    function eventDelegates() {
        $("#simples-search-navbar").on("submit", function navbarSearchSubmit(event) {
            event.preventDefault();
            searchTerm = $(this).find(":input[name=keywords]").val();
            openModal();
        });
        $("#dynamic_dom").on("submit", "form.simples-search", function searchModalSubmit(event) {
            event.preventDefault();
            searchTerm = $(this).find(":input[name=keywords]").val();
            performSearch();
        });
        $("#dynamic_dom").on("click", ".search-quotes-results .btn[data-action]", searchModalResultButton);
        $("#dynamic_dom").on("click", ".comment-hideshow", function showAddComment(event) {
            event.preventDefault();
            var $this = $(this);
            $this.addClass("hidden");
            $this.siblings(".comment-inputfields").slideToggle(200);
        });
        $("#dynamic_dom").on("click", ".comment-addcomment", clickAddComment);
    }
    function searchModalResultButton(event) {
        event.preventDefault();
        var $button = $(this), action = $button.attr("data-action"), $resultRow = $button.parents(".search-quotes-result-row"), transactionId;
        if ("amend" === action) {
            transactionId = $resultRow.attr("data-id");
            var vertical = $resultRow.attr("data-vertical");
            _.defer(function closeModal() {
                meerkat.modules.dialogs.close(modalId);
            });
        } else if ("moreinfo" === action) {
            if ($resultRow.hasClass("open")) {
                $resultRow.removeClass("open");
                $button.text($button.attr("data-originaltext"));
                $resultRow.find("div.moreinfo-container").slideUp(200);
            } else {
                $resultRow.addClass("open");
                $button.attr("data-originaltext", $button.text());
                $button.text("Less details");
                $resultRow.parent().children().not(".open").removeClass("bg-success");
                $resultRow.addClass("bg-success");
                $resultRow.find("div.moreinfo-container").remove();
                $resultRow.append('<div class="moreinfo-container"></div>');
                var $container = $resultRow.find("div.moreinfo-container");
                transactionId = $resultRow.attr("data-id");
                var resultIndex = $resultRow.attr("data-index");
                var resultData = searchResults[resultIndex] || false;
                fetchMoreInfo(transactionId, $container, resultData);
            }
        }
    }
    function fetchMoreInfo(transactionId, $container, extraData) {
        if (typeof transactionId == "undefined" || transactionId.length === 0) {
            $container.html("Could not get more info: transaction ID not known");
            return;
        }
        extraData = extraData || {};
        $container.html(meerkat.modules.loadingAnimation.getTemplate());
        $container.slideDown(200);
        meerkat.modules.comms.get({
            url: "simples/transactions/details.json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: transactionId
            },
            onSuccess: function onSearchSuccess(json) {
                var htmlContent = "";
                if (typeof templateMoreInfo !== "function") {
                    htmlContent = "Could not get more info: template not configured.";
                } else {
                    $.extend(true, json, extraData);
                    htmlContent = templateMoreInfo(json);
                }
                $container.html(htmlContent);
            },
            onError: function onError(obj, txt, errorThrown) {
                $container.html("Could not get more info: " + txt + " " + errorThrown);
            }
        });
    }
    function performSearch() {
        searchResults = false;
        updateModal();
        if (searchTerm === false || searchTerm === "") return;
        $("#simples-search-navbar").find(":input[name=keywords]").val(searchTerm);
        meerkat.modules.comms.post({
            url: "simples/ajax/search_quotes.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false,
            data: {
                simples: true,
                search_terms: searchTerm
            },
            onSuccess: function onSearchSuccess(json) {
                var data = {};
                if (json.hasOwnProperty("search_results") && json.search_results.hasOwnProperty("quote")) {
                    data.results = json.search_results.quote;
                    if (!_.isArray(data.results)) {
                        data.results = [ json.search_results.quote ];
                    }
                    searchResults = data.results;
                }
                updateModal(data);
            },
            onError: function onError(obj, txt, errorThrown) {
                updateModal({
                    errorMessage: txt + ": " + errorThrown
                });
            }
        });
    }
    function openModal() {
        meerkat.modules.dialogs.show({
            title: " ",
            fullHeight: true,
            onOpen: function(id) {
                modalId = id;
                performSearch();
            },
            onClose: function() {}
        });
    }
    function updateModal(data) {
        var htmlContent = "No template found.";
        data = data || {};
        if (typeof templateSearch === "function") {
            data.results = data.results || "";
            data.keywords = data.keywords || searchTerm || "";
            if (data.errorMessage && data.errorMessage.length > 0) {} else if (data.keywords === "") {
                data.errorMessage = "Please enter something to search for.";
            } else if (data.results === "") {
                data.results = meerkat.modules.loadingAnimation.getTemplate();
            }
            htmlContent = templateSearch(data);
        }
        meerkat.modules.dialogs.changeContent(modalId, htmlContent, function simplesSearchModalChange() {
            $("#" + modalId + " .modal-header").empty().prepend($("#" + modalId + " #simples-search-modal-header"));
        });
    }
    function clickAddComment(event) {
        event.preventDefault();
        var $resultRow = $(this).parents(".comment-container");
        var transactionId = $resultRow.attr("data-id");
        var $comment = $resultRow.find("textarea");
        var $error = $resultRow.find(".comment-error");
        if (transactionId === undefined || transactionId.length === 0) {
            $error.text("Transaction ID not found or not defined.");
            return;
        }
        if (!$comment.val || $comment.val().length === 0) {
            $error.text("Comment length can not be zero.");
            return;
        }
        var $button = $resultRow.find(".comment-addcomment");
        $button.prop("disabled", true);
        meerkat.modules.loadingAnimation.showInside($button, true);
        $error.text("");
        addComment(transactionId, $comment.val(), function addCommentOk(json) {
            $button.prop("disabled", false);
            meerkat.modules.loadingAnimation.hide($button);
            $comment.val("");
            $resultRow.find(".comment-hideshow").removeClass("hidden");
            $resultRow.find(".comment-inputfields").slideUp(200);
            if (typeof templateComments === "function") {
                $resultRow.html(templateComments(json));
            }
        }, function addCommentErr(obj, txt, errorThrown) {
            $button.prop("disabled", false);
            meerkat.modules.loadingAnimation.hide($button);
            $error.text("Error: " + txt + " " + errorThrown);
        });
    }
    function addComment(transactionId, comment, callbackSuccess, callbackError) {
        if (!transactionId || transactionId.length === 0) {
            alert("transactionId must be defined.");
            return;
        }
        meerkat.modules.comms.post({
            url: "simples/ajax/comment_add_then_get.jsp",
            dataType: "json",
            cache: false,
            errorLevel: "silent",
            data: {
                transactionId: transactionId,
                comment: comment
            },
            onSuccess: function(json) {
                if (json && json.errors && json.errors.length > 0) {
                    if (typeof callbackError === "function") callbackError(json, "", json.errors[0].message);
                } else {
                    if (typeof callbackSuccess === "function") callbackSuccess(json);
                }
            },
            onError: function(obj, txt, errorThrown) {
                if (typeof callbackError === "function") callbackError(obj, txt, errorThrown);
            }
        });
    }
    meerkat.modules.register("simplesSearch", {
        init: init,
        events: moduleEvents
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var currentTransactionId = 0, intervalSeconds = 1500, timer;
    function init() {
        if ($('[data-provide="simples-tickler"]').length === 0) return;
        meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
            if (obj === undefined) {
                currentTransactionId = 0;
            } else {
                currentTransactionId = obj;
            }
        });
        start(intervalSeconds);
    }
    function start(_intervalSeconds) {
        var intervalMs = _intervalSeconds * 1e3;
        clearInterval(timer);
        timer = setInterval(tickle, intervalMs);
        log("Tickler started @ " + _intervalSeconds + " second interval.");
    }
    function stop() {
        clearInterval(timer);
        log("Tickler stopped.");
    }
    function tickle() {
        meerkat.modules.comms.get({
            url: "simples/tickle.json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false,
            timeout: 5e3,
            data: {
                transactionId: currentTransactionId
            },
            onError: function onError(obj, txt, errorThrown) {
                if (obj.status === 401) {
                    alert("Oh bother, it looks like your session is no longer active. Please click OK and log in again.");
                    window.top.location.href = "simples.jsp";
                } else {
                    alert("Something bad happened when trying to keep your session active. If this occurs again please restart your browser.");
                }
            }
        });
    }
    meerkat.modules.register("simplesTickler", {
        init: init,
        start: start,
        stop: stop
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var currentTransactionId = 0, intervalSeconds = 60, timer;
    function init() {
        meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
            if (obj === undefined) {
                currentTransactionId = 0;
            } else {
                currentTransactionId = obj;
            }
        });
        start(intervalSeconds);
    }
    function start(_intervalSeconds) {
        var intervalMs = _intervalSeconds * 1e3;
        clearInterval(timer);
        timer = setInterval(tickle, intervalMs);
        log("Locker started @ " + _intervalSeconds + " second interval.");
    }
    function stop() {
        clearInterval(timer);
        log("Locker stopped.");
    }
    function tickle() {
        if (currentTransactionId > 0) {
            meerkat.modules.comms.get({
                url: "simples/transactions/lock.json",
                cache: false,
                errorLevel: "silent",
                useDefaultErrorHandling: false,
                timeout: 5e3,
                data: {
                    transactionId: currentTransactionId
                },
                onError: function onError(obj, txt, errorThrown) {
                    meerkat.modules.errorHandling.error({
                        page: "simplesTransactionLocker.js",
                        errorLevel: "silent",
                        description: "failed to update lock " + txt,
                        data: errorThrown
                    });
                }
            });
        }
    }
    meerkat.modules.register("simplesTransactionLocker", {
        init: init,
        start: start,
        stop: stop
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat;
    var template = false, $containers = false, intervalSeconds = 60, timer = false, baseUrl = "";
    function init() {
        $(document).ready(function() {
            $containers = $("[data-provide='simples-user-stats']");
            if ($containers.length === 0) return;
            var $e = $("#simples-template-user-stats");
            if ($e.length > 0) {
                template = _.template($e.html());
            }
            baseUrl = meerkat.modules.simples.getBaseUrl();
            refresh();
        });
    }
    function setInterval(seconds) {
        intervalSeconds = seconds;
        if (timer !== false) {
            clearInterval(timer);
        }
        if (intervalSeconds !== false && intervalSeconds > 0) {
            var intervalMs = intervalSeconds * 1e3;
            timer = window.setInterval(refresh, intervalMs);
        }
        return intervalSeconds;
    }
    function refresh() {
        $containers.each(function() {
            var $this = $(this);
            if ($this.find("table").length === 0) {
                $this.hide();
            }
        });
        var deferred = meerkat.modules.comms.get({
            url: baseUrl + "simples/users/stats_today.json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false
        }).done(function onSuccess(json) {
            var htmlContent = "";
            if (typeof template !== "function") {
                htmlContent = "Unsuccessful because: template not configured.";
            } else {
                htmlContent = template(json);
            }
            $containers.each(function() {
                var $this = $(this);
                var slideDown = false;
                if ($this.find("table").length === 0) {
                    slideDown = true;
                }
                $this.html(htmlContent);
                if (slideDown) {
                    $this.slideDown(200);
                }
            });
        }).fail(function onError(obj, txt, errorThrown) {
            $containers.each(function() {
                $(this).html("Unsuccessful because: " + txt + ": " + errorThrown);
            });
        });
        return deferred;
    }
    meerkat.modules.register("simplesUserStats", {
        init: init,
        setInterval: setInterval,
        refresh: refresh
    });
})(jQuery);

(function($, undefined) {
    var meerkat = window.meerkat, log = meerkat.logging.info;
    var $refreshButton = false, templateUsers = false, $container = false, baseUrl = "";
    function init() {
        $(document).ready(function() {
            var $elements = $("[data-provide='simples-consultant-status']");
            if ($elements.length === 0) return;
            baseUrl = meerkat.modules.simples.getBaseUrl();
            $elements.each(function() {
                var $this = $(this);
                $refreshButton = $(".simples-status-refresh");
                $container = $(".simples-status");
                refresh();
            });
            var $e = $("#simples-template-consultantstatus");
            if ($e.length > 0) {
                templateUsers = _.template($e.html());
            }
        });
    }
    function refresh() {
        meerkat.modules.loadingAnimation.showAfter($refreshButton);
        meerkat.modules.comms.get({
            url: baseUrl + "simples/users/list_online.json",
            cache: false,
            errorLevel: "silent",
            useDefaultErrorHandling: false,
            onSuccess: function onSuccess(json) {
                var htmlContent = "";
                if (typeof templateUsers !== "function") {
                    htmlContent = "Unsuccessful because: template not configured.";
                } else {
                    htmlContent = templateUsers(json);
                }
                $container.html(htmlContent);
            },
            onError: function onError(obj, txt, errorThrown) {
                $container.html("Unsuccessful because: " + txt + ": " + errorThrown);
            },
            onComplete: function onComplete() {
                meerkat.modules.loadingAnimation.hide($refreshButton);
            }
        });
    }
    meerkat.modules.register("simplesUserStatus", {
        init: init
    });
})(jQuery);