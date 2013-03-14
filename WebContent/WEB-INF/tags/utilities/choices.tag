<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpathHouseholdDetails" 			required="true" rtexprvalue="true" description="Household Details field group's xpath" %>
<%@ attribute name="xpathEstimateDetails"			required="true"	rtexprvalue="true" description="Estimate Details field group's xpath" %>
<%@ attribute name="xpathResultsDisplayed"			required="true"	rtexprvalue="true" description="Results Displayed field group's xpath" %>
<%@ attribute name="xpathApplicationDetails" 		required="true" rtexprvalue="true" description="Application Details field group's xpath" %>
<%@ attribute name="xpathApplicationSituation"		required="true"	rtexprvalue="true" description="Application Situation field group's xpath" %>
<%@ attribute name="xpathApplicationThingsToKnow"	required="true"	rtexprvalue="true" description="Application Things To Know field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="nameHouseholdDetails" 			value="${go:nameFromXpath(xpathHouseholdDetails)}" />
<c:set var="nameEstimateDetails" 			value="${go:nameFromXpath(xpathEstimateDetails)}" />
<c:set var="nameResultsDisplayed" 			value="${go:nameFromXpath(xpathResultsDisplayed)}" />
<c:set var="nameApplicationDetails" 		value="${go:nameFromXpath(xpathApplicationDetails)}" />
<c:set var="nameApplicationSituation" 		value="${go:nameFromXpath(xpathApplicationSituation)}" />
<c:set var="nameApplicationThingsToKnow" 	value="${go:nameFromXpath(xpathApplicationThingsToKnow)}" />

<%-- PARAM VALUES --%>
<c:set var="whatToCompare" value="${data[xpathHouseholdDetails].whatToCompare}" />
<c:set var="howToEstimate" value="${data[xpathEstimateDetails].howToEstimate}" />

