<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Handover Form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<h5>Compare the Market want to say Thank You for using our comparison service by offering you the chance to win $1,000.</h5>

<div class="col-xs-12 col-sm-6 col-md-4 col-md-offset-2">
	<div class="competition-banner"></div>
</div>
<div class="col-xs-12 col-sm-6 col-md-4">
	<form_new:row label="Full Name" hideHelpIconCol="true" labelAbove="${true}">
		<field:person_name xpath="${xpath}/name" title="your full name" required="true" placeholder="Your full name" className="sessioncamexclude" />
	</form_new:row>

	<form_new:row label="Email Address" hideHelpIconCol="true" labelAbove="${true}">
		<field_new:email xpath="${xpath}/email" title="your email" placeHolder="Your email address" required="true" className="sessioncamexclude" />
	</form_new:row>

	<form_new:row label="Postcode / Suburb" className="postcodeDetails" hideHelpIconCol="true" labelAbove="${true}">
		<field_new:lookup_suburb_postcode xpath="${xpath}/location" required="true" placeholder="Postcode / Suburb" />
		<field:hidden xpath="${xpath}/suburb" />
		<field:hidden xpath="${xpath}/postcode" />
		<field:hidden xpath="${xpath}/state" />
	</form_new:row>

	<%-- Mandatory agreement to privacy policy --%>
	<form_new:row hideHelpIconCol="true" className="optin-group">
		<c:set var="label">
			I have read the <a data-toggle="dialog" data-content="legal/privacy_statement.jsp" data-cache="true" data-dialog-hash-id="privacystatement" href="legal/privacy_statement.jsp" target="_blank">privacy statement</a> and ANYTHING ELSE
		</c:set>
		<field:hidden xpath="${xpath}/optIn" defaultValue="Y" />
		<field_new:checkbox
			xpath="${xpath}/privacyoptin"
			value="Y"
			className="validate"
			required="true"
			label="${true}"
			title="${label}"
			errorMsg="Please confirm you have read the privacy statement and credit guide" />
	</form_new:row>
</div>

<div class="clearfix"></div>

<div class="col-xs-12 col-sm-6 col-md-4 col-md-offset-2 hidden-xs">
	<a class="btn btn-back btn-block hidden-xs cc-just-continue" href="${productHandoverUrl}">No thanks, continue to provider</a>
</div>
<div class="col-xs-12 col-sm-6 col-md-4">
	<a class="btn btn-next btn-block cc-submit-details" href="javascript:;">Enter competition & continue <span class="icon icon-arrow-right"></span></a>
	<a class="btn btn-back btn-block visible-xs cc-just-continue" href="${productHandoverUrl}">No thanks, continue to provider</a>
</div>
