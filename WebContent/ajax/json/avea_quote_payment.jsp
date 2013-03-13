<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%-- 
	car_quote_results.jsp

	Main workhorse for writing quotes and getting prices.
	It does the following:
	 - Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	 - Calls NTAGGTIC to write the client's data in AGGDTL detail file (and create the AGMHDR header record)   
	 - Initialises the SOAP Aggregator gadget
	 - Passes the client information to the SOAP Aggregator gadget to fetch prices 
	 - Calls AGGTRS to write the initial stats (passing the SOAP response data)
	 - Returns the SOAP response to the page as a JSON object

	@param quote_*	- Full car quote values
	
 --%>
 
<%-- Fetch and store the transaction id --%>
<go:call pageId="AGGTID" wait="TRUE" resultVar="tranXml" transactionId="${data['current/transactionId']}" />
<go:setData dataVar="data" xpath="current/transactionId" value="${tranXml}" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="quote/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="quote/transactionId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/avea_payment/config.xml" />

<c:set var="resultXml" value='' />

<go:soapAggregator config = "${config}"
					transactionId = "${data.text['current/transactionId']}" 
					xml = "${data.xml['quote']}" 
					var = "resultXml"
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

${go:XMLtoJSON(resultXml)}
