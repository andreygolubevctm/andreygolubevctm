<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="UTILITIES" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="utilities" />
</c:if>

<c:if test="${param.preload == '2'}">
	<go:setData dataVar="data" value="*DELETE" xpath="utilities" />
	<c:import url="test_data/preload_utilities.xml" var="utilitiesXml" />
	<go:setData dataVar="data" xml="${utilitiesXml}" />
</c:if>

<c:set var="xpath" value="utilities" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>
	<core:head title="Utilities Insurance Quote Capture" mainCss="common/utilities.css" mainJs="common/js/utilities_lead.js" quoteType="${xpath}" />

	<body class="utilities stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Utilities"/>

		<%-- History handler --%>
		<%--<utilities:history />--%>

		<form:form action="utilities_lead.jsp" method="POST" id="mainform" name="frmMain">

			<form:operator_id xpath="${xpath}/operatorid" />

			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
			<core:referral_tracking vertical="${xpath}" />


			<div id="wrapper">
				<div id="page">

					<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">

							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your details">
								<h2><span>Step 1.</span> Your details</h2>
								<utilities:lead_details xpath="${xpath}/leadFeed" />
							</slider:slide>

							<slider:slide id="slide1" title="Confirmation">
								<h2><span>Step 2.</span> Confirmation</h2>
								<utilities:lead_confirmation />
							</slider:slide>

						</slider:slideContainer>

						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="68" />

						<!-- Bottom "step" buttons -->
						<slider:slideController id="sliderController" />

					<!-- End main QE content -->
					</div>
					<form:help />

					<div style="height:67px"><!--  empty --></div>


			</div>

		</div>


	</form:form>

	<utilities:lead_footer />

	<core:closing_body>
		<agg:includes supertag="true" />
		<utilities:includes />
	</core:closing_body>

</body>

</go:html>