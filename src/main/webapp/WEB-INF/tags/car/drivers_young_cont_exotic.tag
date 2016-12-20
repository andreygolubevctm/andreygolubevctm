<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component - Extra"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>
<c:if test="${empty displaySuffic}">
	<c:set var="displaySuffix">N</c:set>
</c:if>

<%-- HTML --%>
<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
	</jsp:attribute>

	<jsp:body>

		<form_v2:fieldset legend="" id="${name}ExoticContFieldSet" className="show_${displaySuffix}">

			<group_v2:ncd_selection xpath="${xpath}" />

			<form_v2:row label="Any motor insurance claims in the last 5 years (regardless of who was at fault)?" helpId="2" id="quote_drivers_young_claimsRow">
				<field_v2:array_radio xpath="${xpath}/claims" required="true"
					items="Y=Yes,N=No"
					title="if the regular driver has had any motor insurance claims in the last 5 years" />
			</form_v2:row>

			<form_v2:row label="Details of all claims and whether an excess was paid" id="quote_drivers_youngExotic_claims_reasonRow" className="hidden">
				<field_v1:textarea xpath="${xpath}/claims/reason" required="true" title="additional claims information" />
			</form_v2:row>

			<form_v2:row label="Any driving convictions, suspensions, disqualifications in the last 5 years?" id="quote_drivers_young_convictionsRow">
				<field_v2:array_radio xpath="${xpath}/convictions" required="true"
									  items="Y=Yes,N=No"
									  title="if the regular driver has had any driving convictions, suspensions, disqualifications in the last 5 years" />
			</form_v2:row>

			<form_v2:row label="Details of all driving convictions, suspensions, disqualifications - include year and length of suspension" id="quote_drivers_youngExotic_conviction_reasonRow" className="hidden">
				<field_v1:textarea xpath="${xpath}/claims/conviction_reason" required="true" title="additional conviction information" />
			</form_v2:row>

		</form_v2:fieldset>

	</jsp:body>
</form_v2:fieldset_columns>
