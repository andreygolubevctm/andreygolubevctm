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

			<form_v2:row label="First name" hideHelpIconCol="true">
				<field_v2:input xpath="${xpath}/contact/first" title="First Name" required="true" />
			</form_v2:row>

			<form_v2:row label="Last name" hideHelpIconCol="true">
				<field_v2:input xpath="${xpath}/contact/last" title="Last Name" required="true" />
			</form_v2:row>

			<form_v2:row label="Your email address" hideHelpIconCol="true">
				<field_v2:email xpath="${xpath}/email" title="Your email address" required="true" />
			</form_v2:row>

			<form_v2:row hideHelpIconCol="true">
				<c:set var="brandedDisplayName"><content:get key="boldedBrandDisplayName"/></c:set>
				<field_v2:checkbox xpath="${xpath}/terms" label="true" value="Y" title="I would like to receive news and offers from ${brandedDisplayName}" required="false" />
				<field_v2:validatedHiddenField xpath="${xpath}/termsHidden" title="Please agree to receive news and offers from ${brandedDisplayName}" additionalAttributes=" required " />
			</form_v2:row>

			<%-- Mandatory agreement to privacy policy --%>
			<%-- Using a custom checkbox because validation doesn't work on this dropdown --%>
			<form_v2:row hideHelpIconCol="true">
				<c:set var="privacyStatementLink"><form_v1:link_privacy_statement /></c:set>
				<field_v2:checkbox xpath="${xpath}/privacyoptin" label="true" value="Y" title="I have read the ${privacyStatementLink}" required="false" />
				<field_v2:validatedHiddenField xpath="${xpath}/privacyoptinHidden" title="Please confirm you have read the privacy statement" additionalAttributes=" required " />
			</form_v2:row>

			<form_v2:row hideHelpIconCol="true">
				<a href="javascript:;" class="btn btn-save fuel-sign-up">Sign up now</a>
			</form_v2:row>
		</div>
	</div>
</form>

<core_v1:js_template id="signup-success-template">
	<div class="row">
		<div class="col-xs-12">
			<h4>Success!</h4>
			<p>You are now signed up for news and offers from <a href="http://www.comparethemarket.com.au/">www.comparethemarket.com.au</a>.</p>
		</div>
	</div>
</core_v1:js_template>