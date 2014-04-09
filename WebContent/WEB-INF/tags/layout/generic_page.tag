<%@ tag description="Generic Page (no journey, reference number, etc)"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>

<%@ attribute name="head" fragment="true" required="true"  %>
<%@ attribute name="head_meta" fragment="true" required="true"  %>
<%@ attribute name="header" fragment="true" required="true" %>
<%@ attribute name="form_bottom" fragment="true" required="true" %>
<%@ attribute name="footer" fragment="true" required="true" %>
<%@ attribute name="body_end" fragment="true" required="true" %>

<layout:page supertag="false" sessionPop="false" kampyle="false" title="${title}">

	<jsp:attribute name="head">
		<jsp:invoke fragment="head" />
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<jsp:invoke fragment="head_meta" />
	</jsp:attribute>

	<jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

	<jsp:body>
		<article id="page" class="container">
			<h2>${title}</h2>

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