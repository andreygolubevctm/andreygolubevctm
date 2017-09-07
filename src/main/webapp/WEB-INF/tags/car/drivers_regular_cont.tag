<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component - Extra"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="info">
			<h4>Not sure of your NCD rating?</h4>
			<p>You can usually find this on your current insurance policy or renewal notice near the price.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>

		<form_v2:fieldset legend="" id="${name}ContFieldSet" className="">

			<group_v2:ncd_selection xpath="${xpath}" />

			<form_v2:row label="Any motor insurance claims in the last 5 years (regardless of who was at fault)?" helpId="2" id="quote_drivers_regular_claimsRow">
				<c:set var="analAttribute"><field_v1:analytics_attr analVal="Claims last 5y" quoteChar="\"" /></c:set>
				<field_v2:array_radio xpath="${xpath}/claims" required="true"
					items="Y=Yes,N=No,U=Unsure"
					title="if the regular driver has had any motor insurance claims in the last 5 years"
					additionalLabelAttributes="${analAttribute}" />
			</form_v2:row>

			<form_v2:row label="Details of all claims and whether an excess was paid" id="quote_drivers_regular_claims_reasonRow" className="hidden">
				<field_v1:textarea xpath="${xpath}/claimsReason" required="true" title="additional claims information" />
			</form_v2:row>

			<form_v2:row label="Any driving convictions, suspensions, disqualifications in the last 5 years?" id="quote_drivers_regular_convictionsRow" className="hidden">
				<field_v2:array_radio xpath="${xpath}/convictions" required="true"
									  items="Y=Yes,N=No"
									  title="if the regular driver has had any driving convictions, suspensions, disqualifications in the last 5 years" />
			</form_v2:row>

			<form_v2:row label="Details of all driving convictions, suspensions, disqualifications - include year and length of suspension" id="quote_drivers_regular_conviction_reasonRow" className="hidden">
				<field_v1:textarea xpath="${xpath}/convictionsReason" required="true" title="additional conviction information" />
			</form_v2:row>

		</form_v2:fieldset>

	</jsp:body>
</form_v2:fieldset_columns>
