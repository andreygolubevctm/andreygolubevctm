<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="sessionDataService" class="com.ctm.web.core.services.SessionDataService" scope="application" />
<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="application" />
<jsp:useBean id="settingsService" class="com.ctm.web.core.services.SettingsService" scope="application" />
<jsp:useBean id="environmentService" class="com.ctm.web.core.services.EnvironmentService" scope="application" />
<jsp:useBean id="contentService" class="com.ctm.web.core.content.services.ContentService" scope="application" />
<jsp:useBean id="sessionData" class="com.ctm.web.core.model.session.SessionData" scope="session" />
