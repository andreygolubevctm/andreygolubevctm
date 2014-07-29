<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="kampyle"			required="false"  rtexprvalue="true"	 description="Whether to display Kampyle or not" %>
<%@ attribute name="newKampyle"			required="false"  rtexprvalue="true"	 description="Whether to display the NEW Kampyle or not" %>
<%@ attribute name="loading"			required="false"  rtexprvalue="true"	 description="Whether to load the loading overlay" %>
<%@ attribute name="sessionPop"			required="false"  rtexprvalue="true"	 description="Whether to load the session pop" %>
<%@ attribute name="supertag"			required="false"  rtexprvalue="true"	 description="Whether to load supertag or not" %>
<%@ attribute name="devTools"			required="false"  rtexprvalue="true"	 description="Whether to load the dev tools or not" %>
<%@ attribute name="vertical"			required="false"  rtexprvalue="true"	 description="The vertical (required for the dev tools to work)" %>
<%@ attribute name="fatalError"			required="false"  rtexprvalue="true"	 description="Whether to load the dev tools or not" %>
<%@ attribute name="fatalErrorMessage"	required="false"  rtexprvalue="true"	 description="Whether to load the dev tools or not" %>

<%-- VARIABLES --%>
<c:if test="${empty kampyle}"><c:set var="kampyle" value="true" /></c:if>
<c:if test="${empty newKampyle}"><c:set var="newKampyle" value="false" /></c:if>
<c:if test="${empty loading}"><c:set var="loading" value="true" /></c:if>
<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>
<c:if test="${empty supertag}"><c:set var="supertag" value="true" /></c:if>
<c:if test="${empty devTools}"><c:set var="devTools" value="false" /></c:if>

<%-- Loading --%>
<c:if test="${loading eq true}">
	<quote:loading />
</c:if>

<%-- Kampyle Feedback --%>
<c:if test="${kampyle eq true}">
	<%-- Check whether Kampyle is enabled for this brand/vertical --%>
	<c:if test="${pageSettings.getSetting('kampyleFeedback') eq 'Y'}">
	<c:choose>
			<c:when test="${newKampyle eq true}">
				<core_new:kampyle formId="112902" />
		</c:when>
		<c:otherwise>
				<core:kampyle formId="112902" />
		</c:otherwise>
	</c:choose>
</c:if>
</c:if>

<%-- Dev Environment: AB. Removed 2013-12-09 as this is for test environments only
<c:if test="${not empty vertical and devTools eq true}">
	<agg:dev_tools rootPath="${vertical}" />
</c:if>
--%>

<c:if test="${sessionPop eq true}">
	<core:session_pop />
</c:if>

<c:if test="${supertag eq true}">
	<agg:supertag_bottom />
</c:if>

<%-- Dialog for rendering fatal errors --%>
<c:if test="${empty fatalError or fatalError eq true}">
<c:choose>
	<c:when test="${not empty fatalErrorMessage}">
		<form:fatal_error custom="${fatalErrorMessage}" />
	</c:when>
	<c:otherwise>
		<form:fatal_error />
	</c:otherwise>
</c:choose>
</c:if>

<agg:timer />
<core:debug_info />