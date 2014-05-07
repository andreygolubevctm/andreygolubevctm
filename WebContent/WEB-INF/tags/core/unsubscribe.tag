<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Unsubscribe page"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="healthSettings" value="${applicationService.setVerticalAndGetSettingsForPage(pageContext, 'HEALTH')}" scope="page"  />
<c:set var="carSettings" value="${applicationService.setVerticalAndGetSettingsForPage(pageContext, 'CAR')}" scope="page"  />
<c:set var="lifeSettings" value="${applicationService.setVerticalAndGetSettingsForPage(pageContext, 'LIFE')}" scope="page"  />
<c:set var="travelSettings" value="${applicationService.setVerticalAndGetSettingsForPage(pageContext, 'TRAVEL')}" scope="page"  />
<c:set var="fuelSettings" value="${applicationService.setVerticalAndGetSettingsForPage(pageContext, 'FUEL')}" scope="page"  />
<c:set var="utilsSettings" value="${applicationService.setVerticalAndGetSettingsForPage(pageContext, 'UTILITIES')}" scope="page"  />

<%--
This is the default unsubcribe page for compare the market
--%>
<%@ attribute name="brand" required="true"	rtexprvalue="true"	description="brand to unsubscribe in the database" %>

<go:log level="DEBUG" source="core:unsubscribe">Email: ${email}</go:log>
 
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
				initVertical="${unsubscribeData.unsubscribe.vertical}" />
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
									<c:when test="${email eq 'false'}">
										<div class="blue-bar"><h1>Unsubscribe unsuccessful</h1></div>
										<div class="content">
											<p class="first">We are sorry but we have not been able to verify your email address.</p>
										</div>
		</c:when>

									<%-- EMAIL VERIFICATION SUCCEEDED --%>
									<c:otherwise>

										<div class="blue-bar"><img src="brand/ctm/images/icons/broken-heart.png" alt="Broken heart"><h1>You're leaving?!</h1></div>

										<div class="content unsubscribeTemplatePlaceholder">

										</div>

										<%-- UNSUBSCRIBE TEMPLATE --%>
										<core:js_template id="unsubscribe-template">
											<p>We're sorry to see you go<strong>[#= name #]</strong>... we'll miss you!</p>
											<p>If you're sure you'd like to unsubscribe (<span class="link">[#= emailAddress #]</span>) from our email updates, then you can do so by clicking the "Unsubscribe Me" button below.</p>
											<p>Thanks for comparing with us and hopefully we'll still see you around at <a href="http://www.comparethemarket.com.au" class="link" title="Compare the Market">www.comparethemarket.com.au</a> to help out with your insurance needs.</p>

											<c:if test="${not empty vertical}">
												<ui:button mainClass="unsubscribe-button vertical">Unsubscribe from ${go:TitleCase(fn:toLowerCase(vertical))} emails</ui:button>
											</c:if>
											<ui:button mainClass="unsubscribe-button">Unsubscribe me</ui:button>
											<c:set var="exitURL" value="${pageSettings.getSetting('exitUrl')}" />
											<ui:button mainClass="cancel-unsubscribe" theme="blue" href="${exitURL}">Cancel</ui:button>
										</core:js_template>

										<c:set var="onClose">
											window.location="${exitURL}";
										</c:set>
										<ui:dialog id="unsubscribeFeedback" width="600" title="You have successfully unsubscribed" onClose="${onClose}">
											<p>Your unsubscribe from our email updates has been processed. Please note that it may take <strong>up to 72hrs</strong> for our entire systems to be completely updated.</p>
											<p>Compare The Market. Where we love to compare.</p>
											<div class="left-column">
												<%--
												<div class="blue-bar">Give us some feedback</div>
												<div class="content">
													<p><strong>We are sorry to see you go!</strong></p>
													<p>If you have a minute, please let us know why you unsubscribed</p>
													<field:array_radio items="no_longer=I am no longer interested,too_many=I receive too many emails,dont_like=I don't like the emails I receive,did_not_signup=I did not sign up for emails,other=Other" xpath="feedback" title="" required="true"></field:array_radio>
													<core:clear />
													<ui:button mainClass="send-feedback">Send feedback</ui:button>
												</div>
												--%>
												<div>
													<div class="blue-bar">Compare</div>
													<ul class="compare-buttons">
														<li class="green health"><a title="Compare Health Insurance" href="${healthSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Health Insurance</span></div></a></li>
														<li class="blue car"><a title="Compare Car Insurance" href="${carSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Car Insurance</span></div></a></li>
														<li class="blue life"><a title="Compare Life Insurance" href="${lifeSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Life Insurance</span></div></a></li>
														<li class="green travel"><a title="Compare Travel Insurance" href="${travelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Travel Insurance</span></div></a></li>
														<li class="green fuel"><a title="Compare Fuel Prices"  href="${fuelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Fuel</span></div></a></li>
														<li class="blue utilities"><a title="Compare Energy Prices"  href="${utilsSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Energy</span></div></a></li>
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
										</ui:dialog>


										<%-- JAVASCRIPT --%>
										<go:script marker="onready">
											var emailData = ${emailJson};
													<c:choose>
														<c:when test="${DISC eq 'true'}">
															var dat = "hashedEmail=" + emailData.hashedEmail + "&brand=${brand}";
														</c:when>
														<c:otherwise>
															var dat = "hashedEmail=${hashedEmail}&brand=${brand}";
														</c:otherwise>
													</c:choose>
											Unsubscribe.init(emailData , dat, '${vertical}');
</go:script>
									</c:otherwise>
								</c:choose>


							</div>

							<div class="right-column">

								<div class="blue-bar"><h1>Compare</h1></div>
								<ul class="compare-buttons">
									<li class="green health"><a title="Compare Health Insurance" href="${healthSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Health Insurance</span></div></a></li>
									<li class="blue car"><a title="Compare Car Insurance" href="${carSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Car Insurance</span></div></a></li>
									<li class="blue life"><a title="Compare Life Insurance" href="${lifeSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Life Insurance</span></div></a></li>
									<li class="green travel"><a title="Compare Travel Insurance" href="${travelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Travel Insurance</span></div></a></li>
									<li class="green fuel"><a title="Compare Fuel Prices"  href="${fuelSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Fuel</span></div></a></li>
									<li class="blue utilities"><a title="Compare Energy Prices"  href="${utilsSettings.getSetting('exitUrl')}"><div class="icon"></div><div class="icontext"><span>Energy</span></div></a></li>
								</ul>

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