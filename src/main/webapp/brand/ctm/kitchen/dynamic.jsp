<%--
	Kitchen sink dynamic
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="GENERIC"/>

<go:setData dataVar="data" value="1" xpath="current/transactionId"/>

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/"/>

<%-- LOAD SETTINGS --%>
<core_v2:load_preload/>


<%-- HTML --%>
<layout_v1:generic_page title="Kitchen sink: Current &amp; new">

	<jsp:attribute name="head">
		<link href="${assetUrl}brand/${pageSettings.getBrandCode()}/css/kitchensink.css" rel="stylesheet">
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
		<go:script>
			<go:insertmarker format="SCRIPT" name="js-head"/>
		</go:script>

		<go:script>
			$(document).ready(function(){
			<go:insertmarker format="SCRIPT" name="onready"/>
			});
		</go:script>
		<script src="${assetUrl}js/bundles/kitchensink.js"></script>
		<script src="${assetUrl}js/bundles/kitchensink.deferred.js"></script>
		<script>
            $('#mainform').submit(function (event) {
                event.preventDefault();
            });
        </script>
	</jsp:attribute>

    <jsp:body>
        <%@include file="../../../framework/kitchen/dynamic.jsp" %>
    </jsp:body>

</layout_v1:generic_page>