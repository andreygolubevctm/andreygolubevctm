<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("newLineChar2", "\r"); %>
<% pageContext.setAttribute("aposChar", "'"); %>
<% pageContext.setAttribute("aposChar2", "\\\\'"); %>
<% pageContext.setAttribute("slashChar", "\\\\"); %>
<% pageContext.setAttribute("slashChar2", "\\\\\\\\"); %>


<c:import var="config" url="/WEB-INF/aggregator/health_application/hif/config.xml" />
<x:parse var="configXml" doc="${config}" />
<c:set var="gatewayURL" scope="page" ><x:out select="$configXml//*[name()='nabGateway']/*[name()='gatewayURL']" /></c:set>
<c:set var="gatewayDomain" scope="page"><x:out select="$configXml//*[name()='nabGateway']/*[name()='domain']" /></c:set>

<%-- Because of cross domain issues with the payment gateway, we always use a CTM iframe to proxy to HAMBS' iframes so we need iframe src URL and hostOrigin to be pulled from CTM's settings (not the base and root URLs of the current brand). --%>
<c:set var="ctmSettings" value="${settingsService.getPageSettingsByCode('CTM','HEALTH')}"/>
<c:set var="hostOrigin">${ctmSettings.getRootUrl()}</c:set>
<c:if test="${fn:endsWith(hostOrigin, '/')}">
	<c:set var="hostOrigin">${fn:substring( hostOrigin, 0, fn:length(hostOrigin)-1 )}</c:set>
</c:if>

