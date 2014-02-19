<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="xpath" value="fuel" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
</c:if>


<core:load_settings conflictMode="false" vertical="fuel" />

<%-- PRELOAD DATA --%>

<c:if test="${empty param.action && param.preload == '2'}">
	<c:choose>
		<c:when test="${param.xmlFile != null}">
<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="testing/data/${param.xmlFile}" var="fuelXml" />
			<go:setData dataVar="data" xml="${fuelXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="test_data/preload_fuel.xml" var="fuelXml" />
			<go:setData dataVar="data" xml="${fuelXml}" />
		</c:otherwise>
	</c:choose>
</c:if>








<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Fuel Price Checker" mainCss="common/fuel.css" mainJs="common/js/fuel.js" />

	<body class="fuel stage-0">
	
		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Fuel"/>
			
		<form:form action="javascript:void(0);" method="GET" id="mainform" name="frmMain">
		
			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
			<core:referral_tracking vertical="${xpath}" />
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
						
						<form:error id="slideErrorContainer" className="slideErrorContainer fuel" errorOffset="45" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 

						<!-- End main QE content -->
						
					</div>
					
					<form:help />

					<div class="right-panel">
<%--
						<div class="right-panel-top"></div>
						<div class="right-panel-middle" id="fuel_comparison_reminder_holder">
							<!-- This will be filled with the comparison reminder button -->
						</div>
						<div class="right-panel-bottom"></div> --%>
						<div class="spacer"></div>
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
			
						
		</form:form>
				
		<fuel:footer />
		
		<core:closing_body>
			<agg:includes supertag="true" />
			<fuel:includes />
		</core:closing_body>
		
	</body>
	
</go:html>