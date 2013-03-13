<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<group:vehicle_selection xpath="quote/vehicle" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#car_accessories, #car_factory_options").buttonset();
	});
	//omnitureReporting(0);
</go:script>





