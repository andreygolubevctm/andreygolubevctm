<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.html.health_paymentgateway_return')}" />

<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" />
<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/health_application/ahm/config.xml')}" />
<x:parse doc="${config}" var="configXml" />

<%-- PARAMS --%>
<c:set var="comm">
	<x:out select="$configXml/aggregator/westpacGateway/cd_community" />
</c:set>
<c:set var="supp">
	<x:out select="$configXml/aggregator/westpacGateway/cd_supplier_business" />
</c:set>

${logger.debug('Start health_paymentgateway_return. {},{},{}', log:kv('action',param.action ), log:kv('fl_success',param.fl_success ),log:kv('tx_response', param.tx_response ))}

<c:set var="cardNumber" value="${go:jsEscape(param.cd_prerego)}" />
<c:set var="cardScheme" value="${go:jsEscape(param.nm_card_scheme)}" />
<c:set var="cardExpiry" value="${go:jsEscape(param.dt_expiry)}" />
<c:set var="cardHolderName" value="${go:jsEscape(param.nm_card_holder)}" />

<c:choose>
	<c:when test="${not empty param.fl_success and param.fl_success != '1'}">
		${logger.warn('Failed (fl_success != 1) WESTPAC. {},{},{}', log:kv('cardScheme', cardScheme), log:kv('cardExpiry',cardExpiry ), log:kv('cardHolderName',cardHolderName ))}
		<c:set var="success" value="false" />
		<c:set var="message" value="Failed (fl_success != 1)" />
	</c:when>
	<c:when test="${not empty param.action and param.action == 'Cancelled'}">
		${logger.info('Cancel button was pressed WESTPAC: {},{},{}', log:kv('cardScheme', cardScheme) ,log:kv('cardExpiry',cardExpiry ), log:kv('cardHolderName',cardHolderName ))}
		<c:set var="success" value="false" />
		<c:set var="message" value="Cancel button was pressed" />
	</c:when>
	<c:when test="${empty param.fl_success or empty param.cd_community or param.cd_community != comm or empty param.cd_supplier_business or param.cd_supplier_business != supp}">
		${logger.warn('Missing or unexpected parameters WESTPAC: {},{},{}', log:kv('cardScheme', cardScheme), log:kv('cardExpiry',cardExpiry ), log:kv('cardHolderName',cardHolderName ))}
		<c:set var="success" value="false" />
		<c:set var="message" value="Missing or unexpected parameters" />
	</c:when>
	<c:when test="${empty cardNumber or empty cardScheme or empty cardExpiry}">
		${logger.warn('Missing parameters WESTPAC: {},{},{}', log:kv('cardScheme', cardScheme), log:kv('cardExpiry',cardExpiry ), log:kv('cardHolderName',cardHolderName ))}
		<c:set var="success" value="false" />
		<c:set var="message" value="Missing parameters" />
	</c:when>
	<c:otherwise>
		<%-- Capture response values into data bucket --%>
		${logger.debug('Sucessful response was returned from WESTPAC payment gateway. {},{},{},{}', log:kv('cardScheme', cardScheme) , log:kv('cardExpiry', cardExpiry), log:kv('cardHolderName', cardHolderName))}
		<c:set var="success" value="true" />
		<c:set var="message"><c:out value="${param.tx_response}" default="OK" escapeXml="true" /></c:set>
	</c:otherwise>
</c:choose>

<core_v1:doctype />
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
		<meta http-equiv="Expires" content="-1">
		<meta http-equiv="Pragma" content="no-cache">
		<title>Registration outcome</title>

		<script type="text/javascript" src="../../common/js/jquery-1.10.1.min.js"></script>
		<script>
			var success = ${success};
			var message = "${message}";
			var params = {
						number:"${cardNumber}",
						type:"${cardScheme}",
						expiry:"${cardExpiry}",
						name:"${cardHolderName}"
						};
			$(document).ready(function() {
				var meerkat = window.parent.meerkat;
				if (meerkat && meerkat.modules.paymentGateway) {
					if (success) {
						meerkat.messaging.publish(meerkat.modules.events.paymentGateway.SUCCESS,params);
					} else {
						meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL,'return.jsp: '+message);
					}
				} else {
					$('p').html('Oops! The registration failed. Please try again.');
				}
			});
		</script>
	</head>
	<body>
		<p></p>
	</body>
</html>
