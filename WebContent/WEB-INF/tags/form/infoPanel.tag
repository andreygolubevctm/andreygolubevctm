<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 		required="false"  rtexprvalue="true"	 description="title for the slide"%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<div id="infoPanel" style="z-index: 9999; float: left; position: absolute; border:1px solid #AAAAAA; width: 815px; background-color: #FFFFFF">
	<div id="close">close</div>		
				
	<div id="infoData"></div>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$("#infoPanel").hide();
</go:script>