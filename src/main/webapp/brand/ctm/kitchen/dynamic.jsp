<%--
	Kitchen sink dynamic
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="GENERIC" />

<go:setData dataVar="data" value="1" xpath="current/transactionId" />

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}" />

<%-- LOAD SETTINGS --%>
<core_new:load_preload />


<%-- HTML --%>
<layout:generic_page title="Kitchen sink: Current &amp; new">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="${assetUrl}framework/jquery/plugins/jquery.nouislider/jquery.nouislider-6.2.0.css">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<%-- <base href="http://a01961.budgetdirect.com.au:8080/ctm/" />
		<base href="${pageSettings.getBaseUrl()}" /> --%>
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		{
			session: {
				firstPokeEnabled: false
			}
		}
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<script src="${assetUrl}common/js/jquery.maskedinput-1.3-co.js"></script>
		<script src="${assetUrl}framework/jquery/plugins/bootstrap-datepicker/bootstrap-datepicker-2.0.js"></script>
		<script src="${assetUrl}framework/jquery/plugins/jquery.nouislider/jquery.nouislider-6.2.0.min.js"></script>
		<script src="${assetUrl}framework/jquery/plugins/bootstrap-switch-2.0.0.min.js"></script>
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