<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="helpBoxService" class="com.ctm.web.simples.admin.services.HelpBoxService" scope="page" />
<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="applicationDate" value="${applicationService.getApplicationDate(pageContext.getRequest())}" />
<c:set var="currentHelpBox" value='${helpBoxService.getCurrentHelpBox(styleCodeId, applicationDate)}' />

<c:if test="${currentHelpBox ne null}">
    <div id="simples-help-box" data-content="${currentHelpBox.getContent()}"><a href="javascript:;">?</a></div>
</c:if>