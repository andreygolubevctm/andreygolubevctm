<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="LIFE"/>

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="life" />
</c:if>

<c:if test="${param.preload == '2'}">  
			<go:setData dataVar="data" value="*DELETE" xpath="life" />		
			<c:import url="test_data/preload_life.xml" var="lifeXml" />
			<go:setData dataVar="data" xml="${lifeXml}" />		
</c:if>

<c:set var="xpath" value="life" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Life Insurance Quote Capture" mainCss="common/life.css" mainJs="common/js/life.js" />
	
	<body class="life stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Life"/>		

		<%-- History handler --%>
		<life:history />

		<%-- Transferring popup holder --%>
		<core:transferring />

		<form:form action="health_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<%-- Fields to store Lifebroker specific data --%>
			<life:lifebroker_ref label="life" />
					
			<form:operator_id xpath="${xpath}/operatorid" />
			<core:referral_tracking vertical="${xpath}" />
			
			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="true"/>
			<life:progress_bar />

			<div id="wrapper">
				<div id="page">
				
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<life:engine	xpathInsurance="${xpath}/insurance"
											xpathPrimary="${xpath}/primary"
											xpathPartner="${xpath}/partner"
											xpathContactDetails="${xpath}/contactDetails" />
							
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your Needs">
								<h2><span>Step 1.</span> Your Details</h2>
								<c:choose>
									<c:when test="${not empty param.j and param.j eq '1'}">
										<life:insurance xpath="${xpath}" />
										<life:questionset xpath="${xpath}" />
								<life:contact_details xpath="${xpath}/contactDetails" />
									</c:when>
									<c:otherwise>
										<life:contact_details xpath="${xpath}/contactDetails" />
								<life:questionset xpath="${xpath}" />
								<life:insurance xpath="${xpath}" />
									</c:otherwise>
								</c:choose>
							</slider:slide>
							
							<slider:slide id="slide1" title="Compare">
								<h2><span>Step 2.</span> Compare</h2>
								<%-- Results are loaded outside of the slider --%>						
							</slider:slide>
							
							<slider:slide id="slide2" title="Apply">
								<h2><span>Step 3.</span> Apply</h2>
								<%-- Apply content is loaded into a popup --%>						
							</slider:slide>
							
							<slider:slide id="slide3" title="Confirmation">
								<h2><span>Step 4.</span> Confirmation</h2>
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
					
						</div>

				<%-- Quote results (default to be hidden) --%>  
				<life:results />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<life:confirmation />		
			</div>
						
		</form:form>
		
		<life:footer />
		
		<core:closing_body>
			<agg:includes supertag="true" />
		<life:includes />
		</core:closing_body>
		
	</body>
	
</go:html>