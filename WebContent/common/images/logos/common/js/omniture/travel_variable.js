function imageRequest(){
	var s_code=s.t();
	if(s_code)document.write(s_code);
	delete s.events;
}


var initOmniture = false;
var omnitureProduct = '';

function omnitureReporting(slideId) {
	
	switch (slideId){
	
	//travel destination Capture
	case 0:
		if (!initOmniture) {
			
			// Note: pageName also used in the global mbox in travel_quote.jsp
			s.pageName='CC:TravelQuote:1.Traveller-Details';
			s.channel='CC:TravelQuote';
			s.eVar2='Travel Insurance';
			s.eVar48=$('#travel_policyType').val()=="A"?"Annual":"Single";
			s.events='event9';
			s.prop2='CC:TravelQuote:1.Traveller-Details';
			s.prop3='CC';
			s.prop4='CC:TravelQuote:1.Traveller-Details';
			s.eVar26='CC';
			imageRequest();
		}
		break;
			
	// Quote Results
	case 1:
		s.pageName='CC:Quote:2.Quote-Results:List';
		s.prop2='CC:TravelQuote:2.Quote-Results:List';
		s.prop3='CC';
		s.prop4='CC:TravelQuote:2.Quote-Results';
		s.eVar2='Travel Insurance';
		
		var dest = '';
		var chkCount =$('.destcheckbox:checked').length; 
		if (chkCount > 1) {
			$('.destcheckbox:checked').each(function() {
				var chkId=$(this).attr('id');
				dest += $('label[for='+chkId+']').text()+',';
				});
			dest = dest.substring(1, dest.length-1);
		} else {
			var chkId=$('.destcheckbox:checked').first().attr('id');
			dest += $('label[for='+chkId+']').text();
		}
		s.eVar54=dest;
		s.eVar55=$('#travel_dates_fromDate').val();
		s.eVar56=$('#travel_dates_toDate').val();
		s.eVar57=$('#travel_adults').val();
		s.eVar58=$('#travel_children').val();
		s.eVar59=$('#travel_oldest').val();
		s.eVar20=Results._priceCount;
		s.eVar24=Results._currentPrices[0].des;
		s.eVar25=Results._currentPrices[0].provider;
		s.eVar26='CC';
		s.eVar36=Results._currentPrices[0].transactionId;
		s.transactionID=s.eVar36;
		var prdlist= ';';
		for (var x=1; x <= Results._priceCount; x++){
			prdlist+=Results._currentPrices[x-1].des+';;;;'+'eVar47='+x;
			if (x < Results._priceCount) {
				prdlist+=',;';
			}; 
		}
		s.products=prdlist;
		s.events='event7,event4=' + Results._currentPrices[0].transactionId;
		s.channel='CC:TravelQuote';
		imageRequest();
		break;
		
	// More Info
	case 2:		
		s.pageName='CC:TravelQuote:Quote-Results:More-Info';
		s.prop2='CC:TravelQuote:Quote-Results:More-Info';
		s.prop3='CC';
		s.prop4='CC:TravelQuote:Quote-Results';
		s.eVar2='Travel Insurance';
		s.eVar26='CC';
		s.channel='CC:TravelQuote';
		imageRequest();
		break;
		
		
	// Revise your details
	case 3:		
		s.pageName='CC:TravelQuote:Quote-Results:Revise-Details';
		s.prop2='CC:TravelQuote:Quote-Results:More-Info';
		s.prop3='CC';
		s.prop4='CC:TravelQuote:Quote-Results';
		s.eVar2='Travel Insurance';
		s.eVar26='CC';
		s.channel='CC:TravelQuote';
		imageRequest();
		break;
		
		
	// Hand over page
	case 4:		
		s.pageName='CC:TravelQuote:Partner-Handover';
		s.prop2='CC:TravelQuote:Partner-Handover';
		s.prop3='CC';
		s.prop4='CC:TravelQuote:Partner-Handover';
		s.eVar26='CC';
		s.eVar36=Results.getResult(omnitureProduct).transactionId;
		s.transactionID=s.eVar36;
		s.eVar63=Results.getResult(omnitureProduct).des;
		s.eVar46=Results.getResult(omnitureProduct).provider;
		s.products=';'+Results.getResult(omnitureProduct).des+';;;event22='+Results.getResult(omnitureProduct).price;
		s.events='event40,event22';
		s.channel='CC:TravelQuote';
		imageRequest();
		break;
		
		// No Quote results
	case 5:		
		s.pageName='CC:TravelQuote:Quote-Results:No-Quotes-Provided';
		s.prop2= 'CC:TravelQuote:Quote-Results:No-Quotes-Provided';
		s.prop3='CC';
		s.prop4='CC:TravelQuote:Quote-Results';
		s.eVar2='Travel Insurance';
		var dest = '';
		var chkCount =$('.destcheckbox:checked').length; 
		if (chkCount > 1) {
			$('.destcheckbox:checked').each(function() {
				var chkId=$(this).attr('id');
				dest += $('label[for='+chkId+']').text()+',';
				});
			dest = dest.substring(1, dest.length-1);
		} else {
			var chkId=$('.destcheckbox:checked').first().attr('id');
			dest += $('label[for='+chkId+']').text();
		}
		s.eVar54=dest;
		s.eVar55=$('#travel_dates_fromDate').val();
		s.eVar56=$('#travel_dates_toDate').val();
		s.eVar57=$('#travel_adults').val();
		s.eVar58=$('#travel_children').val();
		s.eVar59=$('#travel_oldest').val();
		s.eVar26='CC';
		s.channel='CC:TravelQuote';
		s.events='event5';
		imageRequest();
		break;
	}
}
$(document).ready(function() {
	omnitureReporting(0);
});
