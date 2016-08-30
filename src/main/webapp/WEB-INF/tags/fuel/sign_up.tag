<%@ tag description="Fuel user sign-up for alerts and promotional"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<security:populateDataFromParams rootPath="fuel" delete="false" />

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/signup" />

<%-- HTML --%>
<a href="#" class="fuel-signup-link visible-xs">
	Newsletter Signup
	<span class="icon icon-angle-down"></span>
</a>
<div id="fuel-signup" class="invisible">
	<div class="container">
		<div class="row">
			<div class="col-sm-6">
				<h2>New ways to save every month.</h2>
				<p>Sign up to our newsletter for exclusive deals, news and more on petrol and other products</p>
			</div>
			<div class="col-sm-6">
				<form id="fuel-signup-form">
					<div class="form-group row fieldrow">
						<div class="col-sm-8 row-content">
							<field_v2:email xpath="${xpath}/email" placeHolder="email@domain.com" title="Your email address" required="true" />
							<div class="error-field"></div>
						</div>
						<div class="col-sm-4">
							<button type="button" class="btn btn-secondary">
								<span>Subscribe</span>
							</button>
						</div>
					</div>
					<div class="alert alert-success text-center">Success! Your email address has been added to our database.</div>
					<p class="fuel-signup-agree">I would like to sign up to receive news and offers from comparethemarket.com.au. I agree with the <form_v1:link_privacy_statement overrideLabel="privacy policy." useModalMessage="true" /></p>
				</form>
			</div>
		</div>
	</div>
</div>