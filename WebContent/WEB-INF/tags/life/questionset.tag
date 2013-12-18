<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<c:choose>
	<c:when test="${name eq 'life'}">
		<life:applicant xpath="${xpath}/primary" label="About You and Your Partner" />
	</c:when>
	<c:otherwise>
		<life:applicant xpath="${xpath}/primary" label="About You" />
	</c:otherwise>
</c:choose>
<life:applicant xpath="${xpath}/partner" label="About Your Partner" />
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