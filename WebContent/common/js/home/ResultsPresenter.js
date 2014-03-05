/** Presenter **/
var ResultsPresenter = new Object();
ResultsPresenter = {

	/**
	 * Required
	 * functions:
	 * 		hidePage()
	 * 		update(jsonResult);
	 * 		show();
	**/
	view : new Object(),

	/**
	 * Required
	 * functions:
	 * 		nextStep()
	 * 		setSelectedProductInfo(ResultsPresenter.model.selectedProduct.info)
	**/
	applicationView : new Object(),

	/**
	 * Required
	 * variables:
	 * 		currentProducts
	 * 		selectedProduct
	**/
	model : new Object(),

	/**
	 * Required
	 * functions:
	 * 		updateSelect
	 */
	paymentSelectsHandler: new Object(),

	/**
	 * Required
	 * functions:
	 * 		create
	 */
	policyDetails: new Object(),

	/**
	 * Required
	 * functions:
	 * 		create
	 */
	policySnapshot: new Object(),

	setProduct: function( id ) {
		var success = false;

		var output = '';
		for (property in ResultsPresenter.model.currentProducts) {
			output += property + ': ' + ResultsPresenter.model.currentProducts[property]+'; ';
		}

		$.each(ResultsPresenter.model.currentProducts, function() {
			if (this.productId == id ) {
				success = this;
			}
		});
		if( typeof success == 'object' ) {
			ResultsPresenter.model.selectedProduct = success;
			return true;
		};
		return false;
	},
	fetchData : function(resultsJsp) {
		Loading.show("Loading Your Quotes...");
		ResultsPresenter.view.hidePage();
		this.view.flushResults();

		if (ResultsPresenter.view.ajaxPending){
			return; // we're still waiting for the results.
		};


		$.address.parameter("stage", "results", false );
		$.ajax({
			url: resultsJsp,
			data: "action=latest",
			type: "GET",
			async: true,
			dataType: "json",
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = resultsJsp;
				setting.url = resultsJsp;
			},
			success: function(jsonResult){
				ResultsPresenter.update(jsonResult);
			},

			error: function(jqXHR, textStatus, errorThrown){
//				console.log(jqXHR);
//				console.log(textStatus);
//				console.log(errorThrown);
			}
		});
	},
	update: function(jsonResult) {
		Loading.hide();
		ResultsPresenter.view.update(jsonResult);
		ResultsPresenter.model.currentProducts = [];
		$.each(jsonResult.results.result, function() {
			ResultsPresenter.model.currentProducts.push(this.product);
		});

		ResultsPresenter.view.show();
	},
	renderApplication: function(){
		//Trigger other Application functions
		paymentSelectsHandler.updateSelect(this.model.selectedProduct, this.model.frequencyType); //update the payment frequency info
		policyDetails.create(this.model.selectedProduct, this.model.frequencyType); //render the results for the product summary
		//policySnapshot.create(); //create the more information and confirmation objects
	},
	applyNow: function(_id) {
		if (typeof Kampyle != "undefined") {
			Kampyle.setFormId("85272");
		}

		// check mandatory dialog have been ticked
		var $_exacts = $('#resultsPage').find('.simples-dialogue.exact');
		if( $_exacts.length != $_exacts.find('input:checked').length ){
			generic_dialog.display('<p>Please complete the mandatory dialogue prompts before applying.</p>', 'Validation Error');
			return false;
		};

		// Check user still owner and touch the quote before proceeding
		//TODO move this somewhere else
		ResultsPresenter.model.touchQuote(ResultsPresenter.model.frequencyType, function() {

			ResultsPresenter.setProduct(_id);

			// TODOL work out what this does
			//healthFunds.load( ResultsPresenter.model.selectedProduct.info.provider ); //'super' fund customisation

			ResultsPresenter.applicationView.setSelectedProductInfo(ResultsPresenter.model.selectedProduct);

			ResultsPresenter.renderApplication();

			ResultsPresenter.view.hideResults();
			ResultsPresenter.applicationView.nextStep();

			Track.onApplyClick( ResultsPresenter.model.selectedProduct );
		});
	},
	filter: function() {
		ResultsPresenter.model.frequencyType = ResultsPresenter.view.getFilterType();
		var filterName = "";

		switch(ResultsPresenter.model.frequencyType ) {
		case 'F':
			filterLabel = 'Per Fortnight';
			filterName =  'fortnightly';
			break;
		case 'A':
			filterLabel = 'Per Year';
			filterName =  'annually';
			break;
		default:
			filterLabel = 'Per Month';
			filterName =  'monthly';
			break;
		};

		var id = '';
		var visiblePriceCount = 0;
		$.each(ResultsPresenter.model.currentProducts, function() {
			id = this.productId;
			if(this.premium[filterName] == null || this.premium[filterName].value == ''){
				ResultsPresenter.view.setFilterRow(true, id);
			} else {
				visiblePriceCount ++;
				ResultsPresenter.view.setFilterRow(false, id);
				ResultsPresenter.view.setPricing(filterLabel , this.premium[filterName].text , this.premium[filterName].pricing);
			};
		});

		// TODO: get this working
		// Resort the Price Objects!
		//ResultsPresenter.sortReset();
		//ResultsPresenter.sort();
		ResultsPresenter.view._paginationCurrent();

		// Check if there are any items to display
		if( visiblePriceCount == 0 ){
			$('#headerError').html('There are no products available based on the filter you have chosen.<br /><br />Please try again or contact us for assistance.').fadeIn();
		} else {
			$('#headerError').hide();
		};
	},

	sort: function() {
		ResultsPresenter.model.frequencyType = ResultsPresenter.view.getRankingMode();

		var originalJson = ResultsPresenter.view._jsonResult;
		var sortedJson = ResultsPresenter.view._jsonResult;
		//alert(originalJson);

		switch( ResultsPresenter.model.frequencyType ) {
			case 'L':
				sortedJson.results.result.sort(function(a,b) {
					return (a.product.premium.monthly - b.product.premium.monthly);
				});
				ResultsPresenter.view.update(sortedJson);

				break;
			case 'B':
				// TODO: Sort: benefits: need business rule to implement
//				Results.sortArray.sort(function(a,b) {
//					if( (a.rank < b.rank) || ( (a.rank == b.rank) && (a.premium[_priceCat].value > b.premium[_priceCat].value) ) ){
//						return 1;
//					} else {
//						return -1;
//					};
//				});
				//Unknown business rule for this at the moment, restore to original
				ResultsPresenter.view.update(originalJson);
				break;
		};
	},

	changeExcess: function() {
		this.view.flushResults();
		this.fetchData("ajax/json/home_quote_results.jsp");

		// TODO: changeExcess: need business rule to implement
	},

	applyFilters: function(){
		// TODO: to modify when the other rules will be implemented
		//this.changeExcess();
		this.view.flushResults();
		this.sort();
		this.filter();
	}

};