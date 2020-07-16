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

<%-- Get current  --%>
<c:set var="websiteTermConfigToUse">
	<content:get key="websiteTermsUrlConfig"/>
</c:set>

<%-- HTML --%>
<div id="copyright">
	<div class="container">
		<p>&copy; ${pageSettings.getSetting('brandName')}. All rights reserved.
			<a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank" >Privacy Policy</a>.
			<a href="${pageSettings.getSetting(websiteTermConfigToUse)}" target="_blank" >Website Terms of Use</a>.
		</p>
	</div>
</div>
