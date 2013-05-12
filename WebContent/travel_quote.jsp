<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- SETTINGS --%>
<c:import url="brand/ctm/settings_travel.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<%-- PRELOAD DATA --%>
<go:setData dataVar="data" value="*DELETE" xpath="travel" />
<c:if test="${param.preload == '1'}">
	<c:import url="test_data/travel_preload.xml" var="quoteXml" />
	<go:setData dataVar="data" xml="${quoteXml}" />
</c:if>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head quoteType="travel" title="Travel Quote Capture" mainCss="common/travel.css" mainJs="common/js/travel.js" />

	<body class="travel stage-0">
		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Travel" initialPageName="ctm:quote-form:Travel:Travel Details"/>

		<%-- History handler --%>
		<travel:history />

		<quote:loading hidePowering="true"/>

		<form:form action="travel_results.jsp" method="POST" id="mainform" name="frmMain">
			<c:set var="policyType">
				<c:choose>
					<c:when test = "${param.type == 'A'}">A</c:when>
					<c:otherwise>S</c:otherwise>
				</c:choose>
			</c:set>
			<go:log>${policyType}</go:log>

			<field:hidden xpath="travel/policyType" constantValue="${policyType}" />

			<form:header quoteType="travel" />
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
						<div class="right-panel-top"></div>
						<div class="right-panel-middle">
							<agg:side_panel />
						</div>
						<div class="right-panel-bottom"></div>
					</div>
					<div class="clearfix"></div>
				</div>


				<%-- Quote results (default to be hidden) --%> 
				<travel:results policyType="${policyType}"/>
				<%-- Add the travel footer --%>
			</div>
			<travel:footer/>

			<%-- Product Information --%>
			<agg:product_info />

			<%-- Results none popup --%>
			<agg:results_none providerType="Travel insurance" />

			<%-- 
				The Results-none Popup requires a call to the method "History.showStart"
				Adding manual override to push the user back to the homepage
			--%>

		</form:form>
		<%-- Copyright notice --%>
		<quote:copyright_notice />

		<%-- Kamplye Feedback --%>
		<core:kampyle formId="85272" />

		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />

		<%-- SuperTag Bottom Code --%>
		<agg:supertag_bottom />

		<travel:includes />
	</body>

</go:html>

