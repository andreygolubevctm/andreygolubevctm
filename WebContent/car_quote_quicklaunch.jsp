<%--
	Car quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:core />
<settings:setVertical verticalCode="GENERIC" />
<c:set var="pageSettings" value="${settingsService.getPageSettingsForPage(pageContext.getRequest())}" scope="request"  />

<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
<jsp:useBean id="service" class="com.ctm.services.car.CarVehicleSelectionService" scope="request" />
<c:set var="json" value="${service.getVehicleSelection('', '', '', '', '', '') }" />

<%-- HTML --%>
<layout:generic_page title="Car Quote Quicklaunch">

	<jsp:attribute name="head">
		<script type="text/javascript" src="common/js/car/vehicle_selection.js?${revision}"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				$('body').attr("STYLE", "background-color:transparent");
				car.vehicleSelect.fields = {
					namePfx : "quote_vehicle",
					ajaxPfx : "car_",
					button  : "#quote_vehicle_button",
					year    : "#quote_vehicle_year",
					make    : "#quote_vehicle_make",
					model   : "#quote_vehicle_model",
					context : "/${pageSettings.getContextFolder()}"
				};
				<c:if test="${not empty json}">
				var vehicleData = ${json};
				car.vehicleSelect.data.make = vehicleData.makes;
				</c:if>
				car.vehicleSelect.init();
			});
		</script>
		<style type="text/css">
			body {
				background-color: transparent !important;
			}
			#copyright,#footer,header,#page>h2 {
				display: none;
			}
			fieldset>div>h2 {
				display: none;
			}
			.form-group label {
				display:none;
			}
			#quote_vehicle_buttonRow label {
				display:none;
			}
			article.container {
				width:100%;
				margin:0;
			}
			fieldset {
				margin: 0;
			}
			fieldset .form-group {
				margin-bottom: 0;
				float:left;
				width: 25%;
				margin-right:10px;
			}
			fieldset .form-group .row-content {
				width: 100%;
				padding: 0;
				margin: 0;
			}
			fieldset .form-group .row-content .select {
				margin-right: 15px;
			}
			fieldset .form-group .row-content a {
				width: 100%;
				padding: 11px 15px 12px 15px;
				background-color:#0db14b !important;
				border-radius:20px;
				font-family:inherit;
				font-size:16px;
				font-weight:600;
				box-shadow: rgba(0, 0, 0, 0.0980392) 0px -1px 0px 0px inset;
			}
			#quote_vehicle_makeRow {
				margin-top: 5px;
			}
			#quote_vehicle_buttonRow {
				margin-bottom: 10px;
			}
			@media (max-width: 767px) {
				fieldset .form-group {
					width: 100%;
					margin: 0 0 10px 0;
				}
				fieldset .form-group .row-content .select {
					margin-right: 0;
				}
				#quote_vehicle_buttonRow label {
					display: none;
				}
			}
		</style>
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer" />

	<jsp:attribute name="body_end" />

	<jsp:body>
		<car_layout:slide_quicklaunch />
	</jsp:body>

</layout:generic_page>