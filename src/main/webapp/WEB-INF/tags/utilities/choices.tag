<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpathHouseholdDetails" 				required="true" rtexprvalue="true" description="Household Details field group's xpath" %>
<%@ attribute name="xpathEstimateDetails"				required="true"	rtexprvalue="true" description="Estimate Details field group's xpath" %>
<%@ attribute name="xpathResultsDisplayed"				required="true"	rtexprvalue="true" description="Results Displayed field group's xpath" %>
<%@ attribute name="xpathApplicationDetails" 			required="true" rtexprvalue="true" description="Application Details field group's xpath" %>
<%@ attribute name="xpathApplicationSituation"			required="true"	rtexprvalue="true" description="Application Situation field group's xpath" %>
<%@ attribute name="xpathApplicationPaymentInformation"	required="true"	rtexprvalue="true" description="Application Payment Information field group's xpath" %>
<%@ attribute name="xpathApplicationOptions"			required="true"	rtexprvalue="true" description="Application Options field group's xpath" %>
<%@ attribute name="xpathApplicationThingsToKnow"		required="true"	rtexprvalue="true" description="Application Things To Know field group's xpath" %>
<%@ attribute name="xpathSummary"						required="true"	rtexprvalue="true" description="Summary field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="nameHouseholdDetails" 				value="${go:nameFromXpath(xpathHouseholdDetails)}" />
<c:set var="nameEstimateDetails" 				value="${go:nameFromXpath(xpathEstimateDetails)}" />
<c:set var="nameResultsDisplayed" 				value="${go:nameFromXpath(xpathResultsDisplayed)}" />
<c:set var="nameApplicationDetails" 			value="${go:nameFromXpath(xpathApplicationDetails)}" />
<c:set var="nameApplicationSituation" 			value="${go:nameFromXpath(xpathApplicationSituation)}" />
<c:set var="nameApplicationPaymentInformation" 	value="${go:nameFromXpath(xpathApplicationPaymentInformation)}" />
<c:set var="nameApplicationOptions"			 	value="${go:nameFromXpath(xpathApplicationOptions)}" />
<c:set var="nameApplicationThingsToKnow" 		value="${go:nameFromXpath(xpathApplicationThingsToKnow)}" />
<c:set var="nameSummary" 						value="${go:nameFromXpath(xpathSummary)}" />

<%-- PARAM VALUES --%>
<c:set var="whatToCompare" value="${data[xpathHouseholdDetails].whatToCompare}" />
<c:set var="howToEstimate" value="${data[xpathEstimateDetails].howToEstimate}" />

<%-- setup var to hold 'has bill' variable - if provided by brochure site --%>
<c:set var="has_bill">
	<c:choose>
		<c:when test="${not empty param.has_bill and param.has_bill eq 'yes'}">true</c:when>
		<c:when test="${not empty param.has_bill and param.has_bill eq 'no'}">false</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</c:set>

<go:script marker="js-head">
</go:script>

