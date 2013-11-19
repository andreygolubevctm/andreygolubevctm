<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="settings" class="com.disc_au.web.go.Data" />

<%-- ATTRIBUTES --%>
<%@ attribute name="brand" 			required="true" rtexprvalue="true" description="the name of the concerned brand (e.g ctm, cc, etc.)" %>
<%@ attribute name="application" 	required="true" rtexprvalue="true" description="the name of the concerned application (e.g. utilities, health, etc.)" %>
<%@ attribute name="setting"		required="false" rtexprvalue="true" description="the setting of the application that requests its settings" %>

<c:import url="brand/${brand}/settings_${application}.xml" var="importedXml" />

<go:setData dataVar="settings" xml="${importedXml}" />

<c:choose>
	<c:when test="${not empty setting}">
		${settings.settings[setting]}
	</c:when>
	<c:otherwise>
		${settings.settings}
	</c:otherwise>
</c:choose>