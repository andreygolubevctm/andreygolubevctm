<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="id" required="true" rtexprvalue="true" description="Id for this panel"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Additional css class attribute"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}">

	<form_v2:fieldset id="${id}" legend="Previous Fund Details" className="health-previous_fund">

		<div class="instructional">
			<h4>Switching made simple</h4>
			<p>By providing your current fund's details, your new fund can quickly organise the transfer of your cover.</p>
		</div>

		<c:set var="fieldXpath" value="${xpath}/primary/fundName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Your Current Health Fund" id="clientFund" className="changes-premium">
			<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your health fund" required="true" />
		</form_v2:row>

		<%-- Optional Membership ID's --%>
		<div id="clientMemberID" class="membership">
			<c:set var="fieldXpath" value="${xpath}/primary/memberID" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Membership Number" className="clientMemberID">
				<field_v2:input xpath="${fieldXpath}" title="your member ID" required="true" className="sessioncamexclude" />
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/primary/authority" />
			<form_v2:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
				<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I authorise <span>the fund</span> to contact my previous fund to obtain a clearance certificate" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" />
			</form_v2:row>
		</div>

		<c:set var="fieldXpath" value="${xpath}/partner/fundName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Partner's Current Health Fund" id="partnerFund" className="changes-premium">
			<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="partner's health fund" required="true" />
		</form_v2:row>

		<div id="partnerMemberID" class="membership">
			<c:set var="fieldXpath" value="${xpath}/partner/memberID" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Membership Number" className="partnerMemberID">
				<field_v2:input xpath="${fieldXpath}" title="partner's member ID" required="true" className="sessioncamexclude" />
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/partner/authority" />
			<form_v2:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
				<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="My partner authorises <span>the fund</span> to contact their previous fund to obtain a clearance certificate" label="My partner authorises <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" />
			</form_v2:row>
		</div>

	</form_v2:fieldset>

</div>

