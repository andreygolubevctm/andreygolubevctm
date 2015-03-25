<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

<%-- To proceed a user must select either a valid postcode or enter a suburb and
	select a valid suburb/postcode/state value from the autocomplete. This is to
	avoid suburbs that match multiple locations being sent with request only to be
	returned empty because can only search a single location (FUE-23). --%>
$.validator.addMethod("validateHealthPostcodeSuburb",
	function(value, element) {

		if( healthChoices.isValidLocation(value) ) {
			healthChoices.setLocation(value);

			return true;
		}

		return false;
	}
);
</go:script>

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<form_new:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<c:if test="${not empty callCentreNumber}">
				<ui:bubble variant="info">
					<h4>Do you need a hand?</h4>
					<p>Let's face it, health insurance can be complicated. If you need a hand, here's why you should call us:</p>
					<ul class="themed">
						<li>You get personal service from our experienced and friendly staff</li>
						<li>We help you through each step of the process</li>
						<li>We answer any questions you may have along the way</li>
						<li>We can help you find the right cover for your needs</li>
					</ul>
					<h4>Call us on <span class="noWrap callCentreNumber">${callCentreNumber}</span></h4>
					<p>Our Australian-based call centre hours are:</p>
					<p>
						<strong><form:scrape id='135'/></strong><%-- Get the Call Centre Hours from Scrapes Table HLT-832 --%>
					</p>
					<c:if test="${not empty callCentreSpecialHoursLink and not empty callCentreSpecialHoursContent}">
						${callCentreSpecialHoursLink}
					</c:if>
				</ui:bubble>
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

			<form_new:fieldset legend="Cover Type">

				<c:set var="fieldXpath" value="${xpath}/healthCvr" />
				<form_new:row label="I am" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthCvr" className="health-situation-healthCvr" required="true" title="type of cover" />
				</form_new:row>

				<%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

				<c:set var="fieldXpath" value="${xpath}/location" />
				<c:set var="state" value="${data['health/situation/state']}" />
				<c:set var="location" value="${data['health/situation/location']}" />

				<form_new:row label="I live in" fieldXpath="${fieldXpath}">

					<c:choose>
						<c:when test="${not empty param.state || (not empty state && empty location && (param.action == 'amend' || param.action == 'load'))}">
							<field:state_select xpath="${xpath}/state" useFullNames="true" title="State" required="true" />
						</c:when>
						<c:otherwise>
							<field_new:lookup_suburb_postcode xpath="${fieldXpath}" required="true" placeholder="Suburb / Postcode" />
							<field:hidden xpath="${xpath}/state" />
						</c:otherwise>
					</c:choose>

					<field:hidden xpath="${xpath}/suburb" />
					<field:hidden xpath="${xpath}/postcode" />


				</form_new:row>

				<c:set var="fieldXpath" value="${xpath}/healthSitu" />
				<form_new:row label="I&#39;m looking to" fieldXpath="${fieldXpath}">
					<field_new:general_select xpath="${fieldXpath}" type="healthSitu" className="health-situation-healthSitu" required="true" title="situation type" />
				</form_new:row>

				<%-- Medicare card question --%>
				<c:if test="${callCentre}">
					<c:set var="fieldXpath" value="${xpath}/cover" />
					<form_new:row label="Do all people to be covered on this policy have a green or blue Medicare card?" fieldXpath="${fieldXpath}" className="health_situation_medicare">
						<field_new:array_radio items="Y=Yes,N=No" style="group" xpath="${fieldXpath}" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover"/>
					</form_new:row>
					<go:validate selector="${name}_cover" rule="agree" parm="true" message="Unfortunately we cannot continue with your quote"/>
				</c:if>

				</form_new:fieldset>

				<simples:referral_tracking vertical="health" />

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

<%-- VALIDATION --%>
<go:validate selector="${name}_location" rule="validateHealthPostcodeSuburb" parm="true" message="Please select a valid suburb / postcode" />