<%--
=======================
HIF
=======================
--%>
var healthFunds_HIF = {
	processOnAmendQuote: true,

	set: function() {
		<%-- HTML was already injected so unhide it --%>
		if ($('#hif_questionset').length > 0) {
			$('#hif_questionset').show();

			<%-- Reflow questions --%>
			$('#hif_questionset input').trigger('change');
		}
		else {

			<c:set var="html">
				<div id="hif_questionset">
					<c:set var="fieldXpath" value="health/application/hif/emigrate" />
					<form_new:row fieldXpath="${fieldXpath}" label="Did you or any persons included on this application emigrate to Australia after 1 July 2000?">
						<field_new:array_radio xpath="${fieldXpath}" required="true" title="" items="Y=Yes,N=No" />
						<p class="HIF" style="display:none;">
							As you ticked "Yes", HIF will require a copy of your Medicare Eligibility letter which states the date at which you became eligible to receive Medicare benefits. This letter will assist HIF in determining if a Lifetime Health Cover age loading will need to be added to the amount quoted in this application.
						</p>
						</div>
					</form_new:row>
				</div>
			</c:set>
			<c:set var="html" value="${go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(go:replaceAll(html, slashChar, slashChar2), newLineChar, ''), newLineChar2, ''), aposChar, aposChar2), '	', '')}" />

			$('#health_payment_medicare-selection .content').append('<c:out value="${html}" escapeXml="false" />');


			$('#hif_questionset input').on('change', function() {
				switch ($(this).val()) {
				case 'Y':
					$('#hif_questionset .HIF').slideDown(200);
					break;
				default:
					$('#hif_questionset .HIF').slideUp(200, function(){ $(this).hide(); });
				}
			});

		}<%-- /injection --%>



		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {

			<%-- Dependant definition --%>
			healthFunds._dependants('This policy provides cover for children until their 21st birthday. Student dependants aged between 21-24 years who are engaged in full time study, apprenticeships or traineeships can also be added to this policy. Adult dependants outside these criteria can still be covered by applying for a separate singles policy.');
			$.extend(healthDependents.config, { 'fulltime':true, 'school':true, 'schoolMin':21, 'schoolMax':24, 'schoolID':false });
			healthFunds_HIF.tmpSchoolLabel = $('.health_dependant_details_schoolGroup .control-label').html();
			$('.health_dependant_details_schoolGroup .control-label').html('Educational Institutional');
			$('.health_dependant_details_schoolGroup .help-icon').hide();

			<%-- Increase minimum age requirement for applicants from 16 to 18 --%>
			<%-- Primary --%>
			healthFunds_HIF.$_dobPrimary = $('#health_application_primary_dob');
			healthFunds_HIF.defaultAgeMin = dob_health_application_primary_dob.ageMin;
			dob_health_application_primary_dob.ageMin = 18;
			healthFunds_HIF.$_dobPrimary.rules('add', {messages: {'min_DateOfBirth': healthFunds_HIF.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );
			<%-- Partner --%>
			healthFunds_HIF.$_dobPartner = $('#health_application_partner_dob');
			dob_health_application_partner_dob.ageMin = 18;
			healthFunds_HIF.$_dobPartner.rules('add', {messages: {'min_DateOfBirth': healthFunds_HIF.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

			<%-- How to send information. Second argument = validation required --%>
			healthApplicationDetails.showHowToSendInfo('HIF', true);
			healthApplicationDetails.addOption('SMS', 'S');

			<%-- Previous funds --%>
			$('#health_previousfund_primary_memberID').attr('maxlength', '10');
			$('#health_previousfund_partner_memberID').attr('maxlength', '10');
			healthFunds._previousfund_authority(true);

			<%-- Partner authority --%>
			healthFunds._partner_authority(true);

			<%-- Fund IDs become optional --%>
			$('#clientMemberID').find('input').rules('remove', 'required');
			$('#partnerMemberID').find('input').rules('remove', 'required');

			<%-- Calendar for start cover --%>
			meerkat.modules.healthPaymentStep.setCoverStartRange(0, 29);

			<%-- Payments --%>
			meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });
			meerkat.modules.healthPaymentStep.overrideSettings('bank',{ 'weekly':false, 	'fortnightly':true, 'monthly':true, 'quarterly':true, 'halfyearly':true, 'annually':true });

			//selections for payment date
			$('#update-premium').on('click.NIF', function() {
				var freq = meerkat.modules.healthPaymentStep.getSelectedFrequency();
				healthFunds._payments = { 'min':0, 'max':14, 'weekends':true };
				var _html = healthFunds._paymentDays( $('#health_payment_details_start').val() );
				healthFunds._paymentDaysRender( $('.health-bank_details-policyDay'), _html);
				healthFunds._paymentDaysRender( $('.health-credit-card_details-policyDay'), _html);
			});

		}<%-- /not loading quote --%>
		meerkat.modules.paymentGateway.setup({
			"paymentEngine" : meerkat.modules.healthPaymentGatewayNAB,
			"name" : 'health_payment_gateway',
			"src": '${ctmSettings.getBaseUrl()}', <%-- the CTM iframe source URL --%>
			"origin": '${hostOrigin}', <%-- the CTM host origin --%>
			"hambsIframe": {
				src: '${gatewayURL}',
				remote: '${gatewayDomain}'
	},
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
	unset: function() {
		$('#hif_questionset').hide();

		<%-- Run these if not loading a quote --%>
		if (!$('body').hasClass('injectingFund')) {
			<%-- Dependants --%>
			healthFunds._dependants(false);
			$('.health_dependant_details_schoolGroup .control-label').html(healthFunds_HIF.tmpSchoolLabel);
			delete healthFunds_HIF.tmpSchoolLabel;
			$('.health_dependant_details_schoolGroup .help-icon').show();

			<%-- Age requirements for applicants (back to default) --%>
			dob_health_application_primary_dob.ageMin = healthFunds_HIF.defaultAgeMin;
			healthFunds_HIF.$_dobPrimary.rules('add', {messages: {'min_DateOfBirth': healthFunds_HIF.$_dobPrimary.attr('title') + ' age cannot be under ' + dob_health_application_primary_dob.ageMin} } );

			dob_health_application_partner_dob.ageMin = healthFunds_HIF.defaultAgeMin;
			healthFunds_HIF.$_dobPrimary.rules('add', {messages: {'min_DateOfBirth': healthFunds_HIF.$_dobPartner.attr('title') + ' age cannot be under ' + dob_health_application_partner_dob.ageMin} } );

			delete healthFunds_HIF.defaultAgeMin;
			delete healthFunds_HIF.$_dobPrimary;
			delete healthFunds_HIF.$_dobPartner;

			<%-- How to send information --%>
			healthApplicationDetails.removeLastOption();
			healthApplicationDetails.hideHowToSendInfo();

			<%-- Authority off --%>
			healthFunds._previousfund_authority(false);

			healthFunds._reset();

			<%-- Remove message --%>
			$('#health_payment_details-selection p.HIF').remove();
			<%-- Enable bank account payment option --%>
			$('#health_payment_details_type_ba').prop('disabled', false);
			$('#health_payment_details_type_ba').parent('label').removeClass('disabled').removeClass('disabled-by-fund');

			$('#update-premium').off('click.HIF');
			meerkat.modules.paymentGateway.reset();
		}
	}
};