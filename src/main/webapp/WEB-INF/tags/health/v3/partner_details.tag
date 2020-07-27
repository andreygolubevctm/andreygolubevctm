<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<form_v2:fieldset legend="Your Partner's Details" id="partnerContainer">
	<div id="${name}" class="health_application">
		<health_v3:person_details xpath="${xpath}/partner" title="Your Partner's" id="partner" />
	</div>

	<%-- HTML --%>
	<c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
	<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
	<div id="${name}">
		<div id="partnerpreviousfund" legend="Previous Fund Details" class="health-previous_fund">

		<c:set var="fieldXpath" value="${xpath}/partner/sameFunds" />
			<div class="simples-dialogue-same-funds-partner simples-dialogue row-content mandatory hidden">
					<div class="wrapper">
						<field_v2:checkbox
							xpath="health/simples/dialogue-checkbox-same-funds-partner"
							value="Y"
							required="true"
							label="true"
							errorMsg="Please confirm each mandatory dialog has been read to the client"
							className="checkbox-custom simples_dialogue-checkbox-same-funds-partner"
							title="You've let us know you currently hold both hospital and extras cover. Are these with the same fund?" />
							<field_v2:array_radio id="health_previous_fund_same_funds_partner" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="" className="health-cover-different-funds" />
					</div>
			</div>

			<c:set var="fieldXpath" value="${xpath}/partner/fundName" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Partner's Current Health Fund" id="partnerFund" className="changes-premium">
				<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="partner's health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
			</form_v2:row>

			<div id="partnerMemberID" class="membership">
				<c:set var="fieldXpath" value="${xpath}/partner/memberID" />
				<form_v2:row fieldXpath="${fieldXpath}" label="Membership Number" className="partnerMemberID" smRowOverride="3">
					<field_v2:input xpath="${fieldXpath}" title="partner's member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${false}" placeHolder="Membership No." />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/partner/authority" />
				<form_v2:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
					<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="My partner authorises <span>the fund</span> to contact their previous fund to obtain a clearance certificate" label="My partner authorises <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " />
				</form_v2:row>
			</div>

				<c:set var="fieldXpath" value="${xpath}/partner/extras/fundName" />
				<form_v2:row fieldXpath="${fieldXpath}" label="Partner's Current Extras Fund" id="partnerExtrasFund" className="changes-premium hidden">
					<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="your extras fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
				</form_v2:row>

			<div id="partnerExtrasMemberID" class="membership">
				<c:set var="fieldXpath" value="${xpath}/partner/extras/memberID" />
				<form_v2:row fieldXpath="${fieldXpath}" label="Membership Number" className="partnerMemberID" smRowOverride="3">
					<field_v2:input xpath="${fieldXpath}" title="partner's member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${false}" placeHolder="Membership No." />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/partner/extras/authority" />
				<form_v2:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
					<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="My partner authorise <span>the fund</span> to contact my previous fund to obtain a clearance certificate" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " />
				</form_v2:row>
			</div>

				<health_v3:previous_fund_cancellation xpath="${xpath}" type="partner" />
		</div>
	</div>

</form_v2:fieldset>
