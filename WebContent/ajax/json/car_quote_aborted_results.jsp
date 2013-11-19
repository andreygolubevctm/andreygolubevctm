<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
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
<c:set var="sandpit">
	<core:get_transaction_id id_handler="increment_tranId" quoteType="CAR" />
</c:set>


<go:setData dataVar="data" xpath="quote/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<c:if test="${empty param.action or param.action!='latest'}">
	<%-- Set data from the form and call AGGTIC to write the client data to tables --%>
	<%-- Note, we do not wait for it to return - this is a "fire and forget" request --%>
	<go:setData dataVar="data" xpath="quote" value="*DELETE" />
	<go:setData dataVar="data" value="*PARAMS" />
	<c:set var="ignore"><agg:write_quote productType="CAR" rootPath="quote" /></c:set>
</c:if>

<%-- Does this need a return --%>
{ "result": "success" }