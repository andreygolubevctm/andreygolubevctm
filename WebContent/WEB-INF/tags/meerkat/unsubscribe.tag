<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Unsubscribe page"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	This is the unsubscribe page for compare the meerkat
--%>
<%@ attribute name="brand" required="true"	rtexprvalue="true"	description="brand to unsubscribe in the database" %>

<%-- params --%>
<c:set var="email" value="${data.unsubscribe.email}" />
<c:set var="hashedEmail" value="${data.unsubscribe.hashedEmail}" />
<c:set var="emailJson" value="${data.unsubscribe.emailJson}" />
<c:set var="vertical" value="${data.unsubscribe.vertical}" />

<%-- HTML --%>
<!DOCTYPE html>
<go:html>

	<core:head quoteType="false"
					title="Unsubscribe" nonQuotePage="${true}"
					form="unsubscribeForm"
					errorContainer="#errorContainer"
					mainCss="common/unsubscribe.css" />
	<body>
		<go:script href="/${data.settings.styleCode}/common/js/core/unsubscribe.js" />
		<%-- SuperTag Top Code --%>
		<agg:supertag_top
				type="Unsubscribe"
				initialPageName="Unsubscribe"
				initVertical="${data.unsubscribe.vertical}" />

		<form:form action="" method="POST" id="unsubscribeForm" name="unsubscribeForm">

			<div id="wrapper">
				<form:header quoteType="false" hasReferenceNo="false"/>
				<div id="headerShadow"></div>

				<div id="page">

					<div class="unsubscribe">
						<div class="unsubscribeContainer">
						<div class="left-column">
							<div class="alexanderImage">
								<a href="http://www.comparethemarket.com.au/health-insurance">
									<img  alt="health" src="brand/ctm/meerkat/aleksandr.png" width="134" height="269">
								</a>
							</div>
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

										<div class="content unsubscribeTemplatePlaceholder">

										</div>

										<%-- UNSUBSCRIBE TEMPLATE --%>
										<core:js_template id="unsubscribe-template">
											<p><span class="unsubscribeName" ><strong>[#= name #]</strong>, </span> I am in deep sorrows to hear you no longer delighted by my witty newsletter.
											Was it somethings I said?</p>
											<p>If you still want to unsubscribe <span class="link">[#= emailAddress #]</span> from email-amabob list, please click “unsubscribe me” buttons below.</p>
											<p>In the meantime I will figure out how to break sad news to Sergei.</p>

											<ui:button mainClass="unsubscribe-button vertical">Unsubscribe me</ui:button>
												<ui:button mainClass="cancel-unsubscribe" theme="blue" href="http://www.comparethemeerkat.com.au">Cancel</ui:button>
										</core:js_template>

										<c:set var="onClose">
											window.location="http://www.comparethemeerkat.com.au";
										</c:set>
										<ui:dialog id="unsubscribeFeedback" width="600" title="You have successfully unsubscribed" onClose="${onClose}">
											<p>Your unsubscribe from our email updates has been processed. Please note that it may take <strong>up to 72hrs</strong> for our entire systems to be completely updated.</p>
											<core:clear />
										</ui:dialog>


										<%-- JAVASCRIPT --%>
										<go:script marker="onready">
											var dat = "hashedEmail=${hashedEmail}&brand=${brand}";
											Unsubscribe.init(${emailJson} , dat, '${vertical}');
										</go:script>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="right-column">
								<a href="http://www.comparethemarket.com.au/health-insurance">
									<img src="brand/ctm/meerkat/ctm-health-advert.png" class="crossSell" width="218" height="300">
								</a>
							</div>
						</div>
					</div>

				</div>

			</div>

		</form:form>

		<agg:generic_footer scrapeId="134" includeCopyRight="${false}"/>

		<core:closing_body>
			<agg:includes
				kampyle="false"
				sessionPop="false"
				supertag="true" />
		</core:closing_body>

		<go:style marker="css-head">
			#footer {
				background: #FFFFFF;
					border-top: none;
					border-bottom: none;
					line-height: 110%;
					padding: 10px 40px 25px 40px;
					position: relative;
			}
			.normal-header h1 a {
				background: transparent url('brand/ctm/meerkat/meerkat-logo.png') no-repeat top left;
				height: 72px;
				width: 420px;
				display: block;
				text-indent: -9999px;
			}

			.unsubscribeName {
				display : none;
			}
			.alexanderImage {
				float : left;
			}

			.crossSell {
				float : right;
			}

			body {
				color: #4a4f51;
				font-size: 12px;
				font-family: arial, sans-serif;
				background-image: none;
				background-repeat: repeat;
			}
		</go:style>

	</body>
</go:html>