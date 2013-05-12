var Track_Travel = new Object();

Track_Travel = {
	init: function(){
		Track.init('Travel','Travel Details');

		/* Tracking extensions for Travel Quotes (extend the object - no need for prototype extension as there should only ever be one Track */
		Track.nextClicked = function(stage){
			var policyType=$('#travel_policyType').val();

			var dest='';
			var insType='';
			if (policyType=='S') {
				$('input.destcheckbox:checked').each(function(idx,elem){
					dest+=','+$(this).val();
				});
				dest=dest.substring(1);
				insType='Single Trip';
			} else {
				insType='Annual Policy';
			}
			try {
				superT.trackQuoteForms({
					vertical: this._type,
					actionStep: stage,
					yearOfBirth: '',
					gender: '',
					postCode: '',
					state: '',
					yearOfManufacture: '',
					makeOfCar: '',
					emailID: '',
					destinationCountry: dest,
					travelInsuranceType: insType,
					marketOptIn: '',
					okToCall: ''
				});
			} catch(err){}
		};

		Track.resultsShown = function(eventType){

			PageLog.log("Results");
			var prodArray=new Array();
			var j=0;
			for (var i in Results._currentPrices){
				if (Results._currentPrices[i].available==='Y'){
					var rank=1+parseInt(j);
					prodArray[j]={
						productID : Results._currentPrices[i].productId,
						ranking : rank
					};
					j++;
				}
			}
			try {
				superT.trackQuoteProductList({products:prodArray});

				superT.trackQuoteList ({
					event: eventType
				});
			} catch(err){}
		};

		Track._getTransactionId = function() {
			var transId = '';
			$.ajax({
				url: "ajax/json/get_transactionid.jsp",
				dataType: "json",
				data: {quoteType:"travel", id_handler:"preserve_tranId"},
				type: "GET",
				async: false,
				success: function(msg){
					transId = msg.transactionId;
				},
				timeout: 20000
			});

			return transId;
		};

		Track.onQuoteEvent = function(action, transId, step) {
			var stObj={
					action: action,
					transactionID: transId,
					actionStep: step
				};
			try {
				superT.trackQuoteEvent(stObj);
			} catch(err){}
		};

	}
};