var Track_Car = new Object();

Track_Car = {
	init: function(){
		Track.init('Car','Your Car');
		PageLog.log("YourCar");
		
		/* Tracking extensions for Car Quote (extend the object - no need for prototype extension as there should only ever be one Track */
		Track.nextClicked = function(stage){
			var actionStep='';
			switch(stage){
			case 1:
				actionStep='Car Details';
				PageLog.log("CarDetails");
				break;
			case 2: 
				actionStep='Driver Details'; 
				PageLog.log("DriverDetails");
				break;
			case 3: 
				actionStep='More Details'; 
				PageLog.log("MoreDetails");
				break;
			case 4: 
				actionStep='Address Contact'; 
				PageLog.log("AddressContact");
				break;
			case 5: 
				actionStep='More Info'; 
				PageLog.log("OtherInfo");
				break;
			}
			
			
			var dob=$('#quote_drivers_regular_dob').val();
			if (dob.length>4){
				dob=dob.substring(dob.length-4);
			}
			
			var gender='';
			switch($('input[name=quote_drivers_regular_gender]:checked', '#mainform').val()){
			case 'M': gender='Male'; break;
			case 'F': gender='Female'; break;
			}
			
			var marketOptIn='';
			switch ($('input[name=quote_contact_marketing]:checked','#mainform').val()){
			case 'Y': marketOptIn='Yes'; break; 
			case 'N': marketOptIn='No'; break;
			}
			
			var okToCall='';
			switch ($('input[name=quote_contact_oktocall]:checked','#mainform').val()){
			case 'Y': okToCall='Yes'; break; 
			case 'N': okToCall='No'; break;
			}
			var postCode=$('#quote_riskAddress_postCode').val();
			var stateCode = $('#quote_riskAddress_state').val();
			var vehYear=$('#quote_vehicle_year').val();
			var vehMake=$('#quote_vehicle_make option:selected').text();
			var emailId=Track._getEmailId($('#quote_contact_email').val(),$('#quote_contact_marketing_Y').is(':checked'),$('#quote_contact_oktocall_Y').is(':checked'));
			var stObj={
			    vertical: this._type,
			    actionStep: actionStep,
			    yearOfBirth: dob,
			    gender: gender,
			    postCode: postCode,
			    state: stateCode,
			    yearOfManufacture: vehYear,
			    makeOfCar: vehMake,
			    emailID: emailId,
			    destinationCountry: '',
			    travelInsuranceType: '',
			    marketOptIn: marketOptIn,
			    okToCall: okToCall
			};
			try {
				superT.trackQuoteForms(stObj);
			} catch(err){}
		};
		
		/* @Override resultsShown */
		Track.resultsShown=function(eventType){
			
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
			
				superT.trackQuoteForms({
				    paymentPlan: $('#quote_paymentType option:selected').text(),
				    preferredExcess: $('#quote_excess option:selected').text(),
				    sortEnvironment: Track._getSliderText('small-env'),
				    sortDriveLessPayLess:  Track._getSliderText('small-payasdrive'),
				    sortBestPrice: Track._getSliderText('small-price'),
				    sortOnlineOnlyOffer: Track._getSliderText('small-onlinedeal'),
				    sortHouseholdName: Track._getSliderText('small-household'),
				    event: eventType
				});
			} catch(err){}
		};
		Track.compareClicked= function(){
			var prodArray=new Array();
			$('#basket .basket-items .item').each(function(i,obj){
				prodArray[i]={
					productID:$(this).attr('id').substring(19)
				};
			});
			PageLog.log("CompareProducts");
			try {
				superT.trackQuoteComparison({ products: prodArray });
			} catch(err){}
			
		};
		Track._getSliderText= function(sliderId){
			var s=$('#'+sliderId).prev('span');
			if (s.length >0){
				return s.text();
			} else {
				return '';
			}		
		};
		Track._getEmailId = function(emailAddress,marketing,oktocall) {
			var emailId = '';
			var mkt = (marketing) ? 'Y' : 'N';
			var ok = (oktocall) ? 'Y' : 'N';
			if(emailAddress) {
				$.ajax({
					url: "ajax/json/get_email_id.jsp",
					data: "s=CTCQ&email=" + emailAddress + "&m=" + mkt + "&o=" + ok,
					type: "GET",
					async: false,
					dataType: "json",
					success: function(msg){
						emailId = msg.emailId;
					},
					timeout: 20000
				});		
				return emailId;
			}
		};

		Track._getTransactionId = function( reset ) {
			var transId = '';
			reset = reset || false;
			var dat = {quoteType:"car"};
			if( !reset ) {
				dat.id_handler = "preserve_tranId"
			}
			$.ajax({
				url: "ajax/json/get_transactionid.jsp",
				dataType: "json",
				data: dat,
				type: "GET",
				async: false,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function(msg){
					transId = msg.transactionId;
				},
				timeout: 20000
			});

			return transId;			
		};

		Track.startSaveRetrieve = function(transId, action, step) {
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
