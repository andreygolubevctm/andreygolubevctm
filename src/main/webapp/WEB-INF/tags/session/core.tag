<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="sessionDataService" class="com.ctm.services.SessionDataService" scope="application" />
<jsp:useBean id="applicationService" class="com.ctm.services.ApplicationService" scope="application" />
<jsp:useBean id="settingsService" class="com.ctm.services.SettingsService" scope="application" />
<jsp:useBean id="environmentService" class="com.ctm.services.EnvironmentService" scope="application" />
<jsp:useBean id="contentService" class="com.ctm.services.ContentService" scope="application" />
<jsp:useBean id="sessionData" class="com.ctm.model.session.SessionData" scope="session" />
