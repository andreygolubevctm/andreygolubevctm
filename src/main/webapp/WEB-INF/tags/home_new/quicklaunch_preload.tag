<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Retrieve values passed from Brochure Site --%>
<c:if test="${not empty param.action && param.action == 'ql'}">
	<c:if test="${not empty param.home_coverType}">
		<go:setData dataVar="data" value="${param.home_coverType}" xpath="home/coverType" />
	</c:if>
	<c:if test="${not empty param.home_startDate}">
		<go:setData dataVar="data" value="${param.home_startDate}" xpath="home/startDate" />
	</c:if>
</c:if>