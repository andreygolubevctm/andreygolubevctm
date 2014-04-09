<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment: credit card / bank details popup"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-content" data-provide="paymentGateway" class="${name}-launchers ${name}-credit ${name}">
		
	<div class="success alert alert-success">
		Thank you for registering your credit card details with Westpac.
	</div>
	
	<div class="fail alert alert-danger">
		We were unable to register your credit card details. Please try again or call us <strong>1800 77 77 12</strong>.
	</div>

	<p class="launcher">
		We now need to register your credit card through Westpac in order to process your payment.
		Please be assured that your personal and financial information is treated as highly confidential and stored in accordance with data protection 	regulations.
	</p>
	
	<p class="launcher row-content">
		<button data-gateway="launcher" type="button" class="btn btn-primary btn-lg">Register your credit card details</button>
	</p>

	<field_new:validatedHiddenField xpath="${xpath}-registered" validationErrorPlacementSelector="button[data-gateway='launcher']:visible" />
	<input type="hidden" id="${name}_number" name="${name}_number" value="" />
	<input type="hidden" id="${name}_type" name="${name}_type" value="" />
	<input type="hidden" id="${name}_expiry" name="${name}_expiry" value="" />
	<input type="hidden" id="${name}_name" name="${name}_name" value="" />
	
</div>


