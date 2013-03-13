<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<form:fieldset legend="Info about where is the car parked at night">
	<group:address xpath="quote/riskAddress" type="R" />
</form:fieldset>

<form:fieldset legend="Policy Holder contact details">

		<form:row label="First name" id="firstName">
			<field:person_name xpath="quote/drivers/regular/firstname"
				required="false" title="the policy holder's first name" />
		</form:row>

		<form:row label="Last name" id="lastName">
			<field:person_name xpath="quote/drivers/regular/surname"
				required="false" title="the policy holder's last name" />
		</form:row>

	<form:row label="Email Address">
		<field:contact_email xpath="quote/contact/email" required="true" title="the policy holder's email address" />
	</form:row>
	<form:row label="Please keep me informed via email of news and other offers" id="marketingRow">
		<field:array_radio xpath="quote/contact/marketing" required="true"
			className="marketing" id="marketing" items="Y=Yes,N=No"
			title="if you would like to be informed via email of news and other offers" />
	</form:row>
	<form:row label="Best contact number" helpId="20" id="contactNoRow">
		<field:contact_telno xpath="quote/contact/phone" required="false" id="bestNumber"
			className="bestNumber" title="the best number for the insurance provider to contact you on (You will only be contacted by phone if you answer 'Yes' to the 'OK to call' question on this screen)"/>
	</form:row>
	<form:row label="OK to call" id="oktocallRow">
		<field:array_radio xpath="quote/contact/oktocall" required="true"
			className="oktocall" id="oktocall" items="Y=Yes,N=No"
			title="if it's OK to call the policy holder regarding the lowest price quote" />
	</form:row>
</form:fieldset>

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
</go:style>

<%-- VALIDATION --%>
<go:validate selector="quote_contact_phone" rule="okToCall" parm="true" message="Please enter the best number for the insurance provider to contact you on"/>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#marketing, #oktocall").buttonset();
		$("#marketing").append("<span id='emailOfferText'>I agree to receive news & offer emails from Compare the Market & the insurance provider that presents the lowest price.</span>");
		$("#oktocall").append("<span id='oktocallText'>I give permission for the insurance provider that presents the lowest price to call me within the next 2 business days to discuss my car insurance needs.</span>");
	});

</go:script>






