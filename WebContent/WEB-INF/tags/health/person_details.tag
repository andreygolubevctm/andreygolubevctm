<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="title" required="false" rtexprvalue="true" description="the title"%>
<%@ attribute name="id" required="true" rtexprvalue="true" description="the id"%>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="field_firstname" value="${xpath}/firstname" />
<c:set var="field_firstname" value="${go:nameFromXpath(field_firstname)}" />
<c:set var="field_surname" value="${xpath}/surname" />
<c:set var="field_surname" value="${go:nameFromXpath(field_surname)}" />
<c:set var="field_dob" value="${xpath}/dob" />
<c:set var="field_dob" value="${go:nameFromXpath(field_dob)}" />

<c:set var="dobTitle">
	<c:choose>
		<c:when test="${id eq 'partner'}">applicant's partners</c:when>
		<c:otherwise>primary applicant's</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div class="health-person-details-${id} health-person-details ${id}">

	<form:fieldset legend="${title} Details">

		<form:row label="Title" id="titleRow">
			<field:import_select xpath="${xpath}/title" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title"/>
		</form:row>

		<form:row label="First name" id="firstName" className="halfrow" >
			<field:person_name xpath="${xpath}/firstname" required="true" title="${title} first name" />
		</form:row>

		<form:row label="Last name" id="lastName" className="halfrow right" >
			<field:person_name xpath="${xpath}/surname" required="true" title="${title} last name" />
		</form:row>

		<core:clear />

		<form:row label="Date of birth">
			<field:person_dob xpath="${xpath}/dob" required="true" title="${dobTitle}" ageMin="16" ageMax="120" />
		</form:row>

		<form:row label="Gender" id="${name}_genderRow">
			<field:array_radio id="${name}_gender" xpath="${xpath}/gender" required="true" items="M=Male,F=Female" title="${title} gender" className="health-person-details person-gender" />
		</form:row>

		<c:if test="${id == 'partner'}">
			<form:row label="Would you like to give your partner authority to make claims, changes or enquire about the policy on behalf of anyone listed on the policy?" id="${name}_authority_group" className="health_person-details_authority_group" >
				<field:array_radio id="${name}_authority" xpath="${xpath}/authority" required="true" items="Y=Yes,N=No" title="${title} authority permission" className="health-person-details-authority" />
			</form:row>
		</c:if>

	</form:fieldset>

</div>

<go:script marker="onready">
	$(function() {
		$("#${name}_gender").buttonset();
	});

	<c:if test="${id == 'partner'}">
		$("#${name}_authority").buttonset();
	</c:if>

	slide_callbacks.register({
		direction:	"forward",
		slide_id:	3,
		callback: 	function() {
			$.validator.prototype.applyWindowListeners();
	<c:choose>
		<c:when test="${id == 'primary'}">
			var firstname = $("#${field_firstname}").val();
			var surname = $("#${field_surname}").val();
			var dob = $("#${field_dob}").val();

			if(!firstname.length) {
				$("#${field_firstname}").val( $("#health_contactDetails_firstName").val() );
			}

			if(!surname.length) {
				$("#${field_surname}").val( $("#health_contactDetails_lastname").val() );
			}

			if(!dob.length) {
				$("#${field_dob}").val( $("#health_healthCover_primary_dob").val() );
			}
		</c:when>
		<c:otherwise>
			var dob = $("#${field_dob}").val();

			if(!dob.length) {
				$("#${field_dob}").val( $("#health_healthCover_partner_dob").val() );
			}
		</c:otherwise>
	</c:choose>
		}
	});

	<%-- Add an error for changing the DOB --%>
	$('#${name}_dob').on('change', function(){
		healthPolicyDetails.error();
	});

	<%-- Reverse update the firstname/lastname in quote when changed --%>
<c:if test="${id == 'primary'}">
	$('#${field_firstname}').on('change', function(){
		if($(this).val() != '' && $('#${field_surname}').val() != '') {
			<%--TODO: add messaging framework
				meerkat.messaging.publish("CONTACT_DETAILS", {name : $(this).val() + " " + $('#${field_surname}').val()});
			--%>
			$(document).trigger("CONTACT_DETAILS", [{name : $(this).val() + " " + $('#${field_surname}').val()}]);
		} else if($('#${field_surname}').val() != '') {
			<%--TODO: add messaging framework
				meerkat.messaging.publish("CONTACT_DETAILS", {name : $('#${field_surname}').val()});
			--%>
			$(document).trigger("CONTACT_DETAILS", [{name : $('#${field_surname}').val()}]);
		} else if($(this).val() != '') {
			<%--TODO: add messaging framework
				meerkat.messaging.publish("CONTACT_DETAILS", {name : $(this).val()});
			--%>
			$(document).trigger("CONTACT_DETAILS", [{name : $(this).val()}]);
		}
		$("#health_contactDetails_firstName").val( firstName);
	});
	$('#${field_surname}').on('change', function(){
		var firstName = $('#${field_firstname}').val();
		var contactName = firstName;
		if(firstName != '' && $(this).val() != '') {
			var contactName = contactName + " " + $(this).val();
		} else if(lastName != '') {
			var contactName = $(this).val();
		}
		<%--TODO: add messaging framework
		meerkat.messaging.publish("CONTACT_DETAILS", {name : contactName});
		--%>
		$(document).trigger("CONTACT_DETAILS", [{name : contactName}]);
		<%--$("#health_contactDetails_lastname").val( lastName);--%>
	});
</c:if>


</go:script>
