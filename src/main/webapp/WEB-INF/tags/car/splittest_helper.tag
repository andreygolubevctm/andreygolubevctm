<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<%-- MANDATORY CONTACT FIELDS --%>
<c:set var="mandatoryContactFieldsSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" />

<%-- EDIT DETAILS - REDBOOK CODE --%>
<c:set var="editDetailsRedbookCodeSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 8)}" />

<%-- MAIL CHECK --%>
<c:set var="emailHelperSplitTest" scope="request" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 21)}" />
