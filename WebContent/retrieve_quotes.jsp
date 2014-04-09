<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<c:set var="xpath" value="retrieve_quotes" scope="session" />

<core:load_settings conflictMode="false"/>

<c:set var="_hashedEmail"><c:out value="${param.hashedEmail}" escapeXml="true"/></c:set>
<c:set var="_email"><c:out value="${param.email}" escapeXml="true"/></c:set>


<c:if test="${not empty _hashedEmail}">
	<security:authentication
		emailAddress="${_email}"
		password="${param.password}"
		hashedEmail="${_hashedEmail}"
		brand="CTM" />

	<go:setData dataVar="data" xpath="userData/authentication/validCredentials" value="${userData.validCredentials}" />
	<go:setData dataVar="data" xpath="userData/authentication/emailAddress" value="${userData.emailAddress}" />
	<go:setData dataVar="data" xpath="userData/emailAddress" value="${userData.emailAddress}" />
	<%--TODO: remove this once we are away from disc --%>
	<go:setData dataVar="data" xpath="userData/authentication/password" value="${userData.password}" />
	<c:if test="${not empty userData && userData.validCredentials}">
		<go:setData dataVar="data" value="*LOCK" xpath="userData" />
		<c:redirect url="${data['settings/root-url']}${data.settings.styleCode}/retrieve_quotes.jsp"/>
	</c:if>
</c:if>

<core:doctype />
<go:html>


	<core:head quoteType="false" title="Retrieve Your Quotes" nonQuotePage="${true}" form="retrieveQuoteForm" errorContainer="#errorContainer"/>


	<body class="retrieve">

		<agg:supertag_top type="Car" initialPageName="Retrieve Your Quotes"/>

		<go:setData dataVar="data" xpath="login" value="*DELETE" />
		
		<form:form action="retrieve_quotes.jsp" method="POST" id="retrieveQuoteForm" name="retrieveQuoteForm" autoComplete="on">
		
			<div id="wrapper">		
				<form:header quoteType="false" hasReferenceNo="false" />
				<core:referral_tracking vertical="${xpath}" />
				<div id="headerShadow"></div>
				
				<div id="page">
					<div id="content">
						<c:choose>
							<c:when test="${not empty data.userData && not empty data.userData.authentication && data.userData.authentication.validCredentials}">
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
									<div class="quote-row editable[#=editable#]" id="health_quote_[#=id#]" data-pendingid="[#=pendingID#]">
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
											<div class="quote-pending"><a href="javascript:void(0);" class="tinybtn"><span>In processing</span></a></div>
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
								
								<core:js_template id="home_contents_quote">
									<div class="quote-row" id="home-contents_quote_[#=id#]">
										<div class="quote-date-time">
											<span class="quote-date">[#= quoteDate #]</span>
											<span class="quote-time">[#= quoteTime #]</span>
											<span class="transactionId">Ref: [#= id #]</span>
										</div>

										<div class="quote-details">
											<span class="title">Home and Contents Insurance Quote</span>
											<span class="address">Address: [#=property.address.fullAddress#]</span>
											<span class="homeValue"><span class="label">Home Value: </span>[#=coverAmounts.rebuildCostentry#]</span>
											<span class="contentsValue"><span class="label">Contents Value: </span>[#=coverAmounts.replaceContentsCostentry#]</span>
<!-- 											<span class="premium"><span class="label">Premium: </span>[#=content.premium#]</span> -->
										</div>

										<div class="quote-options">
											<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest Results</span></a></div>
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
				 
				
			</div>
			
		</form:form>
		
		<agg:generic_footer />

		<core:closing_body>
			<agg:includes kampyle="false" sessionPop="false" supertag="true" />
			<core:retrieve_quotes/>
							
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

		</core:closing_body>

	</body>
</go:html>