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


		<form:fieldset legend="Terms and Conditions" className="no-background-color"  id="${name}_fieldset">
			<p>
			<field:checkbox
				xpath="${xpath}/termsAndConditions"
				value="Y"
				title="To process the offer and apply the discounts to your account you should read and should ensure you understand and agree to the following information:"
				required="true"
				label="true" />
			</p>
			<div id="termsConditions"></div>

		</form:fieldset>



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
	<field:hidden xpath="${xpath}/receiveInfo" />
	<field:hidden xpath="${xpath}/hidden/searchId" />

	<%-- some flags to use in the XSL outbound --%>

</div>

<core:js_template id="terms-template">
<p>You have the right to a 10 day cooling off period (COP). This cooling off period begins on the date your agreement commences. You may cancel your agreement by contacting us at any time during the COP without penalty. Your Agreement commences with [#= retailerName #] when you give your verbal acceptance and receive the Confirmation Pack, which will include the full terms and conditions of the Energy Agreement.</p>
<p>[#= retailerName #] will send you a Welcome Pack containing written confirmation of the energy offer accepted, the Energy Agreement and Customer Charter. You may terminate the agreement at any time by contacting [#= retailerName #]. You may be liable for termination fees with your existing provider if you are under contract with them.</p>
<p>By accepting the Energy Offer from [#= retailerName #], you authorise us to create a new account and collect, maintain, use and disclose personal information as set out in the Privacy Statement detailed in the Energy Agreement we will send you. You give your explicit informed consent that your tariff and or discount can change from time to time, in line with the relevant code or guideline, including government price increases. If the tariff and or discount do change you will be notified on your next bill or as required by the code or guideline for your area. You give your explicit informed consent that we may bill you quarterly for electricity and bi-monthly for gas unless you have chosen a monthly billed product.</p>
<p>You accept the terms and conditions mentioned above and you consent to entering into an agreement with [#= retailerName #] on those terms and conditions. You understand and accept that you are accepting an agreement for: [#= planName #] </p>
</core:js_template>


<%-- CSS --%>
<go:style marker="css-head">

	#termsConditions{
		padding-left:25px;
		padding-right:25px;
	}

	

	#${name} label{
		display: block;
		margin-left: 25px;
		font-weight:bold;
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
