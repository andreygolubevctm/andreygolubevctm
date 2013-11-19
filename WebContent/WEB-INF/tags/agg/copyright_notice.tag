<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="date" class="java.util.Date" />

<%-- CSS --%>
<go:style marker="css-head">
#copyright a{
	text-decoration:none;
	color: #5080b1;
}
#copyright a:hover{
	text-decoration:underline;
}
</go:style>

<%-- HTML --%>
<div id="copyright">
	<p>&copy; 2006-<fmt:formatDate value="${date}" pattern="yyyy" /> Compare the Market. All rights reserved.
		<a href="javascript:showDoc('${data['settings/privacy-policy-url']}','Privacy_Policy')">Privacy Policy</a>.
		<a href="javascript:showDoc('${data['settings/website-terms-url']}','Website_Terms_of_Use')">Website Terms of Use</a>.
	</p>
</div>