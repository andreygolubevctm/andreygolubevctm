<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="life" />
</c:if>

<c:if test="${param.preload == '2'}">  
	<c:choose>
		<c:when test="${param.xmlFile != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="life" />		
			<c:import url="testing/data/${param.xmlFile}" var="lifeXml" />
			<go:setData dataVar="data" xml="${lifeXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="life" />		
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="life" />		
			<c:import url="test_data/preload_life.xml" var="lifeXml" />
			<go:setData dataVar="data" xml="${lifeXml}" />		
		</c:otherwise>
	</c:choose>
</c:if>

<c:import url="brand/ctm/settings_life.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<c:set var="xpath" value="life" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head quoteType="life" title="Life Insurance Quote Capture" mainCss="common/life.css" mainJs="common/js/life.js" />
	
	<body class="life stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Life"/>		

		<%-- History handler --%>
		<life:history />

		
		<%-- Loading popup holder --%>
		<quote:loading />

		<%-- Transferring popup holder --%>
		<quote:transferring />

		<form:form action="health_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<%-- Fields to store Lifebroker specific data --%>
			<life:lifebroker_ref label="life" />
					
			<form:operator_id xpath="${xpath}/operatorid" />
			
			<form:header quoteType="life" hasReferenceNo="true" />
			<life:progress_bar />

			<div id="wrapper">
				<div id="page">
				
					<form:joomla_quote/>

						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<life:engine	xpathCover="${xpath}/cover"
											xpathDetailsPrimary="${xpath}/details/primary"
											xpathContactDetails="${xpath}/contactDetails" />
							
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your Needs">
								<h2><span>Step 1.</span> Your Needs</h2>
								<life:cover xpath="${xpath}/cover" />				
							</slider:slide>
							
							<slider:slide id="slide1" title="Your Needs">
								<h2><span>Step 2.</span> Your Details</h2>
								<life:details xpath="${xpath}/details/primary" />
								<life:contact_details xpath="${xpath}/contactDetails" />														
							</slider:slide>
							
							<slider:slide id="slide2" title="Compare">
								<h2><span>Step 3.</span> Compare</h2>
								<%-- Results are loaded outside of the slider --%>						
							</slider:slide>
							
							<slider:slide id="slide3" title="Apply">
								<h2><span>Step 4.</span> Apply</h2>
								<%-- Apply content is loaded into a popup --%>						
							</slider:slide>
							
							<slider:slide id="slide4" title="Confirmation">
								<h2><span>Step 5.</span> Confirmation</h2>
								<%-- Confirmation is loaded outside of the slider --%>	
							</slider:slide>
																					
						</slider:slideContainer>
						
						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="108" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous step</span></a>
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 
					<!-- End main QE content -->
					</div>
					<form:help />
					
					<div style="height:107px"><!--  empty --></div>
					
					<form:scrapes id="slideScrapesContainer" className="slideScrapesContainer" group="health" />
					
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
				<life:results />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<life:confirmation />		
				
				<%-- Quote Comparison popup
				<health:compare /> --%>
	
				<%-- Product info popup
				<health:product_info />				 --%>
				
				<div id="promotions-footer"><!-- empty --></div>
				
			</div>
			<life:footer />
						
			<%-- Results conditions popup  
			<quote:results_terms />--%>

			<%-- Results none popup
			<health:results_none /> --%>
						
			<!-- Advert Id 
			<field:hidden xpath="quote/ccad" />
			-->
		</form:form>
		
		<%-- Copyright notice --%>
		<life:copyright_notice />
		
		<%-- Save Quote Popup --%>
		<quote:save_quote quoteType="life" emailCode="CTLQ" mainJS="LifeQuote" />
		
		<%-- Kamplye Feedback --%>
		<core:kampyle formId="85272" />
		
		<core:session_pop />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
		
		<%--Dialog panel editing benefits from the results page --%>
		<div id="results-edit-benefits"></div>
		
		<%--Dialog panel readmore content on the results page --%>
		<div id="results-read-more"></div>
		
		<%-- Including all go:script and go:style tags --%>
		<life:includes />
	</body>
	
</go:html>