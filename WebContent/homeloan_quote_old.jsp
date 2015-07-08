<%--
	Homeloan quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="HOMELOAN" authenticated="true" />

<c:choose>
	<%-- Attempt to load existing quote into session if data param provided --%>
	<c:when test="${not empty param.data}">
		<homeloan_old:back_load />
	</c:when>
	<%-- Otherwise attempt to use the preload --%>
	<c:otherwise>
		<core_new:load_preload />
	</c:otherwise>
</c:choose>

<core:quote_check quoteType="homeloan" />

<%-- HTML --%>
<layout:journey_engine_page title="Home Loan Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="navbar">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<homeloan:footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<homeloan:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>

		<%-- Slides --%>
		<homeloan_old_layout:slide_details />

		<input type="hidden" name="transcheck" id="transcheck" value="1" />

	</jsp:body>

</layout:journey_engine_page>