<%@ tag description="Generic Page (no journey, reference number, etc)"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>
<%@ attribute name="outputTitle" required="false" rtexprvalue="true" description="Whether to display the title" %>
<%@ attribute name="skipJSCSS" required="false" rtexprvalue="true" description="Provide if wanting to exclude loading normal js/css (except jquery)" %>
<%@ attribute name="head" fragment="true" required="true"  %>
<%@ attribute name="head_meta" fragment="true" required="true"  %>
<%@ attribute name="header" fragment="true" required="true" %>
<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute name="form_bottom" fragment="true" required="true" %>
<%@ attribute name="footer" fragment="true" required="true" %>
<%@ attribute name="body_end" fragment="true" required="true" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>
<%@ attribute fragment="true" required="false" name="vertical_settings" %>

<c:set var="incSuperTag"><c:choose><c:when test="${not empty incSuperTag}">true</c:when><c:otherwise>false</c:otherwise></c:choose></c:set>
<c:set var="skipJSCSS"><c:if test="${not empty skipJSCSS}">true</c:if></c:set>

<layout:page skipJSCSS="${skipJSCSS}" title="${title}">

	<jsp:attribute name="head">
		<jsp:invoke fragment="head" />
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<jsp:invoke fragment="head_meta" />
	</jsp:attribute>

	<jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<jsp:invoke fragment="navbar" />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<jsp:invoke fragment="vertical_settings" />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<jsp:invoke fragment="additional_meerkat_scripts" />
	</jsp:attribute>

	<jsp:body>
		<article id="page" class="container">
			<c:if test="${outputTitle eq true}">
				<h2>${title}</h2>
			</c:if>

			<form id="mainform" name="frmMain">
				<jsp:doBody />

				<jsp:invoke fragment="form_bottom" />
			</form>

		</article>

		<agg:footer_outer>
			<jsp:invoke fragment="footer" />
		</agg:footer_outer>
	</jsp:body>

</layout:page>