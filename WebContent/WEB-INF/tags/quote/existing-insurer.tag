<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 			required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 				required="false"  rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="xpath" 				required="true"   rtexprvalue="true"	 description="the xpath for this widget"%>
<%@ attribute name="productCategories" 	required="true"   rtexprvalue="false"	 description="the product categories (delimited by ,) for which to look for the providers"%>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<form:fieldset legend="Tell us about your current insurance to see how it compares:">

	<form:row label="Do you have comprehensive car insurance?">
		<field:array_radio
			items="Y=Yes,N=No"
			className="button_set"
			xpath="${xpath}/existingInsurer/hasCurrentInsurer" title=""
			required="false"
			defaultValue="N"></field:array_radio>
	</form:row>
	<div id="${name}_currentProvider_row">
		<form:row label="Please select your current insurer?">
			<field:provider_select xpath="${xpath}/existingInsurer/provider"
								required="false"
								productCategories="${productCategories}" />
		</form:row>
		<form:row label="What is your current annual/monthly insurance ">
			<field:array_select items="A=Annual,M=Monthly"
								xpath="${xpath}/existingInsurer/premium/frequency" title=""
								required="false" />
			<field:currency xpath="${xpath}/existingInsurer/premium/amount"
								required="false" title=""/>
		</form:row>
	</div>
</form:fieldset>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="onready">

	var currentValue= "${value.existingInsurer.premium.amount}";

	/**
	 * CAR-269: When they are ready to use conditional validation for
	 * current insurer, just un-comment the below rules. Enjoy.
	 **/

	if('${value.existingInsurer.hasCurrentInsurer}' == 'Y') {
		$('#${name}_currentProvider_row').show();
		/*
		$("#${name}_existingInsurer_premium_amount").rules("add", {required: true});
		$("#${name}_existingInsurer_provider").rules("add", {required: true});
		$("#${name}_existingInsurer_premium_amountentry").rules("add", {required: true});
		*/
	} else {
		$('#${name}_currentProvider_row').hide();
		/*
		$("#${name}_existingInsurer_premium_amount").rules("add", {required: false});
		$("#${name}_existingInsurer_provider").rules("add", {required: false});
		$("#${name}_existingInsurer_premium_amountentry").rules("add", {required: false});
		*/
	}

	$('input[name=${name}_existingInsurer_hasCurrentInsurer]:radio').on('change', function(){
		var checked = Fields.handleToggleOnChecked("#${name}_existingInsurer_hasCurrentInsurer_Y" , '#${name}_currentProvider_row');
		if(checked) {
			$("#${name}_existingInsurer_premium_amount").val(currentValue);//.rules("add", {required: true});
			//$("#${name}_existingInsurer_provider").rules("add", {required: true});
			addInCurrentInsurer();
		} else {
			currentValue = $("#quote_existingInsurer_premium_amount").val();
			$("#${name}_existingInsurer_premium_amount").val("");//.rules("add", {required: false});
			//$("#${name}_existingInsurer_provider").rules("add", {required: false});
			CarResults.removeCurrentProduct();
		}
	});

	function addInCurrentInsurer() {
		var providerId = $("#${name}_existingInsurer_provider :selected").val();
		var providerName = $("#${name}_existingInsurer_provider :selected").text();
		var frequency = $("#${name}_existingInsurer_premium_frequency :selected").val();
		var price = $("#${name}_existingInsurer_premium_amountentry").val().replace(/[^\d.-]/g, '');

		if( providerId && providerId != '' && frequency && frequency != '' && price && price != '' && !isNaN(price) ){
			CarResults.addCurrentProduct( providerId, providerName, frequency, price );
		} else {
			CarResults.removeCurrentProduct();
		}
	}

	$("#${name}_existingInsurer_provider, #${name}_existingInsurer_premium_frequency, #${name}_existingInsurer_premium_amountentry").on("change", function(){
		addInCurrentInsurer();
	});

</go:script>