<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="HOME" />

<c:set var="xpath" value="home" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
</c:if>

<c:if test="${param.preload != null}">
	<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
	<c:import url="test_data/home/preload.xml" var="quoteXml" />
	<go:setData dataVar="data" xml="${quoteXml}" />
</c:if>

<core:doctype />
<go:html>

	<core:head quoteType="${xpath}" title="Home Quote Capture" mainCss="common/home.css" mainJs="common/js/home/home.js" />

	<body class="stage-0 ${xpath}">

		<%-- SuperTag Top Code --%>
		<agg:supertag_top type="Home" initialPageName="ctm:quote-form:Home_Contents:Cover Start" />

		<%-- History handler --%>
		<home:history />

		<form:form action="home_quote_results.jsp" method="POST" id="mainform" name="frmMain">

			<form:operator_id xpath="${xpath}/operatorid" />

			<form:header quoteType="home" hasReferenceNo="true" showReferenceNo="false"/>
			<core:referral_tracking vertical="${xpath}" />
			<home:progress_bar />

			<div id="wrapper">
				<div id="page">

					<div id="content">

						<slider:slideContainer className="sliderContainer">

							<slider:slide id="slide0" title="Cover" className="slide">
								<h2>
									Step 1. <span>Tell us what cover you are looking for</span>
								</h2>

								<home:cover_type
									xpath="${xpath}"
									title="Cover"/>

							</slider:slide>

							<slider:slide id="slide1" title="Occupancy" className="slide">
								<h2>
									Step 2. <span>Tell us about who occupies the home</span>
								</h2>

								<home:property_occupancy
									xpath="${xpath}/occupancy"
									title="Occupancy" />

								<home:business_activity
									xpath="${xpath}/businessActivity"
									title="Business Activity" />


							</slider:slide>

							<slider:slide id="slide2" title="Property" className="slide">
								<h2>
									Step 3. <span>Tell us about the property</span>
								</h2>

								<home:property_description
									xpath="${xpath}/property"
									title="Property Description" />

								<home:property_feature
									xpath="${xpath}/property"
									title="Property Features" />

								<home:cover_amounts
									xpath="${xpath}/coverAmounts"
									title="Cover Amounts" />

							</slider:slide>


<%-- TEMPORARY REMOVAL OF SLIDE AS ONLY 2 QUESTIONS WERE LEFT AFTER THE TEMPORARY REMOVAL OF QUESTIONS - MOVED TO SLIDE 3 --%>
<%-- 							<slider:slide id="slide3" title="Condition/Situation" className="slide"> --%>
<!-- 								<h2> -->
<!-- 									Step 4. <span>Tell us about the condition / situation of the property</span> -->
<!-- 								</h2> -->

<%-- 								<home:property_condition --%>
<%-- 									xpath="${xpath}/property" --%>
<%-- 									title="Property Condition" /> --%>

<%-- 								<home:property_situation --%>
<%-- 									xpath="${xpath}/property" --%>
<%-- 									title="Property Situation" /> --%>

<%-- TEMPORARY REMOVAL OF MULTIPLE QUESTIONs WHICH ARE ONLY REQUIRED BY HOLLARD  --%>
<%-- 								<home:property_construction --%>
<%-- 									xpath="${xpath}/property" --%>
<%-- 									title="Property Construction / Renovation" /> --%>

<%-- 							</slider:slide> --%>

							<slider:slide id="slide3" title="You" className="slide">
								<h2>
									Step 4. <span>Tell us about the policy holder(s)</span>
								</h2>

								<home:policy_holder
									xpath="${xpath}/policyHolder"
									title="Policy Holder" />

							</slider:slide>

							<slider:slide id="slide4" title="Disclosures"  className="slide">
								<h2>
									Step 5. <span>Tell us about your previous cover</span>
								</h2>

								<home:disclosures
									xpath="${xpath}/disclosures"
									title="Previous Cover" />

								<home:accept_quote
									xpath="${xpath}"
									title="Website Terms and Conditions"
									className="homecontents_quote_accept" />

							</slider:slide>

<%-- 							<slider:slide id="slide5" title="Get Quote"  className="slide"> --%>
<!-- 								<h2> -->
<!-- 									<span>Step 6.</span> -->
<!-- 								</h2> -->
<%-- 							</slider:slide> --%>

						</slider:slideContainer>

						<slider:slideController className="homeContentsSlideController" id="homeContentsSlideController" />

						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="68" />

						<!-- End main QE content -->
						</div>
						<form:help />

						<div style="height:67px"><!-- empty --></div>

<!-- Temporary removal of Right Hand Side Panel - This will be added later once copy is completed. -->
<!-- 						<div class="right-panel"> -->
<!-- 							<div class="right-panel-top"></div> -->
<!-- 							<div class="right-panel-middle"> -->
<%-- 								<agg:side_panel /> --%>
<!-- 							</div> -->
<!-- 							<div class="right-panel-bottom"></div> -->
<!-- 						</div> -->
<!-- 						<div class="clearfix"></div> -->
					</div>

					<%-- Quote results (default to be hidden) --%>
					<home:results vertical="${xpath}" />
				</div>


	</form:form>

	<home:footer />

	<core:closing_body>
		<agg:includes supertag="true" />
		<home:includes />
	</core:closing_body>
</body>

</go:html>

