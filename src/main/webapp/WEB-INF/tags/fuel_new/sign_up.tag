<%@ tag description="Fuel user sign-up for alerts and promotional"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<security:populateDataFromParams rootPath="fuel" delete="false" />

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/signup" />

<%-- HTML --%>
<form id="sign-up-form" class="form-horizontal">
	<div class="row scrollable">
		<div class="col-xs-10 col-sm-4 col-xs-pull-0 col-sm-push-8">
				<%--<ui:bubble variant="chatty">--%>
					<%--<p>Do you want emails? Sign up for emails!</p>--%>
					<%--<p>Get emails straight to your email place!</p>--%>
					<%--<p>Emails!</p>--%>
				<%--</ui:bubble>--%>
		</div>
		<div class="col-xs-10 col-sm-8 col-sm-pull-4">
			<h4>Sign Up for News and Offers!</h4>

			<div class="form-submit-error-message hidden alert alert-danger">
				Sorry, there was an error signing you up. Please try again later.
			</div>

			<form_new:row label="First name" hideHelpIconCol="true">
				<field_new:input xpath="${xpath}/contact/first" title="First Name" required="true" />
			</form_new:row>

			<form_new:row label="Last name" hideHelpIconCol="true">
				<field_new:input xpath="${xpath}/contact/last" title="Last Name" required="true" />
			</form_new:row>

			<form_new:row label="Your email address" hideHelpIconCol="true">
				<field_new:email xpath="${xpath}/email" title="Your email address" required="true" />
			</form_new:row>

			<form_new:row hideHelpIconCol="true">
				<c:set var="brandedDisplayName"><content:get key="boldedBrandDisplayName"/></c:set>
				<field_new:checkbox xpath="${xpath}/terms" label="true" value="Y" title="I would like to receive news and offers from ${brandedDisplayName}" required="false" />
				<field_new:validatedHiddenField xpath="${xpath}/termsHidden" required="true" title="Please agree to receive news and offers from ${brandedDisplayName}" />
			</form_new:row>

			<%-- Mandatory agreement to privacy policy --%>
			<%-- Using a custom checkbox because validation doesn't work on this dropdown --%>
			<form_new:row hideHelpIconCol="true">
				<c:set var="privacyStatementLink"><form:link_privacy_statement /></c:set>
				<field_new:checkbox xpath="${xpath}/privacyoptin" label="true" value="Y" title="I have read the ${privacyStatementLink}" required="false" />
				<field_new:validatedHiddenField xpath="${xpath}/privacyoptinHidden" required="true" title="Please confirm you have read the privacy statement" />
			</form_new:row>

			<form_new:row hideHelpIconCol="true">
				<a href="javascript:;" class="btn btn-save fuel-sign-up">Sign up now</a>
			</form_new:row>
		</div>
	</div>
</form>

<core:js_template id="signup-success-template">
	<div class="row">
		<div class="col-xs-12">
			<h4>Success!</h4>
			<p>You are now signed up for news and offers from <a href="http://www.comparethemarket.com.au/">www.comparethemarket.com.au</a>.</p>
		</div>
	</div>
</core:js_template>