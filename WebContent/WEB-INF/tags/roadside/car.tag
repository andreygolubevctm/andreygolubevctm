<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- CSS --%>
<go:style marker="css-head">

/* overwrite for style.css  */
 	#roadside_vehicle_typeRow .vehicleDes {
	 	font-size: 12px;
	    margin-bottom: 10px;
	    margin-left: 5px;
	    width: 482px;
	}
</go:style>


<%-- HTML --%>
<roadside:vehicle_selection_lite xpath="roadside/vehicle" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#car_commercial, #car_odometer").buttonset();
	});
	<%--
	omnitureReporting(0);
	 --%>
</go:script>





