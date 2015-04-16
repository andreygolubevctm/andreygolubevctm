<%@ tag description="Health confirmation loading and parsing"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- Load confirmation information (either a full confirmation or a pending one) --%>
<c:set var="confirmationData"><health:load_confirmation /></c:set>

<%-- get transactionId from confirmation data--%>
<x:parse var="confirmationDataXML" xml="${confirmationData}" />
<c:set var="transactionId"><x:out select="$confirmationDataXML/data/transID" /></c:set>

<%-- HTML PLACEHOLDER --%>
<layout:slide formId="confirmationForm" className="displayBlock">

	<layout:slide_content>
		<div id="confirmation" class="more-info-content"></div>
	</layout:slide_content>

</layout:slide>

<%-- TEMPLATES --%>
	<%-- Logo and prices template --%>
	<health:logo_price_template />

	<%-- Main page template --%>
	<script id="confirmation-template" type="text/html">

		<layout:slide_columns>

			<jsp:attribute name="rightColumn">

				<div class="hidden-xs">
					<health:policySummary showProductDetails="true" />
				</div>

				<div class="row">
					<div class="col-xs-12">
						{{ if(promo.promoText) { }}
							<h2 class="text-hospital">Promotions &amp; Offers</h2>
							{{= promo.promoText }}
						{{ } }}

						{{ if(!about) { className="displayNone"; }  else { className="displayBlock"; } }}
						<div class="{{= className }}">
							<h2 class="text-hospital">About the fund</h2>
							<span class="aboutFund">{{= about }}</span>
						</div>
					</div>
				</div>

				<coupon:confirmation transactionId="${transactionId}" />
				<health:competition_jeep />

			</jsp:attribute>

			<jsp:body>

				<layout:slide_content >

					<div id="health_confirmation-warning">
						<div class="fundWarning alert alert-danger">
							<%-- insert fund warning data --%>
						</div>
					</div>

					<ui:bubble variant="info" className="">
						{{ if ( typeof pending !== "undefined" && pending ) { }}
							<h2>Your application is being processed.</h2>
							<p>Thanks for comparing with <content:get key="brandDisplayName"/>. If you have any further questions, or need any more information about your health insurance policy, please get in touch by calling us on <strong class="callCentreHelpNumber"><content:get key="callCentreHelpNumberApplication"/></strong>.
						{{ } else if( whatsNext ) { }}
							<h2>Success!</h2>
							<p>Your health insurance application is complete and has been submitted to {{= info.providerName }} for processing. Thanks for comparing with <content:get key="brandDisplayName"/>.</p>
							<p>If you have any further questions, or need any more information about your health insurance policy, please get in touch by calling us on <strong class="callCentreHelpNumber"><content:get key="callCentreHelpNumberApplication"/></strong>.
						{{ } }}
					</ui:bubble>

					<div class="moreInfoMainDetails">

						<div class="productSummary horizontal visible-xs clearfix">


							{{ var logoPriceTemplate = $("#logo-price-template").html(); }}
							{{ var htmlTemplate = _.template(logoPriceTemplate); }}
							{{ obj.htmlString = htmlTemplate(obj); }}
							{{= htmlString }}

							<h1 class="productName">{{= info.productTitle }}</h1>
						</div>

					</div>

					<p>Your reference number is <span class="transactionID">{{= transID }}</span></p>

					{{ if ( typeof pending !== "undefined" && pending ) { }}
						<h2 class="text-hospital">Your application is currently being processed.</h2>
						<p>
							We will be in contact with you should we require further information to complete your application. Once your application has been completed you will receive a confirmation email. If you have any questions about your purchased policy call us on: <span class="callCentreHelpNumber"><content:get key="callCentreHelpNumberApplication"/></span>
						</p>
					{{ } else if( whatsNext ) { }}
						<h2 class="text-hospital">Your application has been submitted to {{= info.providerName }} for processing. This is what happens next...</h2>
						{{= whatsNext }}
					{{ } }}

					<div class="row">

						{{ if(typeof hospitalCover !== 'undefined') { }}

							<div class="col-xs-6">

								{{ if(hospitalCover.inclusions.length > 0) { }}
								<h2 class="text-hospital">Hospital Benefits</h2>
									{{ if(promo.hospitalPDF) { }}
										<div class="brochureLinks">
											<p>
												<a href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" class="btn btn-download">Download Hospital Brochure</a>
											</p>
										</div>
									{{ } }}
									<h5>You are covered for:</h5>
									<ul class="indent">
										{{ _.each(hospitalCover.inclusions, function(inclusion){ }}
										<li>{{= inclusion }}</li>
										{{ }) }}
									</ul>
								{{ } }}

								{{ if(hospitalCover.restrictions.length > 0) { }}
									<h5>You have restricted cover for:</h5>
									<ul class="indent">
										{{ _.each(hospitalCover.restrictions, function(restriction){ }}
										<li>{{= restriction }}</li>
										{{ }) }}
									</ul>
									<span class="text-italic small">Limits may apply. See policy brochure for more details.</span>
								{{ } }}

							</div>

						{{ } }}

						{{ if(typeof extrasCover !== 'undefined') { }}

							<div class="col-xs-6">
								{{ if(extrasCover.inclusions.length > 0) { }}
								<h2 class="text-extras">Extras Benefits</h2>
									{{ if(promo.extrasPDF) { }}
										<div class="brochureLinks">
											<p>
												<a href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" class="btn btn-download">Download Extras Brochure</a>
											</p>
										</div>
									{{ } }}
									<h5>You are covered for:</h5>
									<ul class="indent">
										{{ _.each(extrasCover.inclusions, function(inclusion){ }}
										<li>{{= inclusion }}</li>
										{{ }) }}
									</ul>
									<span class="text-italic small">Limits may apply. See policy brochure for more details.</span>
								{{ } }}
							</div>

						{{ } }}

					</div>

					{{ if(typeof hospitalCover !== 'undefined') { }}

						{{ if(hospitalCover.exclusions.length > 0) { }}
							<div class="row moreInfoExclusions">
								<div class="col-xs-12">
									<h5 class="text-hospital">Your Hospital Exclusions:</h5>
									<ul class="exclusions">
										{{ _.each(hospitalCover.exclusions, function(exclusion){ }}
										<li><span class="icon-cross" />{{= exclusion }}</li>
										{{ }) }}
									</ul>
								</div>
							</div>
						{{ } }}

					{{ } }}

				<simples:dialogue id="41" vertical="health" className="yellow" />

				</layout:slide_content>

			</jsp:body>

		</layout:slide_columns>

	</script>

<%-- JAVASCRIPT --%>
	<jsp:useBean id="resultsService" class="com.ctm.services.results.ResultsService" scope="request" />
	<c:set var="jsonString" value="${resultsService.getResultItemsAsJsonString('health', 'category')}" scope="request"  />
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
