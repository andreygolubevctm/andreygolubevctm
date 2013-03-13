<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>

<%-- HTML --%>
<div class="fieldfullrow ${className}" id="${id}">
	<div class="fieldrow_value">	
		<jsp:doBody />
	</div>
	<c:if test="${helpId != null && helpId != ''}">
		<div class="help_icon" id="help_${helpId}"></div>
	</c:if>			
</div>
