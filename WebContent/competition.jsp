<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="COMPETITION" authenticated="true" />

<core_new:quote_check quoteType="competition" />

<layout:journey_engine_page title="Competition">
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<competition:navigation />
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<competition:settings />
	</jsp:attribute>

	<jsp:body>
		<%-- Slides --%>
		<competition_layout:slide_entry cid="${param['cid']}" reference="${param['ref']}" />

		<input type="hidden" name="transcheck" id="transcheck" value="1" />
	</jsp:body>

</layout:journey_engine_page>