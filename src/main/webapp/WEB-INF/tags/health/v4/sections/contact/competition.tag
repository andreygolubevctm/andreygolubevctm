<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<health_v4_contact:competition_settings />

<c:if test="${competitionEnabled == true}">
	<c:set var="competitionPreCheckboxContainer"><content:get key="competitionPreCheckboxContainer"/></c:set>

	<c:out value="${competitionPreCheckboxContainer}" escapeXml="false" />
	<c:if test="${!fn:contains(competitionPreCheckboxContainer, 'health1000promoImage')}">
		<c:set var="offset_class" value=" no-offset"/>
	</c:if>
	<c:if test="${not empty competitionPreCheckboxContainer}">
		<form_v2:row className="competition-optin-group ${offset_class}" hideHelpIconCol="true">
			<c:out value="${competitionPreCheckboxContainer}" escapeXml="false" />
		</form_v2:row>
	</c:if>
	<form_v2:row className="competition-optin-group" hideHelpIconCol="true">
		<c:set var="competitionLabel">
			<content:get key="competitionCheckboxText"/>
		</c:set>
		<field_v2:checkbox xpath="${xpath}/competition/optin" value="Y" required="false" label="${true}" title="${competitionLabel}" errorMsg="Please tick" />
		<field_v1:hidden xpath="${xpath}/competition/previous" />
	</form_v2:row>
</c:if>