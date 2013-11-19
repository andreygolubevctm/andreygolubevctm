<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Loading default settings only if required." %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="settings" class="com.disc_au.web.go.Data" />

<%@ attribute name="vertical"		required="false"	description="Set a vertical option"%>
<%@ attribute name="conflictMode"	required="false"	description="Detects if a conflicting vertical is active and handles the event"%>

<go:log>
SETTINGS:
${data.settings}

VERT: '${data.settings.vertical}'
FAILSAFE MODE?: ${conflictMode}
F-TEST: ${conflictMode == 'true'}
V-TEST-1: ${data.settings.vertical != ''}
V-TEST-2: ${not empty data.settings.vertical}
V-TEST: ${fn:toLowerCase(data.settings.vertical)} !=  ${fn:toLowerCase(vertical)}
</go:log>
<go:log>VERTICAL: ${vertical }</go:log>
<c:choose>
	<c:when test="${not empty vertical}">
		<go:log>VERTICAL FOUND - SORTING SETTINGS</go:log>

		<c:choose>
			<c:when test="${fn:toLowerCase(data.settings.vertical) == fn:toLowerCase(vertical)}">
				<go:log>LOADED: NO FURTHER LOAD REQUIRED</go:log>
				<%-- NO FURTHER LOAD REQUIRED --%>
			</c:when>
			<%-- FAILSAFE PAGE --%>
			<c:when test="${conflictMode == 'true' && not empty data.settings.vertical && (fn:toLowerCase(data.settings.vertical) != fn:toLowerCase(vertical)) && (fn:toLowerCase(data.settings.vertical) != 'frontend') }">
				<go:log>THIS IS A FAIL AND NEEDS TO BE DIVERTED</go:log>
				<c:set var="conflictProduct" value="${fn:toLowerCase(data.settings.vertical)}" scope="session" />
				<c:set var="conflictNewProduct" value="${fn:toLowerCase(vertical)}" scope="session" />
				<c:redirect url="conflict.jsp" />
			</c:when>
			<%-- NORMAL LOAD --%>
			<c:otherwise>
				<go:log>LOADING '/brand/ctm/settings_${vertical}.xml'</go:log>
				<c:import url="/brand/ctm/settings_${vertical}.xml" var="settingsXml" />
				<go:setData dataVar="data" value="*DELETE" xpath="settings" />
				<go:setData dataVar="data" xml="${settingsXml}" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<%-- DEFAULT SETTINGS --%>
	<c:when test="${empty data.settings}">
		<go:log>LOADING DEFAULT SETTINGS</go:log>
		<c:import url="/brand/ctm/settings.xml" var="settingsXml" />
		<go:setData dataVar="data" xml="${settingsXml}" />
	</c:when>
</c:choose>
<%-- REFINE
1. This can potentially be used to load a verticals settings file
2. This can be used to detect if another setting is already in place and if so, either make it a 'tabbed' version or push the user to an 'already in use' page
3. Failsafe page should be able to clear the session if wanted and re-direct back to the users start page
--%>