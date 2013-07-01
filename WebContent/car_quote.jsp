<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Import the data --%>
<c:if test="${param.action != 'latest' and param.action != 'amend'}">
	<go:setData dataVar="data" value="${param.ccad}" xpath="quote/ccad" />
</c:if>

<c:set var="xpath" value="quote" />
<c:set var="quoteType" value="car" />

<c:if test="${param.preload == '2'}">  
	<c:choose>
		<c:when test="${param.xmlFile != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="testing/data/${param.xmlFile}" var="quoteXml" />
			<go:setData dataVar="data" xml="${quoteXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="test_data/preload.xml" var="quoteXml" />
			<go:setData dataVar="data" xml="${quoteXml}" />		
		</c:otherwise>
	</c:choose>
</c:if>


<c:import url="brand/ctm/settings.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head quoteType="${quoteType}" title="Car Quote Capture" />
	
	<body class="engine stage-0 ${xpath}">
	
		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Car" initialPageName="ctm:quote-form:Car:Your Car"/>
		
		<%-- History handler --%>
		<quote:history />
		
		<%-- Loading popup holder --%>
		<quote:loading />

		<%-- Transferring popup holder --%>
		<quote:transferring />
		
		<form:form action="car_quote_results.jsp" method="POST" id="mainform" name="frmMain">
		
			
			<form:header quoteType="${quoteType}" />
			<core:progress_bar />
		
			<div id="wrapper">		
				<div id="page">
				
					<form:joomla_quote/>

						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
							<slider:slide id="slide0" title="Car Capture">
								<h2>Step 1. <span>Your Car</span></h2>
								<quote:car />
							</slider:slide>
							<slider:slide id="slide1" title="Options">
								<h2>Step 2. <span>Car Details</span></h2>
								<quote:options />
							</slider:slide>			
							<slider:slide id="slide2" title="About You">
								<h2>Step 3. <span>Driver Details</span></h2>
								<quote:about_you />
							</slider:slide>
							<slider:slide id="slide3" title="Other Persons">
								<h2>Step 4. <span>More Details</span></h2>
								<quote:drivers />
							</slider:slide> 
							<slider:slide id="slide4" title="Contact/Address Information">
								<h2>Step 5. <span>Address/Contact</span></h2>
								<quote:contact />
							</slider:slide>
							<slider:slide id="slide5" title="Captcha">
								<h2>Step 6. <span>Other Info</span></h2>
								<quote:captcha />
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
					
					<div style="height:67px"><!-- empty --></div>

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
				<quote:results />
				
				<%-- Quote Comparison popup --%>
				<quote:compare />
				
				<%-- Get more details on product popup --%>
				<quote:more_details />
				
			</div>
			<form:footer/>
			
			<%-- Flash animation holder --%>
			<div id="flashWrapper"></div>
			<div id="ieflashMask"></div>
			
			<%-- Results conditions popup --%> 
			<quote:results_terms />

			<%-- Results none popup --%>
			<agg:results_none providerType="Car Insurance"/>  
			

			
			<!-- Advert Id -->
			<field:hidden xpath="quote/ccad" />
			<field:hidden xpath="quote/options/coverType" defaultValue="A" />
			
		</form:form>
		
		<%-- Copyright notice --%>
		<quote:copyright_notice />
		
		<%-- Save Quote Popup --%> 
		<quote:save_quote quoteType="${quoteType}" mainJS="${false}" />
		
		
		<%-- Kamplye Feedback --%>
		<core:kampyle formId="85272" />
		
		<core:session_pop />
		<agg:supertag_bottom />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
		
		<%-- Including all go:script and go:style tags --%>
		<quote:includes />
		
		<%-- Write quote at each step of journey --%>
		<agg:write_quote_onstep quoteType="${quoteType}" />

	</body>
	
</go:html>

