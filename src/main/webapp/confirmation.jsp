<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<session:get settings="true" />
<c:choose>
	<c:when test="${param.action == 'error'}">
		<c:import url="confirmations/error.jsp" var="out">
			<c:param name="action" value="error" />
		</c:import>
		<c:out value="${out}" escapeXml="false" />
	</c:when>
	<c:when test="${pageSettings.getVerticalCode() eq 'generic' }">
		<c:redirect url="${pageSettings.getBaseUrl()}confirmation_entry.jsp">
			<c:param name="ConfirmationID" value="${param.ConfirmationID}" />
			<c:param name="data" value="repopulate" />
		</c:redirect>
	</c:when>
	<c:otherwise>
		<c:import url="confirmations/${pageSettings.getVerticalCode()}.jsp" var="out">
			<c:param name="action" value="confirmation" />
			<c:param name="transactionId" value="${data.current.transactionId}" />
		</c:import>
		<c:out value="${out}" escapeXml="false" />
	</c:otherwise>
</c:choose>