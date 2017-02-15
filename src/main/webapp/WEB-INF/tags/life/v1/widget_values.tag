<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${not empty param.coverFor}">
	<c:set var="output">
		<c:choose>
			<c:when test="${param.coverFor eq 'Y'}">N</c:when>
			<c:when test="${param.coverFor eq 'YP'}">Y</c:when>
		</c:choose>
	</c:set>
	<go:setData dataVar="data" xpath="life/primary/insurance/partner" value="${output}" />
</c:if>

<c:if test="${not empty param.gender}">
	<c:set var="output">
		<c:choose>
			<c:when test="${fn:toUpperCase(param.gender) eq 'M'}">M</c:when>
			<c:when test="${fn:toUpperCase(param.gender) eq 'F'}">F</c:when>
		</c:choose>
	</c:set>
	<go:setData dataVar="data" xpath="life/primary/gender" value="${output}" />
</c:if>