<%@ tag description="Loading of the Homeloan Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="situation"><c:out value="${param.situation}" escapeXml="true"/></c:set>
<c:set var="location"><c:out value="${param.location}" escapeXml="true"/></c:set>

<%-- VARIABLES --%>
<c:set var="fromBrochure" scope="request" value="${false}"/>
<c:if test="${not empty situation or not empty location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>
<c:set var="octoberComp" scope="application" value="${false}"/>
<c:set var="pageAction">
	<c:choose>
		<c:when test="${pageContext.request.servletPath == '/homeloan_confirmation.jsp'}">
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
		<c:if test="${not empty location}">location: '${location}'</c:if>
	},
	navMenu: {
		type: 'offcanvas',
		direction: 'right'
	},
	pageAction: '<c:out value="${pageAction}"/>',
	session: {
		firstPokeEnabled: <c:choose><c:when test="${pageAction eq 'confirmation'}">false</c:when><c:otherwise>true</c:otherwise></c:choose>
	}
}

<c:if test="${not empty cover || not empty situation || not empty location}">
	<c:set var="fromBrochure" scope="request" value="${true}"/>
</c:if>