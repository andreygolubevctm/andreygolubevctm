<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId" required="true" rtexprvalue="true"  %>

<session:core />

<c:set var="data" value="${sessionDataService.removeSessionForTransactionId(pageContext.getRequest(), transactionId)}" scope="request"  />
