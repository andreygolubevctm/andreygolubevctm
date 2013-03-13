<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-head">
#copyright {
	margin-left: auto;
	margin-right: auto;
	color: #5080b1;
	padding-top:10px;	
	padding-bottom:10px;
}
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
	<p>&copy; 2006-2012 <strong>Compare</strong>the<strong>market</strong>.com.au. All rights reserved.
		<a href="javascript:showDoc('${data['settings/privacy-policy-url']}','Privacy_Policy')">Privacy Policy</a>.
		<a href="javascript:showDoc('${data['settings/website-terms-url']}','Website_Terms_of_Use')">Website Terms of Use</a>.
	</p>
</div>
