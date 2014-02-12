<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--TODO: turn this on and off either in a settings file or in the database --%>
<c:set var="showReducedHoursMessage" value="false" />
<c:set var="_action"><c:out value="${param.action}" escapeXml="true"/></c:set>


<c:if test="${empty _action}">
	<go:setData dataVar="data" value="*DELETE" xpath="health" />
</c:if>
<c:if test="${not empty _action}">
	<go:setData dataVar="data" value="${_action}" xpath="action"  />
</c:if>

<core:load_settings conflictMode="false" vertical="health" />

<c:if test="${empty _action && param.preload == '2'}">
	<c:choose>
		<c:when test="${param.xmlFile != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="health" />		
			<c:import url="testing/data/${param.xmlFile}" var="healthXml" />
			<go:setData dataVar="data" xml="${healthXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="health" />		
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:when test="${param.preloader == '3'}">
			<go:setData dataVar="data" value="*DELETE" xpath="health" />		
			<c:import url="test_data/preload_health_application.xml" var="healthXml" />
			<go:setData dataVar="data" xml="${healthXml}" />		
		</c:when>	
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="health" />		
			<c:import url="test_data/preload_health.xml" var="healthXml" />
			<go:setData dataVar="data" xml="${healthXml}" />		
		</c:otherwise>
	</c:choose>
</c:if>

<c:set var="xpath" value="health" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Health Quote Capture" mainCss="common/health.css">
		<meta name="viewport" content="width=1020, user-scalable=yes" />
	</core:head>

	<health:optin_handler />

	<body class="health <c:if test="${not empty callCentre}">callcentre</c:if> stage-0 ${_action}">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Health" initialPageName="ctm:quote-form:Health:Situation"/>

		<%-- History handler --%>
		<health:history />
		
		<form:form action="health_quote_results.jsp" method="POST" id="mainform" name="frmMain">
					
			<form:operator_id xpath="${xpath}/operatorid" />
						
			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="true" showReducedHoursMessage="${showReducedHoursMessage}"/>
			<core:referral_tracking vertical="${xpath}" />
			<health:progress_bar />

			<div id="wrapper">
				<div id="page">
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<health:choices xpathBenefits="${xpath}/benefits" xpathSituation="${xpath}/situation" />
							
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Choose your cover">
								<go:log source="health_quote.jsp" level="DEBUG">ENVIRO: ${data.settings['environment']}</go:log>
								<health:provider_testing xpath="${xpath}" />
								<div id="${name}_situation">
									<h2><span>Step 1.</span> All About You</h2>
									<p class="intro-text">Let's find out about you and what sort of health cover you want</p>
									<health:situation xpath="${xpath}/situation" />
								</div>
								<core:clear />								
								<div id="${name}_benefits">
									<health:benefits xpath="${xpath}/benefits" />
								</div>							
							</slider:slide>
							
							<slider:slide id="slide1" title="Rebates and Discounts">
								<h2><span>Step 2.</span> Your Details</h2>
								<p class="intro-text">We're nearly there with your quote.  We  do however need some more information so that we can provide you with an accurate price</p>
								<health:health_cover_details xpath="${xpath}/healthCover" />
								<core:clear />
								<%--<health:contact_details xpath="${xpath}/contactDetails" required="${callCentre}" />--%>
								<health:contact_details_optin xpath="${xpath}/contactDetails" required="${callCentre}" />
							</slider:slide>
							
							<slider:slide id="slide2" title="Your Results">
								<h2><span>Step 3.</span> Your Comparisons</h2>
								<%-- Results are loaded outside of the slider --%>
							</slider:slide>
							
							<slider:slide id="slide3" title="Application Details">
								<h2><span>Step 4.</span> Your Application Details</h2>		
								<p class="intro-text">You've compared and found the right cover for you.  Now let's get you that deal.<br />All you need to proceed are your banking and Medicare details.</p>
								<health:persons xpath="${xpath}/application" />
								<health:dependants xpath="${xpath}/application/dependants" />
								<core:clear />								
								<health:application_details xpath="${xpath}/application" />						
								<core:clear />
								<health:previous_fund xpath="${xpath}/previousfund" id="previousfund" />
							</slider:slide>																									
												
							<slider:slide id="slide4" title="Payment Details">
								<h2><span>Step 5.</span> Your Payment Details</h2>
								<p class="intro-text">Almost there.  Just a few more details to complete  your application. </p>
								<health:payment xpath="${xpath}/payment" />
								<core:clear />
								<health:declaration xpath="${xpath}/declaration" />
								<health:whats-next xpath="${xpath}/whatsNext" />
							</slider:slide>																									
												
							<slider:slide id="slide5" title="Confirmation">
								<h2>Your details</h2>
								<health:quote xpath="${xpath}/quote" />							
							</slider:slide>													
						</slider:slideContainer>
						
						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="108" minTop="60" />
						<core:generic_dialog />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous step</span></a>
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
							<a href="javascript:void(0);" class="button prompt" id="confirm-step"><span>Submit</span></a>
							<span id="results-alt-buttons">
								<a href="javascript:void(0);" class="button next" id="results-step"><span>Show prices</span></a>
								<span class="or">Or</span>
								<a href="javascript:void(0);" class="button next" id="alt-results-step"><span>Choose benefits</span></a>
							</span>
						</div>
						 
					<!-- End main QE content -->
					</div>
					<form:help />
					
					<div style="height:107px"><!--  empty --></div>
					
					<%-- Policy summary panel (default to be hidden) --%>
					<health:policy_details />					
					
					<health:right_panel rateReview="${false}" showReducedHoursMessage="${showReducedHoursMessage}" />
					
					<health:assurance_panel />

					<div class="clearfix"></div>
				</div>

				<%-- Quote results (default to be hidden) --%> 
				<health:results />
			</div>
						

			<core:call_me_back quoteType="health" qsFirstNameField="health_contactDetails_name"  qsOptinField="health_contactDetails_call"></core:call_me_back>
		</form:form>
		
		<health:footer />
		
		<core:closing_body>
			<agg:includes supertag="true" fatalErrorMessage="Please contact us on 1800 77 77 12 for assistance." />
			<health:includes showReducedHoursMessage="${showReducedHoursMessage}" />
		</core:closing_body>
		
	</body>
	
</go:html>
<go:log source="health_quote.jsp" level="TRACE">${data}</go:log>