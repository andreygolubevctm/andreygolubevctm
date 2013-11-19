<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ include file="/WEB-INF/security/core.jsp" %>

<core:doctype />

<go:setData dataVar="data" xpath="login" value="*DELETE" />
<go:setData dataVar="data" xpath="messages" value="*DELETE" />
<core:load_settings conflictMode="false" />

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


<go:script marker="onready">
	<%-- Make the iframe fit the space remaining after the header --%>
	function pageY(elem) {
		return elem.offsetParent ? (elem.offsetTop + pageY(elem.offsetParent)) : elem.offsetTop;
	}
	function resizeIframe() {
		var iframeId = 'main';
		var buffer = 7; //scroll bar buffer
		var height = window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
		height -= pageY(document.getElementById(iframeId)) + buffer;
		height = (height < 0) ? 0 : height;
		document.getElementById(iframeId).style.height = height + 'px';
	}
	window.onresize = resizeIframe;
	window.onload = resizeIframe;
</go:script>
</body>
</go:html>