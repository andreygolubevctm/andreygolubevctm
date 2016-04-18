<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- TRV-1154 Split Test J=99: Popular Destinations --%>
<c:set var="popularDestinationsEnabled"  scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 99)}" />