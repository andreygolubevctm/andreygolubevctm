<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="url" value="${fn:trim(param.id)}" />

<c:if test="${not empty url}">
	<%-- DELETE ALL EXISTING DATA and SETTINGS --%>
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" value="*DELETE" xpath="current" />
	<go:setData dataVar="data" value="*DELETE" xpath="health" />
	<go:setData dataVar="data" value="*DELETE" xpath="travel" />
	<go:setData dataVar="data" value="*DELETE" xpath="roadside" />
	<go:setData dataVar="data" value="*DELETE" xpath="utilities" />
	<go:setData dataVar="data" value="*DELETE" xpath="quote" />
	<go:setData dataVar="data" value="*DELETE" xpath="life" />
	<go:setData dataVar="data" value="*DELETE" xpath="ip" />
	<go:setData dataVar="data" value="*DELETE" xpath="fuel" />
	<go:setData dataVar="data" value="*DELETE" xpath="readonly" />
	<go:setData dataVar="data" value="*DELETE" xpath="soap-response" />
	<go:setData dataVar="data" value="*DELETE" xpath="confirmation" />
	<c:redirect url="${url}" />
</c:if>

<%-- SETTINGS --%>
<core:load_settings conflictMode="false" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>

	<core:head quoteType="none" title="Redirect" nonQuotePage="true" mainCss="common/normal.css" />

	<body class="conflict">
		<form:header quoteType="none" hasReferenceNo="false" />
		<div id="wrapper">
			<div id="page">
				<div id="content">
					<slider:slideContainer className="sliderContainer">
						<slider:slide id="slide0" title="">
							<h2>Redirect</h2>
							<p>Ooops. Something has gone wrong.</p>
							<p>If you have not been redirected please <a href="javascript:history.back();">click here</a></p>
						</slider:slide>
					</slider:slideContainer>
				</div>
			</div>
		</div>

		<agg:generic_footer />

		<core:closing_body>
			<agg:includes kampyle="false" loading="false" sessionPop="false" supertag="false" />
		</core:closing_body>
	</body>

</go:html>