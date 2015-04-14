<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="now" class="java.util.Date" scope="request" />

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the select box"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%--CSS --%>
<go:style marker="css-head">
	.atCurrentAddress,
	.pastInsurer,
	.insuranceExpiry,
	.insuranceCoverLength,
	.refusal,
	.claimNumber,
	.criminalOffenceNumber{
		display: none;
	}
</go:style>

<%-- HTML --%>
<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">

		<form:row label="Have you had home and/or contents insurance in the last 5 years?">
			<field:array_radio xpath="${xpath}/previousInsurance"
				required="true"
				items="Y=Yes,N=No"
				className="pretty_buttons"
				title="if you have had insurance in the last 5 years"/>
		</form:row>

		<div class="atCurrentAddress">
			<form:row label="Was the insurance policy for the same address as this quote?">
				<field:array_radio xpath="${xpath}/atCurrentAddress"
					required="true"
					items="Y=Yes,N=No"
					className="pretty_buttons"
					title="if the insurance was for this address"/>
			</form:row>
		</div>

		<div class="pastInsurer">
			<form:row label="Who was the insurance with?">
				<field:import_select xpath="${xpath}/insurer"
					className="insurance_companies"
					url="/WEB-INF/option_data/home_contents_insurers.html"
					title = "who the insurance policy was with"
					required="true" />
			</form:row>
		</div>

		<div class="insuranceExpiry">
			<form:row label="Expiry date of the policy">
				<field:basic_date
					xpath="${xpath}/expiry"
					required="true"
					minDate="-5y"
					maxDate="+1y"
					title="the expiry date of the previous insurance policy" />
			</form:row>
		</div>

		<div class="insuranceCoverLength">
			<form:row label="How long have you had the insurance?">
				<field:import_select xpath="${xpath}/coverLength"
					className="coverLength"
					url="/WEB-INF/option_data/home_contents_past_insurance_duration.html"
					title = "how long you have had the insurance"
					required="true" />
			</form:row>
		</div>

		<hr/>

		<form:row label="In the last 5 years, have you or any other household member had any thefts, burglaries or made any insurance claims for home and/or contents?" id="${name}_claimsRow">
			<field:array_radio xpath="${xpath}/claims"
				required="true"
				className="pretty_buttons"
				items="Y=Yes,N=No"
				title="if the policy holder, or any other household member has had any thefts, burglaries or has made any home and/or contents insurance claims in the last 5 years." />
		</form:row>

<!-- 		<div class="claimNumber"> -->
<%-- 			<form:row label="How many claims?"> --%>
<%-- 				<field:array_select xpath="${xpath}/claimNumber" --%>
<%-- 					items="=Please select...,1=1,2=2,3=3,4=4,5=5+" --%>
<%-- 					title = "the number of claims that have been made" --%>
<%-- 					required="true" /> --%>
<%-- 			</form:row> --%>
<!-- 		</div> -->

			<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY GREENSTONE & CALLIDEN --%>
<%-- 		<hr/> --%>

<%-- 		<form:row label="Has an insurance company cancelled or refused to renew your insurance in the last 5 years?"> --%>
<%-- 			<field:array_radio xpath="${xpath}/insuranceRefusal" --%>
<%-- 				required="true" --%>
<%-- 				className="pretty_buttons" --%>
<%-- 				items="Y=Yes,N=No" --%>
<%-- 				title="if an insurance company cancelled or refused to renew your insurance in the last 5 years" /> --%>
<%-- 				Should be 10 years for Youi. Should we only worry about them the day they come on board? --%>
<%-- 		</form:row> --%>

<%-- 		<div class="refusal"> --%>
<%-- 			<form:row label="For which reason?"> --%>
<%-- 				<field:import_select --%>
<%-- 					xpath="${xpath}/refusalReason" --%>
<%-- 					url="/WEB-INF/option_data/home_refusal_reasons.html" --%>
<%-- 					title = "the reason for which the insurance company cancelled or refused to renew your policy" --%>
<%-- 					required="true" /> --%>
<%-- 			</form:row> --%>

<%-- 			<form:row label="Which insurance company cancelled or refused to renew your insurance?"> --%>
<%-- 				<field:import_select xpath="${xpath}/refusalInsurer" --%>
<%-- 					className="insurance_companies" --%>
<%-- 					url="/WEB-INF/option_data/home_contents_insurers.html" --%>
<%-- 					title = "the insurance company that cancelled or refused to renew your policy" --%>
<%-- 					required="true" /> --%>
<%-- 			</form:row> --%>

