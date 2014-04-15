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

		<c:redirect url="${pageSettings.getBaseUrl()}health_confirmation.jsp">
			<c:param name="action" value="confirmation" />
			<c:param name="token" value="${token}" />
		</c:redirect>

	</c:if>
</c:if>

<script>
	<c:set var="fromBrochure" scope="request" value="${false}"/>
	<c:if test="${not empty param.cover || not empty param.situation || not empty param.location}">
		<c:set var="fromBrochure" scope="request" value="${true}"/>
	</c:if>
	var HealthSettings = {
		isCallCentreUser: <c:out value="${not empty callCentre}"/>,
		isFromBrochureSite: <c:out value="${fromBrochure}"/>,
		journeyStage: "<c:out value="${data['health/journey/stage']}"/>",
		pageAction: '<c:out value="${param.action}"/>',
		previousTransactionId: "<c:out value="${data['previous/transactionId']}"/>",
		isNewQuote: <c:out value="${isNewQuote eq true}" />,
		productId: '<c:out value="${data.health.application.productId}" />',
		userId: '<c:out value="${authenticatedData.login.user.uid}" />',
		liveChat: {
			config: {
				lpServer			: "server.lon.liveperson.net",
				lpTagSrv			: "sr1.liveperson.net",
				lpNumber			: "1563103",
				deploymentID		: "1",
				//pluginsConsoleDebug will suppress debug console logs being output for our liveperson plugins.
				pluginsConsoleDebug	: false
			},
			instance: {
				brand	: '${pageSettings.getBrandCode()}',
				vertical: 'Health',
				unit	: 'health-insurance-sales',
				button	: 'chat-health-insurance-sales'
			}
		}
	};
</script>