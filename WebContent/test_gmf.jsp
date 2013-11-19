<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<core:doctype />
<go:html>
	<core:head title="GMF Connection Test" />
	<body>

		<c:import var="testXML" url="/WEB-INF/aggregator/health_application/gmf/example.xml" />
		
		<c:import var="config" url="/WEB-INF/aggregator/health_application/gmf/config.xml" />
		<go:soapAggregator config = "${config}"
						transactionId = "1234" 
						xml = "${testXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
					    
					    
		<c:out value="${resultXml}" escapeXml="true" />
	</body>
</go:html>