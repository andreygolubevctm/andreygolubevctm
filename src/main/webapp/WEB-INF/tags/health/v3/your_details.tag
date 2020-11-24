<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<div id="${name}" class="health_application">
<form_v2:fieldset legend="Your Details">

	<health_v3:person_details xpath="${xpath}/primary" title="Your" id="primary" />
	<health_v3:contact_details xpath="${pageSettings.getVerticalCode()}/application" />

	<%-- HTML --%>
	<c:set var="xpath" value="${pageSettings.getVerticalCode()}/previousfund" />
	<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
	<div id="${name}">

		<div id="yourpreviousfund" legend="Previous Fund Details" class="health-previous_fund">

		<c:set var="fieldXpath" value="health/application/primary/cover/sameProviders" />

		<div class="simples-dialogue-same-funds-primary simples-dialogue row-content mandatory hidden">
				<div class="wrapper">
					<field_v2:checkbox
						xpath="health/simples/dialogue-checkbox-same-funds-primary"
						value="Y"
						required="true"
						label="true"
						errorMsg="Please confirm each mandatory dialog has been read to the client"
						className="checkbox-custom simples_dialogue-checkbox-same-funds-primary"
						title="You've let us know you currently hold both hospital and extras cover. Are these with the same fund?" />
						<field_v2:array_radio id="health_previous_fund_same_funds_primary" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="" className="health-cover-different-funds" />
				</div>
		</div>

			<c:set var="fieldXpath" value="${xpath}/primary/fundName" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Your Current Health Fund" id="clientFund" className="changes-premium" renderLabelAsSimplesDialog="true">
				<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds_condensed.html" title="your health fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
			</form_v2:row>

			<%-- Optional Membership ID's --%>
			<div id="clientMemberID" class="membership">
				<c:set var="fieldXpath" value="${xpath}/primary/memberID" />
				<form_v2:row fieldXpath="${fieldXpath}" label="Membership Number" className="clientMemberID" smRowOverride="3" renderLabelAsSimplesDialog="true">
					<field_v2:input xpath="${fieldXpath}" title="your member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${false}" placeHolder="Membership No." />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/primary/authority" />
				<form_v2:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
					<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I authorise <span>the fund</span> to contact my previous fund to obtain a clearance certificate" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " />
				</form_v2:row>
			</div>

			<c:set var="fieldXpath" value="${xpath}/primary/extras/fundName" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Your Current Extras Fund" id="clientExtrasFund" className="changes-premium hidden" renderLabelAsSimplesDialog="true">
				<field_v2:import_select xpath="${fieldXpath}" url="/WEB-INF/option_data/health_funds.html" title="your extras fund" required="true" additionalAttributes=" data-attach='true' " disableErrorContainer="${true}" />
			</form_v2:row>

			<div id="clientExtrasMemberID" class="membership">
				<c:set var="fieldXpath" value="${xpath}/primary/extras/memberID" />
				<form_v2:row fieldXpath="${fieldXpath}" label="Membership Number" className="clientMemberID" smRowOverride="3" renderLabelAsSimplesDialog="true">
					<field_v2:input xpath="${fieldXpath}" title="your member ID" required="true" className="sessioncamexclude" additionalAttributes=" data-attach='true' " disableErrorContainer="${false}" placeHolder="Membership No." />
				</form_v2:row>

				<c:set var="fieldXpath" value="${xpath}/primary/extras/authority" />
				<form_v2:row fieldXpath="${fieldXpath}" className="health_previous_fund_authority hidden" helpId="522">
					<field_v2:checkbox xpath="${fieldXpath}" value="Y" title="I authorise <span>the fund</span> to contact my previous fund to obtain a clearance certificate" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" customAttribute=" data-attach='true' " />
				</form_v2:row>
			</div>

			<health_v3:previous_fund_cancellation xpath="${xpath}" type="primary" />
		</div>
	</div>

		<c:set var="xpath" value="${pageSettings.getVerticalCode()}/payment" />
		<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
		<div class="health-payment ${className}" id="${id}">
			<health_v1:medicare_details xpath="${xpath}/medicare" />
		</div>
</form_v2:fieldset>
</div>
