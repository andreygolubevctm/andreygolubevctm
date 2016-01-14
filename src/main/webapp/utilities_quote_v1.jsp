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

<c:set var="hasBill" value="${param.has_bill}" />

<c:set var="xpath" value="utilities" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<core_v1:doctype />
<go:html>
	<core_v1:head title="Utilities Insurance Quote Capture" mainCss="common/utilities.css" mainJs="common/js/utilities.js" quoteType="${xpath}" />

	<body class="utilities stage-0">

		<%-- SuperTag Top Code --%>
		<agg_v1:supertag_top type="Utilities"/>

		<%-- History handler --%>
		<utilities_v1:history />

		<form_v1:form action="utilities_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<%-- Fields to store Switchwise specific data --%>
			<field_v1:hidden xpath="utilities/order/receiptid" defaultValue="" />
			<field_v1:hidden xpath="utilities/order/productid" defaultValue="" />
			<field_v1:hidden xpath="utilities/order/estimatedcosts" defaultValue="" />
			<field_v1:hidden xpath="utilities/partner/uniqueCustomerId" defaultValue="" />

	<c:choose>
		<c:when test="${hasBill == 'yes'}">
			<field_v1:hidden xpath="utilities/hasBill" defaultValue="Y" />
		</c:when>
		<c:otherwise>
			<field_v1:hidden xpath="utilities/hasBill" defaultValue="N" />
		</c:otherwise>
		</c:choose>

			<form_v1:operator_id xpath="${xpath}/operatorid" />

			<form_v1:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
			<core_v1:referral_tracking vertical="${xpath}" />
			<utilities_v1:progress_bar />

			<div id="wrapper">
				<div id="page">

					<div id="content">

						<utilities_v1:choices
							xpathHouseholdDetails="${xpath}/householdDetails"
							xpathEstimateDetails="${xpath}/estimateDetails"
							xpathResultsDisplayed="${xpath}/resultsDisplayed"
							xpathApplicationDetails="${xpath}/application/details"
							xpathApplicationSituation="${xpath}/application/situation"
							xpathApplicationPaymentInformation="${xpath}/application/paymentInformation"
							xpathApplicationOptions="${xpath}/application/options"
							xpathApplicationThingsToKnow="${xpath}/application/thingsToKnow"
							xpathSummary="${xpath}/summary"
							/>

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">

							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Household details">
								<h2><span>Step 1.</span> Household details</h2>
								<utilities_v1:household_details xpath="${xpath}/householdDetails" />
								<utilities_v1:estimate_details xpath="${xpath}/estimateDetails" />
								<utilities_v1:results_displayed xpath="${xpath}/resultsDisplayed" />
							</slider:slide>

							<slider:slide id="slide1" title="Choose a plan">
								<h2><span>Step 2.</span> Choose a plan</h2>

							</slider:slide>

							<slider:slide id="slide2" title="Fill out your details">
								<utilities_v1:selected_product />
								<h2><span>Step 3.</span> Fill out your details</h2>
								<utilities_v1:application_details xpath="${xpath}/application/details" />
								<utilities_v1:things_to_know xpath="${xpath}/application/thingsToKnow" />
							</slider:slide>

							<slider:slide id="slide3" title="Confirmation">
								<%-- Confirmation is loaded outside of the slider --%>
							</slider:slide>

						</slider:slideContainer>

						<form_v1:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="68" />

						<!-- Bottom "step" buttons -->
						<slider:slideController id="sliderController" />

					<!-- End main QE content -->
					</div>
					<form_v1:help />

					<div style="height:67px"><!--  empty --></div>



				<utilities_v1:side_panel />

			</div>

			<%-- Quote results (default to be hidden) --%>
			<utilities_v1:results />

			<%-- Confirmation content (default to be hidden) --%>
			<utilities_v1:confirmation />
		</div>


	</form_v1:form>

	<utilities_v1:lead_footer />

	<core_v1:closing_body>
		<agg_v1:includes supertag="true" />
		<utilities_v1:includes />
	</core_v1:closing_body>

</body>

</go:html>