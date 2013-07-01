<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- SETTINGS --%>
<c:import url="brand/ctm/settings.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>

	<core:head quoteType="none" title="The site is currently under maintenance" mainCss="common/normal.css" />

	<body class="maintenance">
		<form:header quoteType="none" hasReferenceNo="false" showReferenceNo="false" />
		<div id="wrapper">
			<div id="page">
				<div id="content">
					<slider:slideContainer className="sliderContainer">
						<slider:slide id="slide0" title="">
							<h2>The quote software is currently under maintenance</h2>
							<p><strong>We apologise for the inconvenience and expect to finish shortly.</strong></p>
							<p>Please check back soon for some great comparisons.</p>
						</slider:slide>
					</slider:slideContainer>
				</div>
			</div>
		</div>
		<agg:footer />
	</body>

</go:html>