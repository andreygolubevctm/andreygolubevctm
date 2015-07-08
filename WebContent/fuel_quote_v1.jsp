<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="FUEL" />

<c:set var="xpath" value="fuel" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
</c:if>

<%-- Check requests from IP and throw 429 if limit exceeded. --%>
<jsp:useBean id="sessionDataService" class="com.ctm.services.SessionDataService" />
<jsp:useBean id="ipCheckService" class="com.ctm.services.IPCheckService" />
<c:choose>
	<%-- Remove session and throw 429 error if request limit exceeded --%>
	<c:when test="${!ipCheckService.isWithinLimitAsBoolean(pageContext.request, pageSettings)}">
		<c:set var="removeSession" value="${sessionDataService.removeSessionForTransactionId(pageContext.request, data.current.transactionId)}" />
		<%	response.sendError(429, "Number of requests exceeded!" ); %>
	</c:when>
	<%-- Only proceed if number of requests not exceeded --%>
	<c:otherwise>
		<%-- PRELOAD DATA --%>
		<c:if test="${empty param.action && param.preload == '2'}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="test_data/preload_fuel.xml" var="fuelXml" />
			<go:setData dataVar="data" xml="${fuelXml}" />
		</c:if>

		<core:doctype />
		<go:html>
			<core:head quoteType="${xpath}" title="Fuel Price Checker" mainCss="common/fuel.css" mainJs="common/js/fuel.js"/>

			<body class="fuel stage-0">

				<%-- SuperTag Top Code --%>
			<agg:supertag_top type="Fuel"/>

			<form:form action="javascript:void(0);" method="GET" id="mainform" name="frmMain">

				<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
				<core:referral_tracking vertical="${xpath}" />
				<fuel:progress_bar />
				<div id="wrapper" class="clearfix">

					<div id="page" class="clearfix">

						<div id="content">

							<!-- Main Quote Engine content -->
							<slider:slideContainer className="sliderContainer">
								<slider:slide id="slide0" title="FuelSearch">
									<fuel:fuel_form  />
								</slider:slide>
							</slider:slideContainer>

							<form:error id="slideErrorContainer" className="slideErrorContainer fuel" errorOffset="45" />

							<!-- Bottom "step" buttons -->
							<div class="button-wrapper">
								<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
							</div>


							<!-- End main QE content -->

						</div>

						<form:help />

						<div class="clearfix"></div>
					</div>

						<%-- Quote results (default to be hidden) --%>
					<fuel:results />
				</div>


			</form:form>

			<fuel:footer />

			<core:closing_body>
				<agg:includes supertag="true" />
				<fuel:includes />
			</core:closing_body>

			</body>

		</go:html>
	</c:otherwise>
</c:choose>