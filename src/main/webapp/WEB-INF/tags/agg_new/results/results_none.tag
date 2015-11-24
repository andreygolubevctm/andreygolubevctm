<%@ tag description="No results popup content" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="brochurewareUrl" value="${fn:substringBefore(pageSettings.getSetting('exitUrl'), '.au/')}.au/" />

<div id="no-results-content">

	<h2>Dont see me here!</h2>



</div>
