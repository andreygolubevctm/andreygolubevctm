<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Settings"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Vars for competition --%>
<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionSecret"><content:get key="competitionSecret"/></c:set>
<c:set var="competitionEnabled" value="${false}" />
<c:if test="${competitionEnabledSetting == 'Y' && competitionSecret == 'kSdRdpu5bdM5UkKQ8gsK'}">
	<c:set var="competitionEnabled" value="${true}" />
</c:if>
