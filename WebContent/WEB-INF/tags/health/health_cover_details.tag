<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Private Health Cover details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="date" class="java.util.Date" />


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="month"><fmt:formatDate value="${date}" pattern="M" /></c:set>
<c:if test="${month > 6}">
	<c:set var="lastyear"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>
	<c:set var="thisyear"><fmt:formatNumber groupingUsed="false"><fmt:formatDate value="${date}" pattern="yyyy" /></fmt:formatNumber>+1</c:set>
</c:if>

<c:if test="${month < 7}">
	<c:set var="lastyear"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>
	<c:set var="thisyear"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>
</c:if>

<%-- Calculate the year for continuous cover - changes on 1st July each year --%>
<fmt:formatDate var="year" value="${date}" pattern="yyyy" />
<c:set var="continuousCoverYear">
	<c:choose>
		<c:when test="${month < 7}">${year - 11}</c:when>
		<c:otherwise>${year - 10}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="${name}-selection" class="health-cover_details">

	<simples:dialogue id="7" mandatory="false" />

	<h3>Lifetime Hospital Cover Loading</h3>
	<p>The Government may charge a levy known as the Lifetime Health Cover (LHC) loading. The levy is based on a number of factors including your age and the number of years you have held private health cover. Let's calculate your levy now.</p>

	<form:fieldset legend="Your Details" className="primary">
		<form:row label="Your date of birth" className="health-your_details-dob-group">
			<field:person_dob xpath="${xpath}/primary/dob" title="primary person's" required="true" ageMin="16" ageMax="120" />
		</form:row>

		<form:row label="Do you currently hold private health insurance?" id="${name}_primaryCover">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/primary/cover" title="your private health cover" required="true" className="health-cover_details" id="${name}_health_cover"/>
		</form:row>

		<form:row id="health-continuous-cover-primary" label="Have you had continuous hospital cover since 1 July ${continuousCoverYear} or 1 July following your 31st birthday?" className="health-your_details-opt-group" helpId="239">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/primary/healthCoverLoading" title="your health cover loading" required="true" id="${name}_health_cover_loading" className="loading"/>
		</form:row>

		<c:if test="${callCentre}">
			<form:row label="Applicant's LHC" helpId="287">
				<field:input_numeric xpath="${xpath}/primary/lhc" minValue="0" maxValue="70" title="Applicant's LHC" required="false" id="${name}_primary_lhc" maxLength="2" className="primary-lhc"/>
			</form:row>
		</c:if>

	</form:fieldset>

	<form:fieldset id="partner-health-cover" legend="Your Partner's Details" className="partner">
		<form:row label="Your partner's date of birth">
			<field:person_dob xpath="${xpath}/partner/dob" title="partner's" required="true" ageMin="16" ageMax="120" />
		</form:row>

		<form:row label="Does your partner currently hold private health insurance?" id="${name}_partnerCover" >
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/partner/cover" title="your private health cover" required="true" className="health-cover_details" id="${name}_partner_health_cover"/>
		</form:row>

		<form:row id="health-continuous-cover-partner" label="Has your partner had continuous hospital cover since 1 July 2002 or 1 July following their 31st birthday?" className="health-your_details-opt-group" helpId="239">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/partner/healthCoverLoading" title="your partner's health cover loading" required="true" id="${name}_partner_health_cover_loading" className="loading"/>
		</form:row>

		<c:if test="${callCentre}">
			<form:row label="Partner's LHC">
				<field:input_numeric xpath="${xpath}/partner/lhc" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
			</form:row>
		</c:if>

	</form:fieldset>

	<core:clear />

	<simples:dialogue id="8" mandatory="false" />
	<simples:dialogue id="9" mandatory="true" />

	<h3>Rebate</h3>
	<p>The Australian Government offers rebates to certain people who take out private health insurance.  The rebates offered depend on your household's taxable income,  the number of dependants you have and your age.</p>

	<form:fieldset legend=" ">
		<form:row label="Do you wish to take the rebate as a reduction to your premium?" helpId="240" className="health_cover_details_rebate">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/rebate" title="your private health cover rebate" required="true" id="${name}_health_cover_rebate" className="rebate"/>
		</form:row>

		<form:row label="How many dependant children do you have?" helpId="241" className="health_cover_details_dependants">
			<field:count_select xpath="${xpath}/dependants" max="12" min="1" title="Please enter number of dependants" required="true"  className="${name}_health_cover_dependants dependants"/>
		</form:row>

		<c:if test="${callCentre}">
			<form:row label="I wish to  calculate my rebate based on" helpId="288" className="health_cover_details_incomeBasedOn" id="${name}_incomeBase">
				<field:array_radio items="S=Single income,H=Household income" xpath="${xpath}/incomeBasedOn" title="income based on" required="true"  />
			</form:row>
		</c:if>

		<form:row label="What is the estimated taxable income for your household for the financial year 1st July 2012 to 30 June 2013?" id="${name}_tier">
			<field:array_select xpath="${xpath}/income"  title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_cover_details_income"/>
			<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
			<c:set var="income_label_xpath" value="${xpath}/income" />
			<input type="hidden" name="${go:nameFromXpath(xpath)}_incomelabel" id="${go:nameFromXpath(xpath)}_incomelabel" value="${data[income_label_xpath]}" />
		</form:row>

		<form:row label=" " id="${xpath}/more">
			<p><a href="javascript:RebatesInfoDialog.launch();">More information about the Government Rebate.</a></p>
		</form:row>


	</form:fieldset>

	<%-- The rebates calculator --%>
	<form:fieldset legend="Rebate and loading" id="health_rebates_group">
		<form:row label="Rebate" >
			<field:input xpath="health_rebate" title="" required="true" readOnly="true" />
		</form:row>
		<form:row label="Loading" >
			<field:input xpath="health_loading" title="" required="true" readOnly="true" />
		</form:row>
	</form:fieldset>

	<core:clear />

