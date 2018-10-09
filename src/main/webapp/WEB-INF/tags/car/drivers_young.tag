<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Young Drive Form Component"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>

<%-- HTML --%>
<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="info" className="ydGreenBubble">
			<h4>Want to add other drivers?</h4>
			<p>At this stage we only want to know about the youngest driver of the car. You'll be able to add other drivers to your policy during the application stage.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>

		<form_v2:fieldset legend="Youngest Driver" id="${name}FieldSet">

			<form_v2:row label="Will anyone younger than the regular driver be driving this car? (This may include a spouse or household member)" helpId="12" id="quote_drivers_youngDriverRow">
				<c:set var="analAttribute"><field_v1:analytics_attr analVal="Young Driver" quoteChar="\"" /></c:set>
				<field_v2:array_radio xpath="${xpath}/exists"
								required="true"
								items="Y=Yes,N=No"
								title="if any driver (including a spouse or household member) is younger than the Regular Driver"
								additionalLabelAttributes="${analAttribute}" />
			</form_v2:row>

			<div id="${name}ToggleArea" class="show_${displaySuffix}">
				<form_v2:row label="Youngest Driver's Gender" id="${name}_genderRow">
					<field_v2:array_radio id="${name}_gender" xpath="${xpath}/gender" required="true" items="M=Male,F=Female" title="${title} gender" className="person-gender" />
				</form_v2:row>

				<form_v2:row label="Youngest driver's date of birth">
					<field_v2:person_dob xpath="${xpath}/dob" title="youngest driver's" required="true" ageMin="16" ageMax="120" validateYoungest="${true}"/>
				</form_v2:row>

				<form_v2:row label="Age youngest driver obtained a full drivers licence" helpId="29">
					<field_v2:age_licence xpath="${xpath}/licenceAge" required="true"	title="youngest" />
				</form_v2:row>

				<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
				<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />

				<form_v2:row label="Any motor insurance claims in the last 5 years (regardless of who was at fault)?" helpId="2" id="quote_drivers_young_claimsRow">
					<field_v2:array_radio xpath="${xpath}Exotic/claims" required="true"
										  items="Y=Yes,N=No"
										  title="if the regular driver has had any motor insurance claims in the last 5 years" />
				</form_v2:row>

				<form_v2:row label="Details of all claims and whether an excess was paid" id="quote_drivers_youngExotic_claims_reasonRow" className="hidden">
					<field_v1:textarea xpath="${xpath}Exotic/claimsReason" required="true" title="additional claims information" />
				</form_v2:row>

				<form_v2:row label="Any driving convictions, suspensions, disqualifications in the last 5 years?" id="quote_drivers_young_convictionsRow">
					<field_v2:array_radio xpath="${xpath}Exotic/convictions" required="true"
										  items="Y=Yes,N=No"
										  title="if the regular driver has had any driving convictions, suspensions, disqualifications in the last 5 years" />
				</form_v2:row>

				<form_v2:row label="Details of all driving convictions, suspensions, disqualifications - include year and length of suspension" id="quote_drivers_youngExotic_conviction_reasonRow" className="hidden">
					<field_v1:textarea xpath="${xpath}Exotic/convictionsReason" required="true" title="additional conviction information" />
				</form_v2:row>
			</div>

			<form_v2:row label="You may be able to reduce the premium if you restrict the age of the drivers" id="quote_restricted_ageRow">
				<c:set var="analAttribute"><field_v1:analytics_attr analVal="Age 2 Driver" quoteChar="\"" /></c:set>
				<field_v2:import_select xpath="quote/options/driverOption"
									url="/WEB-INF/option_data/driver_option.html"
									title="a driver age restriction option"
									className="driver_option"
									required="true"
									additionalAttributes="${analAttribute}" />
			</form_v2:row>

		</form_v2:fieldset>

	</jsp:body>
</form_v2:fieldset_columns>
