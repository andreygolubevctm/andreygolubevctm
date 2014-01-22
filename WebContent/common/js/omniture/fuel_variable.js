function imageRequest(){
	var s_code=s.t();
	if(s_code)document.write(s_code);
	delete s.events;
}


var initOmniture = false;
var omnitureProduct = '';

function omnitureReporting(slideId) {

	switch (slideId){

	//Fuel Initial Page
	case 0:
		if (!initOmniture) {
			// Note: pageName also used in the global mbox in travel_quote.jsp (?relevant)
			s.pageName='CC:FuelQuote:1:Fuel-Details';
			s.channel='CC:FuelQuote';
			s.events='event9';
			s.prop3='CC';
			s.prop4='CC:Fuel:1:Fuel-Details';
			s.eVar2='Fuel';
			imageRequest();
		}
		break;

	// Quote Results
	case 1:
		s.pageName='CC:FuelQuote:2:Quote-Results:List';
		s.channel='CC:FuelQuote';
		s.events="event7,event4="+ Results._currentPrices[0].transactionId;
		s.prop3='CC';
		s.prop4='CC:FuelQuote:2:Quote-Results';
		s.eVar2='Fuel';
		s.eVar36= Results._currentPrices[0].transactionId;
		s.transactionID=s.eVar36;
		imageRequest();
		break;

	// Revise your details
	case 3:
		s.pageName='CC:FuelQuote:3:Quote-Results:Revise-Details';
		s.channel='CC:FuelQuote';
		s.prop3='CC';
		s.prop4='CC:FuelQuote:4:Quote-Results';
		s.eVar2='Fuel';
		imageRequest();
		break;

	// No Quote results
	case 5:
		s.pageName='CC:FuelQuote:2:No-Quotes-Provided';
		s.channel='CC:FuelQuote';
		s.events='event5';
		s.prop3='CC';
		s.prop4='CC:FuelQuote:2:No-Quotes-Provided';
		s.eVar2='Fuel';
		imageRequest();
		break;

	// Using a sign-up form
	case 50:
		s.pageName='CC:FuelQuote:3:Quick-Sign-Up';
		s.channel='CC:FuelQuote';
		s.events='event56';
		s.prop3='CC';
		s.prop4='CC:FuelQuote:3:Quick-Sign-Up';
		s.eVar2='Fuel';
		imageRequest();
		break;
	}
}
$(document).ready(function() {
	omnitureReporting(0);
});
