<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="loading"			required="false"  rtexprvalue="true"	 description="Whether to load the loading overlay" %>
<%@ attribute name="sessionPop"			required="false"  rtexprvalue="true"	 description="Whether to load the session pop" %>
<%@ attribute name="supertag"			required="false"  rtexprvalue="true"	 description="Whether to load supertag or not" %>
<%@ attribute name="devTools"			required="false"  rtexprvalue="true"	 description="Whether to load the dev tools or not" %>
<%@ attribute name="vertical"			required="false"  rtexprvalue="true"	 description="The vertical (required for the dev tools to work)" %>
<%@ attribute name="fatalError"			required="false"  rtexprvalue="true"	 description="Whether to load the dev tools or not" %>
<%@ attribute name="fatalErrorMessage"	required="false"  rtexprvalue="true"	 description="Whether to load the dev tools or not" %>

<%-- VARIABLES --%>
<c:if test="${empty loading}"><c:set var="loading" value="true" /></c:if>
<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>
<c:if test="${empty devTools}"><c:set var="devTools" value="false" /></c:if>
<c:set var="superTagEnabled" value="${pageSettings.getSetting('superTagEnabled') eq 'Y'}" />

<%-- Loading --%>
<c:if test="${loading eq true}">
	<quote:loading />
</c:if>


<%-- Dev Environment 
<c:if test="${not empty vertical and devTools eq true}">
	<agg_v1:dev_tools rootPath="${vertical}" />
</c:if>
--%>

<c:if test="${sessionPop eq true}">
	<core_v1:session_pop />
</c:if>

<c:if test="${superTagEnabled eq true and not empty pageSettings and pageSettings.hasSetting('supertagInitialPageName')}">
	<agg_v1:supertag_bottom />
</c:if>

<%-- Dialog for rendering fatal errors --%>
<c:if test="${empty fatalError or fatalError eq true}">
<c:choose>
	<c:when test="${not empty fatalErrorMessage}">
		<form_v1:fatal_error custom="${fatalErrorMessage}" />
	</c:when>
	<c:otherwise>
		<form_v1:fatal_error />
	</c:otherwise>
</c:choose>
</c:if>