if (typeof(Splunk) === 'undefined') {
	var Splunk  = {};
}
Splunk = {
	props: {
		sessionId:''
	},
	
	setId:function(id){
		this.props.sessionId=id;
	},
	send:function(props){
		$.extend(props,this.props);
		
		$.ajax({
			url:'http://localhost:8080/ctm/ajax/write/splunk.jsp',
			data:props
		});
	},
	event:function(eventId){
		var props={};
		
		switch (eventId){
	
		//Car Capture
		case 0:
			props.event='event9';
			// Note: pageName also used in the global mbox in car_quote.jsp
			props.pageName='CC:Quote:1.Car-Details:Identify-Car';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:1.Car-Details';
			props.eVar100=1;
			props.eVar2='Car Insurance';
			Splunk.send(props);
			break;
				
		// More About Car Details	
		case 1:
			props.pageName='CC:Quote:2.Car-Details:More-Details';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:2.Car-Details';
			props.eVar2='Car Insurance';
			props.eVar11=$('#quote_vehicle_make :selected').text();
			props.eVar12=$('input:radio[name=quote_vehicle_accessories]:checked').val();
			Splunk.send(props);
			break;
			
		// Regular Driver
		case 2:		
			props.pageName='CC:Quote:3.Driver-Details:Regular-Driver';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:3.Driver-Details';
			var alarmFitted = 'Y';
			if ($('input:radio[name=quote_vehicle_modifications]:checked').val() == 'N') {
				alarmFitted = 'N';
			}
			props.eVar13=alarmFitted;
			props.eVar14=$('input:radio[name=quote_vehicle_modifications]:checked').val();
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
			
			props.eVar16=annualKilometresRange;
			props.eVar35=$('input:radio[name=quote_vehicle_damage]:checked').val();
			if ($('input:radio[name=quote_vehicle_damage]:checked').val()=="Y"){
				props.eVar43="RI Hail Damage";
			}
			
			Splunk.send(props);
			break;
			
		// More About Regular Driver
		case 3:		
			props.pageName='CC:Quote:4.Driver-Details:More-Details';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:4.Driver-Details';
			props.eVar9=$('input:radio[name=quote_drivers_regular_gender]:checked').val();
			
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
			props.eVar4=ncdDes;
	
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
			
			props.eVar34=regularDriverAgeRange;
			
			if (annualKilometres < 5000 || annualKilometres > 20000){
				props.eVar43="RI KM Non Quote";
			}
	
			if (regularDriverAge < 25){
				props.eVar43="RI Regular Underaged Driver";
			}		
			
			Splunk.send(props);
			break;
			
			
		// Car Parked At Night Address
		case 4:		
			props.pageName='CC:Quote:5.Driver-Details:More-Details';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:5.Driver-Details';
			props.eVar17=$('#quote_drivers_regular_maritalStatus :selected').text();
			
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
				
				props.eVar44=youngestDriverAgeRange;
				
				if (youngestDriverAge < 25){
					props.eVar43="RI Younger Underaged Driver";
				}
			}
			Splunk.send(props);
			break;
			
		// Captcha
		case 5:		
			props.pageName='CC:Quote:6.Cover-Details:Details';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:6.Cover-Details';
			props.eVar3=$('#quote_riskAddress_postCode').val();
			props.eVar19=$('input:radio[name=quote_contact_marketing]:checked').val();
			props.eVar22=$('input:radio[name=quote_contact_oktocall]:checked').val();
			props.email = $('#quote_contact_email').val();
			Splunk.send(props);
			break;	
				
			
		// Results Page
		case 6:
			if (reportRanking){
				var transactionId = Resultprops.getResult(Resultprops.getTopPosition()).transactionId;
				props.event='event7,event4='+transactionId;
				props.pageName='CC:Quote:8.Quote-Results:List';
				props.eVar2='Car Insurance';
				props.prop3='CC';
				props.channel='CC:Quote';
				props.prop4='CC:Quote:8.Quote-Results';
				props.eVar20=Resultprops._priceCount; // Number of results returned	
				props.eVar21=$('#quote_linkChdId :selected').text();  // How did you hear about us
				props.eVar25=Resultprops.getResult(Resultprops.getTopPosition()).productDes; // Top of the price rankings
				props.eVar36=transactionId;
				props.transactionID=props.eVar36;
				var i =0;
				var lowestPriceProduct='';
				var price=parseInt(9999999999);
				props.products='';
				
				while (i < Resultprops._currentPriceprops.length) {				
					var r = Resultprops._currentPrices[i];				
					if(r.headline){					
						var headlineName = r.headline.name;
						var currentPrice = r.headline.lumpSumTotal;
						var productDes   = r.productDes;
						
						if (r.available=="Y" && !isNaN(currentPrice)){
							props.products+=';'+productDes+' '+headlineName+';;;;eVar47='+(i+1)+',';
							if (currentPrice < price) {
								lowestPriceProduct=productDes + " " + headlineName;
								price = currentPrice;
							}
						}
					}					
					i++;
				}
				props.products = props.productprops.slice(0, -1);
				if (lowestPriceProduct=="") lowestPriceProduct = "unknown";
				props.eVar24=lowestPriceProduct;
				Splunk.send(props);
				reportRanking=false;
			}
			break;
			
			
		// Show Default Results - just rank by price
		case 7:
			reportRanking=true;
			props.pageName="CC:Quote:7:Interim-Page";
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.linkTrackVars='eVar41,events';
			props.linkTrackEvents='event10';
			props.eVar41='default';
			props.event='event10';
			props.t = 'PreOrder';	
			bigSliders=true;
			Splunk.send(props);
			break;		
			
		// Show Ranked Results Button
		case 8:			
			reportRanking=true;		
			if (!bigSliders) {			
				props.pageName="CC:Quote:7:Interim-Page";
				props.eVar2='Car Insurance';
				props.prop3='CC';
				props.channel='CC:Quote';
				props.linkTrackVars='eVar41,events';
				props.linkTrackEvents='event10';
				
				var i=0;
				$("#bigSliders .sliderWrapper .slider").each(function(){
					i++;
					switch (i){
						case 1:
							props.eVar41 = "preload - e" + $(this).slider("value");
							break;
						case 2:
							props.eVar41 += ":dlpl" + $(this).slider("value");
							break;
						case 3:
							props.eVar41 += ":bp" + $(this).slider("value");
							break;
						case 4:
							props.eVar41 += ":ooo" + $(this).slider("value");
							break;
						case 5:
							props.eVar41 += ":hn" + $(this).slider("value");
							break;
						default:
							
					}
				});
				
				props.event='event10';
				props.t = 'PreOrder';
				
				Splunk.send(props);
			}
			break;			
	
	
		// Change Show Ranked Results Slider -  small
		case 9:
			smallSliderCount+=1;
			props.eVar2='Car Insurance';
			props.linkTrackVars='eVar41,events';
			props.linkTrackEvents='event11';			
			props.event='event11';
			props.eVar31=smallSliderCount;
			//props.eVar41='re-order - ' + smallSliderId;
			props.t='Re-Order';
			Splunk.send(props);
			break;	
			
			
		// No Quotes Available
		case 10:
			var transactionId = Resultprops.getResult(Resultprops.getTopPosition()).transactionId;
			props.event='event5:'+transactionId+',event4';
			props.pageName='CC:Quote:8.Quote-Results:No-Quotes';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.prop4='CC:Quote:8.Quote-Results';
			props.eVar32='No Quotes available';
			props.eVar36=transactionId;
			props.transactionID=props.eVar36;
			Splunk.send(props);
			break;
	
			
		// Change of price option
		case 11:
			props.pageName='CC:Quote:8.Quote-Results:Change-Price';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.linkTrackVars='eVar40,events';
			props.linkTrackEvents='event14';
			props.event='event14';
			props.eVar40='Toggle Payment';
			props.eVar29=TogglePaymentOption+=1;  // Count of how many times price has been toggled
			props.t(this,'o','Tool Usage');
			Splunk.send(props);
			break;		
			
			
		// Change of excess option
		case 12:
			props.pageName='CC:Quote:8.Quote-Results:Change-Excess';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Quote';
			props.linkTrackVars='eVar40,events';
			props.linkTrackEvents='event14';
			props.event='event14,event3';
			props.eVar40='Toggle Excess';
			props.eVar30=ToggleExcessOption+=1;  // Count of how many times excess has been toggled
			props.t(this,'o','Tool Usage');
			Splunk.send(props);
			break;
			
			
		// Quotes Saved
		case 20:
			props.eVar2='Car Insurance';
			props.linkTrackVars='eVar5,events';
			props.linkTrackEvents='event1';
			props.event='event1';
			props.t(this,'o','Save Quote');	
			Splunk.send(props);
			break;
	
		// Retrieve Quote
		case 21:
			props.pageName='CC:Retrieve-Quote:Load Quote';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Retrieve-Quote';
			props.event='event2';
			Splunk.send(props);
			break;		
	
		// Amend Quote
		case 22:
			props.pageName='CC:Retrieve-Quote:Amend Quote';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Retrieve-Quote';		
			props.event='event12';
			Splunk.send(props);
			break;
			
		// Re-Quote 
		case 23:
			props.pageName='CC:Retrieve-Quote:Expired Quote';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Retrieve-Quote';		
			props.event='event13';
			Splunk.send(props);
			break;
			
		// Apply Online
		case 30:
			props.eVar2='Car Insurance';
			props.linkTrackVars='products,eVar46,eVar5,eVar14,eVar24,events';
			props.linkTrackEvents='event21,event22';
			props.eVar15='1';
			props.eVar27=aolClickSource;
			var lumpSumTotal = Resultprops.getResult(Splunk.product).headline.lumpSumTotal;
			var productDes   = Resultprops.getResult(Splunk.product).productDes;
			var productCover = Resultprops.getResult(Splunk.product).headline.name;
			var leadNumber   = Resultprops.getLeadNo(Splunk.product);
			props.eVar5=leadNumber;		
			props.eVar46=productDes; 
			props.products=';'+productDes+' '+productCover+';;;event22='+lumpSumTotal;
			props.event='event21,event22';
			props.t(this,'o','Apply Online');	
			Splunk.send(props);
			break;
			
			
		// Apply By Phone 
		case 31:
			if (!applyByPhoneReported) {
				var lumpSumTotal = Resultprops.getResult(Splunk.product).offlinePrice.lumpSumTotal;
				var productDes   = Resultprops.getResult(Splunk.product).productDes;
				var productCover = Resultprops.getResult(Splunk.product).headline.name;
				var leadNumber   = Resultprops.getLeadNo(Splunk.product);
				props.eVar2='Car Insurance';
				props.eVar5=leadNumber;
				props.eVar15=Resultprops.getResultPosition(Splunk.product);
				Splunk.product='';
				props.eVar28=abpClickSource;
				props.eVar46=productDes; 
				props.products=';'+productDes+' '+productCover+';;;event24='+lumpSumTotal;
				props.event='event23,event24';
				props.t(this,'o','Apply By Phone');
				Splunk.send(props);
				applyByPhoneReported=true;
			}
			break;
			
			
		// Compare Quotes
		case 32:
			props.eVar2='Car Insurance';
			props.event='event16';
			props.products=omnitureCompareProducts;
			Splunk.send(props);
			break;
			
			
		// Tool Usage
		case 33:
			props.eVar2='Car Insurance';
			props.linkTrackVars='eVar40,events';
			props.linkTrackEvents='event14';
			props.event='event14';
			props.eVar40='Toggle Excess';
			props.t(this,'o','Tool Usage');
			Splunk.send(props);
			break;
			
		// Transferring/Handover Page
		case 34:
			props.pageName='CC:Quote:Partner-Handover';
			props.eVar2='Car Insurance';
			props.prop3='CC';
			props.channel='CC:Partner-Handover';
			var productDes   = Resultprops.getResult(Splunk.product).productDes;
			var productCover = Resultprops.getResult(Splunk.product).headline.name;
			props.eVar37=productDes + ' ' + productCover;
			props.event = 'event40';
			Splunk.product='';
			Splunk.send(props);
			break;		
			
		default:
		
		}
	}	
};


