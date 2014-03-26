<%@ tag description="Loading of the Health Settings JS Object"%>
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

		<c:redirect url="${data['settings/root-url']}${data['settings/styleCode']}/health_confirmation.jsp">
			<c:param name="action" value="confirmation" />
			<c:param name="token" value="${token}" />
		</c:redirect>

	</c:if>
</c:if>

<%-- Include this tag to add required rebate multiplier variables to the request --%>
<health:changeover_rebates />

<script>
	<c:set var="fromBrochure" scope="request" value="${false}"/>
	<c:if test="${not empty param.cover || not empty param.situation || not empty param.location}">
		<c:set var="fromBrochure" scope="request" value="${true}"/>
	</c:if>
	var HealthSettings = {
		<%-- settings from include.tag --%>
		isCallCentreUser: <c:out value="${not empty callCentre}"/>,
		isFromBrochureSite: <c:out value="${fromBrochure}"/>,
		journeyStage: "<c:out value="${data['health/journey/stage']}"/>",
		pageAction: '<c:out value="${param.action}"/>',
		previousTransactionId: "<c:out value="${data['previous/transactionId']}"/>",
		isNewQuote: <c:out value="${isNewQuote eq true}" />,
		productId: '<c:out value="${data.health.application.productId}" />',
		userId: '<c:out value="${data.login.user.uid}" />'
		<%-- end settings from include.tag --%>

		<%-- Request-scope variables from health:changeover_rebates --%>
		, rebate_multiplier_current: <c:out value="${rebate_multiplier_current}" />
		, rebate_multiplier_future: <c:out value="${rebate_multiplier_future}" />
	};
</script>