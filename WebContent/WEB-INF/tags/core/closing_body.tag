<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to add resources to the bottom of the page before the closing body element via insert markers of the gadget object framework."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	Insert Markers
	------------------------------
	js-closingbodyhref 	: Used for internal and external javascripts	&lt;br/&gt;
	js-closingbody 		: Used for inline javascript code				&lt;br/&gt;
--%>

<%-- Href javascript files included with tags --%>
<go:insertmarker format="HTML" name="js-closingbodyhref" />

<%-- Inline Javascript included with tags. --%>
<go:script>
	// Footer javascript
	<go:insertmarker format="SCRIPT" name="js-closingbody" />
</go:script>

<jsp:doBody />