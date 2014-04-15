<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="verticalCode" required="true" rtexprvalue="true"  %>
<%@ attribute name="authenticated" required="false" rtexprvalue="true"  %>
<%@ attribute name="forceNew" required="false" rtexprvalue="true"  %>

<c:if test="${empty forceNew}">
	<c:set var="forceNew" value="false" />
</c:if>

<session:core />
<settings:setVertical verticalCode="${verticalCode}" />

<c:choose>
	<c:when test="${not empty param.transactionId && forceNew == false}">
		<session:get />
	</c:when>
	<c:otherwise>
		<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
		<c:set var="data" value="${sessionDataService.addNewTransactionDataToSession(pageContext)}" scope="request"  />
	</c:otherwise>
</c:choose>

<c:if test="${authenticated == true}">
	<session:getAuthenticated  />
</c:if>
