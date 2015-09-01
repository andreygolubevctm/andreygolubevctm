<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Check whether is a new quote or existing and sets the isNEWQuote variable"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${go:getLogger('tag:core_new.quote_check')}" />

<%@ attribute name="quoteType" 	required="true"		rtexprvalue="true"	description="The vertical this quote is for"%>

<c:if test="${not empty quoteType}">
    <c:set var="isNewQuote" scope="session">
        <c:choose>
            <c:when test="${not empty param.action and not empty data.current.transactionId and (param.action eq 'amend' or param.action eq 'latest' or param.action eq 'confirmation' or param.action eq 'start-again' or param.action eq 'load' or param.action eq 'expired' or param.action eq 'promotion')}">${false}</c:when>
            <c:when test="${empty data['current/transactionId']}">true</c:when>
            <c:otherwise>${true}</c:otherwise>
        </c:choose>
    </c:set>

    <c:choose>
        <c:when test="${isNewQuote eq true}">
            <core:transaction touch="N" noResponse="true" />
        </c:when>
        <c:otherwise>
            ${logger.debug('Treated as EXISTING quote')}
        </c:otherwise>
    </c:choose>
</c:if>

<%-- Check if quote has been loaded previously (eg page reload) then increment the tranID --%>
<c:if test="${isNewQuote eq false}">
    <c:set var="reloadCount" value="${data.current.reloadCount}" />
    <c:choose>
        <c:when test="${empty reloadCount}">
            <go:setData dataVar="data" xpath="current/reloadCount" value="${0}" />
        </c:when>
        <c:otherwise>
            <go:setData dataVar="data" xpath="current/reloadCount" value="${data.current.reloadCount + 1}" />
            <c:set var="tmpIncrementedTranID"><core:get_transaction_id quoteType="${quoteType}" id_handler="increment_tranId" transactionId="${data.current.transactionId}"/></c:set>
            <core:transaction touch="L" />
        </c:otherwise>
    </c:choose>
</c:if>