<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title for the slide"%>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="true"  rtexprvalue="true"	 description="optional id for this slide"%>


<%-- HTML --%> 
<div class="qe-screen" id="${id}">
	<jsp:doBody />	
	<slider:prevent_tabbing />
</div>