<%-- Javascript object for holding users criteria --%>
<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var utilitiesChoices = new Object();
utilitiesChoices = {
	_slideFieldsets: true,
	_state : '',
	_whatToCompare : '',
	_howToEstimate : '',
	
	_product: false,
	
	_located_providers: {},
	_located_plans: {},
	
	// ajaxLimiters
	_loading_providers: false,
	_loading_plans: false,
	
	initialise : function() {
		
		// track changes
		$('#${nameHouseholdDetails}_whatToCompare, #${nameHouseholdDetails}_howToEstimate, #${nameHouseholdDetails}_state').on('change', function(){
			utilitiesChoices.showHideQuestionElements();
		});
		
		$('#${nameHouseholdDetails}_state').on('change', function(){
			utilitiesChoices.showHideShoulder();
		});
		
		$("#${nameHouseholdDetails}_postcode").on('change', function() {
			UtilitiesQuote.getUtilitiesForPostcode( $(this).val(), function(validUtilities) {
				utilitiesChoices.showHideWhatToCompare(validUtilities);
			});
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
				
		$.each(validUtilities, function(key, utility){
			utilityCode = utility.replace(/[a-z]/g, '');
			$('#${nameHouseholdDetails}_whatToCompare_'+utilityCode).button("enable");
		});
		
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
		
		utilitiesChoices.updateProviderSelects(function() {
		
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
		});
		
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
	
		if(utilitiesChoices._state == 'NSW' && utilitiesChoices._howToEstimate == 'U' && utilitiesChoices._whatToCompare != 'G'){
			$('#${nameEstimateDetails} .usage .shoulderRow').slideDown();
		}else {
			$('#${nameEstimateDetails} .usage .shoulderRow').slideUp();
		}
		
	},
	
	showHideCurrentProvider: function(){
	
		// if Usage is selected, then display fields about their current provider
		/*
		if(utilitiesChoices._howToEstimate == 'U' && utilitiesChoices._state != ''){
			// @todo=fill the providers select inputs (electricity and/or gas) with retailers from this state through ajax
			$('#${nameEstimateDetails} .currentProviderContainer').slideDown();
		}else{
			$('#${nameEstimateDetails} .currentProviderContainer').slideUp();
		}
		
	},
	
	updateProviderSelects: function( callback ) {
		
		$("#utilities_estimateDetails_usage_electricity_currentSupplier").empty();
		$("#utilities_estimateDetails_usage_gas_currentSupplier").empty();
		$("#utilities_estimateDetails_usage_electricity_currentPlan").empty();
		$("#utilities_estimateDetails_usage_gas_currentPlan").empty();
			
		if( utilitiesChoices._whatToCompare != '' && utilitiesChoices._howToEstimate == 'U' && utilitiesChoices._state != ''){
			
			var state = utilitiesChoices._state;
			var postcode = utilitiesChoices._postcode;
			var packagetype = utilitiesChoices._whatToCompare;
			var selected_e = $("#utilities_estimateDetails_usage_electricity_currentSupplierSelected").val();
			var selected_g = $("#utilities_estimateDetails_usage_gas_currentSupplierSelected").val();
		
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
					var dat = {postcode:postcode,state:state,packagetype:packagetype};
					$.ajax({
						url: "ajax/json/utilities_get_allretailers.jsp",
						data: dat,
						type: "POST",
						async: true,
						dataType: "json",
						timeout:20000,
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
						var dat = {retailerid:retailerid,postcode:postcode,state:state,packagetype:utility};
						$.ajax({
							url: "ajax/json/utilities_get_allproducts.jsp",
							data: dat,
							type: "POST",
							async: true,
							dataType: "json",
							timeout:20000,
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
		}
	},
	
	setEmail: function(){
		$('#${nameApplicationDetails}_email').val( $('#${nameResultsDisplayed}_email').val() );
	},
	
	setMovingIn: function(){
		$('#${nameApplicationDetails}_movingIn').val( $('#${nameHouseholdDetails}_movingIn :checked').val() ).trigger('change');
	},
	
	setProduct: function(product){
		
		// @todo = use  the real Results data
		//utilitiesChoices._product = Results.getSelectedProduct();
		utilitiesChoices._product = {
			id: 1337,
			searchId: 42,
			provider: 'MY FAKE PROVIDER'
		};
		
		utilitiesChoices.updateApplicationSlide();
		
	},
	
	updateApplicationSlide: function(){
	
		// @todo = replace path to the id and search id once Results are loaded properly
		$("#${nameApplicationThingsToKnow} #${nameApplicationThingsToKnow}_hidden_productId").val(utilitiesChoices._product.id);
		$("#${nameApplicationThingsToKnow} #${nameApplicationThingsToKnow}_hidden_searchId").val(utilitiesChoices._product.searchId);
		
		$("#${nameApplicationThingsToKnow} #${nameApplicationThingsToKnow}_hidden_productId").val(utilitiesChoices._product.productId);
		$("#${nameApplicationThingsToKnow} #${nameApplicationThingsToKnow}_hidden_searchId").val(utilitiesChoices._product.searchId);
		
		// update moving date datepicker minDate with the retailer's business days notice
		utilitiesChoices.updateMovingDateMinimum();
		
		// show/hide identification fields
		utilitiesChoices.showHideIdentificationFields();
		
		// isPowerOff for APG in QLD only
		utilitiesChoices.showHideIsPowerOff();
		
		// password question and password answer for Alinta
		// @todo ?
		
		// display the provider name in the terms and conditions checkboxes
		utilitiesChoices.parseApplicationSlide();
		
	},
	
	updateMovingDateMinimum: function() {
		
		var providerCode = utilitiesChoices._product.service;
		UtilitiesQuote.getProviderBusinessDaysNotice(providerCode, function(nbBusinessDays){
			var minDate = new Date();
			// BasicDateHandler.AddBusinessDays() is part of the field:basic_date tag
			var weekDays = BasicDateHandler.AddBusinessDays(nbBusinessDays);
			minDate.setDate(minDate.getDate() + weekDays);
			$("#${nameApplicationDetails}_movingDate").datepicker('option', 'minDate', minDate);
		});
		
	},
	
	showHideIdentificationFields: function(){
	
		// @todo = point to the right path once the real Results are going to be loaded
		var provider = utilitiesChoices._product.provider;
	
		var identificationProviders = ['ATW','TRU','AGL','PWD','DOD','ALN'];
		
		// if the identification flag is on
			if( utilitiesChoices._product.info.IdentificationRequired == true){
				// show fields
				$('#${nameApplicationSituation} #identificationSection').show();
			} else {
				// hide fields
				$('#${nameApplicationSituation} #identificationSection').hide();
			}
		
		// if the provider code is part of the list of providers listed in the API
			/*
			var provider = utilitiesChoices._product.service;
			var identificationProviders = ['ATW','TRU','AGL','PWD','DOD','ALN'];
			
			if( $.inArray(provider, identificationProviders) != -1){
				// show fields
				$('#${nameApplicationSituation} #identificationSection').show();
			}else{
				// hide fields
				$('#${nameApplicationSituation} #identificationSection').hide();
			}
			*/
		
	},
	
	showHideIsPowerOff: function(){
	
		var provider = utilitiesChoices._product.service;
		
		if(provider == 'APG' && $('#${nameHouseholdDetails}_state').val() == 'QLD' ){
			
			$('#${nameApplicationDetails} #isPowerOffContainer').slideDown();
			
			// if yes, then display VisualInspectionAppointment
			$('#${nameApplicationDetails}_isPowerOff').on('change', function(){
				if($('#${nameApplicationDetails}_isPowerOff :checked').val() == 'Y'){
					$('#${nameApplicationDetails} #visualInspectionAppointmentContainer').slideDown();
				}else{
					$('#${nameApplicationDetails} #visualInspectionAppointmentContainer').slideUp();
				}
			});
			
		}else{
			$('#${nameApplicationDetails} #isPowerOffContainer').slideUp();
		}
		
	},
	
	showHideMedicalRequirements: function(){
	
		// Life Support option for ATW, NGB and ALN only
		utilitiesChoices.showHideLifeSupport();
		
		// Multiple Sclerosis for ATW and NGB only
		utilitiesChoices.showHideMultipleSclerosis();
	
		var medicalRequirementsSelect = $("#${nameApplicationSituation} #${nameApplicationSituation}_medicalRequirements");
		var container = $("#${nameApplicationSituation} #medicalRequirementsContainer");
		
		var numOfVisibleOptions = $(medicalRequirementsSelect).children('option').filter(function() {
			return $(this).css('display') !== 'none';
		}).length;
		
		if(numOfVisibleOptions == 2){
			container.hide();
		} else {
			container.show();
		}
				
	},
	
	showHideLifeSupport: function(){
	
		var lifeSupportProviders = ['ATW','NGB','ALN'];
		utilitiesChoices.showHideMedicalRequirementsOption( lifeSupportProviders, 'LS' );
		
	},
	
	showHideMultipleSclerosis: function(){
		
		var multipleSclerosisProviders = ['ATW','NGB'];
		utilitiesChoices.showHideMedicalRequirementsOption( multipleSclerosisProviders, 'MS' );
		
	},
	
	showHideMedicalRequirementsOption: function(providersArray, optionValue){
	
		var provider = utilitiesChoices._product.service;
		
		var medicalRequirementsSelectName = "#${nameApplicationSituation} #${nameApplicationSituation}_medicalRequirements";
		var medicalRequirementsSelect = $(medicalRequirementsSelectName);
		var option = medicalRequirementsSelect.find('option[value="'+optionValue+'"]');
		
		if( $.inArray(provider, providersArray) == -1 ){
			
			if(option.attr('selected') == 'selected'){
				option.removeAttr('selected');
				$(medicalRequirementsSelectName+'_').attr('selected', 'selected');
			}
			
			option.hide();
			
		} else {
			option.show();
		}
		
		utilitiesChoices.showHideMedicalRequirements();
		
	},
	
	parseApplicationSlide: function(){
		
		// PREPARE THE DATA
			var provider = utilitiesChoices._product.service;
			
			// find the provider's T&C
			var provider_t_and_c = '';
			$.each(utilitiesChoices._product.info.Downloads.Download, function(key, document){
				if( /Terms (and|&) Conditions/i.test(document.DocumentType) ){
					provider_t_and_c = document.FileName;
				}
			});
		
			var data = {
				selected_utilities: utilitiesChoices.returnWhatToCompare(),
				provider_name: utilitiesChoices._product.provider,
				provider_t_and_c: 'http://www.switchwise.com.au/product-collateral/' + provider_t_and_c,
				switchwise_t_and_c: 'http:/www.switchwise.com/tandc',
				switchwise_privacy_policy: 'http:/www.switchwise.com/privacy'
			}
		
		// SITUATION FIELDSET
			var concessionCheckboxTemplate = $("#${nameApplicationSituation} #concession-checkbox-template").html();
			var parsedTemplate = $(parseTemplate( concessionCheckboxTemplate, data ));
			$("#${nameApplicationSituation}_concession_placeholder").html( parsedTemplate );
		
		// THINGS TO KNOW FIELDSET
			var thingsToKnowTemplate = $("#${nameApplicationThingsToKnow} #things-to-know-template").html();
			var parsedTemplate = $(parseTemplate( thingsToKnowTemplate, data ));
			
			// if there is no terms and conditions document, replace the link by a simple text
			if( provider_t_and_c == ""){
				providerTAndCLink = parsedTemplate.find('#${nameApplicationThingsToKnow}_provider_t_and_c');
				linkText = providerTAndCLink.html();
				providerTAndCLink.after( linkText );
				providerTAndCLink.remove();
			}
			
			$("#${nameApplicationThingsToKnow}_template_placeholder").html( parsedTemplate );
		
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
				alternatePhoneNo: formValues['${nameApplicationDetails}_otherPhoneNumber'],
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
				isPowerOff: '',
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
			
		// IS POWER OFF
			if( formValues['${nameApplicationThingsToKnow}_hidden_isPowerOffRequired'] == "Y"){
				var isPowerOff = formValues['${nameApplicationDetails}_isPowerOff'] == "Y" ? "Yes" : "No";
				$.extend(data, {isPowerOff: isPowerOff});
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
			
			var summaryTextTemplate = $(".${nameSummary} #summary-text-template").html();
			var parsedTemplate = $(parseTemplate( summaryTextTemplate, {provider: utilitiesChoices._product.provider } ));
			$("#${nameSummary}_summaryText_template_placeholder").html( parsedTemplate );
		
		// HIDE SOME ROWS
			if( formValues['${nameApplicationThingsToKnow}_hidden_identificationRequired'] == "N"){
				// hide identification fields
				$(".${nameSummary} .identification").hide();
			}
			if( formValues['${nameApplicationSituation}_concession_hasConcession'] == "N"){
				// hide concession fields
				$(".${nameSummary} .concession").hide();
			}
			if( formValues['${nameApplicationSituation}_medicalRequirements'] == "N" ){
				// hide medicalRequirementsType
				$(".${nameSummary} .medicalRequirements").hide();
			}
			if( formValues['${nameApplicationThingsToKnow}_hidden_isPowerOffRequired'] == "N"){
				// hide isPowerOff field
				$(".${nameSummary} .isPowerOff").hide();
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
