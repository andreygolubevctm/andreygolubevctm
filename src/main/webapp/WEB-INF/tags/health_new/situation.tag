<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- Set A/B test flag j=2 --%>
<c:set var="showOptIn" value="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 2)}" scope="request" />

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<form_new:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_new_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<simples:dialogue id="19" vertical="health" />
			<simples:dialogue id="20" vertical="health" />
			<simples:dialogue id="0" vertical="health" className="red">
				<div class="row">
					<div class="col-sm-12">
						<field_new:array_radio xpath="health/simples/contactType" items="outbound=Outbound quote,inbound=Inbound quote,followup=Follow up call,callback=Chat callback" required="true" title="contact type (outbound/inbound/followup/callback)" />
					</div>
				</div>
			</simples:dialogue>
			<simples:dialogue id="21" vertical="health" mandatory="true" /> <%-- 3 Point Security Check --%>
			<simples:dialogue id="36" vertical="health" mandatory="true" className="hidden simples-privacycheck-statement" /> <%-- Inbound --%>
			<simples:dialogue id="25" vertical="health" mandatory="true" className="hidden follow-up-call" /> <%-- Follow up call --%>

			<form_new:fieldset legend="" postLegend="">

				<c:set var="fieldXpath" value="${xpath}/healthCvr" />
				<form_new:row label="You are a" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthCvr" className="health-situation-healthCvr" required="true" title="situation you are in" />
				</form_new:row>

				<%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

				<c:set var="fieldXpath" value="${xpath}/location" />
				<c:set var="state" value="${data['health/situation/state']}" />
				<c:set var="location" value="${data['health/situation/location']}" />

				<form_new:row label="Living in" fieldXpath="${fieldXpath}">

					<c:choose>
						<c:when test="${not empty param.state || (not empty state && empty location && (param.action == 'amend' || param.action == 'load'))}">
							<field:state_select xpath="${xpath}/state" useFullNames="true" title="State" required="true" />
						</c:when>
						<c:otherwise>
							<field_new:lookup_suburb_postcode xpath="${fieldXpath}" required="true" placeholder="Suburb / Postcode" extraDataAttributes=" data-rule-validateLocation='true' " />
							<field:hidden xpath="${xpath}/state" />
						</c:otherwise>
					</c:choose>

					<field:hidden xpath="${xpath}/suburb" />
					<field:hidden xpath="${xpath}/postcode" />


				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/healthSitu" />
				<form_new:row label="Looking to" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthSitu" className="health-situation-healthSitu" required="true" title="reason you are looking to quote" />
				</form_new:row>

				<%-- Moved from details page. To keep the same xpath we have to manually setup them again --%>
				<c:set var="xpath_hlthcvr" value="${pageSettings.getVerticalCode()}/healthCover" />
				<c:set var="name_hlthcvr" value="${go:nameFromXpath(xpath_hlthcvr)}" />
				<c:set var="name" value="${go:nameFromXpath(xpath)}" />


				<c:set var="fieldXpath" value="${xpath_hlthcvr}/primary/dob" />
				<form_new:row label="Your date of birth" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
					<field_new:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
				</form_new:row>

				<c:set var="fieldXpath" value="${xpath_hlthcvr}/primary/cover" />
				<form_new:row label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name_hlthcvr}_primaryCover">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="if you currently hold private health insurance" required="true" id="${name_hlthcvr}_health_cover"/>
				</form_new:row>

				<%-- Medicare card question --%>
				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/cover" />
					<form_new:row label="Do all people to be covered on this policy have a green or blue Medicare card?" fieldXpath="${fieldXpath}" className="health_situation_medicare">
						<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover" additionalAttributes="data-rule-isCheckedYes='true' data-msg-isCheckedYes='Unfortunately we cannot continue with your quote'" />
					</form_new:row>
				</c:if>

				<%-- A/B test j=2 --%>
				<c:if test="${showOptIn}">
					<c:set var="termsAndConditions">
						<%-- PLEASE NOTE THAT THE MENTION OF COMPARE THE MARKET IN THE TEXT BELOW IS ON PURPOSE --%>
						I understand <content:optin key="brandDisplayName" useSpan="true"/> compares health insurance policies from a range of
						<a href='<content:get key="participatingSuppliersLink"/>' target='_blank'>participating suppliers</a>.
						By providing my contact details I agree that <content:optin useSpan="true" content="comparethemarket.com.au"/> may contact me, during the Call Centre <a href="javascript:;" data-toggle="dialog" data-content="#view_all_hours" data-dialog-hash-id="view_all_hours" data-title="Call Centre Hours" data-cache="true">opening hours</a>, about the services they provide.
						I confirm that I have read the <form:link_privacy_statement />.
					</c:set>

					<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
					<form_new:row className="health-contact-details-optin-group" hideHelpIconCol="true">
						<field_new:checkbox
								xpath="${xpath}/optin"
								value="Y"
								className="validate"
								required="true"
								label="${true}"
								title="${termsAndConditions}"
								errorMsg="Please agree to the Terms &amp; Conditions" />
					</form_new:row>
				</c:if>

				</form_new:fieldset>

				<simples:dialogue id="22" vertical="health" />

				<%-- Health benefits has simples messages --%>
				<simples:dialogue id="23" vertical="health" className="green" >
					<div style="margin-top:20px;">
						<a href="javascript:;"  data-benefits-control="Y" class="btn btn-form">Open Benefits</a>
					</div>
				</simples:dialogue>

		</jsp:body>

	</form_new:fieldset_columns>
</div>