<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="footer" class="clearfix">
	<div class="container">
		<quote:mcafee/>
		<jsp:doBody />
	</div>
</div>

<!-- JAVASCRIPT -->
<go:script marker="onready">
	// add class "first" to first "p"" just in case the browser does not support the pseudo selector nth-type-of used in the CSS
	$("#footer .container p").first().addClass('first');
</go:script>