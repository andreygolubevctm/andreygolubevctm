<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="HOMELMI" />

<c:set var="verticalFeatures" value="home" />
<c:set var="xpath" value="${verticalFeatures}lmi" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />



<agg:page vertical="${xpath}" formAction="home_brands.jsp">

	<jsp:attribute name="header">
		<core:head quoteType="${xpath}" title="${go:TitleCase(verticalFeatures)} Compare Features" mainCss="common/base.css" mainJs="common/js/features/FeaturesResults.js" />
	</jsp:attribute>

	<jsp:attribute name="body_start">
		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Features" initVertical="${xpath}" initialPageName="ctm:${go:TitleCase(verticalFeatures)}:LMI:Select" loadExternalJs="true"/>
	</jsp:attribute>

	<jsp:attribute name="form_top">
		<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
		<core:referral_tracking vertical="${xpath}" />
	</jsp:attribute>


	<jsp:attribute name="form_bottom">
		<features:results vertical="${xpath}" />
	</jsp:attribute>

	<jsp:attribute name="footer">

		<homelmi:footer />

<%-- 		TEMPORARY CHANGE TO CALL TO ACTION FOR COMPLIANCE. THIS WILL BE REVERSED--%>
<%-- 			title="Thank you for using our features comparison" --%>
<%-- 			sub="Now compare prices from our participating insurance providers" --%>
		<ui:call_to_action_bar
			title="Thank you for using our features comparison."
			sub="Now compare prices from our participating insurance providers"
			disclaimer="Each product in this list may offer different features. This information has been supplied by an independent third party. Please always consider the policy wording and product disclosure statement for each product before making a decision to buy. For more information about our features comparison tool, <a href='#footer'>please see our disclaimer</a>."
			disclosure="<span class='greyBg'><span class='arrowImg'></span></span> Click the arrows for more information about this feature"
			moreBtn="true"
			hiddenInitially="true"
		>
			<jsp:attribute name="callToAction">
				<a class="btn green arrow-right" id="${xpath}_signup" href="home_contents_quote.jsp">Get a Quote</a>
			</jsp:attribute>
		</ui:call_to_action_bar>

		<agg:includes supertag="true" />

		<go:script marker="onready">
			Track._transactionID = '${data.current.transactionId}';
		</go:script>

		<go:script marker="js-href"	href="common/js/jquery.ba-hashchange.min.js"/>

		<go:script marker="onready">
			// If the user is clicking browser back button, ensure that the navigation is showing
			// TODO: make this generic across verticals
			$(window).hashchange( function() {
				if (QuoteEngine.getOnResults() && $.address.parameter("stage") == 'start'){
					$('.compareBackButton').click();
				}
				QuoteEngine.setOnResults(location.hash.indexOf("result") > -1);
			})



		</go:script>

		<%-- Record a variable in the data bucket so that if the user goes to the home vertical we can track a conversion. --%>
		<go:setData dataVar="data" value="true" xpath="${xpath}/trackConversion" />
	</jsp:attribute>

	<jsp:body>
		<slider:slideContainer className="sliderContainer">
			<homelmi:brand_selection_step />
		</slider:slideContainer>
	</jsp:body>

</agg:page>

