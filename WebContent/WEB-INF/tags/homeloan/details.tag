<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- POPULATE DATA WITH ANY PARAMS RECEIVED --%>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var LocationObj = {

	is_valid : function( location ) {
		var search_match = new RegExp(/^((\s)*\w+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

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
<form_new:fieldset legend="My Situation" >
	<form_new:row label="I am">
		<field:array_select items="=Please choose...,F=A First Home Buyer,E=An Existing Home Owner" xpath="${xpath}/situation" title="your situation" required="true" />
	</form_new:row>
	<form_new:row label="Living in">
		<field_new:lookup_suburb_postcode xpath="${xpath}/location" required="true" placeholder="Suburb / Postcode" />
		<field:hidden xpath="${xpath}/suburb" defaultValue="" />
		<field:hidden xpath="${xpath}/postcode" defaultValue="" />
		<field:hidden xpath="${xpath}/state" defaultValue="" />
	</form_new:row>
</form_new:fieldset>

<%-- VALIDATION --%>
<go:validate selector="${name}_location" rule="validateSuburbPostcodeState" parm="true" message="Please select a valid suburb / postcode" />