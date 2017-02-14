<%@ tag description="Property Features" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Property Features" id="${name}">

	<%-- Security Features--%>
	<c:set var="fieldXpath" value="${xpath}/hasSecurity" />
	<form_v2:row fieldXpath="${fieldXpath}" label="Is the home fitted with a security alarm?">
		<field_v2:array_radio xpath="${fieldXpath}"
							  title="is the home fitted with a security alarm?"
							  required="true"
							  className="pretty_buttons dontSubmit"
							  items="Y=Yes,N=No"/>
	</form_v2:row>

	<c:set var="fieldXpath" value="${xpath}/securityFeatures" />
	<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Security Features - Tool Tip" quoteChar="\"" /></c:set>
	<form_v2:row fieldXpath="${fieldXpath}" label="Which security features does the home have?" className="securityFeatures" helpId="527" tooltipAttributes="${analyticsAttr}">
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Security Features" quoteChar="\"" /></c:set>
		<field_v2:validatedHiddenField xpath="${xpath}/securityFeaturesCount" className="dontSend" additionalAttributes=" data-rule-securityFeatures='true' " />
		<div class="row">
			<div class="col-lg-6 col-xs-12">
				<field_v2:checkbox xpath="${fieldXpath}/internalSiren" value="Y" title="An Internal Siren" required="false" label="true" additionalLabelAttributes="${analyticsAttr}" />
			</div>

			<div class="col-lg-6 col-xs-12">
				<field_v2:checkbox xpath="${fieldXpath}/externalSiren" value="Y" title="An External Siren" required="false" label="true" additionalLabelAttributes="${analyticsAttr}" />
			</div>

			<div class="col-lg-6 col-xs-12">
				<field_v2:checkbox xpath="${fieldXpath}/strobeLight" value="Y" title="An External Strobe Light" required="false" label="true" additionalLabelAttributes="${analyticsAttr}" />
			</div>

			<div class="col-lg-6 col-xs-12">
				<field_v2:checkbox xpath="${fieldXpath}/backToBase" value="Y" title="Active Back To Base Monitoring" required="false" label="true" additionalLabelAttributes="${analyticsAttr}" />
			</div>
		</div>
	</form_v2:row>

</form_v2:fieldset>