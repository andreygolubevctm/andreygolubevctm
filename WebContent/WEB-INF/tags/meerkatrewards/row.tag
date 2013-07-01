<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 		required="true"  rtexprvalue="true"	 description="label for the field"%>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id for the row" %>

<%-- HTML --%>
<div id="${id}" class="row">
	<div class="${className} columns">
		<label>${label}</label>
		<jsp:doBody />
	</div>
</div>