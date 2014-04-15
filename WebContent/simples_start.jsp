<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />

<core:doctype />

<go:html>
<core:head quoteType="false" title="Simples Start" nonQuotePage="${true}" />
	
<go:script marker="js-href"	href="common/js/jquery.validate-1.11.1.min.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.custom.js"/>

<body>
	
	<img src="brand/ctm/images/arrow.png" style="float:left;margin-left:222px;"> <%-- #WHITELABEL CX --%>
	<div id="welcome">
		Please pick option and make start
	</div>
	
	<%-- Including all go:script and go:style tags --%>
	<simples:includes />

</body>
</go:html>