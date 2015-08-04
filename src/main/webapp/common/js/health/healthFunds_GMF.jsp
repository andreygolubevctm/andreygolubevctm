<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<session:get settings="true" />
<settings:setVertical verticalCode="HEALTH" />

<%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand). --%>
<c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
<c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
<c:if test="${fn:endsWith(hostOrigin, '/')}">
	<c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
</c:if>

<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
GMF
=======================
--%>
var healthFunds_GMF = {
	set: function () {

		<%-- Inject CSS --%>
		<c:set var="html">
			<style type="text/css">

				body.GMF .health_dependant_details_schoolGroup {
					display:none !important;
				}

			</style>
		</c:set>

		$('head').append('<c:out value="${html}" escapeXml="false" />');
	<%-- dependant definition --%>
		healthFunds._dependants('This policy provides cover for your children up to their 21st birthday. Dependants aged under 25 may also be added to the policy provided they are not married or in a defacto relationship and earn less than $20,500 p/annum. Adult dependants outside these criteria can still be covered by applying for a separate policy.');

		<%-- schoolgroups and defacto --%>
		healthDependents.config = { 'school': false, 'defacto': true, 'defactoMin': 21, 'defactoMax': 24 };

		<%-- fund ID's become optional --%>
		$('#clientMemberID input').rules("remove", "required");
		$('#partnerMemberID input').rules("remove", "required");

		<%-- medicare message - once a medicare number has been added - show the message (or if prefilled show the message) --%>
		healthFunds_GMF.$_medicareMessage = $('#health_medicareDetails_message');
		healthFunds_GMF.$_medicareMessage.text('GMF will send you an email shortly so that your rebate can be applied to the premium');
			<%-- check if filled or bind --%>
			if( healthFunds_GMF.$_medicareMessage.siblings('input').val() !== '' ) {
				healthFunds_GMF.$_medicareMessage.fadeIn();
			} else {
				healthFunds_GMF.$_medicareMessage.hide();
				healthFunds_GMF.$_medicareMessage.siblings('input').on('change.GMF', function () {
					<%-- FIX: REFINE: check for validity once medicare validation created --%>
					if( $(this).val() !== '' ) {
						healthFunds_GMF.$_medicareMessage.fadeIn();
					}
				});
			}

		<%-- credit card & bank account frequency & day frequency --%>
		meerkat.modules.healthPaymentStep.overrideSettings('bank', { 'weekly': false, 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': false, 'annually': true });
		meerkat.modules.healthPaymentStep.overrideSettings('credit', { 'weekly': false, 'fortnightly': true, 'monthly': true, 'quarterly': true, 'halfyearly': false, 'annually': true });
		meerkat.modules.healthPaymentStep.overrideSettings('frequency', { 'weekly': 28, 'fortnightly': 28, 'monthly': 28, 'quarterly': 28, 'halfyearly': 28, 'annually': 28 });

		<%-- claims account --%>
		meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions',true);

		<%-- credit card options --%>
		creditCardDetails.config = { 'visa':true, 'mc':true, 'amex': false, 'diners': false };
		creditCardDetails.render();

		$('.health-credit_card_details .fieldrow').hide();
		meerkat.modules.paymentGateway.setup({
			"paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
			"name" : 'health_payment_gateway',
			"src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
			"origin": '${hostOrigin}', <%-- the CTM host origin --%>
			"providerCode":'gmf',
			"brandCode": '${pageSettings.getBrandCode()}',
			"handledType" :  {
				"credit" : true,
				"bank" : false
			},
			"paymentTypeSelector" : $("input[name='health_payment_details_type']:checked"),
			"clearValidationSelectors" : $('#health_payment_details_frequency, #health_payment_details_start ,#health_payment_details_type'),
			"getSelectedPaymentMethod" :  meerkat.modules.healthPaymentStep.getSelectedPaymentMethod
		});
	},
	unset: function () {
		$('[data-provide="paymentGateway"]').unbind( "click" );
		healthFunds._reset();

		<%-- dependant definition off --%>
		healthFunds._dependants(false);

		<%-- medicare message --%>
		healthFunds_GMF.$_medicareMessage.text('').hide();
		healthFunds_GMF.$_medicareMessage.siblings('input').unbind('change.GMF');
		delete healthFunds_GMF.$_medicareMessage;

		<%-- credit card options --%>
		creditCardDetails.resetConfig();
		creditCardDetails.render();

		meerkat.modules.paymentGateway.reset();
	}
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />