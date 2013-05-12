$.validator.addMethod(
	"dateEUR",
	function(value, element) {
		var check = false;
		var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
		if( re.test(value)){
			var adata = value.split('/');
			var d = parseInt(adata[0],10);
			var m = parseInt(adata[1],10);
			var y = parseInt(adata[2],10);
			var xdata = new Date(y,m-1,d);
			if ( ( xdata.getFullYear() == y ) && ( xdata.getMonth () == m - 1 ) && ( xdata.getDate() == d ) ){
				check = true;
			} else {
				check = false;
			}
		} else {
			check = false;
		}
		return (this.optional(element) != false) || check;
	}, 
	"Please enter a date in dd/mm/yyyy format."
);
$.validator.addMethod("minDateEUR",
	function(value, element, param) {	
		function getDate(v){
			var adata = v.split('/');
			return new Date(parseInt(adata[2],10),
							parseInt(adata[1],10)-1,
							parseInt(adata[0],10));
		}
    	return (this.optional(element) != false) || getDate(value) >= getDate(param);
	},
	$.validator.format("Please enter a minimum of {0}.")
);
$.validator.addMethod("maxDateEUR",
	function(value, element, param) {	
		function getDate(v){
			var adata = v.split('/');
			return new Date(parseInt(adata[2],10),
							parseInt(adata[1],10)-1,
							parseInt(adata[0],10));
		}
    	return (this.optional(element) != false) || getDate(value) <= getDate(param);
	},
	$.validator.format("Please enter a maximum of {0}.")
);
//
// Validates NCD: Years driving can exceed NCD years
//
$.validator.addMethod("ncdValid",
	function(value, element) {

		if (element.value == "") return false;

		function getDateFullYear(v){
			var adata = v.split('/');
			return parseInt(adata[2],10);
		}				
		
		// TODO: Get date from server and not client side
		var d = new Date();
		var curYear = d.getFullYear();
		
		var minDrivingAge = 16;
		var rgdYrs = curYear - getDateFullYear($("#quote_drivers_regular_dob").val());
		var ncdYears = value;
		var yearsDriving = rgdYrs - minDrivingAge; 
		//alert("ncdYears: " + ncdYears + " yearsDriving: " + yearsDriving);
		if (ncdYears>yearsDriving){ 
			return false;			
		}
		return true;		
	},
	"Invalid NCD Rating based on number of years driving."
);

//
// Validates youngest drivers age with regular driver, youngest can not be older than regular driver
//
$.validator.addMethod("youngRegularDriversAgeCheck",
	function(value, element, params) {
		function getDate(v){
			var adata = v.split('/');
			return new Date(parseInt(adata[2],10),
							parseInt(adata[1],10)-1,
							parseInt(adata[0],10));
		}	
	
		var rgdDob = getDate($("#quote_drivers_regular_dob").val());
		var yngDob = getDate(value);
						
		// Rgd must be older than YngDrv
		if (yngDob < rgdDob) {
			return (this.optional(element) != false) || false;
		}
		return true;
	},
	"Youngest driver should not be older than the regular driver."
);


