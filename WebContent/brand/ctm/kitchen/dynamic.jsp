<%--
	Kitchen sink dynamic
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- VARIABLES --%>
<c:set var="vertical" value="default" />

<%-- LOAD SETTINGS --%>
<%-- @TODO => <core_new:load_application_settings /> and get rid of line below once done --%>
<core_new:load_page_settings vertical="${vertical}" />
<core:load_settings conflictMode="false" vertical="${vertical}" />
<core_new:load_preload />


<%-- HTML --%>
<layout:generic_page title="Kitchen sink: Current &amp; new">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<%-- <base href="http://a01961.budgetdirect.com.au:8080/ctm/" /> --%>
		<base href="/ctm/" />
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<script src="common/js/jquery.maskedinput-1.3.1.min.js"></script>
		<script src="framework/jquery/plugins/bootstrap-datepicker/bootstrap-datepicker-2.0.js"></script>
		<script>
			$('#mainform').submit(function(event) {
				event.preventDefault();
			});
		</script>
	</jsp:attribute>

	<jsp:body>
		<%@include file="../../../framework/kitchen/dynamic.jsp" %>
	</jsp:body>

</layout:generic_page>