<%-- Javascript object for holding users criteria --%>
<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var utilitiesChoices = new Object();
utilitiesChoices = {
	_slideFieldsets: true,
	_state : '',
	_postcode : '',
	_whatToCompare : '',
	_howToEstimate : '',
	
	_has_bill : ${has_bill},

	_movingIn: '',
	_product: false,
	
	_located_providers: {
		electricity:	{},
		gas:			{}
	},
	

	// ajaxLimiters
	_loading_providers: false,
	_loading_plans: false,
	
	initialise : function() {
		
		<%--Force default value on How To Estimate field when coming from brochure site and has bill handy --%>
		if( utilitiesChoices._has_bill === true ) {
			$('#utilities_householdDetails_howToEstimate').val('U');
			utilitiesChoices.setHowToEstimate('U');
		}

		$('input[name=utilities_householdDetails_movingIn]').on('change',function(){
				utilitiesChoices.showHideCurrentPlans();
		});

		<%--Show/Hide the Supplier Plans help text when changing the current plan --%>
		$('#${nameEstimateDetails}_usage_electricity_currentPlan, #${nameEstimateDetails}_usage_gas_currentPlan').on("change", utilitiesChoices.showHidePlanHelpText);

		// track changes
		$('#${nameHouseholdDetails}_whatToCompare, #${nameHouseholdDetails}_howToEstimate, #${nameHouseholdDetails}_state').on('change', function(){
			utilitiesChoices.showHideQuestionElements();
			utilitiesChoices.showHideCurrentProvider();
		});
		
		

		$("#${nameHouseholdDetails}_state").on('change', function() {
			UtilitiesQuote.getUtilitiesForPostcode( $("#${nameHouseholdDetails}_postcode").val(), $("#${nameHouseholdDetails}_suburb").val(), utilitiesChoices.updateServicesAndProviders );
			});
		
		// trigger postcode change if field is preloaded
		if($('#${nameHouseholdDetails}_location').val() != ''){
			$('#${nameHouseholdDetails}_postcode').trigger('change');
		}
		
		// update the Email value on the application slide
		$('#${nameResultsDisplayed}_email').on('change', function(){
			utilitiesChoices.setEmail();
		});
		utilitiesChoices.setEmail();
		
		$('#${nameResultsDisplayed}_phoneinput').on('blur', function(){
			utilitiesChoices.setPhone();
		});
		utilitiesChoices.setPhone();

		$('#${nameResultsDisplayed}_firstName').on('change', function(){
			utilitiesChoices.setFirstName();
		});
		utilitiesChoices.setFirstName();

		// update the Moving In value on the application slide
		$('input[name=${nameHouseholdDetails}_movingIn]').on('change', function(){
			utilitiesChoices.setMovingIn();
			utilitiesChoices.showHideCurrentProvider();
		});
		utilitiesChoices.setMovingIn();
	
		// init
		utilitiesChoices.showHideQuestionElements();
		utilitiesChoices.showHideCurrentProvider();
	},
	
	setState: function(state){

		utilitiesChoices._state = state;
		
	},
	
	setWhatToCompare: function(whatToCompare){
	
		utilitiesChoices._whatToCompare = whatToCompare;
		
		// either E = Electricity, G = Gas or EG = Electricity and Gas
		
	},

	setHowToEstimate: function(howToEstimate){
	
		utilitiesChoices._howToEstimate = howToEstimate;
		
		// either S = Spend, H = Household Size or U = Usage
		
	},
	
	showHideWhatToCompare: function( validUtilities ){
	
		$('input[name=${nameHouseholdDetails}_whatToCompare]').button('disable');
				
		var toggleButtons = function( utl ) {
			var utilityCode = utl.replace(/[a-z]/g, '');
			$('#${nameHouseholdDetails}_whatToCompare_'+utilityCode).button("enable");
		}
		
		if( typeof validUtilities == "string" ) {
			toggleButtons( validUtilities );
		} else {
			for(var i = 0 ; i < validUtilities.length; i++) {
				toggleButtons( validUtilities[i] );
			}
		}

		if( $('input[name=${nameHouseholdDetails}_whatToCompare]:checked').button('option', 'disabled') == true ){
			$('input[name=${nameHouseholdDetails}_whatToCompare]:checked').prop('checked', false).button('refresh');
		}
		
	},
	
	updateServicesAndProviders:function(json){

		utilitiesChoices.setState($('#${nameHouseholdDetails}_state').val());

		var selected_e = $("#utilities_estimateDetails_usage_electricity_currentSupplierSelected").val();
		if( $("#utilities_estimateDetails_usage_electricity_currentSupplier").find(":selected") ) {
			selected_e = $("#utilities_estimateDetails_usage_electricity_currentSupplier").find(":selected").val();
		}
		var selected_g = $("#utilities_estimateDetails_usage_gas_currentSupplierSelected").val();
		if( $("#utilities_estimateDetails_usage_gas_currentSupplier").find(":selected") ) {
			selected_g = $("#utilities_estimateDetails_usage_gas_currentSupplier").find(":selected").val();
		}

		if(json == null){
			utilitiesChoices.showHideWhatToCompare([]);

			var eProviders = [];
			utilitiesChoices.renderProviderList(eProviders, 'Electricity', utilitiesChoices._state, selected_e);
			
			var gProviders = [];
			utilitiesChoices.renderProviderList(gProviders, 'Gas', utilitiesChoices._state, selected_g);


		}else{

			// Services available

			if(json.serviceType == "Electricity_Gas"){
				utilitiesChoices.showHideWhatToCompare(['EG','E','G']);
			}else if(json.serviceType == "Electricity"){
				utilitiesChoices.showHideWhatToCompare(['E']);
			}else if(json.serviceType == "Gas"){
				utilitiesChoices.showHideWhatToCompare(['G']);
			}else{
				utilitiesChoices.showHideWhatToCompare([]);
			}

			// Providers available

			var eProviders = json.electricityProviders;
			utilitiesChoices.renderProviderList(eProviders, 'Electricity', utilitiesChoices._state, selected_e);
			
			var gProviders = json.gasProviders;
			utilitiesChoices.renderProviderList(gProviders, 'Gas', utilitiesChoices._state, selected_g);

			$("#utilities_householdDetails_tariff").val(json.electricityTariff);
			

		}
		
		
	},

	showHideQuestionElements: function(){
		
		// store the old values
		oldWhatToCompare = utilitiesChoices._whatToCompare;
		oldHowToEstimate = utilitiesChoices._howToEstimate;
		
		// replace them with the changed values
		utilitiesChoices.setWhatToCompare( $('#${nameHouseholdDetails}_whatToCompare :checked').val() );
		utilitiesChoices.setHowToEstimate( $('#${nameHouseholdDetails}_howToEstimate option:selected').val() );
		
		// if whatToCompare and howToEstimate fields are both set
		if(utilitiesChoices._whatToCompare != ''
			&& utilitiesChoices._whatToCompare != undefined
			&& utilitiesChoices._howToEstimate != '' ) {
	
				// show/hide electricity/gas fields
				utilitiesChoices.showHideUtilities();
				
				// if the fieldsets have to be animated too (not yet shown)
				if(utilitiesChoices._slideFieldsets){
				
					utilitiesChoices.showFieldsets();
		
				// otherwise only animate the fields
				} else {
				
					utilitiesChoices.showHideCompareMethod();
					
				}
			
		// if not both set, hide the fieldsets
		} else {
			
			utilitiesChoices.hideFieldsets();
			
		}
		
	},
	
	showFieldsets: function(){
	
		// get the className from the selected way to compare utilities
		var howToEstimateClass = utilitiesChoices.returnHowToEstimateClass(utilitiesChoices._howToEstimate);
		var oldHowToEstimateClass = utilitiesChoices.returnHowToEstimateClass(oldHowToEstimate);
		
		//slide the whole fieldset
		$('#${nameEstimateDetails}').slideDown('fast', function(){
			$("."+howToEstimateClass).slideDown();
			
		});
		
		utilitiesChoices.showHideCurrentProvider();
		
		$('#${nameResultsDisplayed}').slideDown();
		
		utilitiesChoices._slideFieldsets = false;
		
	},
	
	hideFieldsets: function(){
	
		// hide the fieldsets
		if( $('#${nameEstimateDetails}').is(':visible') ){
			
			// hide estimate panel
			$('#${nameEstimateDetails}').slideUp(400, function(){
				// reset visibility of the fields about current provider
				$('#${nameEstimateDetails} .currentProviderContainer').hide();
				
				// reset visibility of the spend, household size and usage divs
				$(this).find('.content>div').hide();
			});
			
			// hide results displayed panel
			$('#${nameResultsDisplayed}').slideUp(400);
			
			utilitiesChoices._slideFieldsets = true;
		}
		
	},
	
	isMovingIn: function() {
		return $('input[name=utilities_householdDetails_movingIn]:checked').val() == 'Y';
	},

	isEstimateBasedOnStandardTariff: function() {
		switch(utilitiesChoices._whatToCompare) {
			case "E":
				if( $('#${nameEstimateDetails}_usage_electricity_currentPlan').val() == "ignore" ) {
					$('.currentProviderContainer .currentProviderContainerHelpTextRow:first span').empty().append(utilitiesChoices.getStandardTariffText());
					return true;
				} else {
					return false;
				}
				break;
			case "G":
				if( $('#${nameEstimateDetails}_usage_gas_currentPlan').val() == "ignore" ) {
					$('.currentProviderContainer .currentProviderContainerHelpTextRow:first span').empty().append(utilitiesChoices.getStandardTariffText());
					return true;
				} else {
					return false;
				}
				break;
			case "EG":
			default:
				if( $('#${nameEstimateDetails}_usage_electricity_currentPlan').val() == "ignore" || $('#${nameEstimateDetails}_usage_gas_currentPlan').val() == "ignore" ) {
					$('.currentProviderContainer .currentProviderContainerHelpTextRow:first span').empty().append(utilitiesChoices.getStandardTariffText());
					return true
				} else {
					return false;
				}
				break;
		}
	},

	getStandardTariffText: function() {
		var text = "";
		switch(utilitiesChoices._whatToCompare) {
			case "E":
				if( $('#${nameEstimateDetails}_usage_electricity_currentPlan').val() == "ignore" ) {
					text = "for electricity";
				}
				break;
			case "G":
				if( $('#${nameEstimateDetails}_usage_gas_currentPlan').val() == "ignore" ) {
					text = "for gas";
				}
				break;
			case "EG":
			default:
				if( $('#${nameEstimateDetails}_usage_electricity_currentPlan').val() == "ignore" || $('#${nameEstimateDetails}_usage_gas_currentPlan').val() == "ignore" ) {
					if( $('#${nameEstimateDetails}_usage_electricity_currentPlan').val() == "ignore" && $('#${nameEstimateDetails}_usage_gas_currentPlan').val() == "ignore" ) {
						text = "for electricity and gas";
					} else if( $('#${nameEstimateDetails}_usage_electricity_currentPlan').val() == "ignore" ) {
						text = "for electricity";
					} else {
						text = "for gas";
					}
				}
				break;
		}

		return text;
	},

	hasSelectedAProvider: function() {
		<%-- Select value is null on page initial page load --%>
		var ecs = $('#utilities_estimateDetails_usage_electricity_currentSupplier').val();
		var gcs = $('#utilities_estimateDetails_usage_gas_currentSupplier').val();
		return (ecs && ecs != '') || (gcs && gcs != '');
	},

	showHideCurrentPlans: function() {
		<%--Ensure the supplier plans row is visible when coming to site from brochure site and have
			selected you have you bill handy OR you have come to the site directly --%>
		if(
			(utilitiesChoices._has_bill === true || utilitiesChoices._has_bill === 0 || (utilitiesChoices._has_bill === false && utilitiesChoices.isMovingIn() === true))
			&& utilitiesChoices.hasSelectedAProvider()
		) {
			$('#utilities_estimateDetails .currentProviderContainerCurrentPlanRow:first').slideDown('slow');
		} else {
			$('#utilities_estimateDetails .currentProviderContainerCurrentPlanRow:first').hide();
		}
	},

	showHidePlanHelpText: function() {
		if( utilitiesChoices.isEstimateBasedOnStandardTariff() ) {
			$('.currentProviderContainer .currentProviderContainerHelpTextRow:first').show();
		} else {
			$('.currentProviderContainer .currentProviderContainerHelpTextRow:first').hide();
		}
	},

	showHideCompareMethod: function(){
	
		// get the className from the selected way to compare utilities
		var howToEstimateClass = utilitiesChoices.returnHowToEstimateClass(utilitiesChoices._howToEstimate);
		var oldHowToEstimateClass = utilitiesChoices.returnHowToEstimateClass(oldHowToEstimate);
		
		// only animate if the values have changed
		if(oldHowToEstimate != utilitiesChoices._howToEstimate){
			$('.'+oldHowToEstimateClass).slideUp();
			$("."+howToEstimateClass).slideDown();
		};
		
	},
	
	showHideUtilities: function(){
	
		// Services available
		switch(utilitiesChoices._whatToCompare){
			case 'E':
				$('.electricity').show();
				$('.gas').hide();
				break;
				
			case 'G':
				$('.gas').show();
				$('.electricity').hide();
				break;
				
			case 'EG':
				$('.electricity').show();
				$('.gas').show();
				break;
		}
		
	},
	
	
	
	showHideCurrentProvider: function(){
		utilitiesChoices.updateProviderSelects(function() {
				
			// if Usage is selected, then display fields about their current provider
			if(
				(
					utilitiesChoices._howToEstimate == 'U' || 
					(utilitiesChoices._howToEstimate == 'S' && utilitiesChoices._movingIn == 'N') ||
					(utilitiesChoices._howToEstimate == 'H' && utilitiesChoices._movingIn == 'N')
				) && utilitiesChoices._state != ''
				  && typeof utilitiesChoices._whatToCompare != 'undefined' && utilitiesChoices._whatToCompare != ''
			){
				$('#${nameEstimateDetails} .currentProviderContainer').slideDown();
			}else{
				$('#${nameEstimateDetails} .currentProviderContainer').slideUp();
			}
		});
	},
	
	updateProviderSelects: function( callback ) {
			
		if( 
			typeof utilitiesChoices._whatToCompare != 'undefined' && utilitiesChoices._whatToCompare != '' &&
			(
				utilitiesChoices._howToEstimate == 'U' || 
				(utilitiesChoices._howToEstimate == 'S' && utilitiesChoices._movingIn == 'N') ||
				(utilitiesChoices._howToEstimate == 'H' && utilitiesChoices._movingIn == 'N')
			) && utilitiesChoices._state != ''
		){
			var state = utilitiesChoices._state;
			
			var postcode = utilitiesChoices._postcode;
			var packagetype = utilitiesChoices._whatToCompare;
			var selected_e = $("#utilities_estimateDetails_usage_electricity_currentSupplierSelected").val();
			if( $("#utilities_estimateDetails_usage_electricity_currentSupplier").find(":selected") ) {
				selected_e = $("#utilities_estimateDetails_usage_electricity_currentSupplier").find(":selected").val();
			}
			var selected_g = $("#utilities_estimateDetails_usage_gas_currentSupplierSelected").val();
			if( $("#utilities_estimateDetails_usage_gas_currentSupplier").find(":selected") ) {
				selected_g = $("#utilities_estimateDetails_usage_gas_currentSupplier").find(":selected").val();
			}
		
			$("#utilities_estimateDetails_usage_electricity_currentSupplier").empty();
			$("#utilities_estimateDetails_usage_gas_currentSupplier").empty();
			$("#utilities_estimateDetails_usage_electricity_currentPlan").empty();
			$("#utilities_estimateDetails_usage_gas_currentPlan").empty();
			
			if( 
				(packagetype == 'EG' && utilitiesChoices._located_providers.electricity.hasOwnProperty(state) && utilitiesChoices._located_providers.gas.hasOwnProperty(state) )
				||
				(packagetype == 'E' && utilitiesChoices._located_providers.electricity.hasOwnProperty(state))
				||
				(packagetype == 'G' && utilitiesChoices._located_providers.gas.hasOwnProperty(state))
			) {
				utilitiesChoices.renderProviderList(utilitiesChoices._located_providers.electricity[state], 'Electricity', state, selected_e);
				utilitiesChoices.renderProviderList(utilitiesChoices._located_providers.gas[state], 'Gas', state, selected_g);
				
				if( typeof callback == "function" ) {
					callback();
				}
			} else {
					
				// this was where we called the ajax again - but we should have the data already.
							
							}
		} else {
			$("#utilities_estimateDetails_usage_electricity_currentSupplier").empty();
			$("#utilities_estimateDetails_usage_gas_currentSupplier").empty();
			$("#utilities_estimateDetails_usage_electricity_currentPlan").empty();
			$("#utilities_estimateDetails_usage_gas_currentPlan").empty();
			
			if( typeof callback == "function" ) {
				callback();
			}
		}
	},
	

	getOptionsLength: function( options ) {
			
		/* Find the length of the options object. Most browsers honour the index order the object
		   has but IE & FF don't so need to get the length. Only IE doesn't like Object.keys so for
		   her we just have to check each index value */
		   
		var length = 0;
		try {
			length = Object.keys(options).length;
		} catch(e) {
			for( var s in options) {
				if( Number(s) > length ) {
					length = Number(s);
				}
			}
			
			if( length > 0) {
				length++;
			}
		}
		
		return length;
	},
	
	renderProviderList: function(list, utility, state, selected) {
		// Insurance against people who click too much
		$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentSupplier").empty();
		
		if(typeof list == "object") {
			utilitiesChoices._located_providers[utility.toLowerCase()][state] = list;
			var options = utilitiesChoices._located_providers[utility.toLowerCase()][state];
			var optionsLen = utilitiesChoices.getOptionsLength(options);
			for(var i = 0; i < optionsLen; i++) {
				if(options.hasOwnProperty(i)) {
					$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentSupplier").append("<option value='" + options[i].id + "' " + (selected == options[i].id ? "selected='true'" : "") + ">" + options[i].name + "</option>");
				}
			}
			
			}
	},
	
	setEmail: function(){
		$('#${nameApplicationDetails}_email').val( $('#${nameResultsDisplayed}_email').val() );
	},
		
	setPhone: function(){
		var phone = $('#${nameResultsDisplayed}_phone').val();
		if(phone.substring(0, 2) == "04") {
			$('#${nameApplicationDetails}_mobileNumberinput').val( $('#${nameResultsDisplayed}_phone').val() );
		} else {
			$('#${nameApplicationDetails}_otherPhoneNumberinput').val( $('#${nameResultsDisplayed}_phone').val() );
				}
	},
	
	setFirstName: function(){
		$('#${nameApplicationDetails}_firstName').val( $('#${nameResultsDisplayed}_firstName').val() );
	},
	
	setMovingIn: function(){
		var movingInVal = $('#${nameHouseholdDetails}_movingIn :checked').val();
		$('#${nameApplicationDetails}_movingIn_' + movingInVal).attr( 'checked', 'checked' ).trigger('change');
		utilitiesChoices._movingIn = movingInVal;
	},
	
	setProduct: function(product){
		
		utilitiesChoices._product = product;
		
	},
	
	updateApplicationSlide: function(){
		
		$("#${nameApplicationThingsToKnow}_hidden_productId").val(utilitiesChoices._product.planId);
		$("#${nameApplicationThingsToKnow}_hidden_searchId").val(utilitiesChoices._product.searchId);
		$("#${nameApplicationDetails}_address_postCode").val( $('#${nameHouseholdDetails}_postcode').val() );
		$("#${nameApplicationDetails}_address_postCode").change();
		$("#${nameApplicationDetails}_address_state").val( $('#${nameHouseholdDetails}_state').val() );
		
		// parse selected product
		utilitiesChoices.parseSelectedProduct();
		
		// update moving date datepicker minDate with the retailer's business days notice
		utilitiesChoices.updateMovingDateMinimum();
		
		
		
		// some providers require more validation
		utilitiesChoices.addRemoveValidationRules();
		
		

		$(".providerName").html(utilitiesChoices._product.provider);
	},
	
	parseSelectedProduct: function(){
		var selectedProductTemplate = $("#selected-product-template").html();
		var parsedTemplate = $(parseTemplate( selectedProductTemplate, utilitiesChoices._product ));
		
		$(".selectedProduct").html( parsedTemplate );
		
		
		if($("#${nameApplicationDetails}_movingIn :checked").val() == 'Y'){
			$('.selectedProductTable .estSavings').hide();
		} else {
			$('.selectedProductTable .estSavings').show();
		}
		
		Results.negativeValues(utilitiesChoices._product.yearlySavings, $(".estSavingsCell"), 'extra' );
	},
	
	updateMovingDateMinimum: function() {
		
		var providerCode = utilitiesChoices._product.service;
			
		var today = new Date();
		today = today.getDate() + "/" + (today.getMonth()+1) + "/" + today.getFullYear();

		var datepicker = $("#utilities_application_details_movingDate").data("datepicker");
		var maxDateAttr = $("#utilities_application_details_movingDate").datepicker("option", "maxDate");
		var maxDate = $.datepicker._determineDate(datepicker, maxDateAttr, new Date());
		maxDate = maxDate.getDate() + "/" + (maxDate.getMonth()+1) + "/" + maxDate.getFullYear();


	},
	
	addRemoveValidationRules: function(){
			$('#${nameApplicationDetails}_mobileNumberinput').addRule("validateMobileField").setRequired(false);
			$('#${nameApplicationDetails}_otherPhoneNumberinput').setRequired(false);
	},

	updateApplyNowSlide : function(){

		$(".${nameSummary}_planDetails").html( $("#aol-features > *:not(h5)").clone() );
		$(".${nameSummary}_pricingInfo").html( $("#aol-price-info p, #aol-price-info table").clone() );
		$(".${nameSummary}_termsAndConditions").html( $("#aol-terms > *, #aol-documentation > *").clone() );
		
		utilitiesChoices.parseApplyNowSlide();
		
	},
	
	parseApplyNowSlide : function(){
		
		// DRAFT DATA OBJECT
			var formValues = $("#mainform").serializeObject();
			data = {
				fullName: formValues['${nameApplicationDetails}_title'] + " " + formValues['${nameApplicationDetails}_firstName'] + " " + formValues['${nameApplicationDetails}_lastName'],
				phoneNo: formValues['${nameApplicationDetails}_mobileNumberinput'],
				alternatePhoneNo: formValues['${nameApplicationDetails}_otherPhoneNumberinput'],
				email: formValues['${nameApplicationDetails}_email'],
				dob: formValues['${nameApplicationDetails}_dob'],
				movingDate: formValues['${nameApplicationDetails}_movingDate'],
				medicalRequirements: formValues['${nameApplicationSituation}_medicalRequirements'] == "Y" ? "Yes" : "No",
				hasConcession: formValues['${nameApplicationSituation}_concession_hasConcession'] == "Y" ? "Yes" : "No",
				concessionType: $("#${nameApplicationSituation}_concession_type :selected").text(),
				cardNo: formValues['${nameApplicationSituation}_concession_cardNo'],
				cardStartDate: formValues['${nameApplicationSituation}_concession_cardDateRange_fromDate'],
				cardEndDate: formValues['${nameApplicationSituation}_concession_cardDateRange_toDate'],
				
				address: '',
				billing_address: '',
				
			};
		
		// ADDRESS
			var address = "";
			// if non standard address
			if( $("#${nameApplicationDetails}_address_nonStd").is(":checked") ){
			
				if( formValues['${nameApplicationDetails}_address_unitShop'] != ""){
					address += formValues['${nameApplicationDetails}_address_unitShop'] + "/";
				}
				address += formValues['${nameApplicationDetails}_address_streetNum'] + " ";
				address += formValues['${nameApplicationDetails}_address_nonStdStreet'] + '<br />';
				address += formValues['${nameApplicationDetails}_address_suburbName'] + ", ";
				address += formValues['${nameApplicationDetails}_address_state'] + " ";
				address += formValues['${nameApplicationDetails}_address_postCode'];
				
			// standard address
			} else {
			
				if( formValues['${nameApplicationDetails}_address_unitShop'] != ""){
					address += formValues['${nameApplicationDetails}_address_unitShop'] + "/";
				}
				address += formValues['${nameApplicationDetails}_address_houseNoSel'] + ' ';
				address += formValues['${nameApplicationDetails}_address_streetName'] + '<br />';
				address += formValues['${nameApplicationDetails}_address_suburbName'] + ", ";
				address += formValues['${nameApplicationDetails}_address_state'] + " ";
				address += formValues['${nameApplicationDetails}_address_postCode'];
				
			}
			$.extend(data, {address: address});
		
		// BILLING ADDRESS
			billing_address = "";
			// if same as postal address
			if( $("#${nameApplicationDetails}_postalMatch").is(":checked") ){
			
				billing_address = address;
				
			// if non standard address
			} else if( $("#${nameApplicationDetails}_postal_nonStd").is(":checked") ){
				
				if( formValues['${nameApplicationDetails}_address_unitShop'] != ""){
					address += formValues['${nameApplicationDetails}_address_unitShop'] + "/";
				}
				billing_address += formValues['${nameApplicationDetails}_postal_streetNum'] + " ";
				billing_address += formValues['${nameApplicationDetails}_postal_nonStdStreet'] + '<br />';
				billing_address += formValues['${nameApplicationDetails}_postal_suburbName'] + ", ";
				billing_address += formValues['${nameApplicationDetails}_postal_state'] + " ";
				billing_address += formValues['${nameApplicationDetails}_postal_postCode'];
				
			// standard address
			} else {
				
				if( formValues['${nameApplicationDetails}_postal_unitShop'] != ""){
					address += formValues['${nameApplicationDetails}_postal_unitShop'] + "/";
				}
				billing_address += formValues['${nameApplicationDetails}_postal_houseNoSel'] + ' ';
				billing_address += formValues['${nameApplicationDetails}_postal_streetName'] + '<br />';
				billing_address += formValues['${nameApplicationDetails}_postal_suburbName'] + ", ";
				billing_address += formValues['${nameApplicationDetails}_postal_state'] + " ";
				billing_address += formValues['${nameApplicationDetails}_postal_postCode'];
				
			}
			$.extend(data, {billing_address: billing_address});
		
				
				
		
			
		// PARSE TEMPLATES
			var accountHolderDetailsTemplate = $(".${nameSummary} #account-holder-details-template").html();
			var parsedTemplate = $(parseTemplate( accountHolderDetailsTemplate, data ));
			$(".${nameSummary}_confirmDetails").html( parsedTemplate );
			
			var summaryTextTemplateId = "summary-text-template";
			if($.inArray( utilitiesChoices._product.service, ['ENA', 'DOD']) != -1 ) {
				summaryTextTemplateId += "-"+utilitiesChoices._product.service; 
			}
			var summaryTextTemplate = $( ".${nameSummary} #" + summaryTextTemplateId ).html();
			var parsedTemplate = $(parseTemplate( summaryTextTemplate, {provider: utilitiesChoices._product.provider } ));
			$("#${nameSummary}_summaryText_template_placeholder").html( parsedTemplate );
		
		// HIDE SOME ROWS
			
			if( formValues['${nameApplicationDetails}_movingIn'] == "N" ){
				// hide moving Date
				$(".${nameSummary} .movingDate").hide();
				$(".${nameSummary}_movingIn").hide();
			} else {
				$(".${nameSummary}_transfer").hide();
			}
			
			$(".${nameSummary}_row").each(function(){
				if($(this).children(".right-column").html() == ""){
					$(this).hide();
				}
			});
	},
	
	//return readable values
	returnHowToEstimateClass: function(howToEstimateCode) {
	
		var howToEstimateClass;
		switch(howToEstimateCode){
			case 'S':
				howToEstimateClass = 'spend';
				break;
				
			case 'H':
				howToEstimateClass = 'household';
				break;
				
			case 'U':
				howToEstimateClass = 'usage';
				break;
		}
		
		return howToEstimateClass;
		
	},
	
	returnWhatToCompare: function() {
		return $('#${nameHouseholdDetails}_whatToCompare :checked').next().children('span').html();
	},
	
	returnHowToEstimate: function() {
		return $('#${nameHouseholdDetails}_howToEstimate option:selected').text();		
	}
	
}
</go:script>

<go:script marker="onready">	 
	$.fn.serializeObject = function()
	{
	    var o = {};
	    var a = this.serializeArray();
	    $.each(a, function() {
	        if (o[this.name] !== undefined) {
	            if (!o[this.name].push) {
	                o[this.name] = [o[this.name]];
	            }
	            o[this.name].push(this.value || '');
	        } else {
	            o[this.name] = this.value || '';
	        }
	    });
	    return o;
	};
	
	<%-- Render the initial set and turn on the items --%>
	utilitiesChoices.initialise();
	
	<c:if test="${not empty param.action and param.action == 'latest'}">
		QuoteEngine.gotoSlide({
			index: 1
		});
		setTimeout(function(){UtilitiesQuote.fetchPrices()},3000);
	</c:if>
</go:script>


<%-- CSS --%>
