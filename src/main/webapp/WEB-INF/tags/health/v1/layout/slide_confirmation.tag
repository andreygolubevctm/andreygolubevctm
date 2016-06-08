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

<%-- Main page template --%>
<script id="confirmation-template" type="text/html">

	<layout_v1:slide_columns>

			<jsp:attribute name="rightColumn">

			</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content >

				<form_v3:fieldset legend="" className="confirmation">
					{{ var fundName = info.providerName ? info.providerName : info.fundName }}
					<div class="row confirmation-complete">
						<div class="col-sm-8 col-xs-12">
							{{ if ( typeof pending !== "undefined" && pending ) { }}
								<h1>Your application is being processed.</h1>
								<p>Thanks for comparing with <content:get key="brandDisplayName"/>. If you have any further questions, or need any more information about your health insurance policy, please get in touch by calling us on <strong class="callCentreHelpNumber"><content:get key="callCentreHelpNumber"/></strong>.
							{{ } else if( whatsNext ) { }}
								<h1 class="success">Congratulations!</h1>
							{{ } }}

							<p>Well done <span>{{= firstName }} {{= lastName }}</span>,<br />
								Your Application has been submitted to <span>{{= fundName }}</span> for processing.</p>

							<p>Your transaction number is <span>{{= transID }}</span>.</p>

							<p>Thank you for comparing <span>Health Insurance</span> with <content:get key="boldedBrandDisplayName"/></p>
						</div>
						<div class="col-sm-4 col-xs-12">
							<coupon:confirmation transactionId="${transactionId}" />
						</div>
						<div class="fundDetails">
							<div class="col-xs-12">
								<p>For any questions, contact {{= fundName }} via any of the methods below</p>
							</div>
							<!-- leveraging existing styles -->
							<div class="col-xs-4 companyLogo {{= info.provider }}-mi" ></div>
							<div class="col-xs-8">
								{{ if(!_.isEmpty(providerInfo.phoneNumber)) { }}<p class="phoneNumber">{{= providerInfo.phoneNumber }}</p class="phoneNumber">{{ } }}
								{{ if(!_.isEmpty(providerInfo.email)) { }}<p>{{= providerInfo.email }}</p>{{ } }}
								{{ if(!_.isEmpty(providerInfo.website)) { }}<p>{{= providerInfo.website }}</p>{{ } }}
							</div>
						</div>
					</div>

					<simples:dialogue id="41" vertical="health" className="yellow" />

				</form_v3:fieldset>

				<form_v3:fieldset legend="">
					<confirmation:other_products heading="More ways to compare" copy="Find more ways to save with comparethemarket.com.au bu selecting any of the insurance or utilities below." ignore="fuel,roadside"  />
				</form_v3:fieldset>

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