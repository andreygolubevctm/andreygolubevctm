<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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