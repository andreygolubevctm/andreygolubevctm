<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Unsubscribe page"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
This is the default unsubcribe page for compare the market
--%>
<%@ attribute name="brand" required="true"	rtexprvalue="true"	description="brand to unsubscribe in the database" %>

<%-- params --%>
<c:set var="email" value="${data.unsubscribe.email}" />
<c:set var="hashedEmail" value="${data.unsubscribe.hashedEmail}" />
<c:set var="emailJson" value="${data.unsubscribe.emailJson}" />
<c:set var="vertical" value="${data.unsubscribe.vertical}" />
<c:set var="DISC" value="${data.unsubscribe.DISC}" />
 
<%-- HTML --%>
<!DOCTYPE html>
<go:html>

	<core:head quoteType="false"
					title="Unsubscribe" nonQuotePage="${true}"
					form="unsubscribeForm"
					errorContainer="#errorContainer"
					mainCss="common/unsubscribe.css" />

	<body class="CTM">
		<go:script href="/${data.settings.styleCode}/common/js/core/unsubscribe.js" />
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
											<c:set var="rootUrl"><core:get_setting brand="ctm" application="car" setting="root-url" /></c:set>
											<ui:button mainClass="cancel-unsubscribe" theme="blue" href="${rootUrl}">Cancel</ui:button>
										</core:js_template>

										<c:set var="onClose">
											window.location="${rootUrl}";
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
														<li class="green health"><a title="Compare Health Insurance" href="<core:get_setting brand="ctm" application="health" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Health Insurance</span></div></a></li>
														<li class="blue car"><a title="Compare Car Insurance" href="<core:get_setting brand="ctm" application="car" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Car Insurance</span></div></a></li>
														<li class="blue life"><a title="Compare Life Insurance" href="<core:get_setting brand="ctm" application="life" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Life Insurance</span></div></a></li>
														<li class="green travel"><a title="Compare Travel Insurance" href="<core:get_setting brand="ctm" application="travel" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Travel Insurance</span></div></a></li>
														<li class="green fuel"><a title="Compare Fuel Prices"  href="<core:get_setting brand="ctm" application="fuel" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Fuel</span></div></a></li>
														<li class="blue utilities"><a title="Compare Energy Prices"  href="<core:get_setting brand="ctm" application="utilities" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Energy</span></div></a></li>
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
													<c:choose>
														<c:when test="${DISC eq 'true'}">
															var emailData = ${emailJson};
															var dat = "hashedEmail=" + emailData.hashedEmail + "&brand=${brand}";
														</c:when>
														<c:otherwise>
															var dat = "hashedEmail=${hashedEmail}&brand=${brand}";
														</c:otherwise>
													</c:choose>
											Unsubscribe.init(${emailJson} , dat, '${vertical}');
</go:script>
									</c:otherwise>
								</c:choose>


							</div>

							<div class="right-column">

								<div class="blue-bar"><h1>Compare</h1></div>
								<ul class="compare-buttons">
									<li class="green health"><a title="Compare Health Insurance" href="<core:get_setting brand="ctm" application="health" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Health Insurance</span></div></a></li>
									<li class="blue car"><a title="Compare Car Insurance" href="<core:get_setting brand="ctm" application="car" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Car Insurance</span></div></a></li>
									<li class="blue life"><a title="Compare Life Insurance" href="<core:get_setting brand="ctm" application="life" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Life Insurance</span></div></a></li>
									<li class="green travel"><a title="Compare Travel Insurance" href="<core:get_setting brand="ctm" application="travel" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Travel Insurance</span></div></a></li>
									<li class="green fuel"><a title="Compare Fuel Prices"  href="<core:get_setting brand="ctm" application="fuel" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Fuel</span></div></a></li>
									<li class="blue utilities"><a title="Compare Energy Prices"  href="<core:get_setting brand="ctm" application="utilities" setting="exit-url" />"><div class="icon"></div><div class="icontext"><span>Energy</span></div></a></li>
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
				supertag="false" />
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