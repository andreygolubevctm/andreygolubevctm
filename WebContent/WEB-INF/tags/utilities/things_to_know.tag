<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Things to know group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


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
				<a href="javascript:void(0);" class="showDoc" data-url="http://www.switchwise.com.au/terms-conditions/" data-title="Switchwise Terms and Conditions">Switchwise's Terms and Conditions</a>
			</c:set>
			<c:set var="switchwisePrivacyPolicy">
				<a href="javascript:void(0);" class="showDoc" data-url="http://www.switchwise.com.au/privacy/" data-title="Switchwise Privacy Policy">Switchwise's Privacy Policy</a>
			</c:set>
			<field:checkbox
				xpath="${xpath}/switchwiseTermsAndConditions"
				value="Y"
				title="<span class='asterisk'>*</span> I understand that <strong>compare</strong>the<strong>market</strong>.com.au is collecting my personal data on behalf of Switchwise and that my personal data will be provided to Switchwise and its third parties for the purposes of 'switching'. I have read, understand and accept ${switchwiseTermsAndConditions} and ${switchwisePrivacyPolicy}."
				required="true"
				errorMsg="Please agree to Switchwise's Terms and Conditions and Privacy Policy"
				label="true" />

			<field:checkbox
				xpath="${xpath}/providerTermsAndConditions"
				value="Y"
				title="<span class='asterisk'>*</span> I understand and agree that:"
				required="true"
				errorMsg="Please agree to the provider's Terms and conditions"
				label="true" />

			<c:set var="providerTermsAndConditions">
				<a class="openProviderTermsAndConditionsDialog" href="javascript:void(0);" id="${name}_provider_t_and_c">[#= provider_name #]'s Terms and Conditions</a>
			</c:set>

			<ul id="providerTermsAndConditionsBullets">
				<li>I have read, understand and accept ${providerTermsAndConditions}. I understand and accept that [#= provider_name #] will perform a credit check in assessing my application.</li>
				<li>[#= provider_name #] may contact me if any additional information is required. If my application is approved my [#= selected_utilities #] will be transferred to [#= provider_name #] as of my next meter read date.</li>
				<li>[#= provider_name #] can vary my rates, tariff structure, billing frequency and the terms of the energy plan at any time by writing to me.</li>
			</ul>

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
	#providerTermsAndConditionsBullets {
		padding-left: 50px;
		list-style: disc;
		line-height: 19px;
	}
		#providerTermsAndConditionsBullets li {
			padding-bottom: 15px;
		}
		#providerTermsAndConditionsBullets a {
			font-size: 100%;
		}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	$('.openProviderTermsAndConditionsDialog').live('click',function(){

			var provider = utilitiesChoices._product.provider;
			var possession = provider.substring(provider.length-1, provider.length) == "s" ? "' " : "'s ";
			$(".supplierName").html(provider + possession);
			$("#${name}_providerTermsAndConditionsPopupDialog").html( $("#aol-documentation ul").clone() );
			${name}_providerTermsAndConditionsPopupDialog.open();


	})
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
