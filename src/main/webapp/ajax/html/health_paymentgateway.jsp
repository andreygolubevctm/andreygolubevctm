<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" verticalCode="HEALTH" />
<c:set var="logger"  value="${log:getLogger('jsp.ajax.html.health_paymentgateway')}" />

<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />

<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/health_application/ahm/config.xml')}" />
<x:parse doc="${config}" var="configXml" />

<%-- PARAMS --%>
<c:set var="id">
	<c:choose>
		<c:when test="${not empty param.transactionId and param.loadSource eq 'salesForce'}">
			<c:out value="${param.transactionId}" escapeXml="true" />
		</c:when>
		<c:otherwise>
			${data.current.transactionId}
		</c:otherwise>
	</c:choose>
</c:set>
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
	${pageSettings.getBaseUrl()}spring/samesite/proxy
</c:set>

${logger.debug('Parsed request for health paymentgateway. {},{},{}', log:kv('username', username) , log:kv('id',id ), log:kv('tokenUrl',tokenUrl ))}

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
		<c:if test="${gatewayError}">
			${logger.error('Error importing url. {},{},{},{}', log:kv('tokenUrl',tokenUrl ), log:kv('username', username), log:kv('id',id ), log:kv('returnURL',returnURL ) , gatewayError)}
		</c:if>
		${logger.debug('Response from import. {}', log:kv('output',output ))}
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
