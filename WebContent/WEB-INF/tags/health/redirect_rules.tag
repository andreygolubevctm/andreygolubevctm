<%@ tag description="Redirect rules for Health"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- redirect to the health confirmation page if coming from an email with old link --%>
<c:if test="${!fn:containsIgnoreCase(pageContext.request.servletPath, 'health_confirmation.jsp')}">
	<c:if test="${not empty param.action and param.action eq 'confirmation' and ( not empty param.PendingID or not empty param.ConfirmationID or not empty param.token )}">

		<c:set var="token" value="" />

		<c:choose>
			<c:when test="${not empty param.ConfirmationID}">
				<c:set var="token" value="${param.ConfirmationID}" />
			</c:when>
			<c:when test="${not empty param.PendingID}">
				<c:set var="token" value="${param.PendingID}" />
			</c:when>
			<c:when test="${not empty param.token}">
				<c:set var="token" value="${param.token}" />
			</c:when>
		</c:choose>

		<c:redirect url="${pageSettings.getBaseUrl()}health_confirmation.jsp">
			<c:param name="action" value="confirmation" />
			<c:param name="token" value="${token}" />
		</c:redirect>

	</c:if>
</c:if>