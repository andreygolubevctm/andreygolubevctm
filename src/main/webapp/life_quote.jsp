<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="LIFE" />
<c:set var="mobileVariant" value="${pageSettings.getSetting('mobileVariant') eq 'Y'}" />
<c:if test="${mobileVariant eq true}">
	<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
	<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
	<c:if test="${deviceType eq 'MOBILE' and empty param.source and param.source ne 'mobile'}">
		<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}life_quote_mobile.jsp?" />
		<c:forEach items="${param}" var="currentParam">
			<c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
		</c:forEach>
		<c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />
	</c:if>
</c:if>

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
<c:set var="GTMEnabled" value="${pageSettings.getSetting('GTMEnabled') eq 'Y'}" />

<life_v1:widget_values />

<core_v1:doctype />
<go:html>
	<core_v1:head quoteType="${xpath}" title="Life Insurance Quote Capture" mainCss="common/life.css" mainJs="common/js/life.js" />
	
	<body class="life stage-0">

	<c:if test="${GTMEnabled eq true and not empty pageSettings and pageSettings.hasSetting('GTMPropertyId')}">
		<c:if test="${not empty pageSettings.getSetting('GTMPropertyId')}">
			<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
					new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
					j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
					'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
			})(window,document,'script','CtMDataLayer','${pageSettings.getSetting('GTMPropertyId')}');</script>
		</c:if>
	</c:if>

		<%-- SuperTag Top Code --%>
		<agg_v1:supertag_top type="Life"/>

		<%-- History handler --%>
		<life_v1:history />

		<%-- Transferring popup holder --%>
		<core_v1:transferring />

		<form_v1:form action="health_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<%-- Fields to store Lifebroker specific data --%>
			<life_v1:lifebroker_ref label="life" />
					
			<form_v1:operator_id xpath="${xpath}/operatorid" />
			<core_v1:referral_tracking vertical="${xpath}" />
			
			<form_v1:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="true"/>
			<life_v1:progress_bar />

			<div id="wrapper">
				<div id="page">
				
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<life_v1:engine	xpathInsurance="${xpath}/insurance"
											xpathPrimary="${xpath}/primary"
											xpathPartner="${xpath}/partner"
											xpathContactDetails="${xpath}/contactDetails" />
							
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your Needs">
								<h2><span>Step 1.</span> Your Details</h2>
										<life_v1:insurance xpath="${xpath}" />
										<life_v1:questionset xpath="${xpath}" />
								<life_v1:contact_details xpath="${xpath}/contactDetails" />
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
						
						<form_v1:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="108" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous step</span></a>
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 
					<!-- End main QE content -->
					</div>
					<form_v1:help />
					
				<life_v1:side_panel />
			</div>

				<%-- Quote results (default to be hidden) --%>  
				<life_v1:results />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<life_v1:confirmation />		
			</div>
						
		</form_v1:form>
		
		<life_v1:footer />
		
		<core_v1:closing_body>
			<agg_v1:includes supertag="true" />
		<life_v1:includes />
		</core_v1:closing_body>
		
	</body>
	
</go:html>