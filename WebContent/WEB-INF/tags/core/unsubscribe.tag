<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Unsubscribe page"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />

<c:set var="customerName" ><c:out escapeXml="true" value="${unsubscribe.getCustomerName()}" /></c:set>
<c:set var="emailAddress" ><c:out escapeXml="true" value="${unsubscribe.getCustomerEmail()}" /></c:set>
<c:set var="verticalCode" ><c:out escapeXml="true" value="${unsubscribe.getVertical()}" /></c:set>
<c:set var="isValid" ><c:out escapeXml="true" value="${unsubscribe.isValid()}" /></c:set>

<c:if test="${applicationService.isVerticalEnabledForBrand(pageContext.getRequest(), 'HEALTH')}">
	<c:set var="healthSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), 'HEALTH')}" scope="page"  />
</c:if>

<c:if test="${applicationService.isVerticalEnabledForBrand(pageContext.getRequest(), 'CAR')}">
	<c:set var="carSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), 'CAR')}" scope="page"  />
</c:if>

<c:if test="${applicationService.isVerticalEnabledForBrand(pageContext.getRequest(), 'LIFE')}">
	<c:set var="lifeSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), 'LIFE')}" scope="page"  />
</c:if>

<c:if test="${applicationService.isVerticalEnabledForBrand(pageContext.getRequest(), 'TRAVEL')}">
	<c:set var="travelSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), 'TRAVEL')}" scope="page"  />
</c:if>

<c:if test="${applicationService.isVerticalEnabledForBrand(pageContext.getRequest(), 'FUEL')}">
	<c:set var="fuelSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), 'FUEL')}" scope="page"  />
</c:if>

<c:if test="${applicationService.isVerticalEnabledForBrand(pageContext.getRequest(), 'UTILITIES')}">
	<c:set var="utilsSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), 'UTILITIES')}" scope="page"  />
</c:if>

<%--
This is the default unsubcribe page for compare the market
--%>

 
<go:log level="DEBUG" source="core:unsubscribe">isValid: ${isValid}</go:log>

<go:log>
Email: ${email}
</go:log>

