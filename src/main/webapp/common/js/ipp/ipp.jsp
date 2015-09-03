<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp:common.js.ipp.ipp')}" />

<%--
This page is used as in iFrame tunnel for the IPP payment mechanism.
- Note it is called as an iFrame, within an IPP iFrame and targets the top most parent page (so it can call a parent function as a tunnel)

Example of tunneling, whether in Simples or not parent.parent will skip over the gateway:
[ simples - Domain A]
	[ iframe Health - Domain B
		[ iframe Gateway - Domain C
			[ iFrame tunnel - Domain B ]
		]
	]
]

--%>
${logger.info('IPP Tunnel being called. {}' , log:kv('param.responsecode',param.responsecode) )}
<html>
	<head>
		<title>IPP Tunnel</title>
	</head>
<body>
	<%-- Check if we have not had a fail from IPP --%>
	<c:choose>
		<c:when test="${not empty param.error}">
			<script language="javascript" type="text/javascript">
				parent.parent.meerkat.modules.healthPaymentIPP.fail('IPP Authentication, ' + '<c:out value="${param.responsecode}" escapeXml="true" />');
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
				};
				<%-- The iFrame's parent should always be only one level up, whether in Simples or single page --%>
				parent.parent.meerkat.modules.healthPaymentIPP.register(jsonPost);
			</script>
		</c:otherwise>
	</c:choose>
</body>
</html>