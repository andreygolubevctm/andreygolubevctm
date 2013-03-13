<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Disable the tab key to switch between elements" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="selector" required="true" rtexprvalue="true" description="the selector of elements for which you want to disable the tab key" %>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$("${selector} *").attr('tabindex', '-1');
</go:script>