<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<life:applicant xpath="${xpath}/primary" label="Your Details" />
<life:applicant xpath="${xpath}/partner" label="Your Partner's Details" />
<life:contact_details xpath="${xpath}/contactDetails" />

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var TogglePartnerFields = function() {
	if( $('#${name}_primary_insurance_partner_Y').is(':checked') ) {
		$('#${name}_partner').slideDown('slow');
	} else {
		$('#${name}_partner').slideUp('fast');
	}
}
</go:script>

<go:script marker="onready">
TogglePartnerFields();
$('input[name=${name}_primary_insurance_partner]').on('change', TogglePartnerFields);
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
#${name}_partner {
	display: none;
}
</go:style>