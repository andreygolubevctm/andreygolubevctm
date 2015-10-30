<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<jsp:useBean id="simplesService" class="com.ctm.web.simples.services.SimplesService" scope="request" />
<jsp:useBean id="transactionService" class="com.ctm.web.health.services.TransactionService" scope="request" />

<session:get authenticated="true" />

<c:set var="operator" value="${authenticatedData['login/user/uid']}" />
<c:set var="tranId" value="${param.transactionId}" />

<c:choose>
	<%-- Try to insert a comment --%>
	<c:when test="${ simplesService.addComment(tranId, operator, param.comment) == true }">

		<%-- Fetch a new set of comments --%>
		<c:out value="${ transactionService.getCommentsForTransactionId(tranId) }" escapeXml="false" />

	</c:when>
	<c:otherwise>

		<%-- Generate error json --%>
		<json:object>
			<json:array name="errors">
				<json:object>
					<json:property name="message" value="Failed to add the comment" />
				</json:object>
			</json:array>
		</json:object>

	</c:otherwise>
</c:choose>
