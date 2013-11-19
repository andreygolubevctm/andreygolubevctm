<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true"
	description="additional css class attribute"%>
<%@ attribute name="id" required="false" rtexprvalue="true"
	description="optional id for this slide"%>
<%-- CSS --%>
<go:style marker="css-head">
	#quote_options_driverOption {
		max-width:320px;
	}
</go:style>
<%-- HTML --%>
<form:fieldset legend="Info about where is the car parked at night">
	<group:address xpath="roadside/riskAddress" type="R" />
</form:fieldset>	



<%-- VALIDATION --%>
<go:validate selector="quote_options_driverOption" rule="allowedDrivers"
	parm="true"
	message="Driver age restriction invalid due to regular driver's age." />