<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- CAR-1206 Split Test J=4 test --%>
<c:set var="regoLookupSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 4) or splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 41)}" />

<%-- CAR-1294 Split Test J=8 test --%>
<c:set var="moreInfoSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 8)}" />
