<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>
<%-- HTML --%>

	<form:row label="First name" id="enquirerName">
		<field:person_name xpath="travel/firstName" required="false" title="the enquirer's first name" />
		<span class="floatSecondField">Surname</span>
		<field:person_name xpath="travel/surname" required="false" title="the enquirer's last name" />
	</form:row>

	<form:row label="Email address" id="emailRow">
		<field:contact_email xpath="travel/email" required="false" title="the enquirer's email address" className="emailAddy" />
		<span id='emailOfferText'>For confirming quote and transaction details.</span>
	</form:row>

	<form:row label="" id="marketingRow">
			<field:checkbox xpath="travel/marketing" value="Y" required="false" label="true"
				title="I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" />

		<!--
		This is how to do it if they ever request the green Yes / No buttons :D
		<field:array_radio xpath="travel/marketing" required="false" className="marketing_buttons" id="marketing_buttons"
			items="Y=Yes,N=No" title="if you would like to be informed via email of news and other offers" />
		-->
	</form:row>

	<%-- Mandatory agreement to privacy policy --%>
	<form:privacy_optin vertical="travel" />


<%-- CSS --%>

<go:style marker="css-head">
	#emailOfferText {
		position: absolute;
		width: 110px;
		text-align: left;
		right: 0px;
		top: 5px;
		color: #555;
		font-size: 10px;
	}

	.floatSecondField {
		margin-left: 21px;
		margin-right: 5px;
		font-size: 13px;
		color: #393939;
	}

	label[for=travel_marketing] {
		color: #777;
	}
	#travel_firstName {
		width: 95px;
	}
	#travel_surname	{
		width: 95px;
	}
	#travel_email {
		width: 280px;
	}
</go:style>
