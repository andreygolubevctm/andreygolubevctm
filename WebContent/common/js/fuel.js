var fuel = new Object();


//Fuel types are hard-coded, sourced from the external service
fuel = {
	/*
	this.petrol = [ [2,'Unleaded', 'ULP'], [5,'Premium Unleaded 95', 'PULP'], [6,'E10', 'E10'], [7,'Premium Unleaded 98', 'PULP98'] ];
	this.diesel = [ [3,'Diesel', 'D'], [8,'Bio-Diesel 20', 'D20'], [9,'Premium Diesel', 'PD'] ];
	this.lpg = [ [4,'LPG', 'LPG'] ];
		this.all = this.petrol.concat(this.diesel,this.lpg);
	*/

	//SORT: function to sort the fuel types and return values
	//fuelID(false,'title') =>all titles or fuelID() => all IDs or fuelID(fuel.petrol) => petrol IDs

	isBrochureSite: false,

	fetch_count : 0,

	fuelID: function(type, element){

		if(typeof(type) !== 'object'){
			type = this.all;
		}

		switch(element)
		{
		case 'title':
			element = 1;
			break;
		case 'tag':
			element = 2;
			break;
		default:
			element = 0;
		}

		//loop through and return the element value
		var s = '';
		var len=type.length;

		for(var i=0; i<len;) {
			s += type[i][element];
			i++;
			if(i != len ){
				s += ',';
			}
		}

		return s;
	},

	limit: function(obj){
		if( $('#fuelTypes').find(':checked').length > 2) {
			$('#fuelTypes').find('input[type=hidden]').valid(); //fire the error to show the user they made a boo-boo
			$(obj).removeAttr('checked');
		};
	},


	//Toggle the state of the fuel buttons
	toggleSelect: function(obj){
		if(obj === true){
			obj = $('#fuelTypes').find(':checkbox');
		} else {
			obj = $(obj).siblings(':checkbox');
		}

		$(obj).each( function(){
			if( $(this).is(':checked') ){
				$(this).removeAttr('checked');
			} else {
				$(this).attr('checked', true);
			}
		});
		fuel.populate();
	},

	//Define the limit amount of petrol
	define: function(obj, override){

		fuel.isBrochureSite = override || false;

		$('#fuelTypes').find(':checkbox').removeAttr('checked'); //reset them all
		if(obj === true){
			obj = $('#fuelTypes').find(':checkbox');
		} else {
			obj = $(obj).siblings(':checkbox');
		}

		var _count = 0;
		var _fuelHiddens = '';

		//Limit count to 2 for only two types or 4 for all fuel in a column
		$(obj).each( function(){
			if(fuel.isBrochureSite || _count < 2){
				$(this).attr('checked', true);
				_fuelHiddens = _fuelHiddens + $(this).val() + ',';
			};
			_count++;
		});

		_fuelHiddens = _fuelHiddens.substring(0, _fuelHiddens.length -1 );

		$('#fuel_hidden').val(_fuelHiddens);

	},

	ajaxPending: false,

	fetchPrices: function(){
		if (fuel.ajaxPending){
			// we're still waiting for the results.
			return;
		}
		Loading.show("Fetching Your Fuel Prices...");
		var dat = $("#mainform").serialize() + "&fetchcount=" + (fuel.fetch_count++)+"&transactionId="+referenceNo.getTransactionID();
		fuel.ajaxPending = true;
		this.ajaxReq =
		$.ajax({
			url: "ajax/json/fuel_price_results.jsp",
			data: dat,
			type: "GET",
			async: true,
			success: function(jsonResult){
				fuel.ajaxPending = false;
				if(typeof jsonResult.error != 'undefined' && jsonResult.error.type == "validation") {
					Loading.hide(function() {
						ServerSideValidation.outputValidationErrors({
							validationErrors: jsonResult.error.errorDetails.validationErrors,
							startStage: 0,
							singleStage : true
						});
					});
				} else {
					//we're no longer just providing the price:  results.price
					Results.update(jsonResult.results);
					Results.show();
					Results._revising = true;
					Loading.hide();
				}
				return false;
			},
			dataType: "json",
			error: function(obj, txt, errorThrown) {
				fuel.ajaxPending = false;
				if(obj.status === 429) {
					var response = {
							error: "limit",
							time: 0,
							result: {
								siteid: null,
								name: null,
								fuelid: null
							}
					};
					Results.update(response);
					Results.show();
					Results._revising = true;
					Loading.hide();
				} else {
					Loading.hide();
					FatalErrorDialog.exec({
						message: "An error occurred when fetching prices: " + txt,
						page: "common/fuel.js:fetchPrices()",
						description: "An error occurred when trying to successfully call or parse the fuel results: " + txt + ' ' + errorThrown,
						data: dat
					});
				}
			},
			timeout:60000,
			complete: function() {
				if (typeof referenceNo !== 'undefined') {
					referenceNo.getTransactionID(true);
				}
			}

		});
	},

	limitExceeded: function() {
		var count = 0;
		$('#fuelTypes').find(':checked').each(function(){
			count++;
		});

		return count > 2;
	},

	populate: function(element){

		fuel.isBrochureSite = false;

		if( element.is(":checked") && fuel.limitExceeded() )
		{
			element.removeAttr("checked");
		}

		var s = '';

		$('#fuelTypes').find(':checked').each(function(){
			s += $(this).val() + ',';
		});

		s = s.substring(0, s.length -1 );

		$('#fuel_hidden').val(s);
	},

	reduceSelectedToLimit: function(limit) {
		limit = limit || 2;
		fuel.isBrochureSite = false;
		var list = $('#fuel_hidden').val().split(",");
		if( list.length > limit ) {
			list = list.slice(0, 2);
			$('#fuel_hidden').val( list.join(",") );
			fuel.renderFromHidden();
		}
	},

	renderFromHidden: function() {
		var list = $('#fuel_hidden').val().split(",");
		$("#fuelTypes input:checkbox").each(function(){
			$(this).removeAttr("checked");
			for( var i in list ) {
				if( list[i] == $(this).val() ) {
					$(this).attr("checked", "checked");
				}
			}
		});
	}
}