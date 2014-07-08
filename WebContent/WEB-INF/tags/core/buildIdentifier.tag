<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="environmentService" class="com.ctm.services.EnvironmentService" scope="request" />

<c:set var="buildIdentifier" value="${ environmentService.getBuildIdentifier() }" />

<c:if test="${ empty buildIdentifier or buildIdentifier == 'dev' }">
	<c:choose>
		<c:when test="${ pageContext.request.localName == 'localhost' }">
			<c:set var="buildIdentifier" value="localhost" />
		</c:when>
		<c:otherwise>
			<c:set var="buildIdentifier" value="dev" />
		</c:otherwise>
	</c:choose>
</c:if>

<c:out value="${buildIdentifier}" />