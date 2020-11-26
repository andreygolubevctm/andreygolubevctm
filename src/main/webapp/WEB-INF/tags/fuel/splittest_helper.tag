<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- CA2-478 Split Test J=customerAccounts test --%>
<c:set var="customerAccountsAuthHeaderSplitTest" scope="request">
    <c:choose>
        <c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 40)}">${true}</c:when>
        <c:otherwise>${false}</c:otherwise>
    </c:choose>
</c:set>