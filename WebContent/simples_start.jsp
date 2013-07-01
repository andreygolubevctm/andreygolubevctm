<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%-- Don't override settings --%>
<c:if test="${empty data.settings.styleCode}">
	<c:import url="brand/ctm/settings.xml" var="settingsXml" />
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" xml="${settingsXml}" />
</c:if>

<go:html>
<core:head quoteType="false" title="Simples Start" nonQuotePage="${true}" />
	
<go:script marker="js-href"	href="common/js/jquery.validate.pack-1.7.0.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.custom.js"/>

<body>
	
	<%--<img src="brand/ctm/images/aleksandr.jpg" style="float:left;margin-left:10px;" />--%>
	<img src="brand/ctm/images/arrow.png" style="float:left;margin-left:222px;">
	<div id="welcome">
		Please pick option and make start
	</div>
	
	<%-- Including all go:script and go:style tags --%>
	<simples:includes />

</body>
</go:html>