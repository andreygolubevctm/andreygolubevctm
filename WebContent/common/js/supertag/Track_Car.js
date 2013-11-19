var Track_Car = new Object();

Track_Car = {
	init: function(){
		Track.init('Car','Your Car');

		/* Tracking extensions for Car Quote (extend the object - no need for prototype extension as there should only ever be one Track */
		Track.nextClicked = function(stage){
			var actionStep='';
			switch(stage){
			case 0:
				actionStep='Your Car';
				PageLog.log("Your Car");
				break;
			case 1:
				actionStep='Car Details';
				PageLog.log("CarDetails");
				Write.touchQuote('H', false, 'CarDetails', true);
				break;
			case 2:
				actionStep='Driver Details';
				PageLog.log("DriverDetails");
				Write.touchQuote('H', false, 'DriverDtls', true);
				break;
			case 3:
				actionStep='More Details';
				PageLog.log("MoreDetails");
				Write.touchQuote('H', false, 'MoreDetail', true);
				break;
			case 4:
				actionStep='Address Contact';
				PageLog.log("AddressContact");
				Write.touchQuote('H', false, 'AddressContact', true);
				break;
			case 5:
				actionStep='More Info';
				PageLog.log("OtherInfo");
				Write.touchQuote('H', false, 'OtherInfo', true);
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
				//console.log('supertag', stObj);
			} catch(err){}
		};

		/* @Override resultsShown */
		Track.resultsShown=function(eventType){
			PageLog.log("Results");

			var prodArray=Track_Car.getDisplayedProducts();

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

			var prodIds = Compare.getComparedProductIds();
			var prodArray= new Array();

			for (var i in prodIds){
				var item = prodIds[i];
				prodArray.push({productID:item});
			}

			Write.touchQuote('H', false, 'ComparePro');
			try {
				//console.log('supertagx3', prodArray);
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
			if (emailAddress) {
				var dat = {brand:Settings.brand, vertical:Settings.vertical, email:emailAddress, m:mkt, o:ok};
				$.ajax({
					url: "ajax/json/get_email_id.jsp",
					data: dat,
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

		Track.bridgingClick = function(transId, quoteNo, productId, elementId){
			superT.trackBridgingClick ({
				type: elementId
				, quoteReferenceNumber: quoteNo
				, transactionID: transId
				, productID: productId
			});

		};
	},
	getDisplayedProducts:function(){
		var productsArray=new Array();
		var positionCounter = 1;
		for (var i in Results.model.sortedProducts){
			var item = Results.model.sortedProducts[i];
			var isDisplayed = Results.isResultDisplayed(item);
			if(isDisplayed){
				productsArray.push({productID:Object.byString(item,Results.settings.paths.productId), ranking:positionCounter});
				positionCounter++;
			}
		}

		return productsArray;
	}
};
