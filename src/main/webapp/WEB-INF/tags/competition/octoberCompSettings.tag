<%@ tag description="Loading of the October Competition Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="octoberComp" scope="application" value="${false}"/>
<c:set var="octoberCompDB"><content:get key="octoberComp" /></c:set>
<c:if test="${pageSettings.getBrandCode() eq 'ctm' && octoberCompDB eq 'Y'}">
	<c:set var="octoberComp" scope="application" value="${true}"/>
</c:if>