//
// Validates...
//
$.validator.addMethod("allowedDrivers",
		function(value, element, params) {
			
			var allowDate = false;
	
			function getDateFullYear(v){
				var adata = v.split('/');
				return parseInt(adata[2],10);
			}	
			function getDateMonth(v){
				var adata = v.split('/');
				return parseInt(adata[1],10)-1;
			}
			function getDate(v){
				var adata = v.split('/');
				return new Date(parseInt(adata[2],10),
								parseInt(adata[1],10)-1,
								parseInt(adata[0],10));
			}			
			
			var minAge;

			switch(value){
				case "H":minAge=21; break;
				case "7":minAge=25; break;
				case "A":minAge=30; break;
				case "D":minAge=40; break;
				default:
					// do nothing
			}
			
			// TODO: Get date from server and not client side
			var d = new Date();
			var curYear = d.getFullYear();
			var curMonth = d.getMonth();
			var rgdDOB = getDate($("#quote_drivers_regular_dob").val());
			var rgdFullYear = getDateFullYear($("#quote_drivers_regular_dob").val());
			var rgdMonth = getDateMonth($("#quote_drivers_regular_dob").val());
			var rgdYrs = curYear - rgdFullYear;

			// Check AlwDrv allows Rgd 
			if (rgdYrs<minAge) {
			} else if (rgdYrs==minAge) {
				if ((rgdFullYear + minAge) == curYear) {
					if (rgdMonth < curMonth) {
						allowDate = true;					
					} else if (rgdMonth == curMonth) {
						if (rgdDOB <= d) {
							allowDate = true;
						}
					}
				}
			} else {
				allowDate=true;			
			}

			if (allowDate==false) {
				return false;				
			}

			return true;
			
		},
		"Driver age restriction invalid due to regular driver's age."
);

//
// Validates youngest driver minimum age
//
$.validator.addMethod("youngestDriverMinAge",
		function(value, element, params) {
			
			function getDateFullYear(v){
				var adata = v.split('/');
				return parseInt(adata[2],10);
			}	
			
			var minAge;
			switch(value){
				case "H":minAge=21; break;
				case "7":minAge=25; break;
				case "A":minAge=30; break;
				case "D":minAge=40; break;
				default:
					// do nothing
			}
			
			// TODO: Get date from server and not client side
			var d = new Date();
			var curYear = d.getFullYear();
			var yngFullYear = getDateFullYear($("#quote_drivers_young_dob").val());
			var yngAge = curYear - yngFullYear;
			if (yngAge < minAge) {
				return (this.optional(element) != false) || false;
			} 			
			return true;
			
		},
		"Driver age restriction invalid due to youngest driver's age."
);

//
// Is used to reset the number of form errors when moving between slides
//
;(function($) {
	$.extend($.validator.prototype, {
		resetNumberOfInvalids: function() {
			this.invalid = {};
			$(this.containers).find(".error, li").remove();
		}
	});
})(jQuery);

//
// Any input field with a class of 'numeric' will only be allowed to input numeric characters
//
$(function() {
	$("input.numeric").numeric();
});	

//
// Validates age licence obtained for regular driver
//
$.validator.addMethod("ageLicenceObtained",
		function(value, element, param) {
			
			var driver;
			switch(element.name){
				case "quote_drivers_regular_licenceAge": driver="#quote_drivers_regular_dob"; break;
				case "quote_drivers_young_licenceAge": driver="#quote_drivers_young_dob"; break;
				default:
					return false;
			}
	
			function getDateFullYear(v){
				var adata = v.split('/');
				return parseInt(adata[2],10);
			}				
			var d = new Date();
			var curYear = d.getFullYear();
			var driverFullYear = getDateFullYear($(driver).val());
			var driverAge = curYear - driverFullYear;
			
			if (isNaN(driverAge) || value < 16 || value > driverAge) {	
				return (this.optional(element) != false) || false;
			} 			
			return true;
			
		},
		"Age licence obtained invalid due to driver's age."
);

//
// Ensures that client agrees to the field 
// Makes sure that checkbox for 'Y' is checked 
//
$.validator.addMethod("agree",
		function(value, element, params) {
			if (value == "Y"){
				return $(element).is(":checked");
			} else {
				return true;
			}
		},
		""
);

//
// Validates OK to call which ensure we have a phone number if they select yes
//
$.validator.addMethod("okToCall",
		function(value, element, params) {
			if ( $('input[name="quote_contact_oktocall"]:checked').val() == "Y" && $('input[name="quote_contact_phone"]').val() == "") {
				return false;
			}  else {
				return true;
			}
			
		},
		""
);

String.prototype.startsWith = function(prefix) {
	return (this.substr(0, prefix.length) === prefix);
}
String.prototype.endsWith = function (suffix) {
	return (this.substr(this.length - suffix.length) === suffix);
}			

