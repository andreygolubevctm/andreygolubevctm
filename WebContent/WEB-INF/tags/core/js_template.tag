<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag for including javascript templates and avoiding errors"%>
<%@ tag body-content="scriptless" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="true" rtexprvalue="true"	 description="The js-template's Id"%>

<go:script marker="js-href" href="common/js/template.js" />

<%-- HTML --%>
<jsp:element name="script">
	<jsp:attribute name="id" trim="true">${id}</jsp:attribute>
	<jsp:attribute name="type">text/html</jsp:attribute>
	<jsp:body>
		<jsp:doBody />
	</jsp:body>
</jsp:element>
