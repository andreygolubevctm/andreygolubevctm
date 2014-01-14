<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Loading default settings only if required." %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="settings" class="com.disc_au.web.go.Data" />

<%@ attribute name="vertical"		required="false"	description="Set a vertical option"%>
<%@ attribute name="conflictMode"	required="false"	description="Detects if a conflicting vertical is active and handles the event"%>
<%@ attribute name="brand"			required="false"	description="Which brand theme needs to be loaded. Default will be 'ctm'"%>
<%@ attribute name="forceLoad"		required="false"	description="Force a new settings file to load every time"%>

<%-- =================================================================================================== --%>
<%-- Details of how settings work are outlined in http://confluence:8090/display/EBUS/CTM+Settings+Files --%>
<%-- =================================================================================================== --%>

<c:if test="${empty brand}">
	<go:log>NO BRAND FOUND - Setting to CTM</go:log>
	<c:set var="brand">ctm</c:set>
</c:if>
<c:if test="${empty vertical}">
	<go:log>NO VERTICAL FOUND - Setting to DEFAULT</go:log>
	<c:set var="vertical" value="default"/>
</c:if>
<c:if test="${empty forceLoad}">
	<c:set var="forceLoad" value="false"/>
</c:if>

<c:set var="vertical" value="${fn:toLowerCase(vertical) }"/>

<go:log>
SETTINGS:
${data.settings}
BRAND: '${data.settings.brand}'
VERT: '${data.settings.vertical}'
FORCELOAD: '${forceLoad}'
FAILSAFE MODE?: ${conflictMode}
F-TEST: ${conflictMode == 'true'}
V-TEST-1: ${data.settings.vertical != ''}
V-TEST-2: ${not empty data.settings.vertical}
V-TEST: ${fn:toLowerCase(data.settings.vertical)} !=  ${fn:toLowerCase(vertical)}
</go:log>

<go:log>VERTICAL: ${vertical }</go:log>
<c:choose>
	<c:when test="${not empty vertical}">
		<go:log>VERTICAL FOUND - SORTING SETTINGS - ${vertical}</go:log>

		<c:choose>
			<%-- NO FURTHER LOAD REQUIRED --%>
			<%-- The "data.settings.styleCode == brand" check is for situations which can override the original settings with a new theme --%>
			<c:when test="${(fn:toLowerCase(data.settings.vertical) == fn:toLowerCase(vertical)) && forceLoad == 'false' && data.settings.styleCode == brand}">
				<go:log>LOADED ${vertical} - ${brand}: NO FURTHER LOAD REQUIRED</go:log>
			</c:when>
			<%-- FAILSAFE PAGE --%>
			<c:when test="${(conflictMode == 'true' && not empty data.settings.vertical && (fn:toLowerCase(data.settings.vertical) != fn:toLowerCase(vertical)) && (fn:toLowerCase(data.settings.vertical) != 'frontend') ) && forceLoad == 'false'}">
				<go:log>THIS IS A FAIL AND NEEDS TO BE DIVERTED</go:log>
				<c:set var="conflictProduct" value="${fn:toLowerCase(data.settings.vertical)}" scope="session" />
				<c:set var="conflictNewProduct" value="${fn:toLowerCase(vertical)}" scope="session" />
				<c:redirect url="conflict.jsp" />
			</c:when>
			<%-- NORMAL LOAD --%>
			<c:otherwise>
				<go:log>NORMAL SETTINGS LOAD: with ${vertical} (BRAND: ${brand})</go:log>

				<go:setData dataVar="data" value="*DELETE" xpath="settings" />

				<c:import url="/brand/ctm/settings_all_env.xml" var="settingsXml" />
				<go:setData dataVar="data" xml="${settingsXml}"/>

				<%-- Combine the 4 files together --%>
				<c:import url="/brand/ctm/settings_merge.xsl" var="xsltFile" />
				<c:set var="settingsXml">
					<x:transform doc="${settingsXml}" xslt="${xsltFile}">
						<x:param name="vertical">${vertical }</x:param>
						<x:param name="brand">${brand }</x:param>
						<x:param name="root-url">http://${data['settings/serverUrl']}/</x:param>
					</x:transform>
				</c:set>

				<%-- Now strip out the duplicates --%>
				<c:import url="/brand/ctm/settings_merge_clean.xsl" var="xsltFile"/>
				<c:set var="settingsXml">
					<x:transform doc="${settingsXml}" xslt="${xsltFile}"></x:transform>
				</c:set>

				<go:setData dataVar="data" value="*DELETE" xpath="settings" />
				<go:setData dataVar="data" xml="${settingsXml}"/>

			</c:otherwise>
		</c:choose>
	</c:when>
</c:choose>
<%-- REFINE
1. This can be used to detect if another setting is already in place and if so, either make it a 'tabbed' version or push the user to an 'already in use' page
2. Failsafe page should be able to clear the session if wanted and re-direct back to the users start page
--%>