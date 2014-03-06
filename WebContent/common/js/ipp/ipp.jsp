<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
This page is used as in iFrame tunnel for the IPP payment mechanism.
- Note it is called as an iFrame, within an IPP iFrame and targets the top most parent page (so it can call a parent function as a tunnel)
--%>
<go:log>IPP Tunnel being called</go:log>
<html>
	<head>
		<title>IPP Tunnel</title>
	</head>
<body>
	<%-- Check if we have not had a fail from IPP --%>
	<c:choose>
		<c:when test="${not empty param.error}">
			<script language="javascript" type="text/javascript">
				top.health_popup_payment_ipp.fail();
			</script>
		</c:when>
		<c:otherwise>
			<script language="javascript" type="text/javascript">
				var jsonPost = {
						token: '<c:out value="${param.token}" escapeXml="true" />',
						maskedcardno: '<c:out value="${param.maskedcardno}" escapeXml="true" />',
						cardtype: '<c:out value="${param.cardtype}" escapeXml="true" />',
						sst: '<c:out value="${param.sst}" escapeXml="true" />',
						sessionid: '<c:out value="${param.sessionid}" escapeXml="true" />',
						responsecode: '<c:out value="${param.responsecode}" escapeXml="true" />',
						responseresult: '<c:out value="${param.responseresult}" escapeXml="true" />',
						resultPage: '<c:out value="${param.resultPage}" escapeXml="true" />'
				}
				if(typeof top.health_popup_payment_ipp == 'undefined'){
					window.frames[0].health_popup_payment_ipp.register(jsonPost);
				} else {
					top.health_popup_payment_ipp.register(jsonPost);
				};
			</script>
		</c:otherwise>
	</c:choose>
</body>
</html>