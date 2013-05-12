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
 
<%-- Fetch and store the transaction id 
<go:call pageId="AGGTID" wait="TRUE" resultVar="tranXml" transactionId="${data['current/transactionId']}" style="CTM"/>
--%>
<%--<go:setData dataVar="data" xpath="current/transactionId" value="${tranXml}" />--%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<go:log>SAVE CAR ID 1: ${data['current/transactionId']}</go:log>

<c:if test="${empty param.action or param.action!='latest'}">
	<%-- Set data from the form and call AGGTIC to write the client data to tables --%>
	<%-- Note, we do not wait for it to return - this is a "fire and forget" request --%>
	<go:setData dataVar="data" xpath="quote" value="*DELETE" />
	<go:setData dataVar="data" value="*PARAMS" />
</c:if>
<go:setData dataVar="data" xpath="quote/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="quote/clientUserAgent" value="${clientUserAgent}" />
<go:setData dataVar="data" xpath="quote/transactionId" value="${data['current/transactionId']}" />

<%-- set items a comma seperated list of values in value=description format --%>
<c:set var="items">CarInsurance = CarInsurance,okToCall = ${data.quote.contact.oktocall},marketing = ${data.quote.contact.marketing}</c:set>

<go:call pageId="AGGTIC" 
			xmlVar="${go:getEscapedXml(data['quote'])}"
			transactionId="${data['current/transactionId']}" 
			mode="P"
			wait="FALSE"
			style="CTM"/>
			
<%-- Save client data to DB marketing --%>
<%-- <agg:write_email items="${items}" emailSource="CARQ" />--%>

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/get_prices/config.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${data.text['current/transactionId']}" 
					xml = "${go:getEscapedXml(data['quote'])}" 
					var = "resultXml"
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

<go:setData dataVar="data" xpath="quote/crsr/leadNo" value="${data['soap-response/results/price[@service=CRSR]/leadNo']}" />
<go:setData dataVar="data" xpath="quote/crsr/prodId" value="${data['soap-response/results/price[@productId=CRSR-01-01]/prodId']}" />

<go:setData dataVar="data" xpath="quote/aubn/leadNo" value="${data['soap-response/results/price[@service=AUBN]/leadNo']}" />
<go:setData dataVar="data" xpath="quote/aubn/prodId" value="${data['soap-response/results/price[@productId=AUBN-01-01]/prodId']}" />


<c:import var="transferXml" url="/WEB-INF/xslt/AGGTRS.xsl"/>
<c:set var="stats">
	<x:transform xml="${debugXml}" xslt="${transferXml}">
		<x:param name="excess" value="${data['quote/excess']}" />
	</x:transform>
</c:set>

<go:log>Writing Results to iSeries ${data['current/transactionId']}</go:log>

<go:call pageId="AGGTRS"   xmlVar="${stats}" wait="FALSE" transactionId="${data['current/transactionId']}" style="CTM"/>
<%-- Return the results as json --%>
${go:XMLtoJSON(resultXml)}
