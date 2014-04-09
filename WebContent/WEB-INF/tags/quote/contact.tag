<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<form:fieldset legend="Where is the car parked at night">
	<group:address xpath="quote/riskAddress" type="" />
</form:fieldset>


<form:fieldset legend="Policy Holder contact details">

		<form:row label="First name" id="firstName">
			<field:person_name xpath="quote/drivers/regular/firstname"
				required="false" title="the policy holder's first name" />

			<span class="floatSecondField">Surname</span>
			<field:person_name xpath="quote/drivers/regular/surname"
				required="false" title="the policy holder's last name" />
		</form:row>

	<form:row label="Email Address">
		<field:contact_email xpath="quote/contact/email" required="false" title="the policy holder's email address" helptext="If you want us to send you a copy of your quote" />
	</form:row>


	<form:row label="OK to email" id="marketingRow">
		<field:array_radio xpath="quote/contact/marketing" required="true"
			className="marketing" id="marketing" items="Y=Yes,N=No"
			title="if you would like to be informed via email of news and other offers" />
	</form:row>
	<form:row label="Best contact number" helpId="20" id="contactNoRow">
		<field:contact_telno xpath="quote/contact/phone" required="false" id="bestNumber"
			className="bestNumber"
			labelName="best number"
			title="The best number for the insurance provider to contact you on (You will only be contacted by phone if you answer 'Yes' to the 'OK to call' question on this screen)" />
	</form:row>
	<form:row label="OK to call" id="oktocallRow">
		<field:array_radio xpath="quote/contact/oktocall" required="true"
			className="oktocall" id="oktocall" items="Y=Yes,N=No"
			title="if it's OK to call the policy holder regarding the lowest price quote" />
	</form:row>

	<%-- Mandatory agreement to privacy policy --%>
	<form:privacy_optin vertical="quote" />

</form:fieldset>

<%-- VALIDATION --%>
<go:validate selector="quote_contact_phoneinput" rule="okToCall" parm="true" message="Please enter the best number for the insurance provider to contact you on"/>
<go:validate selector="quote_contact_email" rule="marketing" parm="true" message="Please enter the policy holder's email address"/>

<go:style marker="css-head">

	#oktocallText, #emailOfferText {
		font-size: 11px;
		width: 210px;
		text-align: left;
		color: #808080;
		margin-left: 10px;
		position: absolute;
		right:0px;
		top:0px;
	}
	#emailOfferText {
		position: absolute;
	}
	#oktocallRow {
		height: 100px;
	}
	#bestNumber_row_legend {
		color: #808080;
		margin-top: 5px;
	}
	#contactTelText {
		float: right;
		clear: both;
	}
	#oktocallRow {
		height:57px;
	}
	#marketingRow {
		height:35px;
	}
	#quote_contact_email {
		width:302px;
	}
	.floatSecondField {
		margin-left: 21px;
		margin-right: 5px;
		font-size: 13px;
		color: #393939;
	}
	#quote_drivers_regular_firstname {
		width: 95px;
	}
	#quote_drivers_regular_surname	{
		width: 95px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#marketing, #oktocall").buttonset();
		$("#marketing").append("<span id='emailOfferText'>I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.</span>");
		$("#oktocall").append("<span id='oktocallText'>I give permission for the insurance provider that presents the lowest price to call me within the next 2 business days to discuss my car insurance needs.</span>");
	});

	$('#quote_contact_marketing_Y, #quote_contact_marketing_N').change(function() {
		var optIn = false
		if($(this).val() == 'Y') {
			optIn = true;
		}
		//$(document).trigger(SaveQuote.setMarketingEvent, [optIn, $('#quote_contact_email').val()]);
		QuoteEngine.validate();
	});

	$('#quote_contact_oktocall_Y, #quote_contact_oktocall_N').change(function() {
		QuoteEngine.validate();
	});

	$('#quote_contact_email').change(function() {
		var optIn = false
		if($('#quote_contact_marketing_Y').val() == 'Y') {
			optIn = true;
		}
		//$(document).trigger(SaveQuote.setMarketingEvent, [optIn, $(this).val()]);
	});
</go:script>






