<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="CARLMI" />

<c:set var="verticalFeatures" value="car" />
<c:set var="xpath" value="${verticalFeatures}lmi" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<agg:page vertical="${xpath}" formAction="car_brands.jsp">

	<jsp:attribute name="header">
		<core:head quoteType="${xpath}" title="${go:TitleCase(verticalFeatures)} Compare Features" mainCss="common/base.css" mainJs="common/js/features/FeaturesResults.js" />
	</jsp:attribute>

	<jsp:attribute name="body_start">
	<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Features" initVertical="${xpath}" initialPageName="ctm:${go:TitleCase(verticalFeatures)}:LMI:Select" loadExternalJs="true"/>
	</jsp:attribute>

	<jsp:attribute name="form_top">
		<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
		<features:results vertical="${xpath}">
			<jsp:attribute name="topLeftCorner">
				<ui:speechbubble colour="blue" arrowPosition="left" width="200">
					<h6>Compare Prices From Our Participating Providers</h6>
					<a class="btn orange arrow-right block" href="car_quote.jsp?int=C:CF:R:1">Get a Quote</a>
				</ui:speechbubble>
	</jsp:attribute>
		</features:results>
	</jsp:attribute>

	<jsp:attribute name="footer">

		<carlmi:footer />

		<ui:call_to_action_bar
			title="Thank you for using our features comparison"
			sub="Now compare prices from our participating insurance providers"
			disclaimer="Each product in this list may offer different features. This information has been supplied by an independent third party. Please always consider the policy wording and product disclosure statement for each product before making a decision to buy."
			disclosure="<span class='greyBg'><span class='arrowImg'></span></span> Click the arrows for more information about this feature"
			moreBtn="true"
			hiddenInitially="true"
		>
			<jsp:attribute name="callToAction">
				<a class="btn green arrow-right" href="car_quote.jsp?int=C:CF:R:2">Get a Quote</a>
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

<%-- Record a variable in the data bucket so that if the user goes to the car vertical we can track a conversion. --%>
		<go:setData dataVar="data" value="true" xpath="${xpath}/trackConversion" />
	</jsp:attribute>

	<jsp:body>
		<slider:slideContainer className="sliderContainer">
			<carlmi:brand_selection_step />
		</slider:slideContainer>
	</jsp:body>

</agg:page>