<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="ip" />
</c:if>

<c:if test="${param.preload == '2'}">
	<c:choose>
		<c:when test="${param.xmlFile != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="ip" />
			<c:import url="testing/data/${param.xmlFile}" var="ipXml" />
			<go:setData dataVar="data" xml="${ipXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="ip" />
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="ip" />
			<c:import url="test_data/preload_ip.xml" var="ipXml" />
			<go:setData dataVar="data" xml="${ipXml}" />
		</c:otherwise>
	</c:choose>
</c:if>

<c:import url="brand/ctm/settings_ip.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<c:set var="xpath" value="ip" scope="session" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head quoteType="ip" title="Income Protection Insurance Quote Capture" mainCss="common/ip.css" mainJs="common/js/ip.js" />
	
	<body class="ip stage-0">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="IP"/>

		<%-- History handler --%>
		<ip:history />

		
		<%-- Loading popup holder --%>
		<quote:loading />

		<%-- Transferring popup holder --%>
		<quote:transferring />

		<form:form action="ip_quote_results.jsp" method="POST" id="mainform" name="frmMain">
		
			<%-- Fields to store Lifebroker specific data --%>
			<life:lifebroker_ref label="ip" />
					
			<form:operator_id xpath="${xpath}/operatorid" />
			
			<form:header quoteType="ip" hasReferenceNo="true" />
			<ip:progress_bar />

			<div id="wrapper">
				<div id="page">

					<form:joomla_quote/>

						<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">

							<%-- INITIAL: stage, set from parameters --%>
							<slider:slide id="slide0" title="Your Details">
								<h2><span>Step 1.</span> Your Details</h2>
								<ip:details xpath="${xpath}/details/primary" />
								<ip:contact_details xpath="${xpath}/contactDetails" />
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

						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="108" />

						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step"><span>Previous step</span></a>
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>

					<!-- End main QE content -->
					</div>
					<form:help />

					<div style="height:107px"><!--  empty --></div>

					<form:scrapes id="slideScrapesContainer" className="slideScrapesContainer" group="ip" />

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
				<ip:results />

				<%-- Confirmation content (default to be hidden) --%>
				<ip:confirmation />

				<div id="promotions-footer"><!-- empty --></div>

			</div>
			<life:footer />

		</form:form>

		<%-- Copyright notice --%>
		<ip:copyright_notice />

		<%-- Save Quote Popup --%>
		<quote:save_quote quoteType="ip" emailCode="CTIQ" mainJS="IPQuote" />

		<%-- Kamplye Feedback --%>
		<core:kampyle formId="85272" />

		<core:session_pop />

		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />

		<%-- Including all go:script and go:style tags --%>
		<ip:includes />

	</body>

</go:html>