<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:import url="brand/ctm/settings.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>

	<core:head title="Reset your password" form="resetPasswordForm" errorContainer="#errorContainer" quoteType="Generic" />
	
	<go:style marker="css-href" href="common/reset_password.css" />
	<go:script marker="js-href" href="common/js/reset_password.js" />
	
	<body>
		
		<form:form action="reset_password.jsp" method="POST" id="resetPasswordForm" name="resetPasswordForm">
		
			<div id="wrapper">		
				<form:header />		
				<div id="headerShadow"></div>
				
				<div id="page">				
					<div id="reset" class="panel">
						<div class="qe-window">
							<h4>Please enter a new password</h4>
							
							<div class="content">							
								
								<group:password_entry xpath="reset" required="true" />
																
								<a href="javascript:void(0);" class="bigbtn" id="reset-button"><span>Next step</span></a>
								
								<input type="hidden" name="reset_id" value="${param.id}" />
							</div>
							<div class="footer"></div>
						</div>
					</div>
					
					
					<div id="resetPasswordErrors">
						<form:error id="errorContainer" className="errorContainer"/>
					</div>
				</div>						
				 				
				<form:footer/>
			</div>
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
			
		</form:form>

		<%-- Copyright notice --%>
		<quote:copyright_notice />
		
	</body>
</go:html>
