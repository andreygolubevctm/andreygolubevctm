<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simples referral trackgin"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${!pageSettings.getSetting('inInEnabled')}">
	<simples:referral_tracking vertical="health" />
</c:if>
