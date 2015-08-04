<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="verticalCode" value="HOME" />

<session:get settings="true" authenticated="true" verticalCode="${verticalCode}" />

<c:set var="vertical" value="home" />
<c:set var="touch" value="R" />
<c:set var="valid" value="true" />

<%--
	home/results.jsp

	Main workhorse for writing quotes and getting prices.
	It does the following:
	- Gets a new transaction id (passing the old one if it exists so we can link the old and new quotes)
	- Calls NTAGGTIC to write the client's data in AGGDTL detail file (and create the AGMHDR header record)
	- Initialises the SOAP Aggregator gadget
	- Passes the client information to the SOAP Aggregator gadget to fetch prices
	- Calls AGGTRS to write the initial stats (passing the SOAP response data)
	- Returns the SOAP response to the page as a JSON object

	@param quote_*	- Full home quote values

--%>

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
<error:recover origin="ajax/json/home/results_ws.jsp" quoteType="${vertical}" />
</c:if>

<%-- Save client data --%>
<core:transaction touch="${touch}" noResponse="true" writeQuoteOverride="${writeQuoteOverride}" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:forward page="/rest/home/quote/get.json"/>