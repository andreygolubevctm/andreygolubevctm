/**
 * Data set handler for creating administration pages in Simples
 * 
 * For implementation notes:
 * http://confluence:8090/display/CM/Creating+Simples+Admin+Interfaces
 */
;(function($, undefined){
	
	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	/**
	 * Model for datums which populate the data set
	 * @param datumAdditionalFields - A function which returns an object of additional fields to use in the model
	 * @param response - Data to populate the model with
	 * @param templateHTML - Template to use for storing the HTML
	 */
	function datumModel(idKey, datumAdditionalFields, response, templateHTML) {
		this.id = response[idKey];
		this.data = new dbModel(response);

		if (datumAdditionalFields) {
			var data = datumAdditionalFields(response);

			for (var i in data) {
				if(i === "extraData"){
					var extraData = data[i];
					for (var j in extraData) {
						var field = extraData[j];
						this.data[j] = (typeof field === "function") ? field() : field;
					}
				} else {
					this[i] = data[i];
				}
			}
		}

		var htmlTemplate = _.template(templateHTML, { variable: "data" });
		this.html = htmlTemplate(this.data);

		return this;
	}
	
	/**
	 * Model which maps to the server-side model
	 * @param data - Data to populate the model with
	 */
	function dbModel(data) {
		var date = new Date(),
			formattedDate = date.getFullYear() + '-' + ("0" + (date.getMonth() + 1)).slice(-2) + '-' + ("0" + (date.getDate())).slice(-2);
		
		this.effectiveStart = formattedDate;
		this.effectiveEnd = formattedDate;

		for(var i in data) {
			this[i] = data[i];
		}

		return this;
	}
	
	/**
	 * Sets a property & value on the model
	 * @param property
	 * @param value
	 */
	dbModel.prototype.setProperty = function(property, value) {
		this[property] = value;
	};
	
	/**
	 * A set of data we can manipulate
	 */
	function dataSet() {
		var that = this;
		this.dataSet = [];
		
		$(document).on("click", ".data-sorter .toggle",function() {
			var $this = $(this),
				sortKey = $this.data("sortkey"),
				// We utilise the .attr() instead of .data() so we can utilise
				// CSS selectors in our less (e.g. .sort-by[data-sortdir="desc"] {...})
				sortDir = $this.attr("data-sortdir"),
				callback = $this.closest(".data-sorter").data("refreshcallback");
			
			$(".data-sorter .toggle")
				.removeClass("sort-by")
				.attr("data-sortdir", "desc");

			$this.addClass("sort-by");
			
			sortDir = (sortDir === "asc") ? "desc" : "asc";
			$this.attr("data-sortdir", sortDir);
			
			that.sort(sortKey, sortDir, callback);
		});
	}

	/**
	 * Clears the current data set
	 */
	dataSet.prototype.empty = function() {
		this.dataSet = [];
	};
	
	/**
	 * Sets the data set of the current instance.
	 */
	dataSet.prototype.set = function(dataSet) {
		this.dataSet = dataSet;
	};
	
	/**
	 * Pushes a data object to the instance's data set.
	 * @param data
	 */
	dataSet.prototype.push = function(data) {
		this.dataSet.push(data);
	};
	
	/**
	 * Get the instance's data set.
	 * @returns {Array}
	 */
	dataSet.prototype.get = function(id) {
		if(id) {
			return this.dataSet.filter(function(el) {
				return el.id === id;
			})[0];
		} else { 
			return this.dataSet;
		}
	};

	/**
	 * Returns an array of offers by the specified type
	 * @param type
	 * @returns {Array}
	 */
	dataSet.prototype.getByType = function(type) {
		return this.get().filter(function(el) {
			if (el.data.type)
				return el.data.type === type;
			else
				return false;
		});
	};

	/**
	 * Gets the index of an object by its id.
	 * Returns -1 if object is not present.
	 * @param objectId
	 * @returns {Number}
	 */
	dataSet.prototype.getIndex = function(objectId) {
		var index = -1;
	
		for(var j = 0; j < this.dataSet.length; j++) {
			if(this.dataSet[j].id === objectId) {
				index = j;
			}
		}
		
		return index;
	};
	
	/**
	 * Updates the data set at a particular index with the provided data object.
	 * @param index
	 * @param data
	 */
	dataSet.prototype.updateIndex = function(index, data) {
		this.dataSet[index] = data;
	};
	
	/**
	 * Drops an object by index from the data set.
	 * @param index
	 * @param count
	 */
	dataSet.prototype.splice = function(index, count) {
		count = count || 1;
		this.dataSet.splice(index, count);
	};
	
	/**
	 * Sorts the data set by specified key in a particular direction.
	 * @param key - The key to sort by (e.g. "data.offerId")
	 * @param direction - "asc" or "desc" 
	 * @param callback - Either a string denoting the object path (e.g. meerkat.modules.simplesSpecialOffers.refresh) or a method.
	 */
	dataSet.prototype.sort = function(key, direction, callback) {
		var keyChain = key.split(".");
		
		direction = direction || "asc";

		var sort = function(a, b) {
			for(var i = 0; i < keyChain.length; i++) {
				var keyChainItem = keyChain[i];
				a = a[keyChainItem];
				b = b[keyChainItem];
			}

			if(typeof a === "string")
				a = a.toLowerCase();
			
			if(typeof b === "string")
				b = b.toLowerCase();
			
			if ((a < b && direction === "asc") || (a > b && direction === "desc"))
				return -1;
			if ((a > b && direction === "asc") || (a < b && direction === "desc"))
				return 1;
			return 0;
		};
		
		var sortedDataSet = this.dataSet.sort(sort);
		this.set(sortedDataSet);
		
		if(typeof callback === "string")
			_getObject(callback)();
		else if(typeof callback === "function")
			callback();
	};
	
	/**
	 * Returns the global object as specified by the method path.
	 * e.g. "meerkat.modules.simplesDataObject.instance" will be returned by searching
	 * for window.meerkat.modules... and then returning that object. This allows us to
	 * specify a method in data attributes and call that method when needed (like in our
	 * sort method).
	 * @param methodPath
	 */
	var _getObject = function(methodPath) {
		var keyChain = methodPath.split("."),
			object = window;
				
		for(var i = 0; i < keyChain.length; i++) {
			object = object[keyChain[i]];
		}
		
		return object;
	};
	
	meerkat.modules.register('adminDataSet', {
		dataSet: dataSet,
		dbModel: dbModel,
		datumModel: datumModel
	});
	
})(jQuery);