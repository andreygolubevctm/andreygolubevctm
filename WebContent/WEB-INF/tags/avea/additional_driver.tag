<%@ tag language="java" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="countId" 		required="true"   rtexprvalue="true" description="Count ID of current driver. Must be a unique number. Eg. driver0, driver1, driver2..." %>
<%@ attribute name="className" 		required="false"  rtexprvalue="true" description="Custom Class to apply to the container" %>
<%@ attribute name="hideSeparator" 	required="false"  rtexprvalue="true" description="Set to hide the separating line under the fields" %>
<%@ attribute name="hideAdd" 		required="false"  rtexprvalue="true" description="Set to hide the Add Another link" %>
<%@ attribute name="xpath" 			required="true"  rtexprvalue="true" description="Set the xpath base" %>



<%-- HTML --%>

	<div id="driver_${countId}" class="driver <c:if test="${className!=null}"> ${className}</c:if>">

		<c:if test="${hideSeparator==null}">
			<avea:separator />
		</c:if>

		<c:if test="${countId=='driver0'}">
			<strong class="driver_head">Regular Driver</strong>
		</c:if>
		<c:if test="${countId!='driver0'}">
			<strong class="driver_head">Additional Driver</strong>
		</c:if>

		<form:row label="Date of birth">
			<field:person_dob xpath="${xpath}/dob" required="true" title="Date of Birth" ageMax="85" ageMin="16"/>
		</form:row>

		<form:row label="Title">
			<field:import_select xpath="${xpath}/title"
						url="/WEB-INF/option_data/titles.html"
						title="Title"
						required="true" />
		</form:row>


		<form:row label="First Name" className="fleft" id="firstName">
			<field:input xpath="${xpath}/firstName" title="First Name" className="driver_first_name" required="true" maxlength="200" />
		</form:row>

		<form:row label="Surname" className="fleft" id="lastName">
			<field:input xpath="${xpath}/lastName" title="Surname" required="true" maxlength="200"  />
		</form:row>

		<form:row label="Licence Number" className="fleft" id="licenceNumber">
			<field:input xpath="${xpath}/licenceNumber" title="Licence Number" className="licence_number" required="true" maxlength="20"  />
		</form:row>

		<form:row label="First Year Licenced" className="fleft" id="firstYearLicenced">
			<field:input xpath="${xpath}/firstYearLicenced" title="First Year Licenced" className="first_year_licenced" required="true" maxlength="4"  />
		</form:row>

		<form:row label="Kilometres Driven" className="fleft" id="kilometresDriven">
			<field:input xpath="${xpath}/kilometresDriven" title="Kilometres Driven" className="kilometres_driven" required="true"  maxlength="20"  />
		</form:row>

		<c:if test="${(hideAdd==null || hideAdd=='false') && countId!='driver0'}">
			<core:clear />
			<a href="javascript:;" id="add_driver_${countId}" class="add_link add_driver">Add another</a>
		</c:if>
		<c:if test="${countId!='driver0'}">
			<a href="javascript:;" id="remove_driver_${countId}" class="remove_link remove_driver">Remove</a>
		</c:if>

		<core:clear />

	</div>

	<core:clear />


<%-- STYLES --%>
<avea:additional_styles />
<avea:additional_scripts countId="${countId}" idIns="driver" maxRows="4" />


<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	$('#quote_avea_${countId}_kilometresDriven').numeric();
	$('#quote_avea_drivers_${countId}_firstYearLicenced').numeric();

	$.validator.addMethod("aveaMin17years",
			function(value, elem, parm) {

				var dob = $('#quote_avea_drivers_'+parm+'_dob').val();
				var fyl = $('#quote_avea_drivers_'+parm+'_firstYearLicenced').val();
				var int_dob = parseInt(dob.substring(6, 10)); // Assumes dd/mm/yyyy format
				var int_fyl = parseInt(fyl);

				if( int_fyl >= int_dob+17 ) {
					return true;
				}else{
					return false;
				}
			},
			""
	);

</go:script>


<%-- VALIDATION --%>
<go:validate selector="quote_avea_drivers_${countId}_firstYearLicenced"  rule="aveaMin17years" parm="'${countId}'" message="First year licensed must be at least 16 years after date of birth" />




