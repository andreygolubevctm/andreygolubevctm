<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpathBenefits" 		required="true"	 rtexprvalue="true"	 description="(benefit) field group's xpath" %>
<%@ attribute name="xpathSituation" 	required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="nameBenefits" 				value="${go:nameFromXpath(xpathBenefits)}" />
<c:set var="nameSituation" 				value="${go:nameFromXpath(xpathSituation)}" />
<c:set var="xpathBenefitsExtras"		value="${xpathBenefits}/benefitsExtras" />
<c:set var="xpathBenefitsExtrasName"	value="${go:nameFromXpath(xpathBenefitsExtras)}" />

<c:set var="param_cover"><c:out value="${param.cover}" escapeXml="true" /></c:set>
<c:set var="param_location"><c:out value="${param.location}" escapeXml="true" /></c:set>
<c:set var="param_situation"><c:out value="${param.situation}" escapeXml="true" /></c:set>


<%-- Test if the data is already set. Advance the user if Params are filled --%>
<c:if test="${empty data[xpathSituation].healthCvr && empty data[xpathSituation].healthSitu}">
	<%-- Data Bucket --%>
	<go:setData dataVar="data" xpath="${xpathSituation}/healthCvr" value="${param_cover}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/location" value="${param_location}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/healthSitu" value="${param_situation}" />
	<go:setData dataVar="data" xpath="${xpathBenefits}/healthSitu" value="${param_situation}" />
	<c:set var="fromBrochure" scope="session" value="${true}"/>
</c:if>
<c:if test="${empty param_cover || empty param_situation || empty param_location}">
	<c:set var="fromBrochure" scope="session" value="${false}"/>
</c:if>


<%-- PARAM VALUES --%>
<c:set var="healthCvr" value="${data[xpathSituation].healthCvr}" />
<c:set var="state" value="${data[xpathSituation].state}" />
<c:set var="healthSitu" value="${data[xpathSituation].healthSitu}" />

<%-- Only ajax-fetch and update benefits if situation is defined in a param (e.g. from brochureware). No need to update if new quote or load quote etc. --%>
<c:set var="performHealthChoicesUpdate" value="false" />
<c:if test="${not empty param_situation or (not empty param.preload and empty data[xpathBenefitsExtras])}">
	<c:set var="performHealthChoicesUpdate" value="true" />
</c:if>



