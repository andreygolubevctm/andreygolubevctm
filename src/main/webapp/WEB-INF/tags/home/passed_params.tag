<%@ tag description="Loading of the Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Retrieve values passed from Brochure Site --%>
<c:if test="${not empty param.ownProperty}">
	<go:setData dataVar="data" value="${param.ownProperty}" xpath="home/occupancy/ownProperty" />
</c:if>
<c:if test="${not empty param.coverType}">
	<go:setData dataVar="data" value="${param.coverType}" xpath="home/coverType" />
</c:if>
