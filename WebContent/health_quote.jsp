<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="health" />
</c:if>
<c:if test="${not empty param.action}">
	<go:setData dataVar="data" value="${param.action}" xpath="action" />
</c:if>

<core:load_settings conflictMode="false" vertical="health" />

<c:if test="${empty param.action && param.preload == '2'}">
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

<c:if test="${param.action eq 'confirmation' and not empty param.ConfirmationID}">
	<sql:setDataSource dataSource="jdbc/ctm" />
	<sql:query var="confirmations">
		SELECT TransID AS id
		FROM ctm.confirmations
		WHERE KeyID = ? AND Vertical = ?
		LIMIT 1
		<sql:param value="${param.ConfirmationID}" />
		<sql:param value="CTMH" />
	</sql:query>
	<c:if test="${not empty confirmations and confirmations.rowCount > 0}">
		<c:import var="ignoreme" url="ajax/json/load_quote.jsp?vertical=health&transactionId=${confirmations.rows[0].id}" />
	</c:if>
</c:if>

<c:set var="xpath" value="health" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Health Quote Capture" mainCss="common/health.css">
		<meta name="viewport" content="width=1020, user-scalable=yes" />
	</core:head>

	<body class="health <c:if test="${not empty callCentre}">callcentre</c:if> stage-0 ${param.action}">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Health" initialPageName="ctm:quote-form:Health:Situation"/>

		<%-- History handler --%>
		<health:history />
		
		<%-- Loading popup holder --%>
		<quote:loading />

		<%-- Transferring popup holder --%>
		<quote:transferring />

		<form:form action="health_quote_results.jsp" method="POST" id="mainform" name="frmMain">
					
			<form:operator_id xpath="${xpath}/operatorid" />
			<core:referral_tracking vertical="${xpath}" />
						
			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="true"/>
			<health:progress_bar />

			<div id="wrapper">
				<div id="page">
					<form:joomla_quote/>
					
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
						
							<health:choices xpathBenefits="${xpath}/benefits" xpathSituation="${xpath}/situation" />
							
							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Choose your cover">
								<go:log>ENVIRO: ${data.settings['environment']}</go:log>
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
					
					<health:right_panel rateReview="${false}" />
					
					<health:assurance_panel />

					<div class="clearfix"></div>
				</div>

				<%-- Quote results (default to be hidden) --%> 
				<health:results />
				
				<%-- Quote Comparison popup
				<health:compare /> --%>
	
				<%-- Product info popup
				<health:product_info />				 --%>
				
				<div id="promotions-footer"><!-- empty --></div>
				
			</div>
			<health:footer />
						
			<%-- Results conditions popup  
			<quote:results_terms />--%>

			<%-- Results none popup
			<health:results_none /> --%>  
						
			<!-- Advert Id 
			<field:hidden xpath="quote/ccad" />
			-->

			<core:call_me_back quoteType="health" qsFirstNameField="health_contactDetails_name"  qsOptinField="health_contactDetails_call"></core:call_me_back>
			<%--<core:call_me_back quoteType="health" qsFirstNameField="health_contactDetails_firstName" qsLastNameField="health_contactDetails_lastname" qsPhoneNoField="health_contactDetails_contactNumber" qsOptinField="health_contactDetails_call"></core:call_me_back>--%>
		</form:form>
		
		<%-- Copyright notice --%>
		<agg:copyright_notice />
		
		<%-- Save Quote Popup --%>
		<quote:save_quote quoteType="${xpath}"
			mainJS="Health"
			includeCallMeback="true" />
		
		<%-- Kamplye Feedback --%>
		<core:kampyle formId="85272" />
		
		<core:session_pop />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error custom="Please contact us on 1800 77 77 12 for assistance." />
		
		<%--Dialog panel editing benefits from the results page --%>
		<div id="results-edit-benefits"></div>
		
		<%--Dialog panel readmore content on the results page --%>
		<div id="results-read-more">
			<div class="content"></div>
			<div class="dialog_footer"></div>
		</div>
		
		<%-- Dialog for when selected product not available --%>
		<core:popup id="update-premium-error" title="Policy not available">
			<p>Unfortunately, no pricing is available for this fund.</p>
			<p>Click the button below to return to your application and try again or alternatively <i>save your quote</i> and call us on <b>1800 77 77 12</b>.</p>
			<div class="popup-buttons">
				<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
			</div>
		</core:popup>

		<health:prices_have_changed_notification />

		<health:popup_hintsdetail />
		<health:hints />
		
		<%-- SuperTag Bottom Code --%>
		<agg:supertag_bottom />
		
		<%-- Including all go:script and go:style tags --%>
		<health:includes />
		
		<health:simples_test />
		
	</body>
	
</go:html>