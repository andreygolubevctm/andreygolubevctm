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
<c:set var="param_location">
	<c:choose>
		<c:when test="${not empty param.postcode_suburb_location}"><c:out value="${param.postcode_suburb_location}" escapeXml="true" /></c:when>
		<c:when test="${not empty param.postcode_suburb_mobile_location}"><c:out value="${param.postcode_suburb_mobile_location}" escapeXml="true" /></c:when>
		<c:when test="${not empty param.health_location}"><c:out value="${param.health_location}" escapeXml="false" /></c:when>
	</c:choose>
</c:set>
<c:set var="param_situation"><c:out value="${param.situation}" escapeXml="true" /></c:set>
<c:set var="param_state"><c:out value="${param.state}" escapeXml="true" /></c:set>


<%-- Test if the data is already set. Advance the user if Params are filled --%>
<c:if test="${empty data[xpathSituation].healthCvr && empty data[xpathSituation].healthSitu}">
	<%-- Data Bucket --%>
	<go:setData dataVar="data" xpath="${xpathSituation}/healthCvr" value="${param_cover}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/location" value="${param_location}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/state" value="${param_state}" />
	<go:setData dataVar="data" xpath="${xpathSituation}/healthSitu" value="${param_situation}" />
	<go:setData dataVar="data" xpath="${xpathBenefits}/healthSitu" value="${param_situation}" />
</c:if>
