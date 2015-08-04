<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="competitionService" class="com.ctm.services.competition.CompetitionService" />
<c:set var="jeepCompetitionEnabledFlag" scope="session" value="${competitionService.isActive(pageContext.getRequest(), 15)}" />

<c:if test="${jeepCompetitionEnabledFlag eq true}">

	<div class="row row-content jeepPromotion">
		<a href="<content:get key="febJeepPromoTNCs" />" title="Win a JEEP Compass Sport" target="_blank">
			<div><!-- Win a JEEP Compass Sport --></div>
			<span>VIEW TERMS AND CONDITIONS</span>
		</a>
	</div>
</c:if>