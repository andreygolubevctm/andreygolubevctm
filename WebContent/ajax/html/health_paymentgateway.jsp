<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get />

<c:import var="config" url="/WEB-INF/aggregator/health_application/ahm/config.xml" />
<x:parse doc="${config}" var="configXml" />

<%-- PARAMS --%>
<c:set var="id" value="${data.current.transactionId}"></c:set>
<c:set var="accountType">
	<c:choose>
		<c:when test="${not empty param.type and param.type == 'DD'}">DD</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>
<c:set var="tokenUrl">
	<x:out select="$configXml/aggregator/westpacGateway/tokenUrl" />
</c:set>
<c:set var="username">
	<x:out select="$configXml/aggregator/westpacGateway/username" />
</c:set>
<c:set var="password">
	<x:out select="$configXml/aggregator/westpacGateway/password" />
</c:set>
<c:set var="registerUrl">
	<x:out select="$configXml/aggregator/westpacGateway/registerUrl" />
</c:set>
<c:set var="comm">
	<x:out select="$configXml/aggregator/westpacGateway/cd_community" />
</c:set>
<c:set var="supp">
	<x:out select="$configXml/aggregator/westpacGateway/cd_supplier_business" />
</c:set>
<c:set var="returnURL">
	<x:out select="$configXml/aggregator/westpacGateway/returnURL" />
</c:set>

<go:log source="health_paymentgateway_jsp" >health_paymentgateway: ID=${id}, ${tokenUrl}</go:log>

<c:choose>
	<c:when test="${empty tokenUrl or empty username or empty password or empty id or empty registerUrl or empty comm or empty supp}">
		<html>
		<body>
			<p><strong>Invalid request.</strong> We're missing some data required to perform this action. Your session may have expired.</p>
		</body>
		</html>
	</c:when>
	<c:otherwise>
		<c:catch var="gatewayError">
			<%-- Fetch a security token from Westpac --%>
			<c:import var="output" url="${tokenUrl}">
				<c:param name="username" value="${username}" />
				<c:param name="password" value="${password}" />
				<c:param name="cd_crn" value="${id}" />
				<c:param name="CP_brandID" value="CTM" />
				<c:param name="CP_cancelURL" value="${returnURL}" />
			</c:import>
		</c:catch>
		<go:log source="health_paymentgateway_jsp" >    Response: ${output}</go:log>

		<c:choose>
			<c:when test="${fn:startsWith(output, 'token=')}">
				<c:redirect url="${registerUrl}">
					<c:param name="token" value="${fn:replace(output, 'token=', '')}" />
					<c:param name="cd_crn" value="${id}" />
					<c:param name="cd_community" value="${comm}" />
					<c:param name="cd_supplier_business" value="${supp}" />
					<c:if test="${not empty accountType}">
						<c:param name="accountType" value="${accountType}" />
					</c:if>
					<c:if test="${not empty returnURL}">
						<c:param name="returnURL" value="${returnURL}" />
					</c:if>
				</c:redirect>
			</c:when>
			<c:otherwise>
				<html>
					<head>
						<script type="text/javascript" src="../../common/js/jquery-1.10.1.min.js"></script>
						<script>
							$(document).ready(function() {
								if (window.parent.meerkat && window.parent.meerkat.modules.paymentGateway) {
									window.parent.meerkat.messaging.publish(window.parent.meerkat.modules.events.paymentGateway.FAIL,'Failed to fetch security token');
								}
							});
						</script>
					</head>
					<body>
						<p>Failed</p>
					</body>
				</html>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
