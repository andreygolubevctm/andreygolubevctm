<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="utilities" />
</c:if>

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

<c:import url="brand/ctm/settings_utilities.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<c:set var="xpath" value="utilities" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head title="Utilities Insurance Quote Capture" mainCss="common/utilities.css" mainJs="common/js/utilities.js" quoteType="${name}" />
	
	<body class="utilities stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Utilities"/>		

		<%-- History handler --%>
		<utilities:history />

		
		<%-- Loading popup holder --%>
		<quote:loading />

		<%-- Transferring popup holder --%>
		<quote:transferring />

		<form:form action="utilities_quote_results.jsp" method="POST" id="mainform" name="frmMain">
					
			<form:operator_id xpath="${xpath}/operatorid" />
			
			<form:header quoteType="${name}" hasReferenceNo="true" showReferenceNo="false" />
			<utilities:progress_bar />

			<div id="wrapper">
				<div id="page">
				
					<form:joomla_quote/>

					<div id="content">
					
						<utilities:choices
							xpathHouseholdDetails="${xpath}/householdDetails"
							xpathEstimateDetails="${xpath}/estimateDetails"
							xpathResultsDisplayed="${xpath}/resultsDisplayed"
							xpathApplicationDetails="${xpath}/application/details"
							xpathApplicationSituation="${xpath}/application/situation"
							xpathApplicationThingsToKnow="${xpath}/application/thingsToKnow"
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
								<h2><span>Step 3.</span> Fill out your details</h2>
								<utilities:application_details xpath="${xpath}/application/details" />
								<utilities:situation xpath="${xpath}/application/situation" />
								<utilities:things_to_know xpath="${xpath}/application/thingsToKnow" />
							</slider:slide>
							
							<slider:slide id="slide3" title="Confirmation">
								<%-- Confirmation is loaded outside of the slider --%>
							</slider:slide>
																					
						</slider:slideContainer>
						
						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="68" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous step</span></a>
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 
					<!-- End main QE content -->
					</div>
					<form:help />
					
					<div style="height:67px"><!--  empty --></div>
					
					<form:scrapes id="slideScrapesContainer" className="slideScrapesContainer" group="utilities" />
					
					<div class="right-panel">
						<div class="right-panel-top"></div>
						<div class="right-panel-middle">
							<agg:side_panel />
						</div>
						<div class="right-panel-bottom"></div>
					</div>
					<div class="clearfix"></div>
				</div>

				<%-- Quote results (default to be hidden) --%>  
				<utilities:results />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<utilities:confirmation />		
				
				<%-- Apply Online Popup --%>
				<utilities:apply_online />
				
				<div id="promotions-footer"><!-- empty --></div>
				
			</div>
			<utilities:footer />
						
		</form:form>
		
		<%-- Copyright notice --%>
		<utilities:copyright_notice />
		
		<%-- Kampyle Feedback --%>
		<core:kampyle formId="85272" />
		
		<core:session_pop />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
		
		<%--Dialog panel editing benefits from the results page --%>
		<div id="results-edit-benefits"></div>
		
		<%--Dialog panel readmore content on the results page --%>
		<div id="results-read-more"></div>
		
		<%-- Including all go:script and go:style tags --%>
		<utilities:includes />
	</body>
	
</go:html>