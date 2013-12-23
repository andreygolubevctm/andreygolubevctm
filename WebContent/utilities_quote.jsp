<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="utilities" />
</c:if>

<core:load_settings conflictMode="false" vertical="utilities" />

<c:if test="${param.preload == '2'}">  
	<c:choose>
		<c:when test="${param.xmlFile != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="utilities" />		
			<c:import url="testing/data/${param.xmlFile}" var="utilitiesXml" />
			<go:setData dataVar="data" xml="${utilitiesXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="utilities" />		
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="utilities" />		
			<c:import url="test_data/preload_utilities.xml" var="utilitiesXml" />
			<go:setData dataVar="data" xml="${utilitiesXml}" />		
		</c:otherwise>
	</c:choose>
</c:if>

<c:set var="xpath" value="utilities" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>
	<core:head title="Utilities Insurance Quote Capture" mainCss="common/utilities.css" mainJs="common/js/utilities.js" quoteType="${xpath}" />
	
	<body class="utilities stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Utilities"/>		

		<%-- History handler --%>
		<utilities:history />

		<form:form action="utilities_quote_results.jsp" method="POST" id="mainform" name="frmMain">
					
			<%-- Fields to store Switchwise specific data --%>
			<field:hidden xpath="utilities/order/receiptid" defaultValue="" />
			<field:hidden xpath="utilities/order/productid" defaultValue="" />
			<field:hidden xpath="utilities/order/estimatedcosts" defaultValue="" />
					
			<form:operator_id xpath="${xpath}/operatorid" />
			
			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
			<core:referral_tracking vertical="${xpath}" />
			<utilities:progress_bar />

			<div id="wrapper">
				<div id="page">
				
					<div id="content">
					
						<utilities:choices
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
								<utilities:household_details xpath="${xpath}/householdDetails" />
								<utilities:estimate_details xpath="${xpath}/estimateDetails" />
								<utilities:results_displayed xpath="${xpath}/resultsDisplayed" />
							</slider:slide>
							
							<slider:slide id="slide1" title="Choose a plan">
								<h2><span>Step 2.</span> Choose a plan</h2>
								
							</slider:slide>
							
							<slider:slide id="slide2" title="Fill out your details">
								<utilities:selected_product />
								<h2><span>Step 3.</span> Fill out your details</h2>
								<utilities:application_details xpath="${xpath}/application/details" />
								<utilities:situation xpath="${xpath}/application/situation" />
								<utilities:payment_information xpath="${xpath}/application/paymentInformation" />
								<utilities:options xpath="${xpath}/application/options" />
								<utilities:things_to_know xpath="${xpath}/application/thingsToKnow" />
							</slider:slide>
							
							<slider:slide id="slide3" title="Apply">
								<utilities:selected_product />
								<h2><span>Step 4.</span> Confirm your details and submit your application</h2>
								<utilities:summary xpath="${xpath}/summary" />
							</slider:slide>
							
							<slider:slide id="slide4" title="Confirmation">
								<%-- Confirmation is loaded outside of the slider --%>
							</slider:slide>
																					
						</slider:slideContainer>
						
						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="68" />
						
						<!-- Bottom "step" buttons -->
						<slider:slideController id="sliderController" />
						 
					<!-- End main QE content -->
					</div>
					<form:help />
					
					<div style="height:67px"><!--  empty --></div>
					
					<form:scrapes id="slideScrapesContainer" className="slideScrapesContainer" group="utilities" />
					
					<utilities:side_panel />
					
				</div>

				<%-- Quote results (default to be hidden) --%>  
				<utilities:results />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<utilities:confirmation />		
			</div>
				
				
		</form:form>
				
			<utilities:footer />
						
		<core:closing_body>
			<agg:includes supertag="true" />
		<utilities:includes />
		</core:closing_body>

	</body>
	
</go:html>