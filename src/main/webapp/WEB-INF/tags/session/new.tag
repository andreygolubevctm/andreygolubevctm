<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="verticalCode" required="true" rtexprvalue="true"  %>
<%@ attribute name="authenticated" required="false" rtexprvalue="true"  %>
<%@ attribute name="forceNew" required="false" rtexprvalue="true"  %>

<c:if test="${empty forceNew}">
	<c:set var="forceNew" value="false" />
</c:if>

<session:core />

<settings:setVertical verticalCode="${fn:toUpperCase(verticalCode)}" />

<c:choose>
	<c:when test="${not empty param.transactionId && forceNew == false}">
		<c:choose>
			<c:when test="${not empty param.action and not empty param.transactionId and (param.action eq 'amend' or param.action eq 'latest' or param.action eq 'confirmation' or param.action eq 'start-again' or param.action eq 'load' or param.action eq 'expired' or param.action eq 'promotion')}">
				<session:get searchLatestRelatedIds="true" />
			</c:when>
			<c:otherwise>
				<session:get />
			</c:otherwise>
		</c:choose>

	</c:when>
	<c:otherwise>
		<c:set var="data" value="${sessionDataService.addNewTransactionDataToSession(pageContext.getRequest())}" scope="request"  />
	</c:otherwise>
</c:choose>

<c:if test="${authenticated == true}">
	<session:getAuthenticated  />
</c:if>
