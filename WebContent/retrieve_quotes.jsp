<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%-- Don't override settings --%>
<c:if test="${empty data.settings.styleCode}">
	<c:import url="brand/ctm/settings.xml" var="settingsXml" />
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" xml="${settingsXml}" />
</c:if>

<go:log>
		param.hashedEmail ${param.hashedEmail}
</go:log>

<c:if test="${param.hashedEmail != null }">
	<security:authentication
		emailAddress="${param.email}"
		password="${param.password}"
		hashedEmail="${param.hashedEmail}"
		brand="CTM" />
	<c:if test="${not empty data.userData && data.userData.validCredentials}">
		<go:setData dataVar="data" value="*UNLOCK" xpath="userData" />
			<go:setData dataVar="data" xpath="userData/hashedEmail" value="*DELETE" />
		<go:setData dataVar="data" value="*LOCK" xpath="userData" />
		<c:redirect url="${data['settings/root-url']}${data.settings.styleCode}/retrieve_quotes.jsp"/>
	</c:if>
</c:if>

<core:doctype />
<go:html>


	<core:head quoteType="false" title="Retrieve Your Quotes" nonQuotePage="${true}" form="retrieveQuoteForm" errorContainer="#errorContainer"/>

	<agg:supertag_top type="Car" initialPageName="Retrieve Your Quotes"/>	
	<core:retrieve_quotes/>
	<body class="retrieve">


		<go:setData dataVar="data" xpath="login" value="*DELETE" />
		
		<form:form action="retrieve_quotes.jsp" method="POST" id="retrieveQuoteForm" name="retrieveQuoteForm" autoComplete="on">
		
			<div id="wrapper">		
				<form:header quoteType="false" hasReferenceNo="false" />
				<div id="headerShadow"></div>
				
				<div id="page">
					<div id="content">
						<c:choose>
							<c:when test="${not empty data.userData && data.userData.validCredentials}">
								<c:import var="QUOTE_RESULTS_JSON" url="ajax/json/retrieve_quotes.jsp" />
								<c:if test="${empty QUOTE_RESULTS_JSON}">
									<core:retrieve_quotes_login/>
								</c:if>
							</c:when>
							<c:otherwise>
								<core:retrieve_quotes_login/>
							</c:otherwise>
						</c:choose>
								
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
								
								<%-- AGG-818: modify to car_quote --%>
								<core:js_template id="quote_quote">
									<div class="quote-row" id="car_quote_[#=id#]_[#=fromDisc#]">
										<div class="quote-date-time">
											<span class="quote-date">[#= quoteDate #]</span>
											<span class="quote-time">[#= quoteTime #]</span>
											<span class="transactionId">Ref: [#= id #]</span>
										</div>
										
										<div class="quote-details">
											<span class="vehicle">[#=vehicle.year#] [#=vehicle.makeDes#] [#=vehicle.modelDes#] </span>
											<span class="regDriver"><span class="label">Regular Driver: </span>[#=drivers.regular.name#][#=drivers.regular.age#] year old [#=drivers.regular.gender#]</span>
											<span class="regDriverYoungest">Youngest driver is regular driver. </span>
											<span class="youngDriver" ><span class="label">Youngest Driver Age: </span>[#=drivers.young.age#] year old [#=drivers.young.gender#]</span>
											<span class="ncd"><span class="label">No Claims Discount: </span>[#=drivers.regular.ncd#]</span>
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
											<div class="quote-amend"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
											<div class="quote-start-again"><a href="javascript:void(0);" class="quote-start-again tinybtn"><span>Start Again</span></a></div>
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
			
			<core:popup id="retrieve-error" title="Retrieve Quotes Error">
				<p>Unfortunately we were unable to retrieve your insurance quotes.</p>
				<p id="retrieve-error-message"></p>
				<p>Click the button below to return to the "Retrieve Your Insurance Quotes" page and try again.</p>				
				<div class="popup-buttons">
					<a href="javascript:void(0);" class="bigbtn return-to-login"><span>Ok</span></a>
				</div>
			</core:popup>					
			<core:reset-password
				returnTo="Retrieve Your Insurance Quotes"
				resetButtonId="reset-button"
				emailFieldId="login_forgotten_email"
				emailFormId="retrieveQuoteForm"
				successCallback="Retrieve.showPanel('login');"
				popup="true"
				onceResetInstructions="Once your password has been reset, follow the process to return to the \"Retrieve Your Insurance Quotes\" page and log in using your new password, to gain access to your previous quotes."
				failedResetInstructions="Click the button below to return to the \"reset your password\" page and try again."
			/>

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
		
		<%-- Omniture Reporting
		<quote:omniture />
		--%>

		<%-- Copyright notice --%>
		<agg:copyright_notice />
		
		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
		<go:script marker="onready">
			<c:choose>
				<c:when test="${not empty QUOTE_RESULTS_JSON}">
					var jsonResult = ${QUOTE_RESULTS_JSON};
					Retrieve.handleJSONResults(jsonResult);
				</c:when>
				<c:otherwise>
					Retrieve.showPanel("login");
				</c:otherwise>
			</c:choose>
		</go:script>
	</body>
</go:html>
