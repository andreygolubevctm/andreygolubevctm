<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<form:fieldset legend="More details about the Regular Driver">
	
	<form:row label="Employment status">
		<field:import_select xpath="quote/drivers/regular/employmentStatus"
			required="true" className="employment_status"
			url="/WEB-INF/option_data/employment_status.html"
			title="regular driver's employment status" />
	</form:row>

	<form:row label="Any motor insurance claims in the last 5 years (regardless of who was at fault)" helpId="2" id="quote_drivers_regular_claimsRow">
		<field:array_radio xpath="quote/drivers/regular/claims" required="true"
			className="claims" id="claims" items="Y=Yes,N=No,U=Don't Know"
			title="if the regular driver has had any motor insurance claims in the last 5 years" />
	</form:row>
</form:fieldset>

<form:fieldset legend="Now we need some info about any other drivers of the car">
	<group:youngDriver_selection xpath="quote/drivers/young" />
	
	<form:row label="We may be able to reduce the premium if you restrict the age of drivers" id="quote_restricted_ageRow">
		<field:import_select xpath="quote/options/driverOption" 
							 url="/WEB-INF/option_data/driver_option.html"
							 title="a driver age restriction option"
							 className="driver_option" 
							 required="true" />						
	</form:row>
</form:fieldset>

