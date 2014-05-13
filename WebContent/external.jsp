<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="GENERIC" />

<c:set var="page_ref" value="iframepage" />

<core:load_settings conflictMode="false" vertical="${page_ref}" />

<%-- Populate source var from params --%>
<c:set var="source">
	<c:set var="temp"><c:out value="${param.source}" escapeXml="true" /></c:set>
	<c:if test="${not empty temp}">${temp}</c:if>
</c:set>

<%-- Exit page if no source provided --%>
<c:if test="${empty source}">
	<c:redirect url="${pageSettings.getSetting('exitUrl')}?nosource=true" />
</c:if>

<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="iFrame Page" mainCss="common/${page_ref}.css" mainJs="common/js/${page_ref}.js" />

	<body class="${page_ref} stage-0">

		<form:form action="health_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<form:header quoteType="${xpath}" hasReferenceNo="false" showReferenceNo="false"/>

			<iframe_page:header source="${source}" />
			<iframe_page:iframe source="${source}" />

		</form:form>

		<core:closing_body>
			<agg:includes supertag="false" />
		</core:closing_body>

	</body>

</go:html>