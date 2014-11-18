<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Homeloan details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<c:set var="currentLoan" value="${xpath}/currentLoan"/>
<c:set var="situation" value="${xpath}/situation"/>

<c:set var="displayCurrentLoan"><c:out value="${data[currentLoan]}" escapeXml="true"/></c:set>
<c:set var="displaySituation"><c:out value="${data[situation]}" escapeXml="true"/></c:set>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- POPULATE DATA WITH ANY PARAMS RECEIVED --%>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var LocationObj = {

	is_valid : function( location ) {
		var search_match = new RegExp(/^((\s)*[\w\-]+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(location));

		if( value != '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}

		return false;
	}
}

<%-- To proceed a user must select either a valid postcode or enter a suburb and
	select a valid suburb/postcode/state value from the autocomplete. This is to
	avoid suburbs that match multiple locations being sent with request only to be
	returned empty because can only search a single location (FUE-23). --%>
$.validator.addMethod("validateSuburbPostcodeState",
	function(value, element) {

		if( LocationObj.is_valid(value) ) {

			<%-- Populate suburb, postcode, state fields --%>
			var location = $.trim(String(value));
			var pieces = location.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');

			$('#${name}_state').val(state);
			$('#${name}_postcode').val(postcode);
			$('#${name}_suburb').val(suburb);

			return true;
		}

		return false;
	},
	"Replace this message with something else"
);
</go:script>

<%-- HTML --%>
<%-- NOTE: situation and goal values need to be kept in sync with com.ctm.model.homeloan.HomeLoanProductSearchRequest

TODO F=Looking to Re-enter the Market to be added post relaunch
 --%>
<form_new:fieldset legend="Your Situation" >
	<form_new:row label="I am">

		<field_new:array_select items="=Please choose...,F=A First Home Buyer,E=An Existing Home Owner" xpath="${xpath}/situation" title="your situation" required="true" />
	</form_new:row>

	<form_new:row label="I am looking to">
		<field_new:array_select items="=Please choose...,FH=Buy my first home,APL=Buy another property to live in,IP=Buy an investment property,REP=Renovate my existing property,CD=Consolidate my debt,CL=Compare better home loan options" xpath="${xpath}/goal" title="your situation" required="true" />
	</form_new:row>

	<form_new:row label="I live in">
		<field_new:lookup_suburb_postcode xpath="${xpath}/location" required="true" placeholder="Suburb / Postcode" />
		<field:hidden xpath="${xpath}/suburb" defaultValue="" />
		<field:hidden xpath="${xpath}/postcode" defaultValue="" />
		<field:hidden xpath="${xpath}/state" defaultValue="" />
	</form_new:row>

	<div id="${name}_existingToggleArea" class="${name}_existingToggleArea show_${displayCurrentLoan}">
		<form_new:row label="Do you currently have a home loan?">
			<field_new:array_radio id="${name}_currentLoan" xpath="${xpath}/currentLoan" required="true" items="Y=Yes,N=No" title="${title}whether you currently have a home loan" />
		</form_new:row>
		<div id="${name}_currentLoanToggleArea" class="${name}_currentLoanToggleArea show_${displayCurrentLoan}">
			<form_new:row label="How much do you have owing on your existing home loan(s)?">
				<field_new:currency xpath="${xpath}/amountOwing" decimal="${false}" defaultValue="" title="Existing home loan" required="true" maxValue="1000000000" />
			</form_new:row>
		</div>

		<form_new:row label="What is the current value of your existing property(ies)?">
			<field_new:currency xpath="${xpath}/assetAmount" title="Current property value" decimal="${false}" defaultValue="" required="true" maxValue="1000000000" />
		</form_new:row>
	</div>


</form_new:fieldset>

<%-- VALIDATION --%>
<go:validate selector="${name}_location" rule="validateSuburbPostcodeState" parm="true" message="Please select a valid suburb / postcode" />
