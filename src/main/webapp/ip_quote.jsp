<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="IP" />
<c:set var="mobileVariant" value="${pageSettings.getSetting('mobileVariant') eq 'Y'}" />
<c:if test="${mobileVariant eq true}">
	<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
	<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
	<c:if test="${deviceType eq 'MOBILE'}">
		<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}ip_quote_mobile.jsp?" />
		<c:forEach items="${param}" var="currentParam">
			<c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
		</c:forEach>
		<c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />
	</c:if>
</c:if>

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
<c:set var="GTMEnabled" value="${pageSettings.getSetting('GTMEnabled') eq 'Y'}" />

<ip_v1:widget_values />

<core_v1:doctype />
<go:html>
	<core_v1:head quoteType="${xpath}" title="Income Protection Insurance Quote Capture" mainCss="common/life.css" mainJs="common/js/life.js" />
	
	<body class="ip stage-0">

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
		<agg_v1:supertag_top type="IP"/>

		<%-- History handler --%>
		<life_v1:history />

		<%-- Transferring popup holder --%>
		<core_v1:transferring />

		<form_v1:form action="ip_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<%-- Fields to store Lifebroker specific data --%>
			<life_v1:lifebroker_ref label="ip" />
					
			<form_v1:operator_id xpath="${xpath}/operatorid" />
			<core_v1:referral_tracking vertical="${xpath}" />
			
			<form_v1:header quoteType="${xpath}" hasReferenceNo="true" />
			<life_v1:progress_bar />

			<div id="wrapper">
				<div id="page">
				
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your Details">
								<h2><span>Step 1.</span> Your Details</h2>
										<ip_v1:insurance xpath="${xpath}/primary/insurance" />
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
						
						<form_v1:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="108" minTop="70" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous step</span></a>
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 
					<!-- End main QE content -->
					</div>
					<form_v1:help />
					
						</div>

				<%-- Quote results (default to be hidden) --%>  
				<life_v1:results vertical="ip" />
								
				<%-- Confirmation content (default to be hidden) --%>  
				<life_v1:confirmation />
				
			</div>


		</form_v1:form>
		
		<life_v1:footer />
		
		<core_v1:closing_body>
			<agg_v1:includes supertag="true" />
		<ip_v1:includes />
		</core_v1:closing_body>
		
	</body>
	
</go:html>