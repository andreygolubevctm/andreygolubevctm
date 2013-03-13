function imageRequest(){
	var s_code=s.t();
	if(s_code)document.write(s_code);
	delete s.events;
}

function omnitureReporting(slideId) {
	
	switch (slideId){
	
	// Additional Information Capture
	case 0:
		
		s.pageName='CC:Purchase:1:Additional_Information';
		s.channel='CC:Purchase';
		s.events='event52';
		s.eVar61=avea_brand;
		
		imageRequest();
		break;
			
	// Buy Online
	case 1:
		
		s.pageName='CC:Purchase:2:Buy_Online';
		s.channel='CC:Purchase';
		s.events='event53';
		s.eVar61=avea_brand;

		imageRequest();
		break;
		
	// Policy Confirmation
	case 2:	
		
		s.pageName='CC:Purchase:3:Payment_Confirmation';
		s.channel='CC:Purchase';
		s.events='event54,event55='+avea_premium;
		s.eVar61=avea_brand;
		s.eVar62=avea_policy;
		
		imageRequest();
		break;
		
	}
	
}
$(document).ready(function() {
	omnitureReporting(0);
});
