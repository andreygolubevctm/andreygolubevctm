/* Tracking extensions for Car Quote */
Track.nextClicked = function(stage){
	var dob=$('#quote_drivers_regular_dob').val();
	if (dob.length()>4){
		dob=substring(dob,dob.length()-4);
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
	
	superT.trackQuoteForms({
	    quoteType: this._type,
	    nextStep: stage,
	    yearOfBirth: dob,
	    gender: gender,
	    postCode: $('#quote_riskAddress_postCode').val(),
	    state: $('#quote_riskAddress_state').val(),
	    yearOfManufacture: $('#quote_vehicle_year').val(),
	    makeOfCar: $('#quote_vehicle_make option:selected').text(),
	    emailID: '',
	    destinationCountry: '',
	    travelInsuranceType: '',
	    marketOptIn: marketOptIn,
	    okToCall: okToCall
	});		
};
Track.resultsShown=function(eventType){
		var prodArray=new Array();
		for (var i in Results._currentPrices){
			prodArray[i]={
				productID : Results.currentPrices(i).productId,
				ranking : i+1
			};
		}
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
	};
Track.compareClicked= function(){
	var prodArray=new Array();
	$('#basket .basket-items .item').each(function(i,obj){
		prodArray[i]={
			productID:$(this).attr('id').substring(19)
		};
	});
	superT.trackQuoteComparison({ products: prodArray });
	
};
Track._getSliderText= function(sliderId){
	var s=$('#'+sliderId).prev('span');
	if (s.length >0){
		return s.text();
	} else {
		return '';
	}		
};