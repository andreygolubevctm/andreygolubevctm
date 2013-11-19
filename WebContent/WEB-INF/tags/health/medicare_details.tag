<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-medicare_details">

	<simples:dialogue id="30" vertical="health" mandatory="true" />

	<form:fieldset legend="Your Medicare details" >

		<form:row label="Are all people to be included on this policy covered by a green or blue Medicare card?" id="medicareCoveredRow" helpId="291">
			<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/cover" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover"/>
		</form:row>

		<form:row label="Your Medicare card number">
			<span id="health_medicareDetails_message"></span>
			<field:medicare_number xpath="${xpath}/number" required="true" className="health-medicare_details-number" title="Medicare card number" />
		</form:row>

		<form:row label="Medicare Expiry Date">
			<field:cards_expiry rule="mcExp" xpath="${xpath}/expiry" title="Medicare card expiry date" required="true" className="health-medicare_details-expiry" />
		</form:row>

		<form:row label="First name on Medicare card">
			<field:input xpath="${xpath}/firstName" title="first name on the Medicare card" required="true" className="health-medicare_details-first_name" />
		</form:row>

		<form:row label="Middle initial on Medicare card">
			<field:input xpath="${xpath}/middleInitial" title="middle initial on the Medicare card" maxlength="1" required="false" className="health-medicare_details-initial" />
		</form:row>

		<form:row label="Surname on Medicare card">
			<field:input xpath="${xpath}/surname" title="last name on the Medicare card" required="true" className="health-medicare_details-surname" />
		</form:row>

	</form:fieldset>

</div>



<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#${name}_cover").buttonset();
	});

	$.address.internalChange(function(event){
		if(event.parameters.stage == 4) {

			var firstname = $("#${name}_firstName");
			var surname = $("#${name}_surname");

			if(!firstname.val().length) {
				firstname.val( $("#health_application_primary_firstname").val() );
			};

			if(!surname.val().length) {
				surname.val( $("#health_application_primary_surname").val() );
			};

			var product = Results.getSelectedProduct();
			var mustShowList = ["GMHBA","Frank"];

			if( $('input[name=health_healthCover_rebate]:checked').val() == "N" && $.inArray(product.info.providerName, mustShowList) == -1) {
				$("#health_payment_medicare-selection").hide().attr("style", "display:none !important");
			} else {
				$("#health_payment_medicare-selection").removeAttr("style");
			}

		};
	});
</go:script>


<go:validate selector="${name}_cover" rule="agree" parm="true" message="To proceed with this policy, you must have a blue or green medicare card" />
