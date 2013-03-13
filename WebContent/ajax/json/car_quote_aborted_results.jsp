<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%-- 
	car_quote_aborted_results.jsp
	
	When a user closes the button or unloads the page(?working) - this is triggered.	

	It does the following:
	 - Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	 - Calls NTAGGTIC to write the client's data in AGGDTL detail file (and create the AGMHDR header record)  	 
	 -- This is a fire and forget - without a return response
	@param quote_*	- Full car quote values
	
 --%>
 
<%-- Fetch and store the transaction id --%>
<go:call pageId="AGGTID" wait="TRUE" resultVar="tranXml" transactionId="${data['current/transactionId']}" />
<go:setData dataVar="data" xpath="current/transactionId" value="${tranXml}" />
<go:log>${tranXml}</go:log>

<c:if test="${empty param.action or param.action!='latest'}">
	<%-- Set data from the form and call AGGTIC to write the client data to tables --%>
	<%-- Note, we do not wait for it to return - this is a "fire and forget" request --%>
	<go:setData dataVar="data" xpath="quote" value="*DELETE" />
	<go:setData dataVar="data" value="*PARAMS" />
</c:if>
<go:setData dataVar="data" xpath="quote/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="quote/transactionId" value="${data['current/transactionId']}" />

<go:call pageId="AGGTIC" 
			xmlVar="${data['quote']}"
			transactionId="${data['current/transactionId']}" 
			mode="P"
			wait="FALSE"/>
			

<%-- Original content (save/write) from car_quote_results removed from below --%>

<%-- Does this need a return --%>
{ "result": "success" }