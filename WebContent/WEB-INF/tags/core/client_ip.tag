<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Captures the ClientIP address and adds to the session scope"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="clientIP" 	required="false"	description="Override the Session"%>

<c:if test="${!empty clientIP}">
	<c:set var="userIP" scope="session" value="${clientIP}"/>
</c:if>

<c:set var="getRemoteAddr" value="<%=request.getRemoteAddr()%>" />
<c:set var="getHeader" value="<%=request.getHeader("X-FORWARDED-FOR")%>" />

<%-- Check if the session variable has been set by the client IP and ignore if it has --%>

<c:if test="${empty sessionScope.userIP}">

	<c:set var="userIP" scope="session">
		<c:choose>
			<c:when test="${!empty fn:trim(getHeader) }">
					${getHeader}
			</c:when>
			<c:otherwise>
					${getRemoteAddr}
			</c:otherwise>
		</c:choose>
	</c:set>

	<%-- Fall back --%>
	<c:if test="${empty fn:trim(userIP)}">
		<go:log>Fall back for the user IP</go:log>
		<c:set var="userIP" scope="session"> ${pageContext.request.remoteAddr}</c:set>
	</c:if>

</c:if>