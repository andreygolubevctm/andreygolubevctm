<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="iFrame to be rendered to page"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="source"	required="true"	rtexprvalue="true"	description="The source label which matches a url element in settings xml - external-url" %>

<%-- VARIABLES --%>
<c:if test="${source eq 'ctp-nsw'}">
	<c:set var="iframe_url">http://prices.maa.nsw.gov.au/</c:set>
	<c:set var="iframe_width">1140</c:set>
</c:if>

<%-- Bounce if no iframe-url found --%>
<c:if test="${empty iframe_url}">
	<c:redirect url="${data.settings['exit-url']}?iframeurl=notfound" />
</c:if>

<%-- HTML --%>
<div id="iframe_wrapper"><!-- empty --></div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	<c:if test="${not empty iframe_width}">
		$('#iframe_wrapper, #header .inner-header').css({width:'${iframe_width}'});
	</c:if>
	IframePage.render('iframe_wrapper', '${iframe_url}');
</go:script>