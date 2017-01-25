<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Random hidden fields for the contact page"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- Optin fields (hidden) for email and phone --%>
<field_v1:hidden xpath="${xpath}/optInEmail" defaultValue="${val_optout}" />
<field_v1:hidden xpath="${xpath}/call" defaultValue="${val_optout}" />

<%-- form privacy_optin --%>
<c:choose>
	<%-- Only render a hidden field when the checkbox has already been selected --%>
	<c:when test="${data['health/privacyoptin'] eq 'Y'}">
		<field_v1:hidden xpath="health/privacyoptin" defaultValue="Y" constantValue="Y" />
	</c:when>
	<c:otherwise>
		<field_v1:hidden xpath="health/privacyoptin" className="validate" />
	</c:otherwise>
</c:choose>