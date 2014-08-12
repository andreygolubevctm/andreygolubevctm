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
	_located_plans: {
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
		
		$('#${nameHouseholdDetails}_state').on('change', function(){
			utilitiesChoices.showHideShoulder();
		});
		
		$("#${nameHouseholdDetails}_postcode").on('change', function() {
			UtilitiesQuote.getUtilitiesForPostcode( $(this).val(), utilitiesChoices.showHideWhatToCompare );
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
		
		// update the Moving In value on the application slide
		$('input[name=${nameHouseholdDetails}_movingIn]').on('change', function(){
			utilitiesChoices.setMovingIn();
			utilitiesChoices.showHideCurrentProvider();
		});
		utilitiesChoices.setMovingIn();
	
		// init
		utilitiesChoices.showHideQuestionElements();
		utilitiesChoices.showHideShoulder();
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
		
		utilitiesChoices.showHideShoulder();		
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
	
	showHideShoulder: function(){
	
		utilitiesChoices.setState($('#${nameHouseholdDetails}_state').val());
		utilitiesChoices._postcode = $('#${nameHouseholdDetails}_postcode').val();
	
		if(utilitiesChoices._postcode.substring(0,1) == '2' && utilitiesChoices._howToEstimate == 'U' && utilitiesChoices._whatToCompare != 'G'){
			$('#${nameEstimateDetails} .usage .shoulderRow').slideDown();
		}else {
			$('#${nameEstimateDetails} .usage .shoulderRow').slideUp();
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
				if( !utilitiesChoices._loading_providers ) {
					utilitiesChoices._loading_providers = true;
					Loading.show("Loading Providers and Plans");
					var dat = {
						postcode:postcode,
						state:state,
						packagetype:packagetype,
						transactionId:referenceNo.getTransactionID()
					};
					
					$.ajax({
						url: "ajax/json/utilities_get_allretailers.jsp",
						data: dat,
						type: "POST",
						async: true,
						dataType: "json",
						timeout:30000,
						cache: false,
						success: function(json){
							utilitiesChoices._loading_providers = false;
							Loading.hide();
							if( typeof json.results.electricity == "object") {
								var eProviders = utilitiesChoices.normaliseProvidersObj(json.results.electricity.providers);
								utilitiesChoices.renderProviderList(eProviders, 'Electricity', state, selected_e);
							}
							if( typeof json.results.gas == "object") {
								var gProviders = utilitiesChoices.normaliseProvidersObj(json.results.gas.providers)
								utilitiesChoices.renderProviderList(gProviders, 'Gas', state, selected_g);
							}
							
							if( typeof callback == "function" ) {
								callback();
							}
						},
						error: function(obj,txt,errorThrown){
							utilitiesChoices._loading_providers = false;
							Loading.hide();
							if( typeof callback == "function" ) {
								callback();
							}
							FatalErrorDialog.exec({
								message:		"Error retrieving list of retailers.",
								page:			"utilities:choices.tag",
								description:	"utilitiesChoices.updateProviderSelects(). AJAX request failed: " + txt + " " + errorThrown,
								data:			dat
							});
						}
					});
				}
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
	
	updateProductSelects: function( utility ) {

		switch(utility) {
			case "Electricity":
			case "Gas":
				var postcode = utilitiesChoices._postcode;
				var state = utilitiesChoices._state;
				var packagetype = utilitiesChoices._whatToCompare;
				var retailerid = $("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentSupplier").val();
				var selected = $("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentProductSelected").val();
				if( $("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentProduct").find(":selected") ) {
					selected = $("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentProduct").find(":selected").val();
				}
				
				$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentPlan").empty();	
				
				if( utilitiesChoices._located_plans[utility.toLowerCase()].hasOwnProperty(state + retailerid) ) {
					utilitiesChoices.renderProductList(utilitiesChoices._located_plans[utility.toLowerCase()][state + retailerid], utility, state, retailerid, selected);
				} else {	
					if( !utilitiesChoices._loading_plans ) {
						utilitiesChoices._loading_plans = true;
						var dat = {
							retailerid:retailerid,
							postcode:postcode,
							state:state,
							packagetype:utility,
							transactionId:referenceNo.getTransactionID()
						};
						$.ajax({
							url: "ajax/json/utilities_get_allproducts.jsp",
							data: dat,
							type: "POST",
							async: true,
							dataType: "json",
							timeout:30000,
							cache: false,
							success: function(json){
								utilitiesChoices._loading_plans = false;						
								utilitiesChoices.renderProductList(json.results[utility.toLowerCase()], utility, state, retailerid, selected);
							},
							error: function(obj,txt,errorThrown){			
								utilitiesChoices._loading_plans = false;
											
								// Insurance against people who click too much
								$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentPlan").empty();
								
								FatalErrorDialog.exec({
									message:		"Error retrieving list of retailers plans.",
									page:			"utilities:choices.tag",
									description:	"utilitiesChoices.updateProductSelects(). AJAX request failed: " + txt + " " + errorThrown,
									data:			dat
								});
							}
						});
					}
				}
				break;
				
			default:
				// ignore
		}
	},
	
	normaliseProvidersObj : function( providersObj ) {
		var providers = [];
		for(var i = 0; i < providersObj.length; i++) {
			providers.push( providersObj[i].provider );
		}
		
		return providers;
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
					$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentSupplier").append("<option value='" + options[i].RetailerId + "' " + (selected == options[i].RetailerId ? "selected='true'" : "") + ">" + options[i].Name + "</option>");
				}
			}
			$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentSupplier").on("change", function(){
				utilitiesChoices.updateProductSelects(utility);
			});
			
			if( selected ) {
				utilitiesChoices.updateProductSelects(utility);
			}
		}
	},
	
	renderProductList: function(list, utility, state, retailerid, selected) {					
		// Insurance against people who click too much
		$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentPlan").empty();
		
		if(typeof list == "object") {
			utilitiesChoices._located_plans[utility.toLowerCase()][state + retailerid] = list;
			var options = utilitiesChoices._located_plans[utility.toLowerCase()][state + retailerid];
			
			for(var i = 0; i < utilitiesChoices.getOptionsLength(options); i++) {
				if(options.hasOwnProperty(i)) {
					$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentPlan").append("<option value='" + options[i].ProductCode + "' " + (selected == options[i].ProductCode ? "selected='true'" : "") + ">" + options[i].Title + "</option>");
				}
			}
			
			if( $.browser.msie ) {
				var util = utility.toLowerCase();
				$("#utilities_estimateDetails_usage_" + util + "_currentPlan").on("focus", function(){
					$(this).css({width:'auto'});
					if( $(this).width() < 185 ) {
						$(this).css({width:'185px'});
					}
				});
				$("#utilities_estimateDetails_usage_" + util + "_currentPlan").on("blur", function(){
					$(this).css({width:'185px'});
				});
				$("#utilities_estimateDetails_usage_" + util + "_currentPlan option").on("click", function(){
					$(this).css({width:'185px'});
				});
			}

			if( utilitiesChoices._has_bill === false ) {
				$("#utilities_estimateDetails_usage_" + utility.toLowerCase() + "_currentPlan").val("ignore");
		}

			utilitiesChoices.showHideCurrentPlans();

			utilitiesChoices.showHidePlanHelpText();
		}
	},
	
	setEmail: function(){
		$('#${nameApplicationDetails}_email').val( $('#${nameResultsDisplayed}_email').val() );
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
		
		$("#${nameApplicationThingsToKnow}_hidden_productId").val(utilitiesChoices._product.productId);
		$("#${nameApplicationThingsToKnow}_hidden_searchId").val(utilitiesChoices._product.searchId);
		$("#${nameApplicationDetails}_address_postCode").val( $('#${nameHouseholdDetails}_postcode').val() );
		$("#${nameApplicationDetails}_address_postCode").change();
		$("#${nameApplicationDetails}_address_state").val( $('#${nameHouseholdDetails}_state').val() );
		
		// parse selected product
		utilitiesChoices.parseSelectedProduct();
		
		// update moving date datepicker minDate with the retailer's business days notice
		utilitiesChoices.updateMovingDateMinimum();
		
		// show/hide payment information (only for DODO)
		utilitiesChoices.showHidePaymentInformation();
		
		// show/hide option fields/fieldset
		utilitiesChoices.showHideOptions();
		
		// show/hide identification fields
		utilitiesChoices.showHideIdentificationFields();
		
		// isPowerOn
		utilitiesChoices.showHideisPowerOn();
		
		// password question and password answer for Alinta
		// @todo ?
		
		// some providers require more validation
		utilitiesChoices.addRemoveValidationRules();
		
		// display the provider name in the terms and conditions checkboxes
		utilitiesChoices.parseApplicationSlide();
		
		$(".providerName").html(utilitiesChoices._product.provider);
	},
	
	parseSelectedProduct: function(){
		var selectedProductTemplate = $("#selected-product-template").html();
		var parsedTemplate = $(parseTemplate( selectedProductTemplate, utilitiesChoices._product ));
		
		$(".selectedProduct").html( parsedTemplate );
		
		if(utilitiesChoices._product.info.GreenPercent == 0){
			$(".selectedProduct .green_percent").html("");
		}
		
		if($("#${nameApplicationDetails}_movingIn :checked").val() == 'Y'){
			$('.selectedProductTable .estSavings').hide();
		} else {
			$('.selectedProductTable .estSavings').show();
		}
		
		Results.negativeValues(utilitiesChoices._product.info.EstimatedSavingText, $(".estSavingsCell"), 'extra' );
	},
	
	updateMovingDateMinimum: function() {
		
		var providerCode = utilitiesChoices._product.service;
		<%-- set min date --%>
		UtilitiesQuote.getMoveInAvailability(providerCode, utilitiesChoices._state, function(moveInAvailability){
			var moveInDate = moveInAvailability.MoveInDate.split("-");
			var minDate = new Date(moveInDate[0],moveInDate[1]-1,moveInDate[2]);
			$("#${nameApplicationDetails}_movingDate").datepicker('option', 'minDate', minDate);
			
			// PARSE MOVE IN DETAILS
			var moveInDetailsTemplate = $("#${nameApplicationDetails} #move-in-details-template").html();
			var parsedTemplate = $(parseTemplate( moveInDetailsTemplate, {business_days: moveInAvailability.MoveInBusinessDayNotice-1} ));
			$("#${nameApplicationDetails}_moveInDetails_placeholder").html( parsedTemplate );
		});
		
		<%-- Disable public holidays --%>
		var today = new Date();
		today = today.getDate() + "/" + (today.getMonth()+1) + "/" + today.getFullYear();

		var datepicker = $("#utilities_application_details_movingDate").data("datepicker");
		var maxDateAttr = $("#utilities_application_details_movingDate").datepicker("option", "maxDate");
		var maxDate = $.datepicker._determineDate(datepicker, maxDateAttr, new Date());
		maxDate = maxDate.getDate() + "/" + (maxDate.getMonth()+1) + "/" + maxDate.getFullYear();

		var params = {country: "Australia", region: utilitiesChoices._state, fromDate: today, toDate: maxDate, format: "dates"};

		UtilitiesQuote.getPublicHolidays(params, function(publicHolidays){
			${nameApplicationDetails}_movingDateHandler._publicHolidays = publicHolidays;
			$("#${nameApplicationDetails}_movingDate").datepicker('option', 'beforeShowDay', ${nameApplicationDetails}_movingDateHandler.isNotWeekendAndNotPublicHoliday);
			$("#${nameApplicationDetails}_movingDate").rules("add",{
				"${nameApplicationDetails}_movingDatenotPublicHolidays": true,
				messages: {
					"${nameApplicationDetails}_movingDatenotPublicHolidays": "The moving date has to be a business day (i.e. not a public holiday)"
				}
			});
		});
	},
	
	showHidePaymentInformation: function(){

		// 2 options on how to determine if we should show the payment information fieldset
		// second option preferred until the payment information fielset's text is less Dodo specific 
		
		// if the payment information flag is on
			/*
			if( utilitiesChoices._product.info.PaymentInformationRequired == true){
				// show fields
				$('#${nameApplicationPaymentInformation}_fieldset').show();
			} else {
				// hide fields
				$('#${nameApplicationPaymentInformation}_fieldset').hide();
			}
			*/
		
		// if the provider code is part of the list of providers listed in the API
			if(utilitiesChoices._product.service == 'DOD'){
				// show fields
				$('#${nameApplicationPaymentInformation}_fieldset').show();
			} else {
				// hide fields
				$('#${nameApplicationPaymentInformation}_fieldset').hide();
			}
	},
	
	showHideOptions: function(){
		
		// Direct Debit
		if( utilitiesChoices._product.info.HasAddOnFeature == true && utilitiesChoices._product.service != 'AGL' ) {
			$('#${nameApplicationOptions}_directDebitRow').show();
			$("#${nameApplicationThingsToKnow}_hidden_directDebitRequired").val('Y');
			
			// trigger change events for preload
			$('#${nameApplicationOptions}_directDebit').trigger('change');
			$('#${nameApplicationOptions}_paymentSmoothing').trigger('change');
		} else {
			$('#${nameApplicationOptions}_directDebitRow').hide();
			$("#${nameApplicationThingsToKnow}_hidden_directDebitRequired").val('N');
		}
		
		// Electronic Bill
		if( utilitiesChoices._product.info.HasAddOnFeature == true ) {
			$('#${nameApplicationOptions}_electronicBillRow').show();
			$("#${nameApplicationThingsToKnow}_hidden_electronicBillRequired").val('Y');
		} else {
			$('#${nameApplicationOptions}_electronicBillRow').hide();
			$("#${nameApplicationThingsToKnow}_hidden_electronicBillRequired").val('N');
		}
		
		// Electronic Communication
		if( utilitiesChoices._product.info.HasAddOnFeature == true && $.inArray(utilitiesChoices._product.service, ['AGL', 'ALN']) == -1 ) {
			$('#${nameApplicationOptions}_electronicCommunicationRow').show();
			$("#${nameApplicationThingsToKnow}_hidden_electronicCommunicationRequired").val('Y');
		} else {
			$('#${nameApplicationOptions}_electronicCommunicationRow').hide();
			$("#${nameApplicationThingsToKnow}_hidden_electronicCommunicationRequired").val('N');
		}
		
		// Bill Delivery Method
		if( utilitiesChoices._product.service == 'APG' ) {
			$('#${nameApplicationOptions}_billDeliveryMethodRow').show();
			$("#${nameApplicationThingsToKnow}_hidden_billDeliveryMethodRequired").val('Y');
		} else {
			$('#${nameApplicationOptions}_billDeliveryMethodRow').hide();
			$("#${nameApplicationThingsToKnow}_hidden_billDeliveryMethodRequired").val('N');
		}
		
		// Fieldset (at least one of the fields above will be displayed when fulfilling the below conditions, so we display the fieldset)
		if( utilitiesChoices._product.info.HasAddOnFeature == true || utilitiesChoices._product.service == 'APG' ) {
			$('#${nameApplicationOptions}').show();
		} else {
			$('#${nameApplicationOptions}').hide();
		}
		
	},
	
	showHideIdentificationFields: function(){
	
		// 2 options on how to determine if we should show the identifications fields
		
		// if the identification flag is on
			if( utilitiesChoices._product.info.IdentificationRequired == true){
				// show fields
				$('#${nameApplicationSituation} #identificationSection').show();
				$("#${nameApplicationThingsToKnow}_hidden_identificationRequired").val('Y');
			} else {
				// hide fields
				$('#${nameApplicationSituation} #identificationSection').hide();
				$("#${nameApplicationThingsToKnow}_hidden_identificationRequired").val('N');
			}
		
		// if the provider code is part of the list of providers listed in the API
			/*
			var provider = utilitiesChoices._product.service;
			var identificationProviders = ['ATW','TRU','AGL','PWD','DOD','ALN'];
			
			if( $.inArray(provider, identificationProviders) != -1){
				// show fields
				$('#${nameApplicationSituation} #identificationSection').show();
				$("#${nameApplicationThingsToKnow}_hidden_identificationRequired").val('Y');
			}else{
				// hide fields
				$('#${nameApplicationSituation} #identificationSection').hide();
				$("#${nameApplicationThingsToKnow}_hidden_identificationRequired").val('N');
			}
			*/
		
	},
	
	showHideisPowerOn: function(){
		var qldExcludeExceptions = ['ORG', 'CLK'];
		var generalExceptions = ['POS'];
		
		var isQldException = (utilitiesChoices._state == "QLD" && $.inArray(utilitiesChoices._product.service, qldExcludeExceptions) == -1);
		var isGeneralException = $.inArray(utilitiesChoices._product.service, generalExceptions) > -1;
		
		if( (isQldException || isGeneralException)
			&& $.type(utilitiesChoices._whatToCompare) != "undefined"
			&& utilitiesChoices._whatToCompare.indexOf("E") != -1
			&& $("#${nameApplicationDetails}_movingIn :checked").val() == "Y" ){
			
			$('#${nameApplicationDetails} #noVisualInspectionAppointmentContainer').slideUp("fast", function(){
				// hack, sometimes the slideUp does not work for some reason
				$('#noVisualInspectionAppointmentContainer').hide();
			});
			$('#isPowerOnContainer').slideDown();
			$("#${nameApplicationThingsToKnow}_hidden_isPowerOnRequired").val('Y');
			
			// Remove the isPowerOn event handler if not QLD to prevent a bug
			// where choosing a QLD property first and then returning to choose
			// a property from another state makes the animation fire
			if(!isQldException) {
				$('#${nameApplicationDetails}_isPowerOn').off('change');
			}

			// if yes, then display VisualInspectionAppointment
			$('#${nameApplicationDetails}_isPowerOn').on('change', function(){
				var $appointmentContainer = $('#visualInspectionAppointmentContainer');

				if($('#${nameApplicationDetails}_isPowerOn :checked').val() == 'N' && isQldException){
						$appointmentContainer.find('.appointmentText.qld').show();
					$appointmentContainer.slideDown();
				}else{
					$appointmentContainer.slideUp(400, function() {
						$appointmentContainer.find('.appointmentText').hide();
			});
				}
			});
			$('#${nameApplicationDetails}_isPowerOn').trigger('change');
			
		}else{
			if( utilitiesChoices._state == "QLD"
				&& $.type(utilitiesChoices._whatToCompare) != "undefined"
				&& utilitiesChoices._whatToCompare.indexOf("E") != -1
				&& $("#${nameApplicationDetails}_movingIn :checked").val() == "Y"){
				$('#noVisualInspectionAppointmentContainer').slideDown("fast", function(){
					// hack, sometimes the slideDown does not work for some reason
					$('#noVisualInspectionAppointmentContainer').show();
				});
			} else {
				$('#noVisualInspectionAppointmentContainer').slideUp("fast", function(){
					// hack, sometimes the slideUp does not work for some reason
					$('#noVisualInspectionAppointmentContainer').hide();
				});
			}
			$('#visualInspectionAppointmentContainer').hide();
			$('#isPowerOnContainer').hide();
			$("#${nameApplicationThingsToKnow}_hidden_isPowerOnRequired").val('N');
			
		}
		
	},
	
	showHideLifeSupport: function(){
	
		var lifeSupportProviders = ['ATW','NGB','ALN'];
		var isActive = utilitiesChoices.showHideMedicalRequirementsOption( lifeSupportProviders, 'LS' );
		$("#${nameApplicationThingsToKnow}_hidden_lifeSupportRequired").val(isActive);
		
	},
	
	showHideMultipleSclerosis: function(){
		
		var multipleSclerosisProviders = ['ATW','NGB'];
		var isActive = utilitiesChoices.showHideMedicalRequirementsOption( multipleSclerosisProviders, 'MS' );
		$("#${nameApplicationThingsToKnow}_hidden_multipleSclerosisRequired").val(isActive);
		
	},
	
	showHideMedicalRequirementsOption: function(providersArray, optionValue){
	
		var provider = utilitiesChoices._product.service;
		var active;
		
		var medicalRequirementsSelectName = "#${nameApplicationSituation}_medicalRequirements";
		var medicalRequirementsSelect = $(medicalRequirementsSelectName);
		var option = medicalRequirementsSelect.find('option[value="'+optionValue+'"]');
		
		if( $.inArray(provider, providersArray) == -1 ){
			
			if(option.attr('selected') == 'selected'){
				option.removeAttr('selected');
				$(medicalRequirementsSelectName+'_').attr('selected', 'selected');
			}
			
			option.hide();
			active = 'N';
			
		} else {
			option.show();
			active = 'Y';
		}
		
		return active;
		
	},
	
	addRemoveValidationRules: function(){
		
		if(utilitiesChoices._product.service == 'DOD' || utilitiesChoices._product.service == 'ENA'){
			// some more validation on phone numbers for Dodo and Energy Australia (they request to have the 2 of them)
			$('#${nameApplicationDetails}_mobileNumberinput').rules("remove", "validateMobileField");
			$('#${nameApplicationDetails}_mobileNumberinput').attr( "required", "required" )
			$('#${nameApplicationDetails}_otherPhoneNumberinput').attr( "required", "required" )
		} else {
			$('#${nameApplicationDetails}_mobileNumberinput').rules("add", "validateMobileField");
			$('#${nameApplicationDetails}_mobileNumberinput').removeAttr("required" )
			$('#${nameApplicationDetails}_otherPhoneNumberinput').removeAttr("required" )
		}
	},
	
	parseApplicationSlide: function(){
		
		// PREPARE THE DATA
			var provider = utilitiesChoices._product.service;
			
			var data = {
				selected_utilities: utilitiesChoices.returnWhatToCompare(),
				provider_name: utilitiesChoices._product.provider,
				switchwise_t_and_c: 'http:/www.switchwise.com/tandc',
				switchwise_privacy_policy: 'http:/www.switchwise.com/privacy'
			}
			
		// SITUATION FIELDSET
			var concessionCheckboxTemplate = $("#${nameApplicationSituation} #concession-checkbox-template").html();
			var parsedTemplate = $(parseTemplate( concessionCheckboxTemplate, data ));
			$("#${nameApplicationSituation}_concession_placeholder").html( parsedTemplate );
			
		// PAYMENT INFORMATION FIELDSET
			if(utilitiesChoices._product.service == 'DOD'){
				// @todo = calculate the estimated costs / 12 (est cost can be a single price or a range of prices)
				var monthlyEstCost = Math.round(utilitiesChoices._product.price.Maximum / 12);
			
				var paymentInformationTemplate = $("#${nameApplicationPaymentInformation} #payment-information-template").html();
				var parsedTemplate = $(parseTemplate( paymentInformationTemplate, {monthlyEstCost: monthlyEstCost} ));
				$("#${nameApplicationPaymentInformation}_template_placeholder").html( parsedTemplate );
			}
			
		// PAYMENT DETAILS FOR ALINTA
			if(utilitiesChoices._product.service == 'ALN'){
				
				UtilitiesQuote.getEnergyProfile(utilitiesChoices._product.searchId, function(energyProfile){
				
					var firstInstalmentsText = "";
					
					if(utilitiesChoices._whatToCompare == "E"){
						firstInstalmentsText = "$" + Math.round(energyProfile.costrange.maximum / 12);
					} else if (utilitiesChoices._whatToCompare == "G") {
						firstInstalmentsText = "$" + Math.round(energyProfile.gascostrange.maximum / 12);
					} else if (utilitiesChoices._whatToCompare == "EG") {
						firstInstalmentsText = "$" + Math.round( (energyProfile.costrange.maximum - energyProfile.gascostrange.maximum) / 12) + " for electricity and $" + Math.round(energyProfile.gascostrange.maximum / 12) + " for gas";
					}
					
					var paymentDetailsTemplate = $("#${nameApplicationOptions} #payment-details-template").html();
					var parsedTemplate = $(parseTemplate( paymentDetailsTemplate, {firstInstalmentsText: firstInstalmentsText}));
					$("#${nameApplicationOptions}_payment_details_placeholder").html( parsedTemplate );
				});
				
			}
		
		// THINGS TO KNOW FIELDSET
			var thingsToKnowTemplate = $("#${nameApplicationThingsToKnow} #things-to-know-template").html();
			var parsedTemplate = $(parseTemplate( thingsToKnowTemplate, data ));
			
			if( utilitiesChoices._movingIn == "Y" ){
				parsedTemplate.find('#${nameApplicationThingsToKnow}_transferChkTransferTitle').hide();
			} else {
				parsedTemplate.find('#${nameApplicationThingsToKnow}_transferChkMoveInTitle').hide();
			}
			
			$("#${nameApplicationThingsToKnow}_template_placeholder").html( parsedTemplate );
		
			<%-- if Click Energy, add some text to the terms and conditions checkbox --%>
			if(utilitiesChoices._product.service == "CLK"){
				var termsText = " I understand that the due date on my Click Energy bills will be ";
				<%-- if NSW, 13 days --%>
				if(utilitiesChoices._state == "NSW"){
					termsText += "13 days";
				<%-- if QLD or VIC, 3 business days --%>
				} else {
					termsText += "3 business days";
				}
				termsText += " from the date the bill is issued.";
				
				var termsCheckbox = $("label[for=${nameApplicationThingsToKnow}_providerTermsAndConditions]");
				termsCheckbox.html(termsCheckbox.html() + termsText);
			<%-- if Red Energy, add some text to the terms and conditions checkbox --%>
			} else if (utilitiesChoices._product.service == "RED") {
				var termsText = " I understand and accept that " + utilitiesChoices._product.provider + " will perform a credit check in assessing my application.";
				var termsCheckbox = $("label[for=${nameApplicationThingsToKnow}_providerTermsAndConditions]");
				termsCheckbox.html(termsCheckbox.html() + termsText);
			}
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
				
				medicalRequirementsType: '',
				identificationType: '',
				identificationNo: '',
				issuedFrom: '',
				isPowerOn: '',
				directDebit: '',
				electronicBill: '',
				electronicCommunication: '',
				billDeliveryMethod: ''
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
		
		// IDENTIFICATION
			if( formValues['${nameApplicationThingsToKnow}_hidden_identificationRequired'] == "Y"){
				// ID type
				var identificationType = $('#${nameApplicationSituation}_identification_idType :selected').text();
				$.extend(data, {identificationType: identificationType});
				
				// ID No
				var identificationNo = formValues['${nameApplicationSituation}_identification_idNo'];
				$.extend(data, {identificationNo: identificationNo});
				
				// Issued from
				var issuedFrom = "";
				if( formValues['${nameApplicationSituation}_identification_idType'] == "DriversLicence" ){
					//state
					issuedFrom = formValues['${nameApplicationSituation}_identification_state'];
				} else if( formValues['${nameApplicationSituation}_identification_idType'] == "Passport" ){
					// country
					issuedFrom = $("#${nameApplicationSituation}_identification_country :selected").text();
				}
				$.extend(data, {issuedFrom: issuedFrom});
			}
		
		// MEDICAL 
			if( formValues['${nameApplicationSituation}_medicalRequirements'] == "Y" ){
				var medical = new Array();
				if( formValues['${nameApplicationSituation}_lifeSupport'] == "Y" ){
					medical.push("Life Support");
				}
				if( formValues['${nameApplicationSituation}_multipleSclerosis'] == "Y" ){
					medical.push("Multiple Sclerosis");
				}
				var medicalRequirementsType = medical.join("<br/>");
				$.extend(data, {medicalRequirementsType: medicalRequirementsType});
			}
			
		// IS POWER ON
			if( formValues['${nameApplicationThingsToKnow}_hidden_isPowerOnRequired'] == "Y"){
				var isPowerOn = formValues['${nameApplicationDetails}_isPowerOn'] == "Y" ? "Yes" : "No";
				$.extend(data, {isPowerOn: isPowerOn});
			}
		
		// DIRECT DEBIT
			if( formValues['${nameApplicationThingsToKnow}_hidden_directDebitRequired'] == "Y"){
				var directDebit = formValues['${nameApplicationOptions}_directDebit'] == "Y" ? "Yes" : "No";
				$.extend(data, {directDebit: directDebit});
			}
			
		// ELECTRONIC BILL
			if( formValues['${nameApplicationThingsToKnow}_hidden_electronicBillRequired'] == "Y"){
				var electronicBill = formValues['${nameApplicationOptions}_electronicBill'] == "Y" ? "Yes" : "No";
				$.extend(data, {electronicBill: electronicBill});
			}
			
		// ELECTRONIC COMMUNICATION
			if( formValues['${nameApplicationThingsToKnow}_hidden_electronicCommunicationRequired'] == "Y"){
				var electronicCommunication = formValues['${nameApplicationOptions}_electronicCommunication'] == "Y" ? "Yes" : "No";
				$.extend(data, {electronicCommunication: electronicCommunication});
			}
		
		// BILL DELIVERY METHOD
			if( formValues['${nameApplicationThingsToKnow}_hidden_billDeliveryMethodRequired'] == "Y"){
				var billDeliveryMethod = formValues['${nameApplicationOptions}_billDeliveryMethod'];
				$.extend(data, {billDeliveryMethod: billDeliveryMethod});
			}
		
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
			if( formValues['${nameApplicationThingsToKnow}_hidden_identificationRequired'] == "N"){
				// hide identification fields
				$(".${nameSummary} .identification").hide();
			}
			if( formValues['${nameApplicationSituation}_concession_hasConcession'] == "N" ||
				(formValues['${nameApplicationSituation}_concession_hasConcession'] == "Y" && utilitiesChoices._state == 'SA')){
				// hide concession fields
				$(".${nameSummary} .concession").hide();
			}
			if( formValues['${nameApplicationSituation}_medicalRequirements'] == "N" ){
				// hide medicalRequirementsType
				$(".${nameSummary} .medicalRequirements").hide();
			}
			if( formValues['${nameApplicationThingsToKnow}_hidden_isPowerOnRequired'] == "N"){
				// hide isPowerOn field
				$(".${nameSummary} .isPowerOn").hide();
			}
			if( formValues['${nameApplicationThingsToKnow}_hidden_directDebitRequired'] == "N"){
				// hide direct debit field
				$(".${nameSummary} .directDebit").hide();
			}
			if( formValues['${nameApplicationThingsToKnow}_hidden_electronicBillRequired'] == "N"){
				// hide electronic bill field
				$(".${nameSummary} .electronicBill").hide();
			}
			if( formValues['${nameApplicationThingsToKnow}_hidden_electronicCommunicationRequired'] == "N"){
				// hide electronic communication field
				$(".${nameSummary} .electronicCommunication").hide();
			}
			if( formValues['${nameApplicationThingsToKnow}_hidden_billDeliveryMethodRequired'] == "N"){
				// hide bill delivery method fields
				$(".${nameSummary} .billDeliveryMethod").hide();
			}
			if( formValues['${nameApplicationDetails}_movingIn'] == "N" ){
				// hide moving Date
				$(".${nameSummary} .movingDate").hide();
				$(".${nameSummary}_movingIn").hide();
			} else {
				$(".${nameSummary}_transfer").hide();
			}
			if( formValues['${nameApplicationSituation}_identification_idType'] == "Medicare"){
				// hide Issued From if ID type is Medicare
				$(".${nameSummary} .issuedFrom").hide();
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
