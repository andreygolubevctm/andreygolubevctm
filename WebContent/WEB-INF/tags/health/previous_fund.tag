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

	<form_new:fieldset id="${id}" legend="Previous Fund Details" className="health-previous_fund">

		<ui:bubble variant="chatty">
			<h4>Did you know that switching is simple?</h4>
			<p>Your chosen fund will handle the switching process for you. Too easy!</p>
		</ui:bubble>

		<c:set var="fieldXpath" value="${xpath}/primary/fundName" />
		<form_new:row fieldXpath="${fieldXpath}" label="Your Current Health Fund" id="clientFund" className="changes-premium">
			<field_new:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="your health fund" required="true" />
		</form_new:row>

		<%-- Optional Membership ID's --%>
		<div id="clientMemberID" class="membership">
			<c:set var="fieldXpath" value="${xpath}/primary/memberID" />
			<form_new:row fieldXpath="${fieldXpath}" label="Membership Number" className="clientMemberID">
				<field_new:input xpath="${fieldXpath}" title="your member ID" required="true" />
			</form_new:row>

			<c:set var="fieldXpath" value="${xpath}/primary/authority" />
			<form_new:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
				<field_new:checkbox xpath="${fieldXpath}" value="Y" title="I authorise <span>the fund</span> to contact my previous fund to obtain a clearance certificate" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" />
			</form_new:row>
		</div>

		<c:set var="fieldXpath" value="${xpath}/partner/fundName" />
		<form_new:row fieldXpath="${fieldXpath}" label="Partner's Current Health Fund" id="partnerFund" className="changes-premium">
			<field_new:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="partner's health fund" required="true" />
		</form_new:row>

		<div id="partnerMemberID" class="membership">
			<c:set var="fieldXpath" value="${xpath}/partner/memberID" />
			<form_new:row fieldXpath="${fieldXpath}" label="Membership Number" className="partnerMemberID">
				<field_new:input xpath="${fieldXpath}" title="partner's member ID" required="true" />
			</form_new:row>

			<c:set var="fieldXpath" value="${xpath}/partner/authority" />
			<form_new:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
				<field_new:checkbox xpath="${fieldXpath}" value="Y" title="My partner authorises <span>the fund</span> to contact their previous fund to obtain a clearance certificate" label="My partner authorises <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" />
			</form_new:row>
		</div>

	</form_new:fieldset>

</div>

