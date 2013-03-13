function imageRequest(){
	var s_code=s.t();
	if(s_code)document.write(s_code);
	delete s.events;
}


var initOmniture = false;
var omnitureProduct = '';

function omnitureReporting(slideId) {
	
	switch (slideId){
	
	//Roadside initial page
	case 0:
		if (!initOmniture) {
			
			// Note: pageName also used in the global mbox in Roadside_quote.jsp
			s.pageName='CC:SARQuote:1:Your-Car';
			s.channel='CC:SARQuote';
			s.events='event9';
			s.prop3='CC';
			s.prop4='CC:SAR:1:Your-Car';
			s.eVar2='SAR';
			imageRequest();
		}
		break;
			
	// Quote Results
	case 1:
		s.pageName='CC:SARQuote:2:Quote-Results:List';
		s.channel='CC:SARQuote';
		s.events='event7,event4='+ Results._currentPrices[0].transactionId;
		s.prop3='CC';
		s.prop4='CC:SARQuote:2:Quote-Results';
		s.eVar2='SAR';
		
		//search variables
		s.eVar64=$('#roadside_vehicle_year').val();
		s.eVar65=$('#roadside_vehicle_make').val();
		s.eVar66=$('#car_commercial').find('input:checked').val();
		s.eVar67=$('#car_odometer').find('input:checked').val();
		s.eVar68=$('#roadside_riskAddress_state').val();					
		
		//product variables
		s.eVar20=Results._priceCount; //results
		s.eVar36=Results._currentPrices[0].transactionId; //transId		
		s.eVar24=Results._currentPrices[0].des; //lowest price product name
		s.eVar25=Results._currentPrices[0].provider; //Top Result Brand Name
		
		//product list
		var prdlist= ';';
		for (var x=1; x <= Results._priceCount; x++){
			prdlist+=Results._currentPrices[x-1].des+';;;;'+'eVar47='+x;
			if (x < Results._priceCount) {
				prdlist+=',;';
			}; 
		}			
		s.products=prdlist;
		
		imageRequest();
		break;
		
	// More Info
	case 2:		
		s.pageName='CC:SARQuote:3:Quote-Results:More-Info';
		s.channel='CC:SARQuote';
		s.prop3='CC';		
		s.prop4='CC:SARQuote:3:Quote-Results';
		s.eVar2='SAR';
		
		imageRequest();
		break;
		
		
	// Revise your details
	case 3:		
		s.pageName='CC:SARQuote:4:Quote-Results:Revise-Details';
		s.channel='CC:SARQuote';
		s.prop3='CC';
		s.prop4='CC:SARQuote:4:Quote-Results';
		s.eVar2='SAR';
		
		imageRequest();
		break;
		
		
	// Hand over page
	case 4:		
		s.pageName='CC:SARQuote:5:Partner-Handover';
		s.channel='CC:Roadside Quote';
		s.events='event40,event22';
		s.prop3='CC';
		s.prop4='CC:SARQuote:5:Partner-Handover';
		s.eVar2='SAR';
		
		//Omniture product
		s.eVar36=Results.getResult(omnitureProduct).transactionId;
		s.eVar46=Results.getResult(omnitureProduct).provider;
		s.transactionID=s.eVar36;
		s.products=';'+Results.getResult(omnitureProduct).des+';;;event22='+Results.getResult(omnitureProduct).price;		
		
		imageRequest();
		break;
		
	// No Quote results
	case 5:		
		s.pageName='CC:SARQuote:2:No-Quotes-Provided';
		s.channel='CC:SARQuote';
		s.events='event5';
		s.prop3='CC';		
		s.prop4='CC:SARQuote:2:No-Quotes-Provided';
		s.eVar2='SAR';
		
		//search variables
		s.eVar64=$('#roadside_vehicle_year').val();
		s.eVar65=$('#roadside_vehicle_make').val();
		s.eVar66=$('#car_commercial').find('input:checked').val();
		s.eVar67=$('#car_odometer').find('input:checked').val();
		s.eVar68=$('#roadside_riskAddress_state').val();		
				
		imageRequest();
		break;
	}
}
$(document).ready(function() {
	omnitureReporting(0);
});