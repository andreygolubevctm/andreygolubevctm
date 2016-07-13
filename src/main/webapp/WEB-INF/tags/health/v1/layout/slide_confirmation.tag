<%@ tag description="Health confirmation loading and parsing"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- Load confirmation information (either a full confirmation or a pending one) --%>
<c:set var="confirmationData"><health_v1:load_confirmation /></c:set>

<%-- get transactionId from confirmation data--%>
<x:parse var="confirmationDataXML" xml="${confirmationData}" />
<c:set var="transactionId"><x:out select="$confirmationDataXML/data/transID" /></c:set>

<%-- HTML PLACEHOLDER --%>
<layout_v1:slide formId="confirmationForm" className="displayBlock">

	<layout_v1:slide_content>
		<div id="confirmation" class="more-info-content"></div>
	</layout_v1:slide_content>

</layout_v1:slide>

<%-- TEMPLATES --%>
<%-- Logo and prices template --%>
<health_v1:logo_price_template />

<%-- Main page template --%>
<script id="confirmation-template" type="text/html">
	{{ var fundName = info.providerName ? info.providerName : info.fundName }}
	{{ if(typeof providerInfo !== 'undefined') { }}
		{{ providerInfo.fundName = fundName }}
		{{ providerInfo.provider = info.provider }}
		{{ var fundDetailsTemplate = meerkat.modules.templateCache.getTemplate($("#confirmation-fund-details-template")) }}
		{{ var fundDetailsHTML = fundDetailsTemplate(providerInfo) }}
	{{ } }}
	<layout_v1:slide_columns>

			<jsp:attribute name="rightColumn">

				<health_v1:policySummary showProductDetails="true" />

				{{ if( whatsNext ) { }}
				<form_v3:fieldset legend="" className="nextSteps visible-xs">
					<health_v1_layout:next_steps_template />
					{{= whatsNext }}
					{{ if(typeof providerInfo !== 'undefined') { }}
					<div class="row">
						{{= fundDetailsHTML }}
					</div>
					{{ } }}
				</form_v3:fieldset>
				{{ } }}

				<form_v3:fieldset legend="">
					<coupon:confirmation transactionId="${transactionId}" />
				</form_v3:fieldset>

			</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content >

				{{ var personName = typeof firstName !== 'undefined' && typeof lastName !== 'undefined' ? "Well done <span>" + firstName + " " + lastName + "</span>,<br />": '' }}
				<div class="row confirmation-complete">
					<div class="col-xs-12">
						{{ if ( typeof pending !== "undefined" && pending ) { }}
						<h1 class="pending">Your application is being processed.</h1>
						<p>Thanks for comparing with <content:get key="brandDisplayName"/>. If you have any further questions, or need any more information about your health insurance policy, please get in touch by calling us on <strong class="callCentreHelpNumber"><content:get key="callCentreHelpNumber"/></strong>.
							{{ } else if( whatsNext ) { }}
						<h1 class="success">Congratulations!</h1>
						{{ } }}

						<p>{{= personName }}
							Your Application has been submitted to <span>{{= fundName }}</span> for processing.</p>

						<p>Your <content:get key="boldedBrandDisplayName"/> reference number is <span>{{= transID }}</span>.</p>

						<p>Please remember to read your policy brochures so that you know exactly what you are covered for.</p>

						<p>Thank you for comparing <span>Health Insurance</span> with <content:get key="boldedBrandDisplayName"/></p>
					</div>

					{{ if(typeof providerInfo !== 'undefined') { }}
					<div class="col-xs-12 hidden-xs">
						{{= fundDetailsHTML }}
					</div>
					{{ } }}

					{{ if( whatsNext ) { }}
					<div class="col-xs-12 nextSteps hidden-xs">
						<health_v1_layout:next_steps_template />
						{{= whatsNext }}
					</div>
					{{ } }}
				</div>

				<simples:dialogue id="41" vertical="health" className="yellow" />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</script>

<%-- JAVASCRIPT --%>
<jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
<c:set var="jsonString" value="${resultsDisplayService.getResultItemsAsJsonString('health', 'category')}" scope="request"  />
<script>
	var resultLabels = ${jsonString};
	var result = ${go:XMLtoJSON(confirmationData)};

	<%--
        add product info contained in session on the page if:
        - there is any
        data.confirmation.health is set in the session when saving an order
    --%>

	<c:if test="${not empty data.confirmation.health}">
	<c:set var="sessionProduct" value="${fn:replace( fn:replace( data.confirmation.health, '<![CDATA[', ''), ']]>', '' ) }" />
	var sessionProduct = ${sessionProduct};
	</c:if>
</script>