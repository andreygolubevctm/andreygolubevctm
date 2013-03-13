<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Don't override settings --%>
<c:if test="${empty data.settings.styleCode}">
	<c:import url="brand/ctm/settings.xml" var="settingsXml" />
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" xml="${settingsXml}" />
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>

	<core:head quoteType="false" title="Unsubscribe" nonQuotePage="${true}" form="unsubscribeForm" errorContainer="#errorContainer"/>
	<core:unsubscribe/>
	
	<body>

		<form:form action="" method="POST" id="unsubscribeForm" name="unsubscribeForm">
		
			<div id="wrapper">		
				<form:header quoteType="false" />		
				<div id="headerShadow"></div>
				
				<div id="page">
					<div id="emlUnsubscribe">
						<form:fieldset legend="Please enter your email address to unsubscribe">
							<form:row label="Your Email Address">
								<field:contact_email xpath="contact_email" required="true" title="the email address to unsubscribe"/>
							</form:row>
							
							
							<a id="unsubscribe-button" href="#" class="bigbtn">
								<span>Unsubscribe</span>
							</a>
						
						</form:fieldset>
					</div>
					<div id="unsubscribeErrors">
						<form:error id="errorContainer" className="errorContainer"/>
					</div>
					
					
				</div>
				
				<form:footer/>				
			</div>
			
			<core:popup id="confirm-unsubscribe" title="Unsubscribe Successful">
				<p>You have been successfully unsubscribed.</p>
				
				<div class="popup-buttons">
					<a href="#" id="return-to-home" class="bigbtn">
						<span>Exit</span>
					</a>
				</div>
			</core:popup>	

			<core:popup id="email-message" title="Unsubscribe Failed">
				<p>Unfortunately we don't have a record of that email address on file.</p>
				<div class="popup-buttons">
					<a href="#" id="return-to-eml" class="bigbtn">
						<span>Back</span>
					</a>
				</div>
			</core:popup>				
			
		</form:form>
		
		<%-- Copyright notice --%>
		<quote:copyright_notice />	
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
	
		<%-- Including all go:script and go:style tags --%>
		<agg:includes />
		
	</body>
</go:html>
