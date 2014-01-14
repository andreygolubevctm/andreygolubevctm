<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<c:set var="_reset_id"><c:out value="${param.id}" escapeXml="true"/></c:set>

<core:load_settings conflictMode="false" />

<core:doctype />
<go:html>

	<core:head title="Reset your password" form="resetPasswordForm" errorContainer="#errorContainer" quoteType="Generic" />

	<go:style marker="css-href" href="common/reset_password.css" />
	<go:script marker="js-href" href="common/js/reset_password.js" />

	<body>

		<form:form action="reset_password.jsp" method="POST" id="resetPasswordForm" name="resetPasswordForm">

			<div id="wrapper">
				<form:header hasReferenceNo="false" />
				<div id="headerShadow"></div>

				<div id="page">
					<div id="reset" class="panel">
						<div class="qe-window">
							<h4>Please enter a new password</h4>

							<div class="content">

								<group:password_entry xpath="reset" required="true" />

								<a href="javascript:void(0);" class="bigbtn" id="reset-button"><span>Next step</span></a>



								<input type="hidden" name="reset_id" value="${_reset_id}" />
							</div>
							<div class="footer"></div>
						</div>
					</div>


					<div id="resetPasswordErrors">
						<form:error id="errorContainer" className="errorContainer"/>
					</div>
				</div>

			</div>

			<agg:generic_footer />

			<core:closing_body>
				<agg:includes kampyle="false" loading="false" sessionPop="false" supertag="false" />

				<core:popup id="reset-confirm" title="Password Change Successful">
					<p>Your password was successfully changed!</p>
					<p>Click the button below to return the "Retrieve Your Insurance Quotes" page and login using your new password, to gain access to your previous quotes.</p>

					<div class="popup-buttons">
						<a href="javascript:void(0);" class="bigbtn" id="return-to-login"><span>OK</span></a>
					</div>
				</core:popup>

				<core:popup id="reset-error" title="Password Change Failed">
					<p>Your password was not changed</p>
					<p id="reset-error-message"></p>
					<p>Please click the button below to return to the "Reset Your Password" page, to request an email with a new reset password link.</p>

					<div class="popup-buttons">
						<a href="javascript:void(0);" class="bigbtn" id="try-again"><span>Try Again</span></a>
					</div>
				</core:popup>
			</core:closing_body>

		</form:form>

	</body>
</go:html>
