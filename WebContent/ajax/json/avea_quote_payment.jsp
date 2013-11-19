<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
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
<c:import var="getTransactionID" url="/ajax/json/get_transactionid.jsp">
	<c:param name="id_handler">increment_tranId</c:param>
</c:import>

<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="quote/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="quote/transactionId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/avea_payment/config.xml" />

<c:set var="resultXml" value='' />

<go:soapAggregator config = "${config}"
					transactionId = "${data.text['current/transactionId']}"
					xml = "${go:getEscapedXml(data['quote'])}"
					var = "resultXml"
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

${go:XMLtoJSON(resultXml)}
