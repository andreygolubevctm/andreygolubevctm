<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="xpath" value="travel" />

<%-- SETTINGS --%>
<core:load_settings conflictMode="false" vertical="${xpath}" />
<%-- PRELOAD DATA --%>
<c:choose>
<c:when test="${empty param.action}">
<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
	<go:setData dataVar="data" value="*DELETE" xpath="userData" />
</c:when>
<c:when test="${param.action == 'result'}">
	<go:setData dataVar="data" xpath="userData/emailSent" value="true" />
</c:when>
</c:choose>
<c:if test="${param.preload == '1'}">  
	<c:import url="test_data/travel_preload.xml" var="quoteXml" />
	<go:setData dataVar="data" xml="${quoteXml}" />		
</c:if>


<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Travel Quote Capture" mainCss="common/travel.css" mainJs="common/js/travel.js" />

	<body class="travel stage-0">
		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Travel" initialPageName="ctm:quote-form:Travel:Travel Details"/>

		<%-- History handler --%>
		<travel:history />

		<form:form action="travel_results.jsp" method="POST" id="mainform" name="frmMain">
			<c:set var="policyType">
				<c:choose>
					<c:when test = "${param.type == 'A'}">A</c:when>
					<c:otherwise>S</c:otherwise>
				</c:choose>
			</c:set>
			<go:log>${policyType}</go:log>
			
			<field:hidden xpath="travel/policyType" constantValue="${policyType}" />
			
			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
			<core:referral_tracking vertical="${xpath}" />
			<div id="navContainer"></div>
			<div id="wrapper" class="clearfix">
				
				<div id="page" class="clearfix">

						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
							
							<c:if test="${policyType=='A'}">
								<slider:slide id="slide0" title="Travellers - Annual Policy">
									<travel:annual_form />
								</slider:slide>
							</c:if>
							
							<c:if test="${policyType=='S'}">
								<slider:slide id="slide0" title="Travellers - Single Policy">
									<travel:single_form />
								</slider:slide>
							</c:if>
							
						</slider:slideContainer>
						
						<form:error id="slideErrorContainer" className="slideErrorContainer travel" errorOffset="42" />
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>
						 
					<!-- End main QE content -->

					</div>
					
					<form:help />
					
					<div class="right-panel">
<%--						<div class="right-panel-top"></div>
							<div class="right-panel-middle" id="travel_comparison_reminder_holder">
								<!-- This will be filled with the comparison reminder button -->
						</div>
						<div class="right-panel-bottom"></div>
--%>						<div class="right-panel-top"></div>
						<div class="right-panel-middle">
							<agg:side_panel />
						</div>
						<div class="right-panel-bottom"></div>
					</div>
					<div class="clearfix"></div>
				</div>
				
				<%-- Quote results (default to be hidden) --%> 
				<travel:results policyType="${policyType}"/>										
			</div>
			
			
		</form:form>

		<travel:footer />
				
		<core:closing_body>
			<agg:includes supertag="true" />
			<travel:includes />
		</core:closing_body>

	</body>
	
</go:html>

