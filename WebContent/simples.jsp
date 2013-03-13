<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<go:setData dataVar="data" xpath="*" value="*DELETE" />
<c:import url="brand/ctm/settings.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />
<c:set var="login"><core:login uid="${param.uid}" asim="N" /></c:set>
<c:set var="callCentre" scope="session"><simples:security key="callCentre" /></c:set>

<go:html>
<simples:head title="Simples Dashboard" />

<body class="ctm">
<c:choose>
	<c:when test="${!callCentre }">
		<h1>This page is for authorised use only</h1>
	</c:when>
	<c:otherwise>
		<form:form name="mainform" action="javascript:void(0);" id="mainform" method="POST">
			<core:loadsafe />
			<simples:menu_bar />
		</form:form>
		<iframe id="main" width="100%" src="simples_start.jsp"></iframe>
	</c:otherwise>
</c:choose>

<!-- Loading animation -->
<quote:loading />

<core:popup id="retrieve-quote-error" title="Retrieve Quotes Error">
	<p>Unfortunately we were unable to retrieve your quote.</p>
	<div id="retrieve-quote-error-message"></div>
	<p>Click the button below to return to the "Search Quotes" page and try again.</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<core:popup id="search-quotes-error" title="Search Quotes Error">
	<p>Unfortunately we were unable to complete your search.</p>
	<div id="search-quotes-error-message"></div>
	<p>Click the button below to return to the "Search Quotes" page and try again.</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<core:popup id="quote-comments-error" title="Quote Comments Error">
	<p>Unfortunately we were unable to display any comments.</p>
	<div id="quote-comments-error-message"></div>
	<p>Click the button below to close and try another quote id.</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<core:popup id="quote-add-comments-error" title="Add Comment Error">
	<p>Unfortunately we could not add your comment.</p>
	<div id="quote-add-comments-error-message"></div>
	<p>Click the button below to close and try again.</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<core:popup id="simples-processing" title="Processing...">
	<p>&nbsp;</p>
	<div id="simples-processing-message"></div>
	<p>&nbsp;</p>
</core:popup>

<%-- Dialog for rendering fatal errors --%>
<form:fatal_error />

</body>
</go:html>
