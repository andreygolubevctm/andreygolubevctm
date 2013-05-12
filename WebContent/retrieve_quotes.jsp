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


	<core:head quoteType="false" title="Retrieve Your Quotes" nonQuotePage="${true}" form="retrieveQuoteForm" errorContainer="#errorContainer"/>
	<agg:supertag_top type="Car" initialPageName="Retrieve Your Quotes"/>	
	<core:retrieve_quotes/>

	
	<body class="retrieve">

		<go:setData dataVar="data" xpath="login" value="*DELETE" />
		
		<form:form action="retrieve_quotes.jsp" method="POST" id="retrieveQuoteForm" name="retrieveQuoteForm">
		
			<div id="wrapper">		
				<form:header quoteType="false" />		
				<div id="headerShadow"></div>
				
				<div id="page">
					<div id="content">
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
											<a href="javascript:void(0);" class="bigbtn" id="reset-button"><span>Next</span></a>
											<a href="javascript:void(0);" class="bigbtn" id="go-back-button"><span>Prev</span></a>
										</div>
									</form:row>
								</div>
								<div class="footer"></div>
							</div>
						</div>
						
						<div class="side-image"></div>
						
						<div id="retrieveQuoteErrors">
							<form:error id="errorContainer" className="errorContainer" errorOffset="24" />
						</div>
						
						
						<div id="quotes" style="display:none;">
							<h3><span id="quotesTitle">Your Quotes</span></h3>
							<div class="full-width">
								<div class="header">
									<div class="quote-date-time">Quote Date</div>
									<div class="quote-details">Details</div>
									<div class="quote-options">Quote Options</div>
								</div>
								
								<core:js_template id="quote_quote">
									<div class="quote-row" id="car_quote_[#=id#]">
										<div class="quote-date-time">
											<span class="quote-date">[#= quoteDate #]</span>
											<span class="quote-time">[#= quoteTime #]</span>
											<span class="transactionId">Ref: [#= id #]</span>
										</div>
										
										<div class="quote-details">
											<span class="vehicle">[#=vehicle.year#] [#=vehicle.make#] [#=vehicle.model#] </span>
											<span class="regDriver"><span class="label">Regular Driver: </span>[#=driver.name#][#=driver.age#] year old [#=driver.gender#]</span>
											<span class="regDriverYoungest">Youngest driver is regular driver. </span>
											<span class="youngDriver" ><span class="label">Youngest Driver Age: </span>[#=youngDriver.age#] year old [#=youngDriver.gender#]</span>
											<span class="ncd"><span class="label">No Claims Discount : </span>[#=driver.ncd#]</span>
										</div>
										
										<div class="quote-options">
											<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest Results</span></a></div>
											<div class="quote-amend"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
										</div>
									</div>
								</core:js_template>
								
								<core:js_template id="health_quote">
									<div class="quote-row" id="health_quote_[#=id#]">
										<div class="quote-date-time">
											<span class="quote-date">[#= quoteDate #]</span>
											<span class="quote-time">[#= quoteTime #]</span>
											<span class="transactionId">Ref: [#= id #]</span>
										</div>
										
										<div class="quote-details">
											<span class="title">Health Insurance Quote</span>
											<span class="situation">Situation: [#=situation.healthCvr#] - [#=situation.healthSitu#] </span>
											<span class="benefits"><span class="label">Benefits: </span>[#=benefits.list#]</span>
											<span class="dependants" ><span class="label">Dependants: </span>[#=healthCover.dependants#]</span>
											<span class="income"><span class="label">Income : </span>[#=healthCover.income#]</span>
										</div>
										
										<div class="quote-options">
											<!--<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest Results</span></a></div> -->
											<div class="quote-amend"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
										</div>
									</div>
								</core:js_template>
								
								<core:js_template id="life_quote">
									<div class="quote-row" id="life_quote_[#=id#]">
										<div class="quote-date-time">
											<span class="quote-date">[#= quoteDate #]</span>
											<span class="quote-time">[#= quoteTime #]</span>
											<span class="transactionId">Ref: [#= id #]</span>
										</div>
										
										<div class="quote-details">
											<span class="title">Life Insurance Quote</span>
											<span class="situation">Situation: [#=content.situation#]</span>
											<span class="term"><span class="label">Term Life Cover: $</span>[#=content.term#]</span>
											<span class="tpd"><span class="label">TPD Cover: $</span>[#=content.tpd#]</span>
											<span class="trauma"><span class="label">Trauma Cover: $</span>[#=content.trauma#]</span>
											<span class="premium"><span class="label">Premium: </span>[#=content.premium#]</span>
										</div>
										
										<div class="quote-options">
											<!--<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest Results</span></a></div> -->
											<div class="quote-amend"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
										</div>
									</div>
								</core:js_template>
								
								<core:js_template id="ip_quote">
									<div class="quote-row" id="ip_quote_[#=id#]">
										<div class="quote-date-time">
											<span class="quote-date">[#= quoteDate #]</span>
											<span class="quote-time">[#= quoteTime #]</span>
											<span class="transactionId">Ref: [#= id #]</span>
										</div>
										
										<div class="quote-details">
											<span class="title">Income Protection Insurance Quote</span>
											<span class="situation">Situation: [#=content.situation#]</span>
											<span class="income"><span class="label">Income: $</span>[#=content.income#]</span>
											<span class="amount"><span class="label">Benefit Amount: $</span>[#=content.amount#]</span>
											<span class="premium"><span class="label">Premium: </span>[#=content.premium#]</span>
										</div>
										
										<div class="quote-options">
											<!--<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest Results</span></a></div> -->
											<div class="quote-amend"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
										</div>
									</div>
								</core:js_template>
								
								<div class="content">
									<div id="quote-list"></div>	
									<div id="quote-list-empty" style="display:none">Unfortunately we cannot find any saved quotes for your email address</div>
								</div>
								<div class="footer"> </div>
							</div>
							<div class="side-image-results"></div>
						</div>		
					</div>			
				</div>
				 
				
				<agg:footer/>				
			</div>
			
			<core:popup id="confirm-reset" title="Reset Password">
				<p>Your password reset email has been sent to <span id="confirm-reset-email"></span></p>
				<p>To reset your password click the link provided in that email and follow the process provided on our secure website.</p>  
				<p>Once your password has been reset, follow the process to return to the "Retrieve Your Insurance Quotes" page and log in using your new password, to gain access to your previous quotes.</p>
				
				<div class="popup-buttons">
					<a href="javascript:void(0);" class="bigbtn return-to-login"><span>Ok</span></a>
				</div>
			</core:popup>					

			<core:popup id="retrieve-error" title="Retrieve Quotes Error">
				<p>Unfortunately we were unable to retrieve your insurance quotes.</p>
				<p id="retrieve-error-message"></p>
				<p>Click the button below to return to the "Retrieve Your Insurance Quotes" page and try again.</p>				
				<div class="popup-buttons">
					<a href="javascript:void(0);" class="bigbtn return-to-login"><span>Ok</span></a>
				</div>
			</core:popup>					

		</form:form>
		
		<core:popup id="new-date" title="Enter New Commencement Date">
			<p>The quote you selected has a commencement date in the past.</p>
			<p>Please enter a new commencement date and click the button below to view the latest prices for this quote.</p>

			<form:row label="Commencement Date">
				<field:commencement_date xpath="newDate" required="false" />
			</form:row>	
							
			<div class="popup-buttons">
				<a href="javascript:void(0);" id="new-date-button"></a>
			</div>			
		</core:popup>	
		
		<!-- Loading animation -->
		<quote:loading />	
		
		<%-- Copyright notice --%>
		<quote:copyright_notice />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
		
	</body>
</go:html>
