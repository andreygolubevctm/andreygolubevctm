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
	
		
	//Toggle the state of the fuel buttons
	toggleSelect: function(obj){
		if(obj === true){
			obj = $('#fuelTypes').find(':checkbox');
		} else {
			obj = $(obj).siblings(':checkbox');
		}
		
		$(obj).each( function(){
			if( $(this).is(':checked') ){
				$(this).attr('checked', false);
			} else {
				$(this).attr('checked', true);
			}
		});
		fuel.populate();
	},
	
	
	ajaxPending: false,

	fetchPrices: function(){		
		if (fuel.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		Loading.show("Fetching Your<br />Fuel Prices...");
		var dat = $("#mainform").serialize();
		fuel.ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/fuel_price_results.jsp",
			data: dat,
			type: "GET",
			async: true,
			success: function(jsonResult){
				fuel.ajaxPending = false;
								
				//we're no longer just providing the price:  results.price
				Results.update(jsonResult.results);
				Results.show();
				Results._revising = true;
				Loading.hide();
				return false;
			},
			dataType: "json",
			error: function(obj,txt){
				fuel.ajaxPending = false;
				Loading.hide();
				alert("An error occurred when fetching prices :" + txt);
			},
			timeout:60000
		});
	},
	
	
	populate: function(){
		var s = '';
		$('#fuelTypes').find(':checked').each(function(){
			s += $(this).val() + ',';
		});
		$('#fuel_hidden').val(s);
	}
	
	
}