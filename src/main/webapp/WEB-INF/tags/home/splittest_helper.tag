<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- HNC-405 Split Test J=11 --%>
<c:set var="brochurewarePassedParams" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 11)}" />
