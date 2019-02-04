<%@ tag import="com.ctm.web.reward.services.RewardService" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag description="Health confirmation loading and parsing"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber" /></c:set>

<c:set var="openingHoursTimeZone"><content:get key="openingHoursTimeZone" /></c:set>

<%-- This xpath does not seem to be wired in yet... --%>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}/callback" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="todays_day" pattern="EEEE" value="${now}" />

<%-- Get vars to send to lifebroker if required - Start --%>
<c:set var="lbContactName" >
	<c:choose>
		<c:when test="${not empty data.health.application.primary.firstname && not empty data.health.application.primary.surname}">${data.health.application.primary.firstname}<c:out value=" " />${data.health.application.primary.surname}</c:when>
		<c:when test="${not empty data.health.application.primary.title && not empty data.health.application.primary.surname}">${data.health.application.primary.title}<c:out value=" " />${data.health.application.primary.surname}</c:when>
		<c:when test="${not empty data.health.application.primary.firstname}">${data.health.application.primary.firstname}</c:when>
		<c:when test="${not empty data.health.application.primary.surname}">${data.health.application.primary.surname}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="lbContactDOB" >
	<c:choose>
		<c:when test="${not empty data.health.application.primary.dob}">${data.health.application.primary.dob}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="lbContactGender" >
	<c:choose>
		<c:when test="${not empty data.health.application.primary.gender}">${data.health.application.primary.gender}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="lbContactState" >
	<c:choose>
		<c:when test="${not empty data.health.application.address.state}">${data.health.application.address.state}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="lbContactPostCode" >
	<c:choose>
		<c:when test="${not empty data.health.application.address.postCode}">${data.health.application.address.postCode}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="lbContactPhone" >
	<c:choose>
		<c:when test="${not empty data.health.application.mobile}">${data.health.application.mobile}</c:when>
		<c:otherwise>${data.health.application.other}</c:otherwise>
	</c:choose>
</c:set>

<c:set var="lbContactEmail" >
	<c:choose>
		<c:when test="${not empty data.health.application.email and 'email@westfund.com.au' ne fn:toLowerCase(data.health.application.email)}">${data.health.application.email}</c:when>
		<c:otherwise>${data.health.contactDetails.email}</c:otherwise>
	</c:choose>
</c:set>

<%-- lifebroker vars - End --%>


<%
	RewardService rewardService = (RewardService) RequestContextUtils.findWebApplicationContext(request).getBean("rewardService");
	request.setAttribute("rewardService", rewardService);
%>

<%-- Load confirmation information (either a full confirmation or a pending one) --%>
<c:set var="confirmationData"><health_v1:load_confirmation /></c:set>

<%-- get transactionId from confirmation data--%>
<x:parse var="confirmationDataXML" xml="${confirmationData}" />
<c:set var="transactionId"><x:out select="$confirmationDataXML/data/transID" /></c:set>
<c:set var="status"><x:out select="$confirmationDataXML/data/status" /></c:set>
<c:set var="redemptionId"><x:out select="$confirmationDataXML/data/redemptionId" /></c:set>
<c:set var="voucherValue"><x:out select="$confirmationDataXML/data/voucherValue" /></c:set>
<c:choose>
	<c:when test="${not empty redemptionId}">
		<c:set var="rewardOrder" value="${rewardService.getOrderAsJson(redemptionId, pageContext.request)}" />
	</c:when>
	<c:otherwise>
		<c:set var="rewardOrder" value="{}" />
	</c:otherwise>
</c:choose>

<%-- HTML PLACEHOLDER --%>
<layout_v1:slide formId="confirmationForm" className="displayBlock">

	<layout_v1:slide_content>
		<div id="confirmation"></div>
	</layout_v1:slide_content>

</layout_v1:slide>

