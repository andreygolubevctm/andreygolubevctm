<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${not empty param.income}">
	<c:set var="income"><c:out value="${param.income}" escapeXml="true" /></c:set>
	<go:setData dataVar="data" xpath="ip/primary/insurance/income" value="${income}" />
</c:if>