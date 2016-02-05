<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<form_v2:fieldset_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<simples:dialogue id="19" vertical="health" />
			<simples:dialogue id="20" vertical="health" />
			<simples:dialogue id="0" vertical="health" className="red">
				<div class="row">
					<div class="col-sm-12">
						<field_v2:array_radio xpath="health/simples/contactType" items="outbound=Outbound quote,inbound=Inbound quote,followup=Follow up call,callback=Chat callback" required="true" title="contact type (outbound/inbound/followup/callback)" />
					</div>
				</div>
			</simples:dialogue>
			<simples:dialogue id="21" vertical="health" mandatory="true" /> <%-- 3 Point Security Check --%>
			<simples:dialogue id="36" vertical="health" mandatory="true" className="hidden simples-privacycheck-statement" /> <%-- Inbound --%>
			<simples:dialogue id="25" vertical="health" mandatory="true" className="hidden follow-up-call" /> <%-- Follow up call --%>

			<form_v2:fieldset legend="" postLegend="">

				<c:set var="fieldXpath" value="${xpath}/healthCvr" />
				<form_v2:row label="You are a" fieldXpath="${fieldXpath}">
					<field_v2:general_select xpath="${fieldXpath}" type="healthCvr" className="health-situation-healthCvr" required="true" title="situation you are in" />
				</form_v2:row>

				<%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

				<c:set var="fieldXpath" value="${xpath}/location" />
				<c:set var="state" value="${data['health/situation/state']}" />
				<c:set var="location" value="${data['health/situation/location']}" />

				<form_v2:row label="Living in" fieldXpath="${fieldXpath}">

					<c:choose>
						<c:when test="${not empty param.state || (not empty state && empty location && (param.action == 'amend' || param.action == 'load'))}">
							<field_v1:state_select xpath="${xpath}/state" useFullNames="true" title="State" required="true" />
						</c:when>
						<c:otherwise>
							<field_v2:lookup_suburb_postcode xpath="${fieldXpath}" required="true" placeholder="Suburb / Postcode" extraDataAttributes=" data-rule-validateLocation='true' " />
							<field_v1:hidden xpath="${xpath}/state" />
						</c:otherwise>
					</c:choose>

					<field_v1:hidden xpath="${xpath}/suburb" />
					<field_v1:hidden xpath="${xpath}/postcode" />


				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/healthSitu" />
				<form_v2:row label="Looking to" fieldXpath="${fieldXpath}">
					<field_v2:general_select xpath="${fieldXpath}" type="healthSitu" className="health-situation-healthSitu" required="true" title="reason you are looking to quote" />
				</form_v2:row>

				</form_v2:fieldset>

				<simples:dialogue id="22" vertical="health" />

				<%-- Health benefits has simples messages --%>
				<simples:dialogue id="23" vertical="health" className="green" >
					<div style="margin-top:20px;">
						<a href="javascript:;"  data-benefits-control="Y" class="btn btn-form">Open Benefits</a>
					</div>
				</simples:dialogue>

		</jsp:body>

	</form_v2:fieldset_columns>
</div>