<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to create the head tag including markers needed for the gadget object framework."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="formName" value="meerkatRewardsForm" />

<%-- HTML --%>
<jsp:element name="form">
	<jsp:attribute name="id">${formName}</jsp:attribute>
	<jsp:attribute name="class">custom</jsp:attribute>
	<jsp:attribute name="name">${formName}</jsp:attribute>
	<jsp:attribute name="method">POST</jsp:attribute>
	<jsp:attribute name="action">ajax/write/meerkat_rewards.jsp</jsp:attribute>
	<jsp:attribute name="autocomplete">off</jsp:attribute>
	<jsp:body>
		<jsp:doBody />
	</jsp:body>
</jsp:element>

<%-- EXTERNAL JAVASCRIPTS --%>
<go:script marker="js-href"	href="common/js/jquery.maskedinput-1.3-co.min.js"/>
<go:script marker="js-href"	href="common/js/jquery.metadata.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.pack-1.7.0.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.custom.js"/>
<go:script marker="js-href"	href="common/js/jquery.bgiframe.js"/>