<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<core:doctype />
<html>

	<body>
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0137917_AUF_req_in_1356907240236.xml" var="textXML" />
		<c:import var="config" url="/WEB-INF/aggregator/health_application/auf/config.xml" />
 	<go:soapAggregator config = "${config}"
						transactionId = "2137917" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
 	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0237929_AUF_req_in_1356907517348.xml" var="textXML" />
	
		<go:soapAggregator config = "${config}"
						transactionId = "2237929" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
 	
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0337948_AUF_req_in_1356907812358.xml" var="textXML" />
	
		<go:soapAggregator config = "${config}"
						transactionId = "2337948" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0438023_AUF_req_in_1356909743935.xml" var="textXML" />
	
		<go:soapAggregator config = "${config}"
						transactionId = "2438023" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0537954_AUF_req_in_1356907919300.xml" var="textXML" />
	
		<go:soapAggregator config = "${config}"
						transactionId = "2537954" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0637997_AUF_req_in_1356909066156.xml" var="textXML" />
	
		<go:soapAggregator config = "${config}"
						transactionId = "2637997" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0738014_AUF_req_in_1356909468728.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "2738014" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0838157_AUF_req_in_1356911465862.xml" var="textXML" />
	<go:soapAggregator config = "${config}"
						transactionId = "2838157" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/0938034_AUF_req_in_1356909948981.xml" var="textXML" />
	
		<go:soapAggregator config = "${config}"
						transactionId = "2938034" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />
	
	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1038100_AUF_req_in_1356910914552.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3038100" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1138222_AUF_req_in_1356913100894.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3138222" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1238145_AUF_req_in_1356911273198.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3238145" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1338284_AUF_req_in_1356913624217.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3338284" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1438227_AUF_req_in_1356913180481.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3438227" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1538238_AUF_req_in_1356913341549.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3538238" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1638353_AUF_req_in_1356914505236.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3638353" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	<c:import url="/WEB-INF/aggregator/health_application/auf/extract-fixed/1738544_AUF_req_in_1356916173398.xml" var="textXML" />
			<go:soapAggregator config = "${config}"
						transactionId = "3738544" 
						xml = "${textXML}" 
					    var = "resultXml"
					    debugVar="debugXml" />

	</body>
</html>