</div>

<div class="clear"></div>

<health:popup_rebates></health:popup_rebates>
<health:popup_medicare_levy_surcharge></health:popup_medicare_levy_surcharge>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var healthCoverDetails = {

	<%-- //RESOLVE: this object was quickly constructed from an anon. function, and can be cleaner --%>

	init: function(){

		healthCoverDetails.primary_dob($('#${name}_primary_dob'));
		healthCoverDetails.partner_dob($('#${name}_partner_dob'));

		$('#${name}_primary_dob').on('blur', function() {
			healthCoverDetails.primary_dob($(this));
		});

		$('#${name}_partner_dob').on('blur', function() {
			healthCoverDetails.partner_dob($(this));
		});

		$.address.internalChange(function(event){
			if(event.parameters.stage == 1)
			{
				if( !$("#reference_no").is(":visible") )
				{
					$("#reference_no").show();
				}
			}
		});

		this.setIncomeBase();
		this.setHealthFunds();

		healthCoverDetails.applyNoteListeners();

	},

	partner_dob: function($obj){
		var _dobString = $($obj).val();
		if(_dobString != '' ){
			if( isLessThan31Or31AndBeforeJuly1(_dobString) ) {
				healthCoverDetails.partnerDOB = true;
				healthCoverDetails.setHealthFunds();
				return;
			};
		};
		healthCoverDetails.partnerDOB = false;
		healthCoverDetails.setHealthFunds();
	},

	primary_dob: function($obj){
		var _dobString = $($obj).val();
		if(_dobString != ''){
			if( isLessThan31Or31AndBeforeJuly1(_dobString) ) {
				healthCoverDetails.primaryDOB = true;
				healthCoverDetails.setHealthFunds();
				return;
			};
		};
		healthCoverDetails.primaryDOB = false;
		healthCoverDetails.setHealthFunds();
	},

	getRebateChoice: function(){
		return $('#${name}-selection').find('.health_cover_details_rebate :checked').val();
	},

	setIncomeBase: function(){
		if(healthChoices._cover == 'S' && healthCoverDetails.getRebateChoice() == 'Y'){
			$('#${name}-selection').find('.health_cover_details_incomeBasedOn').slideDown();
		} else {
			$('#${name}-selection').find('.health_cover_details_incomeBasedOn').slideUp();
		};
	},

	<%-- Previous funds, settings --%>
	displayHealthFunds: function(){
		var $_previousFund = $('#mainform').find('.health-previous_fund');
		var $_primaryFund = $('#clientFund').find('select');
		var $_partnerFund = $('#partnerFund').find('select');

		if( $_primaryFund.val() != 'NONE' && $_primaryFund.val() != ''){
			$_previousFund.find('#clientMemberID').slideDown();
			$_previousFund.find('.membership').addClass('onA');
		} else {
			$_previousFund.find('#clientMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onA');
		};

		if( healthChoices.hasSpouse() && $_partnerFund.val() != 'NONE' && $_partnerFund.val() != ''){
			$_previousFund.find('#partnerMemberID').slideDown();
			$_previousFund.find('.membership').addClass('onB');
		} else {
			$_previousFund.find('#partnerMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onB');
		};

		if( !$_previousFund.find('.membership').hasClass('onA') && !$_previousFund.find('.membership').hasClass('onB') ) {
			$_previousFund.find('.membership').slideUp();
		} else {
			$_previousFund.find('.membership').slideDown();
		};
	},

	setHealthFunds: function(){
		<%-- Quick variables --%>
		var _primary = $('#${name}_primaryCover').find(':checked').val();
		var _partner = $('#${name}_partnerCover').find(':checked').val();
		var $_primaryFund = $('#clientFund').find('select');
		var $_partnerFund = $('#partnerFund').find('select');

		<%-- Primary Specific --%>
		if( _primary == 'Y' ) {
			if( healthCoverDetails.primaryDOB ){
				$('#health-continuous-cover-primary').slideDown();
			};
		} else {
			if( _primary == 'N'){
				resetRadio($('#health-continuous-cover-primary'),'N');
			};
			$('#health-continuous-cover-primary').slideUp();
		};

			if( _primary == 'Y' && $_primaryFund.val() == 'NONE'){
				$_primaryFund.val('');
			} else if(_primary == 'N'){
				$_primaryFund.val('NONE');
			};

		<%-- Partner Specific --%>
		if( _partner == 'Y' ) {
			if( healthCoverDetails.partnerDOB ){
				$('#health-continuous-cover-partner').slideDown();
			};
		} else {
			if( _partner == 'N'){
				resetRadio($('#health-continuous-cover-partner'),'N');
			};
			$('#health-continuous-cover-partner').slideUp();
		};

			if( _partner == 'Y' && $_partnerFund.val() == 'NONE'){
				$_partnerFund.val('');
			} else if(_partner == 'N'){
				$_partnerFund.val('NONE');
			};

		<%-- Adjust the questions further along --%>
		healthCoverDetails.displayHealthFunds();
	},

	<%-- Manages the descriptive titles of the tier drop-down --%>
	setTiers: function(){

		var _value = '';
		var _text = '';

		<%-- Set the dependants allowance and income message --%>
		var _allowance = ($('#${name}_dependants').val() - 1);

		if( _allowance > 0 ){
			_allowance = _allowance * 1500;
			$('#${name}_incomeMessage').text('this includes an adjustment for your dependants');
		} else {
			_allowance = 0;
			$('#${name}_incomeMessage').text('');
		};

		<%-- Set the tier type based on hierarchy of selection --%>
		if( $('#${name}_incomeBase').is(':visible') && $('#${name}_incomeBase').find(':checked').length > 0 ) {
			var _cover = $('#${name}_incomeBase').find(':checked').val();
		} else {
			var _cover = healthChoices.returnCoverCode();
		};

		<%-- Reset and than Loop through all of the options --%>
		$('#${name}_income').find('option').each( function(){
			//set default vars
			_value = $(this).val();
			_text = '';

			<%-- Calculate the Age Bonus --%>
			if( typeof(Results._rates) === 'undefined'){
				_ageBonus = 0;
			} else {
				_ageBonus = parseInt(Results._rates.ageBonus);
			};

			if(_cover == 'S' || _cover == ''){ <%-- Single tiers --%>
				switch(_value)
				{
				case '0':
					_text =  '$'+ (88000 + _allowance) +' or less ('+ (30 + _ageBonus) +'% rebate)';
					break;
				case '1':
					_text = '$'+ (88001 + _allowance) +' - $'+ (102000 + _allowance) + ' ('+ (20 + _ageBonus) +'% rebate)';
					break;
				case '2':
					_text = '$'+ (102001 + _allowance) +' - $'+ (136000 + _allowance) + ' ('+ (10 + _ageBonus) +'% rebate)';
					break;
				case '3':
					_text = '$'+ (136001 + _allowance) + '+ (no rebate)';
					break;
				};
			} else { <%-- Family tiers --%>
				switch(_value)
				{
				case '0':
					_text =  '$'+ (176000 + _allowance) +' or less ('+ (30 + _ageBonus) +'% rebate)';
					break;
				case '1':
					_text = '$'+ (176001 + _allowance) +' - $'+ (204000 + _allowance) + ' ('+ (20 + _ageBonus) +'% rebate)';
					break;
				case '2':
					_text = '$'+ (204001 + _allowance) +' - $'+ (272000 + _allowance) + ' ('+ (10 + _ageBonus) +'% rebate)';
					break;
				case '3':
					_text = '$'+ (272000 + _allowance) + '+ (no rebate)';
					break;
				};
			};

			<%-- Set Description --%>
			if(_text != ''){
				$(this).text(_text);
			};

			<%-- Hide these questions as they are not required --%>
			if( healthCoverDetails.getRebateChoice() == 'N' || !healthCoverDetails.getRebateChoice() ) {
				$('#${name}_tier').slideUp();
				$('.health-medicare_details').hide();
			} else {
				$('#${name}_tier').slideDown();
				$('.health-medicare_details').show();
			};
			
			if( $(this).is(":selected") )
			{
				$('#${name}_incomelabel').val( $(this).html() );
			}
		});


	},

	applyNoteListeners : function()
	{
		$('#${name}_primary_dob').on('blur', function() {			
				healthCoverDetails.showHideNotes();
		});
		
		$('#${name}_primaryCover').find('input').on('change', function(){
				healthCoverDetails.showHideNotes();
		});

		$('#${name}_partner_dob').on('blur', function() {
				healthCoverDetails.showHideNotes();
		});

		$('#${name}_partnerCover').find('input').on('change', function(){
				healthCoverDetails.showHideNotes();
		});

		slide_callbacks.register({
			mode:		'after',
			slide_id:	1,
			callback:	function() { healthCoverDetails.showHideNotes(false, 0); }
		});
	},

	showHideNotes : function( force_hide, delay )
	{
		var delay = delay || 400;
		
		var callback = function() {
		
		force_hide == force_hide || false;

		var primary_cover 	= $('input[name=${name}_primary_cover]:checked', '#mainform').val();
		var primary_age 	= healthCoverDetails.getAgeAsAtLastJuly1( $('#${name}_primary_dob').val() );
		var partner_cover 	= $('input[name=${name}_partner_cover]:checked', '#mainform').val();
		var partner_age 	= healthCoverDetails.getAgeAsAtLastJuly1( $('#${name}_partner_dob').val() );
		
		var cover_no = false;
		var cover_yes = false;

		if( !force_hide && (primary_cover == "N" && primary_age < 31) )
		{
			hints.remove("primary_cover_yes1");
			hints.remove("primary_cover_yes2");
			
			var target = $("#health_healthCover-selection .primary").first().find(".content").first();
			hints.add({
				target:		target,
				id:			"primary_cover_no",
				content:	"You will have to pay higher premiums if you don't take out private hospital cover before you turn 31. Find out about the <a href='javascript:HintsDetailDialog.launch(\"lifetime-cover-loading\");'>Lifetime Hospital Cover loading</a>",
				y_offset:	34,
					x_offset:	-599,
				position:	"mid"
			});
			
			cover_no = true;
		}
		else
		{
			hints.remove("primary_cover_no");
		}

		if( !force_hide && primary_cover == "Y" )
		{
			var target = $("#health_healthCover-selection .primary").first().find(".content").first();
			hints.add({
				target:		target,
				id:			"primary_cover_yes1",
				content:	"Did you know that switching is simple. Your chosen fund will handle the switching process for you. Too easy.",
				group:		"primary_cover",
				y_offset:	34,
					x_offset:	-599,
				position:	"mid"
			});
			hints.add({
				target:		target,
				id:			"primary_cover_yes2",
				content:	"You don't have to re-serve your <a href='javascript:HintsDetailDialog.launch(\"waiting-periods\");'>waiting periods</a> for the same or lower levels of cover.",
				group:		"primary_cover",
				y_offset:	34,
					x_offset:	-599,
				position:	"mid"
			});
			
			cover_yes = true;
		}
		else
		{
			hints.remove("primary_cover_yes1");
			hints.remove("primary_cover_yes2");
		}

		if( !cover_no && !force_hide && (partner_cover == "N" && partner_age < 31) )
		{
			hints.remove("partner_cover_yes1");
			hints.remove("partner_cover_yes2");
			
			var target = $("#health_healthCover-selection .partner").first().find(".content").first();
			hints.add({
				target:		target,
				id:			"partner_cover_no",
				content:	"You will have to pay higher premiums if you don't take out private hospital cover before you turn 31. Find out about the Lifetime Hospital Cover loading",
				y_offset:	34,
					x_offset:	-599,
				position:	"mid"
			});
		}
		else
		{
			hints.remove("partner_cover_no");
		}

		if( !cover_yes && !force_hide && partner_cover == "Y" )
		{
			var target = $("#health_healthCover-selection .partner").first().find(".content").first();
			hints.add({
				target:		target,
				id:			"partner_cover_yes1",
				content:	"Switching is easy.  Your chosen fund will handle with switching process for you.",
				group:		"partner_cover",
				y_offset:	34,
					x_offset:	-599,
				position:	"mid"
			});
			hints.add({
				target:		target,
				id:			"partner_cover_yes2",
				content:	"You don't have to re-serve your waiting periods for the same or lower levels of cover.",
				group:		"partner_cover",
				y_offset:	34,
					x_offset:	-599,
				position:	"mid"
			});
		}
		else
		{
			hints.remove("partner_cover_yes1");
			hints.remove("partner_cover_yes2");
		}
		};
				
		setTimeout(function() {	
			callback();
		}, delay);
	},

	getAgeAsAtLastJuly1: function( dob )
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(6 < month || (6 == month && 1 < day))
		{
			age--;
		}

		return age;
	}
};

