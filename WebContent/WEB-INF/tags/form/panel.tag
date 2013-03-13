<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Container for a collection of form:rows"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 			required="true"  rtexprvalue="true"  description="Text to display in title bar" %>
<%@ attribute name="id" 			required="false" rtexprvalue="true"  description="Id attribute for panel" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="helpId" 		required="false" rtexprvalue="true"  description="The panel's help Icon id (if non shown, help is not shown)" %>

<%-- if Id passed, prefix with the attribute code --%>
<c:if test="${ not empty(id) }">
	<c:set var="id" value=" id='${id}'" />
</c:if>

<%-- HTML --%>
<div class="panel ui-widget ui-content ${className}"${id}>
	<div class="panel_header">
		${title}
	</div>
	<div class="panel_content">
		<jsp:doBody />
	</div>
</div>