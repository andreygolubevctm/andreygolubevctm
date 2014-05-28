<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
	Used to send the values chosen on the toggles back to the iSeries.
	Called whenever the user changes the "importance" of any of the toggles.
--%>

<c:catch var="error">
	<agg:email_results/>
</c:catch>

<c:choose>
	<c:when test="${not empty error}">
		{"success":false,"transactionId":"${data.current.transactionId}"}
	</c:when>
	<c:otherwise>{"success":true,"transactionId":"${data.current.transactionId}"}</c:otherwise>
</c:choose>