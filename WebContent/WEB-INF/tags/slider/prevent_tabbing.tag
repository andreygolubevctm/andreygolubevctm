<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Prevent lose of focus from a slide by capturing form field tabbing" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div class="prevent_tabbing"><input type="text" value="" name="skip" onfocus="QuoteEngine.validate(); $(this).parents('.qe-screen').find(':input:visible:first').focus()" /></div>
<core:clear />

<%-- CSS --%>
<go:style marker="css-head">
.prevent_tabbing {
	position: relative;
	top: -25px;
}
.prevent_tabbing input {
	position: absolute;
	clip: rect(0px 1px 1px 0px);
	clip: rect(0px, 1px, 1px, 0px);
	height: 1px;
	width: 1px;
}
</go:style>
