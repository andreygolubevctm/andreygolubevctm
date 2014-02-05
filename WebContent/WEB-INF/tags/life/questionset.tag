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
</go:script>

<go:script marker="onready">
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
<%-- To remove blurriness from Firefox but still be cool elsewhere --%>
.qe-window h4 {
	font-weight: 500;
}
</go:style>