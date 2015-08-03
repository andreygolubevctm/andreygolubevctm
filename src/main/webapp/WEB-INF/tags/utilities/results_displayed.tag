<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Results Displayed group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionEnabled" value="${competitionEnabledSetting == 'Y'}" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Your Contact Details">
		
		<form:row label="First name">
			<field:input xpath="${xpath}/firstName" required="false" title="your first name" />
		</form:row>
		
		<form:row label="Your email address">
			<field:contact_email xpath="${xpath}/email" required="false" title="your email address" />
		</form:row>

		<form:row label="Phone">
			<field:contact_telno xpath="${xpath}/phone" required="false" title="your phone number" />
		</form:row>

		<%-- COMPETITION START --%>
		<c:if test="${competitionEnabled == true}">
			<form:row label="" className="promo-row">
				<div class="promo-container">
					<div class="promo-image ${vertical}"></div>
					<c:set var="competitionCheckboxText"><content:get key="competitionCheckboxText" /></c:set>
					<field:checkbox xpath="${xpath}/competition/optin" value="Y" title=" ${competitionCheckboxText}" required="false" label="true"/>
					<field:hidden xpath="${xpath}/competition/previous" />
				</div>
			</form:row>
		</c:if>
		<%-- COMPETITION END--%>

		<%-- Mandatory agreement to privacy policy --%>
		<form:privacy_optin vertical="utilities" />

		<field:hidden xpath="${xpath}/optinPhone" defaultValue="N" />
		<field:hidden xpath="${xpath}/optinMarketing" defaultValue="N" />

	</form:fieldset>		

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name}{
		zoom: 1;
	}
	.fieldrow_value {
		max-width: 410px;
		margin-bottom: 10px;
	}
</go:style>


<%-- JAVASCRIPT --%>

<go:script marker="onready">
	$("#utilities_privacyoptin").on("click", function(event) {

		if ($(this).is(":checked")) {
			$("#utilities_resultsDisplayed_optinPhone").val('Y');
			$("#utilities_resultsDisplayed_optinMarketing").val('Y');
		} else {
			$("#utilities_resultsDisplayed_optinPhone").val('N');
			$("#utilities_resultsDisplayed_optinMarketing").val('N');
		}
	});

	<c:if test="${competitionEnabled eq true}">
	$('#utilities_resultsDisplayed_competition_optin[type="checkbox"]').on('change', function(e){
		if(this.checked) {
			<%--
				Opt In -- Unset phone number as mandatory field
			--%>
			$('#utilities_resultsDisplayed_firstName').attr('required', 'required').addClass('state-force-validate');
			$('#utilities_resultsDisplayed_email').attr('required', 'required').addClass('state-force-validate');
			$('#utilities_resultsDisplayed_phoneinput').attr('required', 'required').addClass('state-force-validate');
		} else {
			<%--
				Opt Out -- Unset phone number as mandatory field
			--%>
			$('#utilities_resultsDisplayed_firstName').attr('required', false).removeClass('error');
			$('#mainform').validate().element('#utilities_resultsDisplayed_firstName');

			$('#utilities_resultsDisplayed_email').attr('required', false).removeClass('error');
			$('#mainform').validate().element('#utilities_resultsDisplayed_email');

			$('#utilities_resultsDisplayed_phoneinput').attr('required', false).removeClass('error');
			$('#mainform').validate().element('#utilities_resultsDisplayed_phoneinput');
		}
	});
</c:if>
</go:script>


<%-- VALIDATION --%>
