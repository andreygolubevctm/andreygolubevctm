<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="TRAVEL" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="travel" />

<%-- Test and or Increment ID if required --%>
<c:choose>
    <%-- RECOVER: if things have gone pear shaped --%>
    <c:when test="${empty data.current.transactionId}">
        <error:recover origin="ajax/json/travel_quote_results.jsp" quoteType="travel" />
    </c:when>
    <c:when test="${param.incrementTransactionId == true}">
        <c:set var="id_return">
            <core:get_transaction_id quoteType="travel" id_handler="increment_tranId" transactionId="${data.current.transactionId}" />
        </c:set>
    </c:when>
    <c:otherwise>
        <%-- All is good --%>
    </c:otherwise>
</c:choose>


<%-- Save data --%>
<core:transaction touch="R" noResponse="true"  />


<jsp:forward page="/rest/travel/quote/get.json"/>