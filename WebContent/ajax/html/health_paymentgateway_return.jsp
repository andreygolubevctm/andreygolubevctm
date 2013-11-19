<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:import var="config" url="/WEB-INF/aggregator/health_application/ahm/config.xml" />
<x:parse doc="${config}" var="configXml" />

<%-- PARAMS --%>
<c:set var="comm">
	<x:out select="$configXml/aggregator/westpacGateway/cd_community" />
</c:set>
<c:set var="supp">
	<x:out select="$configXml/aggregator/westpacGateway/cd_supplier_business" />
</c:set>

<go:log>health_paymentgateway_return: action:${param.action}, fl_success:${param.fl_success}, tx_response:${param.tx_response}</go:log>

<core:doctype />
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
		<meta http-equiv="Expires" content="-1">
		<meta http-equiv="Pragma" content="no-cache">
		<title>Registration outcome</title>

		<script type="text/javascript" src="../../common/js/jquery-1.7.2.min.js"></script>
		<script>
			var success = false;
			var message = '';
			var params = {};
			$(document).ready(function() {
				if (window.parent.healthFunds.paymentGateway) {
					if (success) {
						window.parent.healthFunds.paymentGateway.success(params);
					}
					else {
						window.parent.healthFunds.paymentGateway.fail('return.jsp: '+message);
					}
				}
				else {
					//if (success) {
					//	$('p').html('Thank you - you have successfully registered.');
					//}
					//else {
						$('p').html('Oops! The registration failed. Please try again.');
					//}
				}
			});
		</script>
	</head>
	<body>
		<c:choose>
			<c:when test="${not empty param.fl_success and param.fl_success != '1'}">
				<script>
					success = false;
					message = 'Failed (fl_success != 1)';
					params = {};
				</script>
			</c:when>
			<c:when test="${not empty param.action and param.action == 'Cancelled'}">
				<script>
					success = false;
					message = 'Cancel button was pressed';
					params = {};
				</script>
			</c:when>
			<c:when test="${empty param.fl_success or empty param.cd_community or param.cd_community != comm or empty param.cd_supplier_business or param.cd_supplier_business != supp}">
				<script>
					success = false;
					message = 'Missing or unexpected parameters';
					params = {};
				</script>
			</c:when>
			<c:when test="${empty param.cd_prerego or empty param.nm_card_scheme or empty param.dt_expiry}">
				<script>
					success = false;
					message = 'Missing parameters';
					params = {};
				</script>
			</c:when>
			<c:otherwise>
				<%-- Capture response values into data bucket --%>
				<go:log>WESTPAC: ${param.cd_prerego}, ${param.nm_card_scheme}, ${param.dt_expiry}, ${param.nm_card_holder}</go:log>
				<script>
					success = true;
					message = '<c:out value="${param.tx_response}" default="OK" escapeXml="true" />';
					params = {number:'${param.cd_prerego}', type:'${param.nm_card_scheme}', expiry:'${param.dt_expiry}', name:'${param.nm_card_holder}'};
				</script>
			</c:otherwise>
		</c:choose>
		
		<p></p>
	</body>
</html>
