<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<core:doctype />
<go:html>
	<core:head title="NIB Connection Test" />
	<body>
		<c:set var="testXML">
			<health></health>
		</c:set>
	
		<c:import var="config" url="/WEB-INF/aggregator/health_application/nib/config.xml" />
		<go:soapAggregator config = "${config}"
						transactionId = "1234" 
						xml = "${testXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
	</body>
</go:html>