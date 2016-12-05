<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${not empty param.income}">
	<c:set var="income"><c:out value="${param.income}" escapeXml="true" /></c:set>
	<go:setData dataVar="data" xpath="ip/primary/insurance/income" value="${income}" />
</c:if>

<c:if test="${not empty param.gender}">
	<c:set var="output">
		<c:choose>
			<c:when test="${fn:toUpperCase(param.gender) eq 'M'}">M</c:when>
			<c:when test="${fn:toUpperCase(param.gender) eq 'F'}">F</c:when>
		</c:choose>
	</c:set>
	<go:setData dataVar="data" xpath="ip/primary/gender" value="${output}" />
</c:if>