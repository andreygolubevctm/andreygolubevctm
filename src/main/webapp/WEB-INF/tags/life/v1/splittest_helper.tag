<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- LIF-406 Split Test J=11 test --%>
<c:set var="lif406SplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 11)}" />