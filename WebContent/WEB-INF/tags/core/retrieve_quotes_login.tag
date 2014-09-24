<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="retrieve_quotes log in"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div id="login" class="panel">
	<div class="qe-window">
		<h4>Please log in to view your insurance quotes</h4>

		<div class="content">
			<form:row label="Your Email Address">
				<field:contact_email xpath="login/email" required="true" title="the email address you used when saving your quotes"/>
			</form:row>
			<form:row label="Your Password">
				<field:password xpath="login/password" required="true" title="a new password"/>
			</form:row>
			<form:row label="">
				<div id="login-forgotten"><a href="javascript:void(0);">Forgotten your password? Click Here</a></div>
			</form:row>
			<form:row label="">
				<a href="javascript:void(0);" class="bigbtn" id="login-button"><span>Login</span></a>
			</form:row>
		</div>
		<div class="footer"></div>
	</div>
</div>

<div id="forgotten-password" class="panel">
	<div class="qe-window">
		<h4>Please enter your email address to reset your password</h4>
		<div class="content">
			<form:row label="Your Email Address">
				<field:contact_email xpath="login/forgotten/email" required="true" title="the email address you used when saving your quotes"/>
			</form:row>

			<form:row label="">
				<div id="forgotten-password-buttons">
					<a href="javascript:void(0);" class="bigbtn" id="reset-button"><span>Reset</span></a>
					<a href="javascript:void(0);" class="bigbtn" id="go-back-button"><span>Back</span></a>
				</div>
			</form:row>
		</div>
		<div class="footer"></div>
	</div>
</div>