</go:script>

<go:script marker="onready">

	$(function() {
		$("#${name}_health_cover, #${name}_partner_health_cover, #${name}_health_cover_loading, #${name}_partner_health_cover_loading, #${name}_health_cover_rebate, #${name}_incomeBase").buttonset();
	
	});

	$('#${name}_dependants').on('change', function(){
		healthCoverDetails.setTiers();
		healthDependents.setDependants();
	} );

	$('#${name}_incomeBase').find('input').on('change', function(){
		$('#${name}_income').prop('selectedIndex',0);
		healthCoverDetails.setTiers();
	});

	<%-- Due to event-firing order, this is now in choices.tag
	$('#${name}_primaryCover, #${name}_partnerCover').find('input').on('change', function(){
		healthCoverDetails.setHealthFunds();
	});
	--%>
	$('#${name}-selection').find('.health_cover_details_rebate').on('change', function(){
		healthCoverDetails.setIncomeBase();
		healthChoices.dependants();
		healthCoverDetails.setTiers();
	} );

	$('#health_rebate, #health_loading').attr('disabled', true);

	healthCoverDetails.init();

</go:script>

<%-- CSS --%>
<go:style marker="css-head">
.health-cover_details h3 {
	padding-bottom: 0.5em;
}
.health-cover_details p {
	line-height: 150%;
}
#health-continuous-cover-partner, #health-continuous-cover-primary,
#${name}-selection .health_cover_details_incomeBasedOn,
#${name}-selection .health_cover_details_dependants,
#${name}_tier {
	min-height:0;
	display:none;
}
#health_rebates_group {
	display:none;
}
</go:style>
