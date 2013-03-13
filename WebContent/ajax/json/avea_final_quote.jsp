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

 <%-- Check if session good to go --%>	
<c:if test="${data['quote/options/commencementDate'] != null 
		&& not empty data['quote/options/commencementDate']
		&& data['quote/options/commencementDate'] != '' 
		&& fn:length(data['quote/options/commencementDate'])==10}">

<%-- Fetch and store the transaction id --%>
<go:call pageId="AGGTID" wait="TRUE" resultVar="tranXml" transactionId="${data['current/transactionId']}" />
<go:setData dataVar="data" xpath="current/transactionId" value="${tranXml}" />
<go:setData dataVar="data" value="*PARAMS" />
<go:setData dataVar="data" xpath="quote/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="quote/transactionId" value="${data['current/transactionId']}" />

<go:call pageId="AGGTIC" 
			xmlVar="${data['quote']}"
			transactionId="${data['current/transactionId']}" 
			mode="P"
			wait="FALSE"/>


	<%-- Load the config and send quotes to the aggregator gadget --%>
	<c:import var="config" url="/WEB-INF/aggregator/avea_final_quote/config.xml" />
	<go:soapAggregator config = "${config}"
						transactionId = "${data.text['current/transactionId']}" 
						xml = "${data.xml['quote']}" 
						var = "resultXml"
						debugVar="debugXml" />
	
	<%-- Add the results to the current session data --%>
	<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
	<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	
	<c:import var="transferXml" url="/WEB-INF/xslt/AGGTRS.xsl"/>
	<c:set var="stats">
		<x:transform xml="${debugXml}" xslt="${transferXml}">
			<x:param name="excess" value="${data['quote/excess']}" />
		</x:transform>
	</c:set>
	

<go:log>Writing Results to iSeries</go:log>

<go:call pageId="AGGTRS"   xmlVar="${stats}" wait="FALSE" transactionId="${data['current/transactionId']}" />
<%-- Return the results as json --%>
${go:XMLtoJSON(resultXml)}
</c:if>