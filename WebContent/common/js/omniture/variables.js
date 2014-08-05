
var bigSliders = false;	
var reportRanking = true;
var annualKilometres = 0;
var applyByPhoneReported=false;

function imageRequest(){
	var s_code=s.t();
	if(s_code)document.write(s_code);
	delete s.events;
}

function dobAge(dob){
	try {
	    var now = new Date();
	    var dob = dob.split('/');
	    if(dob.length==3){
	          var born = new Date(dob[2], dob[1]*1-1, dob[0]);
	          var years = new Date(now.getTime() - born.getTime());
	          var base = new Date(0);
	          return years.getFullYear()-base.getFullYear();
	    }
	} catch (err) { 
		return 0;
	}
}

var initOmniture = false;
var TogglePaymentOption = 0;
var ToggleExcessOption = 0;
var smallSliderCount = 0;
var aolClickSource = 'ResultsPage';
var abpClickSource = 'ResultsPage';
var omnitureProduct = '';

function omnitureReporting(slideId) {
	
	switch (slideId){
	
	//Car Capture
	case 0:
		if (!initOmniture) {
			s.events='event9';
			// Note: pageName also used in the global mbox in car_quote.jsp
			s.pageName='CC:Quote:1.Car-Details:Identify-Car';
			s.prop3='CC';
			s.channel='CC:Quote';
			s.prop4='CC:Quote:1.Car-Details';
			s.eVar100=1;
			s.eVar2='Car Insurance';
			imageRequest();
		}
		break;
			
		
	// More About Car Details	
	case 1:
		s.pageName='CC:Quote:2.Car-Details:More-Details';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.prop4='CC:Quote:2.Car-Details';
		s.eVar2='Car Insurance';
		s.eVar11=$('#quote_vehicle_make :selected').text();
		s.eVar12=$('input:radio[name=quote_vehicle_accessories]:checked').val();
		imageRequest();
		break;
		
		
	// Regular Driver
	case 2:		
		s.pageName='CC:Quote:3.Driver-Details:Regular-Driver';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.prop4='CC:Quote:3.Driver-Details';
		var alarmFitted = 'Y';
		if ($('input:radio[name=quote_vehicle_modifications]:checked').val() == 'N') {
			alarmFitted = 'N';
		}
		s.eVar13=alarmFitted;
		s.eVar14=$('input:radio[name=quote_vehicle_modifications]:checked').val();
		annualKilometres = $('input[name=quote_vehicle_annualKilometres]').val();
		var annualKilometresRange = 0;		
		if (annualKilometres < 5000) {
			annualKilometresRange = '0 - 5,000';
			
		} else if (annualKilometres > 5000 && annualKilometres < 10001) {
			annualKilometresRange = '5,001 - 10,000';
			
		} else if (annualKilometres > 10000 && annualKilometres < 15001) {
			annualKilometresRange = '10,001 - 15,000';
			
		} else if (annualKilometres > 15000 && annualKilometres < 20001) {
			annualKilometresRange = '15,001 - 20,000';
			
		} else if (annualKilometres > 20000 && annualKilometres < 25001) {
			annualKilometresRange = '20,001 - 25,000';
			
		} else if (annualKilometres > 25000 && annualKilometres < 30001) {
			annualKilometresRange = '25,001 - 30,000';
			
		} else if (annualKilometres > 30000 && annualKilometres < 40001) {
			annualKilometresRange = '30,001 - 40,000';
			
		} else if (annualKilometres > 40000 && annualKilometres < 50001) {
			annualKilometresRange = '40,001 - 50,000';
			
		} else if (annualKilometres > 50000) {
			annualKilometresRange = 'More';			
		}	
		
		s.eVar16=annualKilometresRange;
		s.eVar35=$('input:radio[name=quote_vehicle_damage]:checked').val();
		if ($('input:radio[name=quote_vehicle_damage]:checked').val()=="Y"){
			s.eVar43="RI Hail Damage";
		}
		
		imageRequest();
		break;
		
		
	// More About Regular Driver
	case 3:		
		s.pageName='CC:Quote:4.Driver-Details:More-Details';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.prop4='CC:Quote:4.Driver-Details';
		s.eVar9=$('input:radio[name=quote_drivers_regular_gender]:checked').val();
		
		var ncdVal = $('#quote_drivers_regular_ncd').val();		
		switch (ncdVal) {
			case '0': ncdDes = 'None(Rating 6)'; break;
			case '1': ncdDes = '1 Years (Rating 5)'; break;
			case '2': ncdDes = '2 Years (Rating 4)'; break;
			case '3': ncdDes = '3 Years (Rating 3)'; break;
			case '4': ncdDes = '4 Years (Rating 2)'; break;
			case '5': ncdDes = '5 Years (Rating 1)'; break;
			default:  ncdDes = '';
		}		
		s.eVar4=ncdDes;

		var regularDriverAge = dobAge($('input[name=quote_drivers_regular_dob]').val());
		var regularDriverAgeRange = 0;
		
		if (regularDriverAge < 17) {
			regularDriverAgeRange = '<17';
			
		} else if (regularDriverAge > 16 && regularDriverAge < 21) {
			regularDriverAgeRange = '17-20';
			
		} else if (regularDriverAge > 20 && regularDriverAge < 25) {
			regularDriverAgeRange = '21-24';
			
		} else if (regularDriverAge > 24 && regularDriverAge < 31) {
			regularDriverAgeRange = '25-30';
			
		} else if (regularDriverAge > 30 && regularDriverAge < 36) {
			regularDriverAgeRange = '31-35';
			
		} else if (regularDriverAge > 35 && regularDriverAge < 41) {
			regularDriverAgeRange = '36-40';

		} else if (regularDriverAge > 40 && regularDriverAge < 46) {
			regularDriverAgeRange = '41-45';
			
		} else if (regularDriverAge > 45 && regularDriverAge < 51) {
			regularDriverAgeRange = '46-50';
			
		} else if (regularDriverAge > 50 && regularDriverAge < 56) {
			regularDriverAgeRange = '51-55';
			
		} else if (regularDriverAge > 55 && regularDriverAge < 61) {
			regularDriverAgeRange = '56-60';
			
		} else if (regularDriverAge > 60 && regularDriverAge < 66) {
			regularDriverAgeRange = '61-65';
			
		} else if (regularDriverAge > 65 && regularDriverAge < 71) {
			regularDriverAgeRange = '66-70';			
			
		} else if (regularDriverAge > 70) {
			regularDriverAgeRange = '71+';			
		}	
		
		s.eVar34=regularDriverAgeRange;
		
		if (annualKilometres < 5000 || annualKilometres > 20000){
			s.eVar43="RI KM Non Quote";
		}

		if (regularDriverAge < 25){
			s.eVar43="RI Regular Underaged Driver";
		}		
		
		imageRequest();
		break;
		
		
	// Car Parked At Night Address
	case 4:		
		s.pageName='CC:Quote:5.Driver-Details:More-Details';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.prop4='CC:Quote:5.Driver-Details';
		s.eVar17=$('#quote_drivers_regular_maritalStatus :selected').text();
		
		if ($('input:radio[name=quote_drivers_young_exists]:checked').val()=="Y") {
			
			var youngestDriverAge = dobAge($('input[name=quote_drivers_young_dob]').val());
			var youngestDriverAgeRange = 0;
			
			if (youngestDriverAge < 17) {
				youngestDriverAgeRange = '<17';
				
			} else if (youngestDriverAge > 16 && youngestDriverAge < 21) {
				youngestDriverAgeRange = '17-20';
				
			} else if (youngestDriverAge > 20 && youngestDriverAge < 25) {
				youngestDriverAgeRange = '21-24';
				
			} else if (youngestDriverAge > 24 && youngestDriverAge < 31) {
				youngestDriverAgeRange = '25-30';
				
			} else if (youngestDriverAge > 30 && youngestDriverAge < 36) {
				youngestDriverAgeRange = '31-35';
				
			} else if (youngestDriverAge > 35 && youngestDriverAge < 41) {
				youngestDriverAgeRange = '36-40';

			} else if (youngestDriverAge > 40 && youngestDriverAge < 46) {
				youngestDriverAgeRange = '41-45';
				
			} else if (youngestDriverAge > 45 && youngestDriverAge < 51) {
				youngestDriverAgeRange = '46-50';
				
			} else if (youngestDriverAge > 50 && youngestDriverAge < 56) {
				youngestDriverAgeRange = '51-55';
				
			} else if (youngestDriverAge > 55 && youngestDriverAge < 61) {
				youngestDriverAgeRange = '56-60';
				
			} else if (youngestDriverAge > 60 && youngestDriverAge < 66) {
				youngestDriverAgeRange = '61-65';
				
			} else if (youngestDriverAge > 65 && youngestDriverAge < 71) {
				youngestDriverAgeRange = '66-70';			
				
			} else if (youngestDriverAge > 70) {
				youngestDriverAgeRange = '71+';			
			}	
			
			s.eVar44=youngestDriverAgeRange;
			
			if (youngestDriverAge < 25){
				s.eVar43="RI Younger Underaged Driver";
			}
		}
		imageRequest();
		break;
		
		
	// Captcha
	case 5:		
		s.pageName='CC:Quote:6.Cover-Details:Details';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.prop4='CC:Quote:6.Cover-Details';
		s.eVar3=$('#quote_riskAddress_postCode').val();
		s.eVar19=$('input:radio[name=quote_contact_marketing]:checked').val();
		s.eVar22=$('input:radio[name=quote_contact_oktocall]:checked').val();
		imageRequest();
		break;	
			
		
	// Results Page
	case 6:
		if (reportRanking){
			var transactionId = Results.getResult(Results.getTopPosition()).transactionId;
			s.events='event7,event4='+transactionId;
			s.pageName='CC:Quote:8.Quote-Results:List';
			s.eVar2='Car Insurance';
			s.prop3='CC';
			s.channel='CC:Quote';
			s.prop4='CC:Quote:8.Quote-Results';
			s.eVar20=Results._priceCount; // Number of results returned	
			s.eVar21=$('#quote_linkChdId :selected').text();  // How did you hear about us
			s.eVar25=Results.getResult(Results.getTopPosition()).productDes; // Top of the price rankings
			s.eVar36=transactionId;
			s.transactionID=s.eVar36;
			var i =0;
			var lowestPriceProduct='';
			var price=parseInt(9999999999);
			s.products='';
			
			while (i < Results._currentPrices.length) {				
				var r = Results._currentPrices[i];				
				if(r.headline){					
					var headlineName = r.headline.name;
					var currentPrice = r.headline.lumpSumTotal;
					var productDes   = r.productDes;
					
					if (r.available=="Y" && !isNaN(currentPrice)){
						s.products+=';'+productDes+' '+headlineName+';;;;eVar47='+(i+1)+',';
						if (currentPrice < price) {
							lowestPriceProduct=productDes + " " + headlineName;
							price = currentPrice;
						}
					}
				}					
				i++;
			}
			s.products = s.products.slice(0, -1);
			if (lowestPriceProduct=="") lowestPriceProduct = "unknown";
			s.eVar24=lowestPriceProduct;
			imageRequest();
			reportRanking=false;
		}
		break;
		
		
	// Show Default Results - just rank by price
	case 7:
		reportRanking=true;
		s.pageName="CC:Quote:7:Interim-Page";
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.linkTrackVars='eVar41,events';
		s.linkTrackEvents='event10';
		s.eVar41='default';
		s.events='event10';
		s.t(this,'o','PreOrder');	
		bigSliders=true;
		imageRequest();
		break;		
		
	// Show Ranked Results Button
	case 8:			
		reportRanking=true;		
		if (!bigSliders) {			
			s.pageName="CC:Quote:7:Interim-Page";
			s.eVar2='Car Insurance';
			s.prop3='CC';
			s.channel='CC:Quote';
			s.linkTrackVars='eVar41,events';
			s.linkTrackEvents='event10';
			
			var i=0;
			$("#bigSliders .sliderWrapper .slider").each(function(){
				i++;
				switch (i){
					case 1:
						s.eVar41 = "preload - e" + $(this).slider("value");
						break;
					case 2:
						s.eVar41 += ":dlpl" + $(this).slider("value");
						break;
					case 3:
						s.eVar41 += ":bp" + $(this).slider("value");
						break;
					case 4:
						s.eVar41 += ":ooo" + $(this).slider("value");
						break;
					case 5:
						s.eVar41 += ":hn" + $(this).slider("value");
						break;
					default:
						
				}
			});
			
			s.events='event10';
			s.t(this,'o','PreOrder');
			
			imageRequest();
		}
		break;			


	// Change Show Ranked Results Slider -  small
	case 9:
		smallSliderCount+=1;
		s.eVar2='Car Insurance';
		s.linkTrackVars='eVar41,events';
		s.linkTrackEvents='event11';			
		s.events='event11';
		s.eVar31=smallSliderCount;
		//s.eVar41='re-order - ' + smallSliderId;
		s.t(this,'o','Re-Order');
		imageRequest();
		break;	
		
		
	// No Quotes Available
	case 10:
		var transactionId = Results.getResult(Results.getTopPosition()).transactionId;
		s.events='event5:'+transactionId+',event4';
		s.pageName='CC:Quote:8.Quote-Results:No-Quotes';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.prop4='CC:Quote:8.Quote-Results';
		s.eVar32='No Quotes available';
		s.eVar36=transactionId;
		s.transactionID=s.eVar36;
		imageRequest();
		break;

		
	// Change of price option
	case 11:
		s.pageName='CC:Quote:8.Quote-Results:Change-Price';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.linkTrackVars='eVar40,events';
		s.linkTrackEvents='event14';
		s.events='event14';
		s.eVar40='Toggle Payment';
		s.eVar29=TogglePaymentOption+=1;  // Count of how many times price has been toggled
		s.t(this,'o','Tool Usage');
		imageRequest();
		break;		
		
		
	// Change of excess option
	case 12:
		s.pageName='CC:Quote:8.Quote-Results:Change-Excess';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Quote';
		s.linkTrackVars='eVar40,events';
		s.linkTrackEvents='event14';
		s.events='event14,event3';
		s.eVar40='Toggle Excess';
		s.eVar30=ToggleExcessOption+=1;  // Count of how many times excess has been toggled
		s.t(this,'o','Tool Usage');
		imageRequest();
		break;
		
		
	// Quotes Saved
	case 20:
		s.eVar2='Car Insurance';
		s.linkTrackVars='eVar5,events';
		s.linkTrackEvents='event1';
		s.events='event1';
		s.t(this,'o','Save Quote');	
		imageRequest();
		break;

	// Retrieve Quote
	case 21:
		s.pageName='CC:Retrieve-Quote:Load Quote';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Retrieve-Quote';
		s.events='event2';
		imageRequest();
		break;		

	// Amend Quote
	case 22:
		s.pageName='CC:Retrieve-Quote:Amend Quote';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Retrieve-Quote';		
		s.events='event12';
		imageRequest();
		break;
		
	// Re-Quote 
	case 23:
		s.pageName='CC:Retrieve-Quote:Expired Quote';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Retrieve-Quote';		
		s.events='event13';
		imageRequest();
		break;
		
	// Apply Online
	case 30:
		s.eVar2='Car Insurance';
		s.linkTrackVars='products,eVar46,eVar5,eVar14,eVar24,events';
		s.linkTrackEvents='event21,event22';
		s.eVar15='1';
		s.eVar27=aolClickSource;
		var lumpSumTotal = Results.getResult(omnitureProduct).headline.lumpSumTotal;
		var productDes   = Results.getResult(omnitureProduct).productDes;
		var productCover = Results.getResult(omnitureProduct).headline.name;
		var leadNumber   = Results.getLeadNo(omnitureProduct);
		s.eVar5=leadNumber;		
		s.eVar46=productDes; 
		s.products=';'+productDes+' '+productCover+';;;event22='+lumpSumTotal;
		s.events='event21,event22';
		s.t(this,'o','Apply Online');	
		imageRequest();
		break;
		
		
	// Apply By Phone 
	case 31:
		if (!applyByPhoneReported) {
			var lumpSumTotal = Results.getResult(omnitureProduct).offlinePrice.lumpSumTotal;
			var productDes   = Results.getResult(omnitureProduct).productDes;
			var productCover = Results.getResult(omnitureProduct).headline.name;
			var leadNumber   = Results.getLeadNo(omnitureProduct);
			s.eVar2='Car Insurance';
			s.eVar5=leadNumber;
			s.eVar15=Results.getResultPosition(omnitureProduct);
			omnitureProduct='';
			s.eVar28=abpClickSource;
			s.eVar46=productDes; 
			s.products=';'+productDes+' '+productCover+';;;event24='+lumpSumTotal;
			s.events='event23,event24';
			s.t(this,'o','Apply By Phone');
			imageRequest();
			applyByPhoneReported=true;
		}
		break;
		
		
	// Compare Quotes
	case 32:
		s.eVar2='Car Insurance';
		s.events='event16';
		s.products=omnitureCompareProducts;
		imageRequest();
		break;
		
		
	// Tool Usage
	case 33:
		s.eVar2='Car Insurance';
		s.linkTrackVars='eVar40,events';
		s.linkTrackEvents='event14';
		s.events='event14';
		s.eVar40='Toggle Excess';
		s.t(this,'o','Tool Usage');
		imageRequest();
		break;
		
	// Transferring/Handover Page
	case 34:
		s.pageName='CC:Quote:Partner-Handover';
		s.eVar2='Car Insurance';
		s.prop3='CC';
		s.channel='CC:Partner-Handover';
		var productDes   = Results.getResult(omnitureProduct).productDes;
		var productCover = Results.getResult(omnitureProduct).headline.name;
		s.eVar37=productDes + ' ' + productCover;
		s.events = 'event40';
		omnitureProduct='';
		imageRequest();
		break;		
		
	default:
		
	}
	//Splunk.event(slideId);
}

$(document).ready(function() {
	omnitureReporting(0);
});

