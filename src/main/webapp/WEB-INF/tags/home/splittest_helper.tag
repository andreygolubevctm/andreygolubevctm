<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<!-- SINGLE OPTIN TEST - 1 & 2 default and 3 is the test -->
<c:set var="singleOptinSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 3)}" />