<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Container with a title and an optional horizontal rule"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="tiels for the section"%>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>
<%@ attribute name="separator"	required="false" rtexprvalue="true"	 description="whether to display an horizontal rule at the bottom of the section" %>


<%-- HTML --%>
<div class="section" id="${id}">
	<div class="section-title">${title}</div>
	<c:if test="${helpId != null && helpId != ''}">
		<div class="help_icon" id="help_${helpId}"></div>
	</c:if>
	<core:clear />
	<div>
		<jsp:doBody />
	</div>
	<c:if test="${not empty separator}">
		<hr />
	</c:if>
</div>

<%-- CSS --%>
<go:script marker="css-head">
	#${id} .help_icon{
		margin-top: 3px;
	}
</go:script>