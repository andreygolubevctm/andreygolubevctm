<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="callCentreHoursBubble" scope="request"><content:getOpeningHoursBubble /></c:set>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<form_new_layout:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<c:if test="${not empty callCentreNumber}">
				<health_content:call_centre_help />
				${callCentreHoursBubble}
			</c:if>
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

			<form_new:fieldset legend="About you">

				<c:set var="fieldXpath" value="${xpath}/healthCvr" />
				<form_new_layout:row label="I am" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthCvr" className="health-situation-healthCvr" required="true" title="situation you are in" />
				</form_new_layout:row>

				<%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

				<c:set var="fieldXpath" value="${xpath}/location" />
				<c:set var="state" value="${data['health/situation/state']}" />
				<c:set var="location" value="${data['health/situation/location']}" />

				<form_new_layout:row label="I live in" fieldXpath="${fieldXpath}">

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


				</form_new_layout:row>

				<c:set var="fieldXpath" value="${xpath}/healthSitu" />
				<form_new_layout:row label="I&#39;m looking to" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthSitu" className="health-situation-healthSitu" required="true" title="reason you are looking to quote" />
				</form_new_layout:row>

				<%-- Moved from details page. To keep the same xpath we have to manually setup them again --%>
				<c:set var="xpath_hlthcvr" value="${pageSettings.getVerticalCode()}/healthCover" />
				<c:set var="name" value="${go:nameFromXpath(xpath)}" />

				<c:set var="fieldXpath" value="${xpath_hlthcvr}/primary/dob" />
				<form_new_layout:row label="Your date of birth" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
					<field_new:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
				</form_new_layout:row>

				<c:set var="fieldXpath" value="${xpath_hlthcvr}/primary/cover" />
				<form_new_layout:row label="Do you currently hold private health insurance?" fieldXpath="${fieldXpath}" id="${name}_primaryCover">
					<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="if you currently hold private health insurance" required="true" id="${name}_health_cover"/>
				</form_new_layout:row>

				<%-- Medicare card question --%>
				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/cover" />
					<form_new_layout:row label="Do all people to be covered on this policy have a green or blue Medicare card?" fieldXpath="${fieldXpath}" className="health_situation_medicare">
						<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover" additionalAttributes="data-rule-isCheckedYes='true' data-msg-isCheckedYes='Unfortunately we cannot continue with your quote'" />
					</form_new_layout:row>
				</c:if>

				<c:set var="fieldXpath" value="${xpath}/coverType" />
				<form_new_layout:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthCvrType" className="health-situation-healthCvrType" required="true" title="your cover type" />
				</form_new_layout:row>

			</form_new:fieldset>

			<simples:dialogue id="22" vertical="health" />

			<%-- Health benefits has simples messages --%>
			<simples:dialogue id="23" vertical="health" className="green" >
				<div style="margin-top:20px;">
					<a href="javascript:;"  data-benefits-control="Y" class="btn btn-form">Open Benefits</a>
				</div>
			</simples:dialogue>

		</jsp:body>

	</form_new_layout:fieldset_columns>
</div>