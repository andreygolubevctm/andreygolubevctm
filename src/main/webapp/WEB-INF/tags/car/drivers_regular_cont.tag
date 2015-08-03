<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component - Extra"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="bubbleClass">
	<c:if test="${showRegoLookupContent eq true}">point-left</c:if>
</c:set>

<%-- HTML --%>
<form_new:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="info" className="${bubbleClass}">
			<h4>Not sure of your NCD rating?</h4>
			<p>You can usually find this on your current insurance policy or renewal notice near the price.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>

		<form_new:fieldset legend="" id="${name}ContFieldSet" className="">

			<group_new:ncd_selection xpath="${xpath}" />

			<form_new:row label="Any motor insurance claims in the last 5 years (regardless of who was at fault)?" helpId="2" id="quote_drivers_regular_claimsRow">
				<field_new:array_radio xpath="${xpath}/claims" required="true"
					items="Y=Yes,N=No,U=Unsure"
					title="if the regular driver has had any motor insurance claims in the last 5 years" />
			</form_new:row>

		</form_new:fieldset>

	</jsp:body>
</form_new:fieldset_columns>