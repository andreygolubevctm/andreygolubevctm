<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<form_new:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="info" className="point-left">
            <h4>Options, Accessories & Modifications</h4>
            <p>By listing all of the options, accessories and modifications, the insurer will be able to get a more accurate idea of the car's true value.</p>
        </ui:bubble>
	</jsp:attribute>

    <jsp:body>
        <car:options_factory xpath="${xpath}/vehicle/factoryOptions" />
        <car:options_accessories xpath="${xpath}/vehicle/accessories" />
        <car:options_modifications xpath="${xpath}/vehicle/modifications" />
        <car:options_usage xpath="${xpath}/vehicle" />
        <car:options_dialog_inputs xpath="${xpath}/vehicle/options/inputs/container" />
    </jsp:body>
</form_new:fieldset_columns>