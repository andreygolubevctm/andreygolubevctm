<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="IP" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="ip" />
</c:if>

<c:if test="${param.preload == '2'}">  
			<go:setData dataVar="data" value="*DELETE" xpath="ip" />		
			<c:import url="test_data/preload_ip.xml" var="ipXml" />
			<go:setData dataVar="data" xml="${ipXml}" />		
</c:if>

<c:set var="xpath" value="ip" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Income Protection Insurance Quote Capture" mainCss="common/life.css" mainJs="common/js/life.js" />
	
	<body class="ip stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="IP"/>		

		<%-- History handler --%>
		<life:history />

		<%-- Transferring popup holder --%>
		<core:transferring />

		<form:form action="ip_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<%-- Fields to store Lifebroker specific data --%>
			<life:lifebroker_ref label="ip" />
					
			<form:operator_id xpath="${xpath}/operatorid" />
			<core:referral_tracking vertical="${xpath}" />
			
			<form:header quoteType="${xpath}" hasReferenceNo="true" />
			<life:progress_bar />

			<div id="wrapper">
				<div id="page">
				
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your Details">
								<h2><span>Step 1.</span> Your Details</h2>
								<ip:insurance xpath="${xpath}/primary/insurance" />
								<life:questionset xpath="${xpath}" />
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
						
						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="108" minTop="70" />
						
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
				<life:results vertical="ip" />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<life:confirmation />
				
			</div>


		</form:form>
		
		<life:footer />
		
		<core:closing_body>
			<agg:includes supertag="true" />
		<ip:includes />
		</core:closing_body>
		
	</body>
	
</go:html>