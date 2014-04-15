<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="CAR" />

<%-- Record touch event when transferring from carlmi vertical.
	(record here on so it gets recorded against the transaction id of the carlmi) --%>
<c:set var="trackLmiConversion" value="${data.carlmi.trackConversion}" />
<c:if test="${trackLmiConversion == true && param['int'] != null}">
	<go:setData dataVar="data" value="false" xpath="carlmi/trackConversion" />
	<core:transaction touch="H" comment="getQuote" noResponse="true" writeQuoteOverride="N" />
</c:if>

<%-- Start fresh quote, on refresh --%>
<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="quote" />
	<go:setData dataVar="data" value="*DELETE" xpath="ranking" />
</c:if>

<%-- Import the data on 'action' --%>
<c:if test="${param.action != 'latest' and param.action != 'amend' and param.action != 'ql'}">
	<go:setData dataVar="data" value="${param.ccad}" xpath="quote/ccad" />
</c:if>

<%-- Import the data on QuickLaunch action --%>
<c:if test="${not empty param.action && param.action == 'ql'}">
	<c:if test="${not empty param.quote_vehicle_make}">
		<go:setData dataVar="data" value="${param.quote_vehicle_make}" xpath="quote/vehicle/make" />
	</c:if>
	<c:if test="${not empty param.quote_vehicle_model}">
		<go:setData dataVar="data" value="${param.quote_vehicle_model}" xpath="quote/vehicle/model" />
	</c:if>
	<c:if test="${not empty param.quote_vehicle_year}">
		<go:setData dataVar="data" value="${param.quote_vehicle_year}" xpath="quote/vehicle/year" />
	</c:if>
</c:if>

<c:set var="xpath" value="quote" />
<c:set var="quoteType" value="car" />

<c:set var="xpath" value="car" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty param.action && param.preload == '2'}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="test_data/preload.xml" var="quoteXml" />
			<go:setData dataVar="data" xml="${quoteXml}" />		
</c:if>

<core:doctype />
<go:html>
<core:head quoteType="${quoteType}" title="Car Quote Capture" mainCss="common/base.css" mainJs="common/js/car/car.js"/>
	
	<body class="engine stage-0 ${xpath}">
	
		<%-- SuperTag Top Code --%>
	<agg:supertag_top type="Car"
		initialPageName="ctm:quote-form:Car:Your Car" />
		
		<%-- History handler --%>
		<quote:history />
		
	<form:form action="car_quote_results.jsp" method="POST" id="mainform"
		name="frmMain">
		
			
		<form:header quoteType="${quoteType}" hasReferenceNo="true" showReferenceNo="false"/>
		<core:referral_tracking vertical="${xpath}" />
		<quote:progress_bar />
		
			<div id="wrapper">		
				<div id="page">
				
						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
							<slider:slide id="slide0" title="Car Capture">
							<h2>
								Step 1. <span>Your Car</span>
							</h2>
								<quote:car />
							</slider:slide>
							<slider:slide id="slide1" title="Options">
							<h2>
								Step 2. <span>Car Details</span>
							</h2>
								<quote:options />
							</slider:slide>			
							<slider:slide id="slide2" title="About You">
							<h2>
								Step 3. <span>Driver Details</span>
							</h2>
								<quote:about_you />
							</slider:slide>
							<slider:slide id="slide3" title="Other Persons">
							<h2>
								Step 4. <span>More Details</span>
							</h2>
								<quote:drivers />
							</slider:slide> 
							<slider:slide id="slide4" title="Contact/Address Information">
							<h2>
								Step 5. <span>Address/Contact</span>
							</h2>
								<quote:contact />
							</slider:slide>
							<slider:slide id="slide5" title="Captcha">
							<h2>
								Step 6. <span>Other Info</span>
							</h2>
								<quote:captcha />
							</slider:slide>															

						</slider:slideContainer>
						
					<form:error id="slideErrorContainer"
						className="slideErrorContainer" errorOffset="68" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
						<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous
								step</span></a> <a href="javascript:void(0);" class="button next"
							id="next-step"><span>Next step</span></a>
						</div>
						 
					<!-- End main QE content -->
					</div>
					<form:help />
					
				<div style="height: 67px">
					<!-- empty -->
				</div>

					<div class="right-panel">
						<div class="right-panel-top"></div>
						<div class="right-panel-middle">
						<agg:side_panel_car />
						</div>
						<div class="right-panel-bottom"></div>
					</div>
					<div class="clearfix"></div>
				</div>

				<%-- Quote results (default to be hidden) --%> 
			<quote:results vertical="${quoteType}" />
			</div>
			
			
			<!-- Advert Id -->
			<field:hidden xpath="quote/ccad" />
			<field:hidden xpath="quote/options/coverType" defaultValue="A" />
			
		</form:form>
		
	<quote:footer />
		
	<core:closing_body>
		<agg:includes supertag="true" />
		<quote:includes />
	</core:closing_body>
		
	</body>
	
</go:html>