<%-- Javascript object for holding users criteria --%>
<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var healthChoices = new Object();
healthChoices = {
	_cover : '',
	_situation : '',
	_state : '${state}',
	_benefits : new Object,
	
	initialise : function(cover, situation, benefits) {
		healthChoices.setCover(cover, true);
		var performUpdate = <c:out value="${performHealthChoicesUpdate}" />;
		healthChoices.setSituation(situation, performUpdate);

		healthChoices.prefillBenefitsList();
		
		if( Health._new_quote ){
			healthChoices.prefill(benefits);
		};
	},
	
	<%-- Return a query string object for the rates ajax call --%>
	getRates: function(){
		
		var $_obj = $('.health-cover_details');			
		
		if( this.checkStage() == 'PRE' ) {
				
			<%-- PRE RESULTS --%>
		var _string = 'dependants='+ $_obj.find('select.dependants').val()
			  + '&income='+ $_obj.find('.income option:selected').val()
			  + '&rebate_choice=' + $_obj.find('.rebate input:checked').val()
			  + '&primary_dob='+ $_obj.find('.primary .person_dob').val()
			  + '&primary_loading='+ $_obj.find('.primary .loading:checked').val()
			  + '&primary_current='+  $_obj.find('.primary .health-cover_details:checked').val()
			  + '&primary_loading_manual='+ $_obj.find('.primary-lhc').val()
			  + '&partner_dob='+ $_obj.find('.partner .person_dob').val()
			  + '&partner_loading='+ $_obj.find('.partner .loading:checked').val()
			  + '&partner_current='+  $_obj.find('.partner .health-cover_details:checked').val()
			  + '&partner_loading_manual='+ $_obj.find('.partner-lhc').val()
			  + '&cover='+ this._cover;
		return _string;
	
	} else if( this.checkStage() == 'POST' ) {
	
		var $_objPost = $('.health_application');
		
		var _primaryCover = ( $('#clientFund').find(':selected').val() == 'NONE' )?'N':'Y';
		var _partnerCover = ( $('#partnerFund').find(':selected').val() == 'NONE' )?'N':'Y';
	
		<%-- POST RESULTS: Cannot change the original questions for continuous loading --%>
			var _string = 'dependants='+ $_obj.find('select.dependants').val()
				  + '&income='+ $_obj.find('.income option:selected').val()
				  + '&rebate_choice=' + $_obj.find('.rebate input:checked').val()
				  + '&primary_dob='+ $_objPost.find('.primary .person_dob').val()
				  + '&primary_loading='+ $_obj.find('.primary .loading:checked').val()
				  + '&primary_current='+ _primaryCover
				  + '&primary_loading_manual='+ $_obj.find('.primary-lhc').val()
				  + '&partner_dob='+ $_objPost.find('.partner .person_dob').val()
				  + '&partner_loading='+ $_obj.find('.partner .loading:checked').val()
				  + '&partner_current='+ _partnerCover
				  + '&partner_loading_manual='+ $_obj.find('.partner-lhc').val()
				  + '&cover='+ this._cover;
			return _string;
		
		};
		
		return false;
	},
	
	<%-- Determine what stage the application is at --%>
	checkStage: function(){			
		if( $('#health_application_provider, #health_application_productId').val() == '' ) {			
			return 'PRE';
		} else {
			return 'POST';
		};							
	},
	
	<%-- Check if the rates can be seen --%>
	getRatesCheck: function(){
	
		<%-- ALWAYS FAIL --%>
		if(this._cover == ''){
			return false;
		};

		<%-- Rebate must be selected --%>
		if (!healthChoices.getReductionFlag()) {
			return false;
		}		

		<%-- PRE/POST RESULTS CHECK --%>		
		if( this.checkStage() == 'PRE' ) {		
			var $_obj = $('.health-cover_details');
		} else if( this.checkStage() == 'POST' ) {			
			var $_obj = $('.health_application');
		};
		
		<%-- Check DOB requirements, for either single or couple  --%>
		if( this._cover != 'S' && this._cover != 'SPF' ) {
			var _DOB = ( !!$_obj.find('.primary .person_dob').val() && !!$_obj.find('.partner .person_dob').val() );
		} else {
			var _DOB = ( !!$_obj.find('.primary .person_dob').val() );
		};
		
		<%-- INSTA fail --%>
		if(!_DOB){
			return false;
		};
		
		<%-- DOB not in future --%>
		if( this._cover != 'S' && this._cover != 'SPF' ) {
			if( ( returnAge( $_obj.find('.primary .person_dob').val() ) < 0 ) || ( returnAge( $_obj.find('.partner .person_dob').val() ) < 0 )  ){
				return false;
			};			
		} else {
			if( returnAge( $_obj.find('.primary .person_dob').val() ) < 0 ){
				return false;
			};		
		};
		
		if( $_obj.find('.rebate').find(':checked').val() == 'Y' && $_obj.find('.income').val() == '' ){
			return false;
		};

		return true;		
	
	},
	
	getReductionFlag: function(){
		return $('.health-cover_details').find('.rebate:checked').val();
	},	
	
	<%-- changes the JSON object and also the Dom object  --%>
	render : function(){			
		$.each(healthChoices._benefits, function(name, value) {
			if(value === false) {
				$('#${xpathBenefitsExtrasName}_'+name).removeAttr('checked');
			} else {
				$('#${xpathBenefitsExtrasName}_'+name).attr('checked','checked');
			};
		});
	},
	
	<%-- Takes the inital aray --%>
	prefill : function(items){	
		var items = items.split(',');
		healthChoices.reset();
		$.each(items, function(index, value){
			healthChoices.addBenefit(value);
		});
		healthChoices.render();

		<%-- If price filter is present update it --%>
		if(typeof priceMinSlider !== "undefined"){
			priceMinSlider.reset();
		};
	},		
	
	<%-- uses an Ajax call to grab a specific default set --%>
	update : function(){		
		<%-- Only bother making the call if a valid situation is selected. --%>
		if (healthChoices._situation.length > 0) {
			var dat = {situation: healthChoices._situation };
			$.ajax({
				url: "ajax/csv/get_benefits.jsp",
				dataType: "text",
				data: dat,
				type: "GET",
				async: true,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function(csvResults){
						healthChoices.prefill(csvResults);
				},					
				error: function(obj,txt){
					FatalErrorDialog.exec({
						message:		"An error occurred when updating your choices " + txt,
						page:			"health:choices.tag",
						description:	"healthChoices.update(). AJAX request failed: " + txt,
						data:			dat
					});
				},
				timeout:60000
			});
		}
	},		

	hasSpouse : function() {
		switch(this._cover) {
		   	case 'C':
		   	case 'F':
		      	return true;
		      	break;
		   	default:			      	
		   		return false;
		      	break;
		};
	},

	hasChildren : function() {
		switch(this._cover) {
		   	case 'F':
		   	case 'SPF':
		      	return true;
		      	break;
		   	default:
		      	return false;
		      	break;
		};
	},

	addBenefit : function(name) {
		healthChoices._benefits[name] = true;
	},

	removeBenefit : function(name) {
		healthChoices._benefits[name] = false;
	},

	hasBenefit : function(name) {
		return healthChoices._benefits.hasOwnProperty(name) ? healthChoices._benefits[name] : false;
	},

	definedBenefit : function(name) {
		return healthChoices._benefits.hasOwnProperty(name);
	},
	
	benefitCategory: function() {
		return resultsBenefitsMgr.getCategory();
	},

	reset : function(){
		healthChoices._benefits = {};
		$('#health_benefitsContentContainer').find('input:checkbox').removeAttr('checked'); //reset them all
		healthChoices.prefillBenefitsList();
	},

	<%-- This takes the amount of ticks and adds this to the benefit list and removes any unticked --%>
	prefillBenefitsList : function() {
		$("#health_benefitsContentContainer").find(":checkbox").each(function(){
			var key = $(this).attr("id").split("Extras_")[1];
			<%-- Generate the key and add/remove --%>
			if( $(this).is(':checked') ){
				healthChoices.addBenefit(key);
			} else {
				healthChoices.removeBenefit(key);
			};
		});
	},		

	setCover : function(cover, ignore_rebate_reset) {	
		ignore_rebate_reset = ignore_rebate_reset || false;

		healthChoices._cover = cover;			

		if( !ignore_rebate_reset ) {
			healthChoices.resetRebateForm();
		}		

		if(!healthChoices.hasSpouse()) {
			healthChoices.flushPartnerDetails();
			$('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').hide();			
		} else {
			$('#partner-health-cover, #partner, .health-person-details-partner, #partnerFund').show();				
		};
		
		<%-- See if Children should be on or off --%>
		healthChoices.dependants();
		
		<%-- Set the auxillary data --%>
		Health.setRates();
		healthCoverDetails.displayHealthFunds();
		healthCoverDetails.setTiers();

		<%-- If price filter is present update it --%>
		if(typeof priceMinSlider !== "undefined"){
			priceMinSlider.reset();
		};
	},

	setSituation: function(situation, performUpdate) {
		if (performUpdate !== false)
			performUpdate = true;

		<%-- Change the message --%>
		if(situation != healthChoices._situation){
			HealthBenefits.updateIntro(situation);
			healthChoices._situation = situation;
		};
	
		$('#${nameBenefits}_healthSitu, #${nameSituation}_healthSitu').val( situation );

		if (performUpdate) {
		healthChoices.update();
		}
	},

	isValidLocation : function( location ) {

		var search_match = new RegExp(/^((\s)*\w+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(location));

		if( value != '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}

		return false;
	},

	setLocation : function(location) {
		if( healthChoices.isValidLocation(location) ) {
			var value = $.trim(String(location));
			var pieces = value.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');

			$('#${nameSituation}_state').val(state);
			$('#${nameSituation}_postcode').val(postcode);
			$('#${nameSituation}_suburb').val(suburb);

			healthChoices.setState(state);
		}
	},

	setState : function(state) {
		healthChoices._state = state;
		<%-- FIX: Turn on/off ambulance selection depending on state (see xsl sheet) --%>
		
		if( state == "QLD" || state == "TAS" ) {
			state = (state == "QLD") ? "Queensland" : "Tasmania";
			var text = "For residents of " + state + ", ambulance cover is provided by your State Government";
			
			$("#health_benefits_benefitsExtras_Ambulance").attr("disabled", "true");
			$(".ambulanceText").html(text).show();
		}
		else {
			$("#health_benefits_benefitsExtras_Ambulance").removeAttr("disabled");
			$(".ambulanceText").hide();
		}
	},
	
	setDob : function(value, $_obj) {
		if(value != ''){
			$_obj.val(value);
		};
	},
	
	setContactNumberReverse: function(){
		<%-- HLT-476: No reverse updating of the phone is to occur --%>
		return false;
		<%-- END HLT-476
		var tel = String($('#health_application_other').val());
		var mob = String($('#health_application_mobile').val());
		var src = String($('#health_contactDetails_contactNumber').val());
		
		if( 
			(tel.length && tel == src) || 
			(mob.length && mob == src)
		) {
			// ignore as at least one of the numbers entered matches that originally entered in questionset
		} else {		
			// Update the questionset number with either the new mobile or other number
			if( mob.length ) {
				if( mob.indexOf('04') == 0 ) {
				$('#health_contactDetails_contactNumber').val( $('#health_application_mobile').val() );
				$('#health_contactDetails_contactNumber').trigger('blur');
				} else {
					$('#health_application_mobileinput').val('');
					$('#health_application_mobileinput').trigger('blur');
				}
			} else if( tel.length ) {
				$('#health_contactDetails_contactNumber').val( $('#health_application_other').val() );
				$('#health_contactDetails_contactNumber').trigger('blur');
			}
		} --%>
	},	
	
	dependants: function() {				
		if( healthChoices.hasChildren() && $('.health_cover_details_rebate :checked').val() == 'Y' ) {
			$('.health_cover_details_dependants').slideDown();
		} else {			
			$('#health_healthCover_dependants option:selected').prop("selected", false);
			$('.health_cover_details_dependants').slideUp();				
		};
		healthDependents.setDependants();
	},
	
	//return readable values
	returnCover: function() {
		return $('#${nameSituation}_healthCvr option:selected').text();		
	},
	
	returnCoverCode: function() {
		return this._cover;		
	},
	
	returnSituation: function() {
		switch( $('#${nameSituation}_healthSitu option:selected').val() )
		{
		case 'ATP':
			return 'cover to avoid taxes and penalties';
		case 'LBC':
			return 'better cover';
		case 'LC':
			return 'cover to compare';				
		case 'FK':
		case 'CSF':
			return 'cover suited to families';
		case 'YC':
		case 'YS':
			return 'cover suited to young people';
		case 'M':
			return 'cover suited to mature people';																											
		default:
			return 'cover';
		};						
	},		
	
	returnState: function( prefix ) {
		prefix = prefix || false;
		
		switch(healthChoices._state)
		{
			case 'QLD':
				return 'Queensland';
			case 'NSW':
				return 'New South Wales';
			case 'VIC':
				return 'Victoria';
			case 'WA':
				return 'Western Australia';
			case 'SA':
				return 'South Australia';
			case 'TAS':
				return 'Tasmania';
			case 'NT':
				return (prefix === true ? 'the ' : '') + 'Northern Territory';
			case 'ACT':
				return (prefix === true ? 'the ' : '') + 'Australian Capital Territory';																												
			default:
				return 'an unknown location';
		};
	},

	flushPartnerDetails : function() {
		$('#health_healthCover_partner_dob').val('');
		$('#partner-health-cover input[name="health_healthCover_partner_cover"]:checked').each(function(){
	      $(this).checked = false;  
		});
		resetRadio($('#health_healthCover_partnerCover'));
		$('#partner-health-cover input[name="health_healthCover_partner_healthCoverLoading"]:checked').each(function(){
	      $(this).checked = false;  
		});
		resetRadio($('#health-continuous-cover-partner'));
	},

	resetRebateForm : function() {
		$('#health_healthCover_health_cover_rebate input[name="health_healthCover_rebate"]:checked').each(function(){
	      $(this).checked = false;  
		});
		resetRadio($('#health_healthCover_health_cover_rebate'));
		$('#health_healthCover_dependants option').first().prop("selected", true);
		$('#health_healthCover_dependants option:selected').prop("selected", false);
		$('#health_healthCover_income option').first().prop("selected", true);
		$('#health_healthCover_income option:selected').prop("selected", false);
		$('#health_healthCover_incomelabel').val('');
		healthCoverDetails.setIncomeBase();
		healthChoices.dependants();
		healthCoverDetails.setTiers();
		$('.health_cover_details_dependants').hide();
		$('#health_healthCover_tier').hide();
		$('#health_rebates_group').hide();
	},
	
	<%-- Adjust the first slide (self-contained) between its two states --%>
	_situationBenefit: function(_click, _mode) {
		if(typeof _mode == 'undefined'){
			_mode = false;
		};
	
		$('.health-info-text').hide();
		<%-- 'Cover Type' is active when button hit --%>
		if( ( $('#${nameBenefits}').is(':hidden') && !_mode ) || ( _mode == 'benefits' ) ){
			if( _click == false && $('#${nameSituation}').find(':selected[value=""]').length > 0 || ( $('.health_situation_medicare:visible').length == 1 && $('.health_situation_medicare:visible').find('input:checked').length == 0  ) ){
				return false; //prevent early firing of warnings
			};
			if( !QuoteEngine.validate() ){
				return false;
			} else {
				$('#slide'+QuoteEngine._options.prevSlide).css( { 'max-height':'300px' });
				$('#slide'+QuoteEngine._options.currentSlide).css( { 'max-height':'5000px' });
				QuoteEngine.scrollTo();
			};
		} else {
			$('#slide'+QuoteEngine._options.prevSlide).css( { 'max-height':'300px' });
			$('#slide'+QuoteEngine._options.currentSlide).css( { 'max-height':'300px' });
			QuoteEngine.scrollTo();
		};
	}
}
</go:script>

<go:script marker="onready">	 
	<%-- Render the initial set and turn on the items --%>
	healthChoices.initialise('${healthCvr}', '${healthSitu}', '${_benefits}');
	
	<%-- DOB transfer --%>
	healthChoices.setDob($('.health-cover_details').find('.primary .person_dob').val(), $('.health-person-details-primary').find('.person_dob') );
	healthChoices.setDob($('.health-person-details-partner').find('.person_dob').val(), $('.health-person-details-partner').find('.person_dob') );
	
	$('.health-cover_details').find('.primary .person_dob').on('change', function() {
		healthChoices.setDob($(this).val(), $('.health-person-details-primary').find('.person_dob') );
	});
	$('.health-cover_details').find('.partner .person_dob').on('change', function() {
		healthChoices.setDob($(this).val(), $('.health-person-details-partner').find('.person_dob') );
	});
	
	$('#health_healthCover-selection').find('input, select').on('change', function() {
		<%-- Should be in health_cover_details.tag but we need it to trigger before running setRates below --%>
		if ($(this).parent().attr('id') == 'health_healthCover_health_cover' || $(this).parent().attr('id') == 'health_healthCover_partner_health_cover') {
			healthCoverDetails.setHealthFunds();
		}
		<%-- Confirm valid DOBs before firing off ajax --%>
		if ($('.health-person-details-primary').find('.person_dob').val() == '' || $('.health-person-details-primary').find('.person_dob').valid()) {
		if ($('.health-person-details-partner').find('.person_dob').val() == '' || $('.health-person-details-partner').find('.person_dob').valid()) {
			Health.setRates();
		}
		}
	});
	
	<%-- See if rates can load --%>
	Health.setRates();
	
	<c:if test="${not empty param.action and param.action == 'latest'}">
		QuoteEngine.gotoSlide({
			index: 1
		});
		setTimeout(function(){Health.fetchPrices()},3000);
	</c:if>
</go:script>


<%-- CSS --%>
<go:style marker="css-head">
</go:style>
