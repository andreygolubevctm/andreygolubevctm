<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true"/>

<%--
Clear out any previous health quote information and restart the health application
1. clean out data relating to health pricing
2. re-direct back to the health application start page
--%>

<go:setData dataVar="data" value="*DELETE" xpath="health" />
<go:setData dataVar="data" value="*DELETE" xpath="readonly" />
<go:setData dataVar="data" value="*DELETE" xpath="soap-response" />
<go:setData dataVar="data" value="*DELETE" xpath="confirmation/health" />

<c:redirect url="${pageSettings.getBaseUrl()}health_quote.jsp">
	<c:forEach var="par" items="${param}">
		<c:if test="${par.key != 'ConfirmationID' && par.key != 'action' && not fn:startsWith(par.key, 'utm_') && par.key != 'PendingID'}">
			<c:param name="${par.key}" value="${par.value}" />
		</c:if>
	</c:forEach>	
</c:redirect>