<%-- TEMPLATES --%>
	<%-- Logo and prices template --%>
	<core_v1:js_template id="logo-template"><health_v3:logo_template /></core_v1:js_template>
	<core_v1:js_template id="price-template"><health_v3:price_template /></core_v1:js_template>

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

				<c:set var="coupon"><coupon:confirmation transactionId="${transactionId}" /></c:set>

				<c:if test="${not empty coupon}">
				<form_v3:fieldset legend="">
					${coupon}
				</form_v3:fieldset>
				</c:if>

				<c:set var="voucherConfirmationMessage">
					<content:get key="voucherConfirmationMessage"/>
				</c:set>

				<c:if test="${not empty voucherValue and not empty voucherConfirmationMessage}">
					<form_v3:fieldset legend="">
						${fn:replace(voucherConfirmationMessage, 'voucherValue', voucherValue)}
					</form_v3:fieldset>
				</c:if>

			</jsp:attribute>

			<jsp:body>

				<layout_v1:slide_content >
				<competition:confirmEntry />
					<form_v3:fieldset legend="" className="confirmation">

                        <reward:reward_confirmation_message />
						{{ var personName = typeof firstName !== 'undefined' && typeof lastName !== 'undefined' ? "Well done <span class='important-text'>" + firstName + " " + lastName + "</span>,<br />": '' }}
						<div class="row confirmation-complete">
							<div class="col-xs-12">
								{{ if ( typeof pending !== "undefined" && pending ) { }}
									<h1 class="pending">Your application is being processed.</h1>
									<p><span class="thankyou-pending">Thanks for <span class="compare">comparing with</span><span class="purchase">purchasing from</span> <content:get key="brandDisplayName"/>. </span>If you have any further questions, or need any more information about your health insurance policy, please get in touch by calling us on <strong class="callCentreHelpNumber"><content:get key="callCentreHelpNumber"/></strong>.
								{{ } else if( whatsNext ) { }}
									<h1 class="success">Congratulations!</h1>
								{{ } }}

								<p>{{= personName }}
								Your Application has been submitted<span class="submitted-fund-name-visibility"> to <span class="important-text">{{= fundName }}</span></span> for processing.</p>

								<p class="ref-number-line">Your <content:get key="boldedBrandDisplayName"/> reference number is <span class="important-text">{{= transID }}</span>.</p>

								<p>Please remember to read your policy brochures so that you know exactly what you are covered for.</p>

								<p class="thankyou-success">Thank you for <span class="compare">comparing</span><span class="purchase">purchasing</span> <span class="important-text">Health Insurance</span> <span class="compare">with</span><span class="purchase">from</span> <content:get key="boldedBrandDisplayName"/>.<span class="success-and-further-questions">{{ if ( !(typeof pending !== "undefined" && pending) ) { }} If you have any further questions, or need any more information about your health insurance policy, please get in touch by calling us on <strong class="callCentreHelpNumber"><content:get key="callCentreHelpNumber"/></strong>.{{ } }}</span></p>

							</div>

						</div>

						<c:if test="${not empty callCentre and callCentre}">
							<div class="row confirmation-complete no-wimples">
								<div class="callbackLeads simples-dialogue yellow">

									<div class="lbContactName hidden">${lbContactName}</div>
									<div class="lbContactDOB hidden">${lbContactDOB}</div>
									<div class="lbContactGender hidden">${lbContactGender}</div>
									<div class="lbContactState hidden">${lbContactState}</div>
									<div class="lbContactPostCode hidden">${lbContactPostCode}</div>
									<div class="lbContactPhone hidden">${lbContactPhone}</div>
									<div class="lbContactEmail hidden">${lbContactEmail}</div>
									<div class="lbContactTransactionId hidden"><c:out value="${data['current/transactionId']}"/></div>

									<simples:dialogue id="98" vertical="health" />

									<div class="callbackLeadsContent hidden">

										<div class="call-now-panel">
											<div class="col-xs-6">

												<a href="javascript:;" class="lb-switch lb-call-type">Choose another time for a call?</a>
											</div>
											<div class="col-xs-5">
												<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
												<button id="lb-callBackNow" class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}><span>Call me now</span></button><small>within 30 mins, during call centre opening hours</small>
											</div>
										</div>

										<div class="call-later-panel hidden">
											<div class="col-xs-12">

												<a href="javascript:;" class="lb-switch lb-call-type">Cancel, customer wants a call right now</a>
											</div>

											<div class="col-xs-12 time-and-date-form-fields">
												<form_v4:row label=" ">

													<field_v2:array_radio xpath="${xpath}/lb-day" required="true" className="lb-callbackDay"
																		  items="Today=,Tomorrow=,NextDay=,TheFollowingDay=,DayAfterThat=,LastDay="
																		  title="" wrapCopyInSpan="true" />
												</form_v4:row>

												<form_v4:row label="Pick a time for " id="lb-pickATimeLabel">
													<field_v2:array_select xpath="${xpath}/lb-time" required="true" className="callbackTime lb-callbackTime"
																		   items="="
																		   title="" />
												</form_v4:row>
											</div>

											<div class="col-xs-12 call-me-later">
												<div class="col-xs-5">
													<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Call Request" quoteChar="\"" /></c:set>
													<button id="lb-callBackLater"  class="btn btn-secondary btn-lg btn-block" ${analyticsAttr}>Call me later...</button>
												</div>
											</div>

											<div class="timezone-description">All Australian based call centre hours are ${openingHoursTimeZone}</div>

										</div>

										<br />

									</div>

									<div class="callbackLeadsContent-thankyou hidden">
										<div class="row">
											<div class="col-xs-12 center">
												<h4 class="text-center">Thanks ${lbContactName}</h4>
												<p class="text-center">One of our life insurance experts to call you on the number <span class="text-center">${lbContactPhone}</span></p>

											</div>
											<div class="col-xs-12 callDate text-center">
												<h2><span class="returnCallDate"></span>,
													<span class="text-center returnCallTime"></span>
												</h2>
												<div class="quote-ref">Client Reference: <span class="returnCallClientRef"></span></div>
											</div>
										</div>
									</div>

									<div class="callbackLeadsContent-error hidden">
										<div class="row">
											<div class="col-xs-12 error">
												<h2 class="text-center">Unfortunately we are unable to process your request at the moment</h2>
											</div>
										</div>
									</div>
								</div>

							</div>
						</c:if>

						<div class="row confirmation-complete">


							{{ if(typeof providerInfo !== 'undefined') { }}
								<div class="col-xs-12 hidden-xs fund-details-html">
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

						<simples:dialogue id="41" vertical="health" />

					</form_v3:fieldset>

					<form_v3:fieldset legend="" className="confirmation-other-products">
						<confirmation:other_products heading="More ways to compare" copy="Find more ways to save with comparethemarket.com.au by selecting any of the insurance or utilities below." ignore="fuel,roadside"  />
					</form_v3:fieldset>

				</layout_v1:slide_content>

			</jsp:body>

		</layout_v1:slide_columns>

	</script>

<%-- JAVASCRIPT --%>
	<jsp:useBean id="resultsService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
	<c:set var="jsonString" value="${resultsService.getResultItemsAsJsonString('health', 'category')}" scope="request"  />
	<script>
		var resultLabels = ${jsonString};
		var result = ${go:XMLtoJSON(confirmationData)};
		var rewardOrder = ${rewardOrder};
		var encryptedOrderLineId = "${redemptionId}";

		<%--
			add selected product object if it exists (stored in database)
		--%>
		<jsp:useBean id="selectedProductService" class="com.ctm.web.health.services.HealthSelectedProductService" scope="request" />
		<c:if test="${not empty transactionId}">
			<c:set var="selectedProduct" value="${selectedProductService.getProductXMLViaBean(transactionId)}" />
			<c:if test="${not empty selectedProduct}">
				var sessionProduct = ${selectedProduct};
			</c:if>
		</c:if>

		<c:if test="${not empty transactionId && status eq 'OK'}">
			<jsp:useBean id="touchService" class="com.ctm.web.core.services.AccessTouchService" scope="request" />
			<c:set var="hasTouch" value="${touchService.touchCheck(transactionId, 'CONF')}" scope="request"  />
			try {
				if(result instanceof Object && result.hasOwnProperty('data') && result.data instanceof Object) {
					result.data.viewed = <c:choose><c:when test="${hasTouch eq true}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
				}
			} catch(e) {
				// ignore
			}
		</c:if>
	</script>