<%-- HTML --%>
<!DOCTYPE html>
<go:html>

	<core:head quoteType="false"
					title="Unsubscribe" nonQuotePage="${true}"
					form="unsubscribeForm"
					errorContainer="#errorContainer"
					mainCss="common/unsubscribe.css" />

	<body class="CTM">
		<go:script href="common/js/core/unsubscribe.js" />
		<%-- SuperTag Top Code --%>
		<agg:supertag_top
				type="Unsubscribe"
				initialPageName="Unsubscribe"
				initVertical="${verticalCode}" />
		<social:fb_root />

		<form:form action="" method="POST" id="unsubscribeForm" name="unsubscribeForm">

			<div id="wrapper">
				<form:header quoteType="false" hasReferenceNo="false"/>
				<div id="headerShadow"></div>

				<div id="page">

					<div class="unsubscribe">
						<div class="unsubscribeContainer">
							<div class="left-column">
	<c:choose>
									<%-- EMAIL VERIFICATION FAILED --%>
									<c:when test="${!isValid}">
										<div class="blue-bar"><h1>Unsubscribe unsuccessful</h1></div>
										<div class="content">
											<p class="first">We are sorry but we have not been able to verify your email address.</p>
										</div>
		</c:when>

									<%-- EMAIL VERIFICATION SUCCEEDED --%>
									<c:otherwise>

										<div class="blue-bar"><img src="brand/ctm/images/icons/broken-heart.png" alt="Broken heart"><h1>You're leaving?!</h1></div>

										<div class="content unsubscribeTemplatePlaceholder">
											<p>We're sorry to see you go<strong> ${customerName}</strong>... we'll miss you!</p>
											<p>If you're sure you'd like to unsubscribe <c:if test="${not empty emailAddress}">(<span class="link">${emailAddress}</span>)</c:if> from our email updates, then you can do so by clicking the "Unsubscribe Me" button below.</p>										

											<c:if test="${not empty vertical}">
												<ui:button mainClass="unsubscribe-button vertical">Unsubscribe from ${go:TitleCase(fn:toLowerCase(vertical))} emails</ui:button>
											</c:if>
											<ui:button mainClass="unsubscribe-button">Unsubscribe me</ui:button>
											<c:set var="exitURL" value="${pageSettings.getSetting('exitUrl')}" />
											<ui:button mainClass="cancel-unsubscribe" theme="blue" href="${exitURL}">Cancel</ui:button>
										</div>

										<c:set var="onClose">
											window.location="${exitURL}";
										</c:set>
										<ui:dialog id="unsubscribeFeedback" width="600" title="You have successfully unsubscribed" onClose="${onClose}">
											<p>Please note that it may take <strong>up to 72hrs</strong> to remove you from our system.</p>
											
											<%-- The following content is for CTM only, for whitelabel the following areas are to be blank. --%>
											<c:if test="${pageSettings.getBrandCode() eq 'ctm'}">

											<div class="left-column">
													
												<div>
													<div class="blue-bar">Compare</div>
													<ul class="compare-buttons">
															
															<c:if test="${not empty healthSettings}">
														<li class="green health"><a title="Compare Health Insurance" href="${healthSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Health Insurance</span></div></a></li>
															</c:if>
															<c:if test="${not empty carSettings}">
														<li class="blue car"><a title="Compare Car Insurance" href="${carSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Car Insurance</span></div></a></li>
															</c:if>
															<c:if test="${not empty lifeSettings}">
														<li class="blue life"><a title="Compare Life Insurance" href="${lifeSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Life Insurance</span></div></a></li>
															</c:if>
															<c:if test="${not empty travelSettings}">
														<li class="green travel"><a title="Compare Travel Insurance" href="${travelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Travel Insurance</span></div></a></li>
															</c:if>
															<c:if test="${not empty fuelSettings}">
														<li class="green fuel"><a title="Compare Fuel Prices"  href="${fuelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Fuel</span></div></a></li>
															</c:if>
															<c:if test="${not empty utilsSettings}">
														<li class="blue utilities"><a title="Compare Energy Prices"  href="${utilsSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Energy</span></div></a></li>
															</c:if>
													</ul>
												</div>
											</div>

											<div class="right-column">
												<div class="blue-bar">Stay in touch</div>
												<div class="content social">
													<social:fb_like href="https://www.facebook.com/Comparethemarket.com.au" font="segoe ui" send="false" show_faces="true" width="200"/>
													<a href="http://www.facebook.com/comparethemarket.com.au" title="Find us on Facebook"><img src="common/images/social/find_us_on_fb.gif" alt="Find Us on Facebook Button" /></a>
												</div>
											</div>
											<core:clear />

											</c:if>

										</ui:dialog>


										<%-- JAVASCRIPT --%>
										<go:script marker="onready">
											Unsubscribe.init();
</go:script>
									</c:otherwise>
								</c:choose>


							</div>
							<%-- The following content is for CTM only, for whitelabel the following areas are to be blank. --%>
							<c:if test="${pageSettings.getBrandCode() eq 'ctm'}">
							<div class="right-column">

								<div class="blue-bar"><h1>Compare</h1></div>
								<ul class="compare-buttons">
										<c:if test="${not empty healthSettings}">
									<li class="green health"><a title="Compare Health Insurance" href="${healthSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Health Insurance</span></div></a></li>
										</c:if>
										<c:if test="${not empty carSettings}">
									<li class="blue car"><a title="Compare Car Insurance" href="${carSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Car Insurance</span></div></a></li>
										</c:if>
										<c:if test="${not empty lifeSettings}">
									<li class="blue life"><a title="Compare Life Insurance" href="${lifeSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Life Insurance</span></div></a></li>
										</c:if>
										<c:if test="${not empty travelSettings}">
									<li class="green travel"><a title="Compare Travel Insurance" href="${travelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Travel Insurance</span></div></a></li>
										</c:if>
										<c:if test="${not empty fuelSettings}">
									<li class="green fuel"><a title="Compare Fuel Prices"  href="${fuelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Fuel</span></div></a></li>
										</c:if>
										<c:if test="${not empty utilsSettings}">
									<li class="blue utilities"><a title="Compare Energy Prices"  href="${utilsSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Energy</span></div></a></li>
										</c:if>
								</ul>
								</c:if>
							</div>
						</div>
					</div>

				</div>

			</div>

		</form:form>

		<agg:generic_footer />

		<core:closing_body>
			<agg:includes
				kampyle="false"
				sessionPop="false"
				supertag="true" />
<go:style marker="css-head">
				body.CTM {
					overflow:scroll;
	} 

	#page {
		min-height:550px;
	}
</go:style>
		</core:closing_body>
	
	</body>
</go:html>