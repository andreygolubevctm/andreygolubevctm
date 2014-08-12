<%@ tag description="Loading of the Health Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="situation"><c:out value="${param.situation}" escapeXml="true"/></c:set>
<c:set var="postcode_suburb_location"><c:out value="${param.postcode_suburb_location}" escapeXml="true"/></c:set>
<c:set var="cover"><c:out value="${param.cover}" escapeXml="true"/></c:set>
<c:set var="location"><c:out value="${param.location}" escapeXml="true"/></c:set>

<%-- VARIABLES --%>
<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty situation or not empty postcode_suburb_location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>

<c:set var="pageAction">
	<c:choose>
		<c:when test="${pageContext.request.servletPath == '/confirmation.jsp'}">
			confirmation
		</c:when>
		<c:otherwise>
			<c:out value="${param.action}"/>
		</c:otherwise>
	</c:choose>
</c:set>

{
	isFromBrochureSite: <c:out value="${fromBrochure}"/>,
	brochureValues:{
		<c:if test="${not empty situation}">situation: '${situation}'</c:if>
		<c:if test="${not empty situation and not empty postcode_suburb_location}">,</c:if>
		<c:if test="${not empty postcode_suburb_location}">location: '${postcode_suburb_location}'</c:if>
	},
	pageAction: '<c:out value="${pageAction}"/>'
}

<c:if test="${not empty cover || not empty situation || not empty location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>