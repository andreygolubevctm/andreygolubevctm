<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Start fresh quote, on refresh --%>
<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="quote" />
	<go:setData dataVar="data" value="*DELETE" xpath="ranking" />
</c:if>

<%-- Import the data on 'action' --%>
<c:if test="${param.action != 'latest' and param.action != 'amend'}">
	<go:setData dataVar="data" value="${param.ccad}" xpath="quote/ccad" />
</c:if>

<c:set var="xpath" value="quote" />
<c:set var="quoteType" value="carlmi" />

<core:load_settings conflictMode="false" vertical="carlmi" />

<c:set var="xpath" value="carlmi" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty param.action && param.preload == '2'}">
	<c:choose>
		<c:when test="${param.xmlFile != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="testing/data/${param.xmlFile}" var="quoteXml" />
			<go:setData dataVar="data" xml="${quoteXml}" />
		</c:when>
		<c:when test="${param.xmlData != null}">
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<go:setData dataVar="data" xml="${param.xmlData}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="test_data/car/preload_lmi.xml" var="quoteXml" />
			<go:setData dataVar="data" xml="${quoteXml}" />
		</c:otherwise>
	</c:choose>
</c:if>

<core:doctype />
<go:html>
<core:head quoteType="${quoteType}" title="Car Compare Features" mainCss="common/base.css" mainJs="common/js/carlmi/carlmi.js" />

<body class="engine stage-0 ${xpath}">

	<%-- SuperTag Top Code --%>
	<agg:supertag_top type="CarLMI" initialPageName="ctm:Car:LMI:Select" loadExternalJs="true"/>


	<%-- Loading popup holder --%>
	<quote:loading />

	<%-- Transferring popup holder --%>
	<quote:transferring />


	<go:style marker="css-head">

		/* CSS Overrides to match design */

		#wrapper{
			box-shadow:none;
		}

		#content{
			width:980px;
		}

		#qe-wrapper{
			padding-top:0;
		}

		#qe-wrapper .scrollable{
			width:980px;
		}

		.normal-header{
			height:auto;
		}

	</go:style>

	<form:form action="car_brands.jsp" method="POST" id="mainform" name="frmMain">

		<form:header quoteType="${quoteType}" hasReferenceNo="true" showReferenceNo="false"/>

		<div id="wrapper">
			<div id="page">

				<div id="content" class="">

					<!-- Main Quote Engine content -->
					<slider:slideContainer className="sliderContainer">

						<carlmi:brand_selection_step />

					</slider:slideContainer>

					<!-- End main QE content -->
				</div>
				<form:help />

			</div>

			<%-- Quote results (default to be hidden) --%>
			<carlmi:results vertical="${quoteType}" />

		</div>

		<ui:call_to_action_bar
			title="Thank you for using our features comparison"
			sub="Now compare prices from our participating insurance providers"
			action="Get a Quote"
			disclaimer="Each product in this list may offer different features. This information has been supplied by an independent third party. Please always consider the policy wording and product disclosure statement for each product before making a decision to buy."
			disclosure="<span class='greyBg'><span class='arrowImg'></span></span> Click the arrows for more information about this feature"
			moreBtn="true"
			hiddenInitially="true"
		/>

		<carlmi:footer />

		<%-- Results conditions popup --%>
		<quote:results_terms />

	</form:form>

	<%-- Copyright notice --%>
	<agg:copyright_notice />

	<%-- Kamplye Feedback --%>
	<core:kampyle formId="85272" />

	<%-- Dev Environment
		<agg:dev_tools rootPath="${quoteType}" />--%>

	<core:session_pop />
	<agg:supertag_bottom />

	<%-- Dialog for rendering fatal errors --%>
	<form:fatal_error />

</body>

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
<go:setData dataVar="data" value="true" xpath="carlmi/trackConversion" />

</go:html>