<%-- 			<c:set var="currentYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set> --%>
<%-- 			<form:row label="What year was this?"> --%>
<%-- 				<field:array_select xpath="${xpath}/refusalYear" --%>
<%-- 					title ="the year an insurance company cancelled or refused to renew your policy" --%>
<%-- 					items="=Please Select...,${currentYear}=${currentYear},${currentYear-1}=${currentYear-1},${currentYear-2}=${currentYear-2},${currentYear-3}=${currentYear-3},${currentYear-4}=${currentYear-4},${currentYear-5}=${currentYear-5}" --%>
<%-- 					required="true" /> --%>
<%-- 			</form:row> --%>

<%-- 		</div> --%>

<%-- 		<hr/> --%>

<%-- 		<form:row label="Have you or anyone named insured ever had a claim denied?"> --%>
<%-- 			<field:array_radio xpath="${xpath}/deniedClaim" --%>
<%-- 				required="true" --%>
<%-- 				className="pretty_buttons" --%>
<%-- 				items="Y=Yes,N=No" --%>
<%-- 				title="if you or anyone named insured ever had a claim denied" /> --%>
<%-- 		</form:row> --%>

<%-- 		<hr/> --%>

<%-- 		<form:row label="Have you been convicted of a criminal offence?"> --%>
<%-- 			<field:array_radio xpath="${xpath}/criminalOffence" --%>
<%-- 				required="true" --%>
<%-- 				className="pretty_buttons" --%>
<%-- 				items="Y=Yes,N=No" --%>
<%-- 				title="if you have been convicted of a criminal offence" /> --%>
<%-- 		</form:row> --%>

<%-- 		<div class="criminalOffenceNumber"> --%>
<%-- 			<form:row label="How many times have you been convicted?"> --%>
<%-- 				<field:array_select xpath="${xpath}/criminalOffenceNumber" --%>
<%-- 					items="=Please select...,1=1,2=2,3=3,4=4,5=5+" --%>
<%-- 					title = "how many times you have been convicted" --%>
<%-- 					required="true" /> --%>
<%-- 			</form:row> --%>
<%-- 		</div> --%>

<%-- 		<core:clear /> --%>
	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var InsuranceInformation = new Object();
	InsuranceInformation = {

		init: function(){

<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY GREENSTONE & CALLIDEN --%>
<%-- 			$('input[name=${name}_claims]').on('change', function(){ --%>
<!-- 				InsuranceInformation.toggleClaimNumber(); -->
<!-- 			}); -->
<%-- 			$('input[name=${name}_insuranceRefusal]').on('change', function(){ --%>
<%-- 				InsuranceInformation.toggleRefusal(); --%>
<%-- 			}); --%>

<%-- 			$('input[name=${name}_criminalOffence]').on('change', function(){ --%>
<%-- 				InsuranceInformation.toggleCriminalOffenceNumber(); --%>
<%-- 			}); --%>

			$('input[name=${name}_previousInsurance]').on('change', function(){

				if( $('input[name=${name}_previousInsurance]:checked').val() == 'Y' ){
					$('.atCurrentAddress').slideDown();
					$('.pastInsurer').slideDown();
					$('.insuranceExpiry').slideDown();
					$('.insuranceCoverLength').slideDown();
				} else {
					$('.atCurrentAddress').slideUp();
					$('.pastInsurer').slideUp();
					$('.insuranceExpiry').slideUp();
					$('.insuranceCoverLength').slideUp();
				}
			});

			$('input[name=${name}_previousInsurance]').trigger("change");
			<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY GREENSTONE & CALLIDEN --%>
<!-- 			InsuranceInformation.toggleClaimNumber(); -->
<%-- 			InsuranceInformation.toggleRefusal(); --%>
<%-- 			InsuranceInformation.toggleCriminalOffenceNumber(); --%>

		},

<!-- 		toggleClaimNumber: function(){ -->

<%-- 			if( $('input[name=${name}_claims]:checked').val() == "Y" ){ --%>
<!-- 				$('.claimNumber').slideDown(); -->
<!-- 			} else { -->
<!-- 				$('.claimNumber').slideUp(); -->
<!-- 			} -->

<!-- 		}, -->

<%-- 		toggleRefusal: function(){ --%>

<%-- 			if( $('input[name=${name}_insuranceRefusal]:checked').val() == "Y" ){ --%>
<%-- 				$('.refusal').slideDown(); --%>
<%-- 			} else { --%>
<%-- 				$('.refusal').slideUp(); --%>
<%-- 			} --%>

<%-- 		}, --%>

<%-- 		toggleCriminalOffenceNumber: function(){ --%>

<%-- 			if( $('input[name=${name}_criminalOffence]:checked').val() == "Y" ){ --%>
<%-- 				$('.criminalOffenceNumber').slideDown(); --%>
<%-- 			} else { --%>
<%-- 				$('.criminalOffenceNumber').slideUp(); --%>
<%-- 			} --%>

<%-- 		} --%>

	};
</go:script>

<go:script marker="onready">
	InsuranceInformation.init();
</go:script>