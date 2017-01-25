<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition code for the sidebar"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v4_contact:competition_settings />
<%-- Please check the database for this content --%>
<c:if test="${competitionEnabled == true}">
	<content:get key="healthCompetitionRightColumnPromo"/>
</c:if>

<health_v2_content:sidebar />