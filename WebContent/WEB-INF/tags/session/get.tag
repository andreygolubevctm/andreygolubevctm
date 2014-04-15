<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="verticalCode" required="false" rtexprvalue="true"  %>
<%@ attribute name="authenticated" required="false" rtexprvalue="true"  %>
<%@ attribute name="settings" required="false" rtexprvalue="true"  %>
<%@ attribute name="searchPreviousIds" required="false" rtexprvalue="true"  %>

<session:core />

<c:if test="${empty searchPreviousIds}">
	<%-- This is to support verticals where the transaction id is incremented by an ajax call but the client side variable is not updated.
	This parameter allows the session logic to look in the previous transaction id setting to look for a match
	PLEASE CONSIDER THIS ABILITY DEPRECATED AND ONLY HERE TO SUPPORT EXISTING FUNCTIONALITY --%>
	<c:set var="searchPreviousIds" value="false" />
</c:if>

<c:if test="${not empty verticalCode}">
	<%-- This is only for session recovery - if the data bucket is emptied, then this can be used to repopulate it correctly and load the correct application settings if required --%>
	<c:set var="recoveryVerticalSet" value="${applicationService.setVerticalCodeOnPageContext(pageContext, verticalCode)}" scope="page"  />
</c:if>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<c:set var="transactionId" value="${param.transactionId}"/>
<c:set var="data" value="${sessionDataService.getSessionForTransactionId(pageContext, transactionId, searchPreviousIds)}" scope="request"  />

<c:if test="${authenticated == true}">
	<session:getAuthenticated  />
</c:if>

<c:if test="${settings == true}">
	<c:set var="pageSettings" value="${applicationService.getPageSettingsForPage(pageContext)}" scope="request"  />
</c:if>