<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="xpath" value="fuel" scope="session" />

<%-- SETTINGS --%>
<c:import url="brand/ctm/settings_fuel.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<%-- PRELOAD DATA --%>
<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head quoteType="fuel" title="Fuel Price Checker" mainCss="common/fuel.css" mainJs="common/js/fuel.js" />

	<body class="fuel stage-0">
	
		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Fuel"/>
			
		<quote:loading hidePowering="true"/>
		
		<form:form action="javascript:void(0);" method="GET" id="mainform" name="frmMain">
		
			<form:header quoteType="fuel" />
			<fuel:progress_bar />	
			<div id="wrapper" class="clearfix">
				
				<div id="page" class="clearfix">

					<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
							<slider:slide id="slide0" title="FuelSearch">
								<fuel:fuel_form />
							</slider:slide>																							
						</slider:slideContainer>
						
						<form:error id="slideErrorContainer" className="slideErrorContainer fuel" errorOffset="42" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 
						<!-- End main QE content -->
						
					</div>
					
					<form:help />

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
				<fuel:results />

			</div>
			
			<fuel:footer/>	
						
			<%-- Product Information --%>
			<agg:product_info />	
			
		</form:form>
		
		<%-- Copyright notice --%>
		<quote:copyright_notice />
				
		<%-- Kamplye Feedback --%>
		<core:kampyle formId="85272" />
		
		<%-- Quick Capture sign Up Form --%>
		<fuel:quick_capture />		
		
		<core:session_pop />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
		
		<fuel:includes />
		<agg:supertag_bottom />
	</body>
	
</go:html>