<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Things to know group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">

	<div id="${name}_template_placeholder"></div>
	<core:js_template id="things-to-know-template">

		<form:fieldset legend="Things you need to know" className="no-background-color"  id="${name}_fieldset">

			<c:set var="switchwiseTermsAndConditions">
				<a href="javascript:showDoc('http://www.switchwise.com.au/terms-conditions/', 'Switchwise Terms and Conditions')">Switchwise's Terms and Conditions</a>
			</c:set>
			<c:set var="switchwisePrivacyPolicy">
				<a href="javascript:showDoc('http://www.switchwise.com.au/privacy/', 'Switchwise Privacy Policy')">Switchwise's Privacy Policy</a>
			</c:set>
			<field:checkbox
				xpath="${xpath}/switchwiseTermsAndConditions"
				value="Y"
				title="<span class='asterisk'>*</span> I understand that <strong>compare</strong>the<strong>market</strong>.com.au is collecting my personal data on behalf of Switchwise and that my personal data will be provided to Switchwise and its third parties for the purposes of 'switching'. I have read, understand and accept ${switchwiseTermsAndConditions} and ${switchwisePrivacyPolicy}."
				required="true"
				errorMsg="Please agree to Switchwise's Terms and Conditions and Privacy Policy"
				label="true" />

			<c:set var="transferTitle">
				<span id="${name}_transferChkMoveInTitle">
					<span class='asterisk'>*</span> I understand and agree that if my application is approved my [#= selected_utilities #] will be connected with [#= provider_name #] and a connection fee for each fuel type will be included on my first bill.
				</span>
				<span id="${name}_transferChkTransferTitle">
					<span class='asterisk'>*</span> I understand and agree that if my application is approved my [#= selected_utilities #] will be transferred to [#= provider_name #] as of my next meter read date unless I am already a customer of [#= provider_name #].
				</span>
			</c:set>
			<field:checkbox
				xpath="${xpath}/transfer"
				value="Y"
				title="${transferTitle}"
				required="true"
				errorMsg="Please agree that the supplier is entitled to proceed with the transfer/connection"
				label="true" />

			<field:checkbox
				xpath="${xpath}/rateChange"
				value="Y"
				title="<span class='asterisk'>*</span> I understand and agree that if my application is approved [#= provider_name #] can vary my rates, tariff structure, billing frequency and the terms of the energy plan at any time provided that [#= provider_name #] provide me with written notice of such variation."
				required="true"
				errorMsg="Please acknowledge that the supplier can vary rates, tariff structure and billing frequency"
				label="true" />

			<c:set var="providerTermsAndConditions">
				<a href="javascript:utilitiesThingsToKnow.openProviderTermsAndConditionsDialog()" id="${name}_provider_t_and_c">[#= provider_name #]'s Terms and Conditions</a>
			</c:set>
			<field:checkbox
				xpath="${xpath}/providerTermsAndConditions"
				value="Y"
				title="<span class='asterisk'>*</span> I have read, understand and accept ${providerTermsAndConditions}."
				required="true"
				errorMsg="Please agree to the supplier's Terms and Conditions"
				label="true" />

			<field:checkbox
				xpath="${xpath}/receiveInfo"
				value="Y"
				title="I would like to receive electronic communication from <strong>compare</strong>the<strong>market</strong>.com.au and [#= provider_name #] from time to time."
				required="false"
				label="true" />

		</form:fieldset>

	</core:js_template>

	<c:set var="css">
		.${name}_providerTermsAndConditionsPopupDialogContainer ul li{
			list-style-image: url(brand/ctm/images/bullet_edit.png);
			list-style-position: outside;
			margin: 0 0 0.6em 14px;
		}
	</c:set>
	<ui:dialog
		id="${name}_providerTermsAndConditionsPopup"
		title="<span class='supplierName'></span>Documentation"
		width="500"
		extraCss="${css}" />

	<field:hidden xpath="${xpath}/hidden/productId" />
	<field:hidden xpath="${xpath}/hidden/searchId" />

	<%-- some flags to use in the XSL outbound --%>
	<field:hidden xpath="${xpath}/hidden/identificationRequired" />
	<field:hidden xpath="${xpath}/hidden/isPowerOnRequired" />
	<field:hidden xpath="${xpath}/hidden/directDebitRequired" />
	<field:hidden xpath="${xpath}/hidden/paymentSmoothingRequired" />
	<field:hidden xpath="${xpath}/hidden/electronicBillRequired" />
	<field:hidden xpath="${xpath}/hidden/electronicCommunicationRequired" />
	<field:hidden xpath="${xpath}/hidden/billDeliveryMethodRequired" />

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} label{
		display: block;
		margin-left: 25px;
		padding-bottom: 15px;
		line-height: 19px;
	}
	#${name} input[type="checkbox"]{
		float: left;
	}
	#${name} label a{
		font-size: 100%;
	}
	.asterisk {
		color: red;
		font-size: 16px;
		font-weight: bold;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var utilitiesThingsToKnow = {
		init: function(){

		},

		openProviderTermsAndConditionsDialog: function(){
			var provider = utilitiesChoices._product.provider;
			var possession = provider.substring(provider.length-1, provider.length) == "s" ? "' " : "'s ";
			$(".supplierName").html(provider + possession);
			$("#${name}_providerTermsAndConditionsPopupDialog").html( $("#aol-documentation ul").clone() );
			${name}_providerTermsAndConditionsPopupDialog.open();
		}
	};
</go:script>

<go:script marker="onready">

	utilitiesThingsToKnow.init();

</go:script>

<%-- VALIDATION --%>
